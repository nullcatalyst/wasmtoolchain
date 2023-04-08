def _wasm_toolchain_impl(ctx):
    ctx.file("WORKSPACE", 'workspace(name = "{}")\n'.format(ctx.name))
    ctx.extract(
        archive = Label("@bazel_wasm_toolchain//toolchain:lib/libc_hdrs.tar.gz"),
        output = "include/libc",
    )
    ctx.extract(
        archive = Label("@bazel_wasm_toolchain//toolchain:lib/libcxx_hdrs.tar.gz"),
        output = "include/libcxx",
    )

    base_path = ""
    exe_extension = ""
    tools = {}
    native_compilers = []

    if "windows" in ctx.os.name:
        base_path = ctx.execute(["cmd.exe", "/c", "echo %cd%"]).stdout
        base_path = base_path.strip().replace("\\", "/")
        exe_extension = ".exe"

        tools = {
            "tools/clang.exe": Label("@bazel_wasm_toolchain//toolchain:windows-x86_64/clang.exe"),
            "tools/clang++.exe": Label("@bazel_wasm_toolchain//toolchain:windows-x86_64/clang.exe"),
            "tools/llvm-ar.exe": Label("@bazel_wasm_toolchain//toolchain:windows-x86_64/llvm-ar.exe"),
            "tools/wasm-ld.exe": Label("@bazel_wasm_toolchain//toolchain:windows-x86_64/lld.exe"),
        }

        native_compilers.extend([
            '"x64_windows|msvc-cl": "@local_config_cc//:cc-compiler-x64_windows",',
            '"x64_windows|clang-cl": "@local_config_cc//:cc-compiler-x64_windows-clang-cl",',
            '"x64_windows": "@local_config_cc//:cc-compiler-x64_windows",',
        ])
    elif "mac" in ctx.os.name:
        base_path = ctx.execute(["pwd"]).stdout.strip()

        tools = {
            "tools/clang": Label("@bazel_wasm_toolchain//toolchain:macos-x86_64/clang-14"),
            "tools/clang++": Label("@bazel_wasm_toolchain//toolchain:macos-x86_64/clang-14"),
            "tools/llvm-ar": Label("@bazel_wasm_toolchain//toolchain:macos-x86_64/llvm-ar"),
            "tools/wasm-ld": Label("@bazel_wasm_toolchain//toolchain:macos-x86_64/lld"),
        }

        native_compilers.extend([
            '"darwin|clang": "@local_config_cc//:cc-compiler-darwin_x86_64",',
            '"darwin": "@local_config_cc//:cc-compiler-darwin_x86_64",',
        ])

    # Untested
    # elif "nix" in ctx.os.name:
    #     base_path = ctx.execute(["pwd"]).stdout.strip()
    #     exe_extension = ""

    #     tools = {
    #         "tools/clang": Label("@bazel_wasm_toolchain//toolchain:linux-x86_64/clang-14"),
    #         "tools/clang++": Label("@bazel_wasm_toolchain//toolchain:linux-x86_64/clang-14"),
    #         "tools/llvm-ar": Label("@bazel_wasm_toolchain//toolchain:linux-x86_64/llvm-ar"),
    #         "tools/wasm-ld": Label("@bazel_wasm_toolchain//toolchain:linux-x86_64/lld"),
    #     }

    #     native_compilers.extend([
    #         '"linux|clang": "@local_config_cc//:cc-compiler-linux_x86_64",',
    #         '"linux": "@local_config_cc//:cc-compiler-linux_x86_64",',
    #     ])

    libs = {
        "lib/libc.a": Label("@bazel_wasm_toolchain//toolchain:lib/libc.a"),
        "lib/libcxx.a": Label("@bazel_wasm_toolchain//toolchain:lib/libcxx.a"),
        "lib/libdlmalloc.a": Label("@bazel_wasm_toolchain//toolchain:lib/libdlmalloc.a"),
    }

    symlinks = dict(tools, **libs)  # merge dicts
    for name, label in symlinks.items():
        ctx.symlink(label, name)

    ctx.template(
        "BUILD.bazel",
        ctx.attr._build_tpl,
        {
            "%{workspace_name}": ctx.name,
            "%{base_path}": base_path,
            "%{exe_extension}": exe_extension,
            "%{include_stdlib}": "{}".format(ctx.attr.include_stdlib),
            "%{native_compilers}": "\n    ".join(native_compilers),
        },
    )

    ctx.template(
        "toolchain.bzl",
        ctx.attr._toolchain_tpl,
        {
            "%{workspace_name}": ctx.name,
            "%{base_path}": base_path,
            "%{exe_extension}": exe_extension,
            "%{include_stdlib}": "{}".format(ctx.attr.include_stdlib),
        },
    )

wasm_toolchain = repository_rule(
    attrs = {
        "_build_tpl": attr.label(
            default = Label("@bazel_wasm_toolchain//toolchain:BUILD.bazel.tpl"),
            allow_single_file = True,
        ),
        "_toolchain_tpl": attr.label(
            default = Label("@bazel_wasm_toolchain//toolchain:toolchain.bzl.tpl"),
            allow_single_file = True,
        ),
        "include_stdlib": attr.bool(default = True),
    },
    implementation = _wasm_toolchain_impl,
)
