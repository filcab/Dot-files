
YCM: cd into YouCompleteMe and:

macOS:
time env EXTRA_CMAKE_ARGS=-DEXTERNAL_LIBCLANG_PATH=...path/to/llvm/build/lib/libclang.dylib ./install.py --clang-completer --rust-completer --js-completer --ninja

win (we might need to edit third_party/ycmd/third_party/cregex/regex_?/_regex.c and #undef _DEBUG ):
timeit env EXTRA_CMAKE_ARGS="-DEXTERNAL_LIBCLANG_PATH=...path/to/llvm/lib/libclang.lib -DPATH_TO_LLVM_ROOT=.../path/to/llvm" python install.py --clang-completer --rust-completer --ts-completer --ninja

