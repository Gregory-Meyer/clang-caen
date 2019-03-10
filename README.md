# clang-caen

This repository is a Vagrant environment suitable to build LLVM 7.0.1 on
CentOS 7.6. CentOS 7.6 is about as close as you can get to RHEL 7.6 without
paying for RHEL, so artifacts produced in this environment should be suitable
for use on UM CAEN computers.

## Usage

For most users, it will be suffient to grab the most recent tagged release from
the releases page and untar it into $HOME. For example, I would find the Clang
binary at `/home/gregjm/bin/clang`. Be sure to add `$HOME/bin` to your `PATH`
and add `$HOME/lib` to `LD_LIBRARY_PATH`. If you're using bash or zsh, your
steps look like this:

```bash
cd ~/Downloads
wget https://github.com/Gregory-Meyer/clang-caen/releases/download/llvm-7.0.1-2019-03-10/llvm-7.0.1-2019-03-10.tar.xz
tar xvf llvm-7.0.1-2019-03-10.tar.xz
cp -ar llvm-7.0.1-2019-03-10/. $HOME
echo "export PATH=$HOME/bin:\$PATH" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=$HOME/lib:\$LD_LIBRARY_PATH" >> ~/.bashrc
```

If you're using fish, it's essentially the same:

```fish
cd ~/Downloads
wget https://github.com/Gregory-Meyer/clang-caen/releases/download/llvm-7.0.1-2019-03-10/llvm-7.0.1-2019-03-10.tar.xz
tar xvf llvm-7.0.1-2019-03-10.tar.xz
cp -ar llvm-7.0.1-2019-03-10/. $HOME
set -Ux fish_user_paths $HOME/bin $fish_user_paths
set -Ux LD_LIBRARY_PATH $HOME/lib:$LD_LIBRARY_PATH
```

If you are going to build programs and link them against libcxx for full C++17
compatibility, I recommend setting the rpath of executables suitably. You can
do this on a per-object basis as follows:

```bash
clang++ main.cpp -std=c++17 -stdlib=libc++ -Wl,-rpath=$HOME/lib
```

If you want this to be standard for all projects you compile and you use
a metabuild system like CMake, export these environment variables, which will
set you up to use the full LLVM toolchain:

```bash
export CC="$HOME/bin/clang"
export CXX="$HOME/bin/clang++"
export LD="$HOME/bin/ld.lld"
export CFLAGS="-stdlib=libc++"
export CXXFLAGS="-stdlib=libc++"
export LDFLAGS="-fuse-ld=lld -Wl,-rpath=$HOME/lib"
```

Or in fish:

```fish
set -Ux CC "$HOME/bin/clang"
set -Ux CXX "$HOME/bin/clang++"
set -Ux LD "$HOME/bin/ld.lld"
set -Ux CFLAGS "-stdlib=libc++"
set -Ux CXXFLAGS "-stdlib=libc++"
set -Ux LDFLAGS "-fuse-ld=lld -Wl,-rpath=$HOME/lib"
```

### DIY

If you are so inclined to build LLVM yourself, feel free. Ensure that you have
Vagrant and VirtualBox installed, then run these commands.

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

You will now be SSH'd into a local VM running CentOS 7.6, CMake 3.13.4 and the
newest release of Ninja (1.9.0 at the time of writing) are preinstalled for
you, as is the default C/C++ toolchain - GCC 4.8.5. Inside the machine, run:

```bash
/vagrant/build.sh
tar cfJ /vagrant/llvm-7.0.1.tar.xz ~/llvm-install
```

You should now see the LLVM tarball in this repository's root directory on your
host machine. Use the tarball in the same way as above, but use `scp` or
something to get it onto your target environment (CAEN).
