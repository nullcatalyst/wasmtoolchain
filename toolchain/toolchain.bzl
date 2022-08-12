def _wasm_toolchain_impl(ctx):
    ctx.file("WORKSPACE", 'workspace(name = "{}")\n'.format(ctx.name))

    if "windows" in ctx.os.name:
        base_path = ctx.execute(["cmd.exe", "/c", "echo %cd%"]).stdout
        base_path = base_path.strip().replace("\\", "/")
        exe_extension = ".exe"

        tools = {
            "clang.exe": Label("@bazel_wasm_toolchain//toolchain:windows-x86_64/clang.exe"),
            "clang++.exe": Label("@bazel_wasm_toolchain//toolchain:windows-x86_64/clang.exe"),
            "llvm-ar.exe": Label("@bazel_wasm_toolchain//toolchain:windows-x86_64/llvm-ar.exe"),
            "wasm-ld.exe": Label("@bazel_wasm_toolchain//toolchain:windows-x86_64/lld.exe"),
            "libc.a": Label("@bazel_wasm_toolchain//toolchain:lib/libc.a"),
        }
    else:
        base_path = ctx.execute(["pwd"]).stdout
        exe_extension = ""

        tools = {
            "clang": Label("@bazel_wasm_toolchain//toolchain:macos-x86_64/clang-14"),
            "clang++": Label("@bazel_wasm_toolchain//toolchain:macos-x86_64/clang-14"),
            "llvm-ar": Label("@bazel_wasm_toolchain//toolchain:macos-x86_64/llvm-ar"),
            "wasm-ld": Label("@bazel_wasm_toolchain//toolchain:macos-x86_64/lld.exe"),
            "libc.a": Label("@bazel_wasm_toolchain//toolchain:lib/libc.a"),
        }

    libs = {
        "libc.a": Label("@bazel_wasm_toolchain//toolchain:lib/libc.a"),
        "libdlmalloc.a": Label("@bazel_wasm_toolchain//toolchain:lib/libdlmalloc.a"),
    }

    symlinks = dict(tools, **libs)  # merge dicts
    for name, label in symlinks.items():
        ctx.symlink(label, name)

    ctx.template(
        "BUILD.bazel",
        ctx.attr._build_tpl,
        {
            "%{base_path}": base_path,
            "%{exe_extension}": exe_extension,
        },
    )
    ctx.template(
        "toolchain.bzl",
        ctx.attr._toolchain_tpl,
        {
            "%{base_path}": base_path,
            "%{exe_extension}": exe_extension,
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
    },
    implementation = _wasm_toolchain_impl,
)
