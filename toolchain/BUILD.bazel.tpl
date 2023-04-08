load(":toolchain.bzl", "cc_toolchain_config")

cc_toolchain_suite(
    name = "toolchain",
    toolchains = {
        %{native_compilers}
        "wasm32|clang": ":wasm_toolchain",
        "wasm32": ":wasm_toolchain",
    },
)

cc_toolchain_config(name = "wasm_toolchain_config")

cc_toolchain(
    name = "wasm_toolchain",
    all_files = ":empty",
    compiler_files = ":compiler_files",
    dwp_files = ":empty",
    linker_files = ":linker_files",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 0,
    toolchain_config = ":wasm_toolchain_config",
    toolchain_identifier = "wasm-toolchain",
)

filegroup(name = "empty")

# The compiler needs to be able to access all of the headers.
filegroup(
    name = "compiler_files",
    srcs = glob(["include/**/*"]),
)

# The linker needs to be able to access the standard library.
filegroup(
    name = "linker_files",
    srcs = glob(["lib/**/*"]),
)
