#!/bin/sh

yum upgrade -y
yum install -y ninja-build wget
yum groupinstall -y "Development Tools"

wget -q https://github.com/Kitware/CMake/releases/download/v3.13.4/cmake-3.13.4-Linux-x86_64.tar.gz
tar xf cmake-3.13.4-Linux-x86_64.tar.gz
rm cmake-3.13.4-Linux-x86_64.tar.gz
cp -a cmake-3.13.4-Linux-x86_64/. /usr/local/
rm -rf cmake-3.13.4-Linux-x86_64

git clone git://github.com/ninja-build/ninja.git
cd ninja
python configure.py --bootstrap
cp ninja /usr/local/bin/ninja

mkdir -p /usr/local/src
git clone https://github.com/llvm/llvm-project.git
cd llvm-project
git checkout llvmorg-7.0.1
