load(":toolchain.bzl", "cc_toolchain_config")

cc_toolchain_suite(
    name = "toolchain",
    toolchains = {
        "wasm32": ":wasm_toolchain",
        "wasm32|clang": ":wasm_toolchain",
    },
)

cc_toolchain_config(name = "wasm_toolchain_config")

cc_toolchain(
    name = "wasm_toolchain",
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 0,
    toolchain_config = ":wasm_toolchain_config",
    toolchain_identifier = "wasm-toolchain",
)

filegroup(name = "empty")
