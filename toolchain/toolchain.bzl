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
    else:
        base_path = ctx.execute(["pwd"]).stdout
        exe_extension = ""

        tools = {
            "tools/clang": Label("@bazel_wasm_toolchain//toolchain:macos-x86_64/clang-14"),
            "tools/clang++": Label("@bazel_wasm_toolchain//toolchain:macos-x86_64/clang-14"),
            "tools/llvm-ar": Label("@bazel_wasm_toolchain//toolchain:macos-x86_64/llvm-ar"),
            "tools/wasm-ld": Label("@bazel_wasm_toolchain//toolchain:macos-x86_64/lld.exe"),
        }

    libs = {
        "lib/libc.a": Label("@bazel_wasm_toolchain//toolchain:lib/libc.a"),
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
