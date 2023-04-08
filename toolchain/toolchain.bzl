_WORKSPACE_NAME = "@com_nullcatalyst_wasmtoolchain"

def _wasm_toolchain_impl(ctx):
    ctx.file("WORKSPACE", 'workspace(name = "{}")\n'.format(ctx.name))
    ctx.extract(
        archive = Label("{ws}//toolchain:lib/libc_hdrs.tar.gz".format(ws = _WORKSPACE_NAME)),
        output = "include/libc",
    )
    ctx.extract(
        archive = Label("{ws}//toolchain:lib/libcxx_hdrs.tar.gz".format(ws = _WORKSPACE_NAME)),
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
            "tools/clang.exe": Label("{ws}//toolchain:windows-x86_64/clang.exe".format(ws = _WORKSPACE_NAME)),
            "tools/clang++.exe": Label("{ws}//toolchain:windows-x86_64/clang.exe".format(ws = _WORKSPACE_NAME)),
            "tools/llvm-ar.exe": Label("{ws}//toolchain:windows-x86_64/llvm-ar.exe".format(ws = _WORKSPACE_NAME)),
            "tools/wasm-ld.exe": Label("{ws}//toolchain:windows-x86_64/lld.exe".format(ws = _WORKSPACE_NAME)),
        }

        native_compilers.extend([
            '"x64_windows|msvc-cl": "@local_config_cc//:cc-compiler-x64_windows",',
            '"x64_windows|clang-cl": "@local_config_cc//:cc-compiler-x64_windows-clang-cl",',
            '"x64_windows": "@local_config_cc//:cc-compiler-x64_windows",',
        ])
    elif "mac" in ctx.os.name:
        base_path = ctx.execute(["pwd"]).stdout.strip()

        tools = {
            "tools/clang": Label("{ws}//toolchain:macos-x86_64/clang-14".format(ws = _WORKSPACE_NAME)),
            "tools/clang++": Label("{ws}//toolchain:macos-x86_64/clang-14".format(ws = _WORKSPACE_NAME)),
            "tools/llvm-ar": Label("{ws}//toolchain:macos-x86_64/llvm-ar".format(ws = _WORKSPACE_NAME)),
            "tools/wasm-ld": Label("{ws}//toolchain:macos-x86_64/lld".format(ws = _WORKSPACE_NAME)),
        }

        native_compilers.extend([
            '"darwin|clang": "@local_config_cc//:cc-compiler-darwin_x86_64",',
            '"darwin": "@local_config_cc//:cc-compiler-darwin_x86_64",',
        ])
    elif "linux" in ctx.os.name:
        base_path = ctx.execute(["pwd"]).stdout.strip()

        tools = {
            "tools/clang": Label("{ws}//toolchain:linux-x86_64/clang-14".format(ws = _WORKSPACE_NAME)),
            "tools/clang++": Label("{ws}//toolchain:linux-x86_64/clang-14".format(ws = _WORKSPACE_NAME)),
            "tools/llvm-ar": Label("{ws}//toolchain:linux-x86_64/llvm-ar".format(ws = _WORKSPACE_NAME)),
            "tools/wasm-ld": Label("{ws}//toolchain:linux-x86_64/lld".format(ws = _WORKSPACE_NAME)),
        }

        native_compilers.extend([
            '"k8|gcc": "@local_config_cc//:cc-compiler-k8",',
            '"k8|clang": "@local_config_cc//:cc-compiler-k8",',
            '"k8": "@local_config_cc//:cc-compiler-k8",',
        ])
    else:
        fail("Unsupported platform: {}".format(ctx.os.name))

    libs = {
        "lib/libc.a": Label("{ws}//toolchain:lib/libc.a".format(ws = _WORKSPACE_NAME)),
        "lib/libcxx.a": Label("{ws}//toolchain:lib/libcxx.a".format(ws = _WORKSPACE_NAME)),
        "lib/libdlmalloc.a": Label("{ws}//toolchain:lib/libdlmalloc.a".format(ws = _WORKSPACE_NAME)),
    }

    symlinks = dict(tools, **libs)  # merge dicts
    for name, label in symlinks.items():
        ctx.symlink(
            label,
            target_file = name,
            is_executable = True,
        )

    ctx.template(
        "BUILD.bazel",
        ctx.attr._build_tpl,
        {
            "%{workspace_name}": ctx.name,
            "%{base_path}": base_path,
            "%{exe_extension}": exe_extension,
            "%{include_stdlib}": "{}".format(ctx.attr.include_stdlib),
            "%{native_compilers}": "\n        ".join(native_compilers),
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
        "include_stdlib": attr.bool(default = True),
        "_build_tpl": attr.label(
            default = Label("{ws}//toolchain:BUILD.bazel.tpl".format(ws = _WORKSPACE_NAME)),
            allow_single_file = True,
        ),
        "_toolchain_tpl": attr.label(
            default = Label("{ws}//toolchain:toolchain.bzl.tpl".format(ws = _WORKSPACE_NAME)),
            allow_single_file = True,
        ),
    },
    implementation = _wasm_toolchain_impl,
)
