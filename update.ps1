bazel build --config wasm //lib/c -c opt
Copy-Item -Force -Verbose "bazel-bin\lib\c\libc.a" -Destination "toolchain\lib\libc.a"

bazel build --config wasm //lib/dlmalloc -c opt
Copy-Item -Force -Verbose "bazel-bin\lib\dlmalloc\libdlmalloc.a" -Destination "toolchain\lib\libdlmalloc.a"
