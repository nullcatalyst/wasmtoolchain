load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load("@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl", "artifact_name_pattern", "feature", "flag_group", "flag_set", "tool_path", "with_feature_set")

def _tool_path(path):
    return "%{base_path}/{}%{exe_extension}".format(path)

def _toolchain_impl(ctx):
    cc_tool_path = _tool_path("clang")
    cpp_tool_path = _tool_path("clang++")
    ld_tool_path = _tool_path("wasm-ld")
    ar_tool_path = _tool_path("llvm-ar")

    tool_paths = [
        tool_path(name = "gcc", path = cc_tool_path),
        tool_path(name = "cpp", path = cpp_tool_path),
        tool_path(name = "ld", path = ld_tool_path),
        tool_path(name = "ar", path = ar_tool_path),
        tool_path(name = "nm", path = "false"),
        tool_path(name = "objdump", path = "false"),
        tool_path(name = "strip", path = "false"),
    ]

    cxx_builtin_include_directories = [
        "%package(@%{workspace_name}//)%/lib/c/include",
        "%package(@%{workspace_name}//)%/lib/cxx/include",
    ]

    artifact_name_patterns = [
        artifact_name_pattern(
            category_name = "executable",
            prefix = "",
            extension = "",
            # extension = ".wasm",
        ),
    ]

    all_link_actions = [
        ACTION_NAMES.cpp_link_executable,
        ACTION_NAMES.cpp_link_dynamic_library,
        ACTION_NAMES.cpp_link_nodeps_dynamic_library,
    ]
    all_assemble_actions = [
        ACTION_NAMES.assemble,
        ACTION_NAMES.preprocess_assemble,
    ]
    c_compile_actions = [
        ACTION_NAMES.linkstamp_compile,
        ACTION_NAMES.c_compile,
        ACTION_NAMES.lto_backend,
    ]
    cpp_compile_actions = [
        ACTION_NAMES.cpp_compile,
        ACTION_NAMES.cpp_header_parsing,
        ACTION_NAMES.cpp_module_compile,
        ACTION_NAMES.cpp_module_codegen,
    ]
    all_compile_actions = c_compile_actions + cpp_compile_actions

    default_linker_flags = feature(
        name = "default_linker_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_link_actions,
                flag_groups = ([
                    flag_group(
                        flags = [
                            "--target=wasm32-unknown-unknown",
                            "-Wl,--no-entry",
                            "--no-standard-libraries",
                            "-L%{base_path}",
                            "-lc",
                            "-ldlmalloc",
                        ],
                    ),
                ]),
            ),
        ],
    )

    default_compile_flags = feature(
        name = "default_compile_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_link_actions + all_assemble_actions + all_compile_actions,
                flag_groups = [
                    flag_group(
                        flags = [
                            "--target=wasm32-unknown-unknown",
                            "-D__wasm__=1",
                            "-Wall",
                            "-Werror",
                        ],
                    ),
                ],
            ),
            flag_set(
                actions = all_assemble_actions,
                flag_groups = [
                    flag_group(
                        flags = [
                            "-fno-canonical-system-headers",
                        ],
                    ),
                ],
            ),
            flag_set(
                actions = c_compile_actions,
                flag_groups = [
                    flag_group(
                        flags = [
                            "-nostdinc",
                        ],
                    ),
                ],
            ),
            flag_set(
                actions = cpp_compile_actions,
                flag_groups = [
                    flag_group(
                        flags = [
                            "-nostdinc++",
                            "-std=c++20",
                        ],
                    ),
                ],
            ),
            flag_set(
                actions = all_link_actions + all_assemble_actions + all_compile_actions,
                flag_groups = [
                    flag_group(flags = [
                        "-glldb",
                        "-O0",
                    ]),
                ],
                with_features = [with_feature_set(features = ["dbg"])],
            ),
            flag_set(
                actions = all_link_actions + all_assemble_actions + all_compile_actions,
                flag_groups = [
                    flag_group(flags = [
                        "-glldb",
                        "-gline-tables-only",
                        "-O1",
                    ]),
                ],
                with_features = [with_feature_set(features = ["fastbuild"])],
            ),
            flag_set(
                actions = all_link_actions + all_assemble_actions + all_compile_actions,
                flag_groups = [
                    flag_group(
                        flags = [
                            "-g0",
                            "-O3",
                            "-DNDEBUG",
                        ],
                    ),
                ],
                with_features = [with_feature_set(features = ["opt"])],
            ),
        ],
    )

    user_compile_flags = feature(
        name = "user_compile_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_assemble_actions + all_compile_actions,
                flag_groups = [
                    flag_group(
                        flags = ["%{user_compile_flags}"],
                        iterate_over = "user_compile_flags",
                        expand_if_available = "user_compile_flags",
                    ),
                ],
            ),
        ],
    )

    include_paths = feature(
        name = "include_paths",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = c_compile_actions + cpp_compile_actions,
                flag_groups = [
                    flag_group(
                        flags = ["-iquote", "%{quote_include_paths}"],
                        iterate_over = "quote_include_paths",
                    ),
                    flag_group(
                        flags = ["-I%{include_paths}"],
                        iterate_over = "include_paths",
                    ),
                    flag_group(
                        flags = ["-isystem", "%{system_include_paths}"],
                        iterate_over = "system_include_paths",
                    ),
                ],
            ),
        ],
    )

    unfiltered_compile_flags = feature(
        name = "unfiltered_compile_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_assemble_actions + all_compile_actions,
                flag_groups = [
                    flag_group(
                        flags = [
                            # Do not resolve our symlinked resource prefixes to real paths.
                            "-no-canonical-prefixes",
                            # "-fno-canonical-system-headers",
                            # Reproducibility
                            "-Wno-builtin-macro-redefined",
                            "-D__DATE__=\"redacted\"",
                            "-D__TIMESTAMP__=\"redacted\"",
                            "-D__TIME__=\"redacted\"",
                        ],
                    ),
                ],
            ),
        ],
    )

    features = [
        feature(name = "dbg"),
        feature(name = "opt"),
        feature(name = "fastbuild"),
        default_linker_flags,
        default_compile_flags,
        user_compile_flags,
        include_paths,
        unfiltered_compile_flags,
    ]

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        features = features,
        # action_configs = action_configs,
        artifact_name_patterns = artifact_name_patterns,
        cxx_builtin_include_directories = cxx_builtin_include_directories,
        toolchain_identifier = "wasm-toolchain",
        host_system_name = "local",
        target_system_name = "local",
        target_cpu = "wasm",
        target_libc = "unknown",
        compiler = "clang",
        abi_version = "unknown",
        abi_libc_version = "unknown",
        tool_paths = tool_paths,
    )

cc_toolchain_config = rule(
    implementation = _toolchain_impl,
    attrs = {},
    provides = [CcToolchainConfigInfo],
)
