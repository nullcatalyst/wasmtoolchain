def _wasm_toolchain_impl(ctx):
    ctx.file("WORKSPACE", 'workspace(name = "{}")\n'.format(ctx.name))

    if "windows" in ctx.os.name:
        base_path = ctx.execute(["cmd.exe", "/c", "echo %cd%"]).stdout
        base_path = base_path.strip().replace("\\", "/")
        exe_extension = ".exe"

        tools = {
            "@bazel_wasm_toolchain//toolchain:windows-x86_64/clang.exe": "clang.exe",
            "@bazel_wasm_toolchain//toolchain:windows-x86_64/clang++.exe": "clang++.exe",
            "@bazel_wasm_toolchain//toolchain:windows-x86_64/llvm-ar.exe": "llvm-ar.exe",
        }
    else:
        base_path = ctx.execute(["pwd"]).stdout
        exe_extension = ""

        tools = {
            "@bazel_wasm_toolchain//toolchain:macos-x86_64/clang": "clang",
            "@bazel_wasm_toolchain//toolchain:macos-x86_64/clang++": "clang++",
            "@bazel_wasm_toolchain//toolchain:macos-x86_64/llvm-ar": "llvm-ar",
        }

    for label, name in tools.items():
        ctx.symlink(Label(label), name)

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
            default = Label("//toolchain:BUILD.bazel.tpl"),
            allow_single_file = True,
        ),
        "_toolchain_tpl": attr.label(
            default = Label("//toolchain:toolchain.bzl.tpl"),
            allow_single_file = True,
        ),
    },
    implementation = _wasm_toolchain_impl,
)
