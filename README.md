# wasmtoolchain

This repo contains a very basic stripped down version of libc and libc++, so that they can be used
without making the wasm binary too bloated.

It also contains the minimal clang compilers and binaryen tools to be able to compile c/c++ to wasm
on Windows, macOS, or linux. Even though this repo is laid out and intended to be used with bazel,
these libraries and tools can be easily be extracted and used standalone.

## Usage

Add the following to your `WORKSPACE.bazel` file:

```bzl
# Make it easy to update the version
_WASMTOOLCHAIN_COMMIT = "48d85bb87be20820f65a4b4f7afb877362ad55af"

http_archive(
    name = "com_nullcatalyst_wasmtoolchain",
    sha256 = "1fe02add01a6c21903fffed1be6851fd1e69ddfc94b937d1b4a392d9374ca53e",
    strip_prefix = "wasmtoolchain-{}".format(_WASMTOOLCHAIN_COMMIT),
    url = "https://github.com/nullcatalyst/wasmtoolchain/archive/{}.tar.gz".format(_WASMTOOLCHAIN_COMMIT),
)

load("@com_nullcatalyst_wasmtoolchain//toolchain:toolchain.bzl", "wasm_toolchain")

# This will be the name of the workspace that contains the toolchain.
# The standard library and tools corresponding to your host OS will be extracted here.
# Note that it must match the name passed in the flag (below).
wasm_toolchain(name = "wasm_toolchain")
```

Then pass the following flags when running `bazel` on the command line:

```
--crosstool_top=@wasm_toolchain//:toolchain --cpu=wasm32
```

Or, better yet, add a special configuration to your `.bazelrc` file (it's a file that sits right beside your `WORKSPACE.bazel` file) so that it is easier to remember:

```
# This tells bazel that whenever a `build` command is run using the `wasm` config
# ie: `bazel build --config wasm ...`, then also add the following flags
build:wasm              --crosstool_top=@wasm_toolchain//:toolchain
build:wasm              --cpu=wasm32
```
