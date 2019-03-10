#!/bin/sh

set -e

mkdir -p ~/llvm-build
cd ~/llvm-build
cmake /vagrant/llvm-project/llvm \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=~/llvm-install \
    -DLLVM_TARGETS_TO_BUILD=X86 \
    -DLLVM_ENABLE_EH=ON \
    -DLLVM_ENABLE_RTTI=ON \
    -DLLVM_ENABLE_PIC=ON \
    -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;libcxx;libcxxabi;lldb;compiler-rt;lld;polly" \
    -DLLVM_USE_LINKER=gold \
    -DLLVM_ENABLE_LTO=ON \
    -DLLVM_PARALLEL_COMPILE_JOBS=2 \
    -DLLVM_PARALLEL_LINK_JOBS=2
cmake --build . -j 2

mkdir -p ~/llvm-install
cmake --build . --target install
