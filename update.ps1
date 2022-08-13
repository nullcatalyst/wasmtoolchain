Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function ThrowOnNativeFailure {
    if (-not $?) {
        throw "failed with exit code $LastExitCode"
    }
}

# libc

bazel build --config wasm //lib/c -c opt
ThrowOnNativeFailure

Copy-Item -Force -Verbose "bazel-bin\lib\c\libc.a" -Destination "toolchain\lib\libc.a"
ThrowOnNativeFailure

# libcxx

bazel build --config wasm //lib/cxx -c opt
ThrowOnNativeFailure

Copy-Item -Force -Verbose "bazel-bin\lib\cxx\libcxx.a" -Destination "toolchain\lib\libcxx.a"
ThrowOnNativeFailure

# dlmalloc

bazel build --config wasm //lib/dlmalloc -c opt
ThrowOnNativeFailure

Copy-Item -Force -Verbose "bazel-bin\lib\dlmalloc\libdlmalloc.a" -Destination "toolchain\lib\libdlmalloc.a"
ThrowOnNativeFailure

# Copy headers

tar -czf "toolchain/lib/libc_hdrs.tar.gz" -C "lib/c/include" "."
ThrowOnNativeFailure

tar -czf "toolchain/lib/libcxx_hdrs.tar.gz" -C "lib/cxx/include" "."
ThrowOnNativeFailure
