# clang-caen

This repository is a Vagrant environment suitable to build LLVM 8.0.0 on
CentOS 7.6. CentOS 7.6 is about as close as you can get to RHEL 7.6 without
paying for RHEL, so artifacts produced in this environment should be suitable
for use on UM CAEN computers.

## Usage

For most users, it will be suffient to grab the most recent tagged release from
the releases page and untar it into $HOME. For example, I would find the Clang
binary at `/home/gregjm/bin/clang`. Be sure to add `$HOME/bin` to your `PATH`
and add `$HOME/lib` to `LD_LIBRARY_PATH`.

The first step is just downloading the artifacts and extracting them into your
home folder.

```bash
cd ~/Downloads
wget https://github.com/Gregory-Meyer/clang-caen/releases/download/llvm-8.0.0-2019-03-18/llvm-8.0.0-2019-03-18.tar.xz
tar xvf llvm-8.0.0-2019-03-18.tar.xz
cp -ar llvm-8.0.0-2019-03-18/. $HOME
```

The next steps depend on what shell you use.

### bash

```bash
echo "export PATH=$HOME/bin:\$PATH" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=$HOME/lib:\$LD_LIBRARY_PATH" >> ~/.bashrc
```

### zsh

```zsh
echo "export PATH=$HOME/bin:\$PATH" >> ~/.zshenv
echo "export LD_LIBRARY_PATH=$HOME/lib:\$LD_LIBRARY_PATH" >> ~/.zshenv
```

### fish

```fish
set -Ux fish_user_paths $HOME/bin $fish_user_paths
set -Ux LD_LIBRARY_PATH $HOME/lib:$LD_LIBRARY_PATH
```

If you are going to build programs and link them against libcxx for full C++17
compatibility, you will have to set the linker paths and rpath you embed in
executables. When linking an executable or library, you will have to pass quite
a few flags:

```bash
clang++ -L$HOME/lib -Wl,-rpath=$HOME/lib -lc++ -lc++abi -stdlib=libc++ -std=c++17 main.cpp
```

However, if you are just building an object, this will suffice:

```bash
clang++ -stdlib=libc++ -std=c++17 -c main.cpp
```

If you want this to be standard for all projects you compile, export these
environment variables, which will set you up to use the full LLVM toolchain:

```bash
export CC="$HOME/bin/clang"
export CXX="$HOME/bin/clang++"
export LD="$HOME/bin/ld.lld"
export CFLAGS="-stdlib=libc++"
export CXXFLAGS="-stdlib=libc++"
export LDFLAGS="-fuse-ld=lld -Wl,-rpath=$HOME/lib -L$HOME/lib -lc++ -lc++abi"
```

Or in fish:

```fish
set -Ux CC "$HOME/bin/clang"
set -Ux CXX "$HOME/bin/clang++"
set -Ux LD "$HOME/bin/ld.lld"
set -Ux CFLAGS "-stdlib=libc++"
set -Ux CXXFLAGS "-stdlib=libc++"
set -Ux LDFLAGS "-fuse-ld=lld -Wl,-rpath=$HOME/lib -L$HOME/lib -lc++ -lc++abi"
```

If you use CMake or autoconf, these will be automatically respected. If you
prefer not to, compiling projects is as simple as:

```bash
$CXX $CXXFLAGS main.cpp -c
$CXX $CXXFLAGS $LDFLAGS main.o -o main
```

### DIY

If you are so inclined to build LLVM yourself, feel free. Ensure that you have
Vagrant and VirtualBox installed, then:

```bash
vagrant plugin install vagrant-vbguest
git clone https://github.com/Gregory-Meyer/clang-caen.git
cd clang-caen
git submodule init
git submodule update # this initializes the llvm-project submodule
$VISUAL Vagrantfile # modify vb.memory and vb.cpus to 50-75% of your resources
vagrant up # this will take a few minutes
vagrant ssh
```

You will now be SSH'd into a local VM running CentOS 7.6. CMake 3.14.0 and the
latest release of Ninja (1.9.0 at the time of writing) are preinstalled, as is
the default C/C++ toolchain on RHEL 7.6 - GCC 4.8.5. Inside the machine, run:

```bash
/vagrant/build.sh # this will take a few hours
tar cfJ /vagrant/llvm-8.0.0.tar.xz ~/llvm-install
```

You should now see the LLVM tarball in this repository's root directory on your
host machine. Use the tarball in the same way as above, but use `scp` or
something to get it onto your target environment (CAEN).
