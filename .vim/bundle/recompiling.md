
YCM: cd into YouCompleteMe and:
time env EXTRA_CMAKE_ARGS=-DEXTERNAL_LIBCLANG_PATH=...path/to/llvm/build/lib/libclang.dylib ./install.py --clang-completer --rust-completer --js-completer --ninja
