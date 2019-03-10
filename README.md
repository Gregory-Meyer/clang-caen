# clang-caen

This repository is a Vagrant environment that usable to build LLVM 7.0.1 on
CentOS 7.6, roughly equivalent to a RHEL 7.6 machine such as those used by UM
CAEN computers.

## Usage

For most users, it will be suffient to grab the most recent tagged release from
the releases page and untar it into $HOME. For example, I would find the Clang
binary at `/home/gregjm/bin/clang`. Be sure to add `$HOME/bin` to your `PATH`
and add `$HOME/lib` to `LD_LIBRARY_PATH`. If you're using bash or zsh, your
steps look like this:

```bash
cd ~/Downloads
wget https://github.com/gregjm/clang-caen/archive/llvm-7.0.1-2019-03-10.tar.gz
tar xvf llvm-7.0.1-2019-03-10.tar.xz
cp -ar llvm-7.0.1-2019-03-10/. $HOME
echo "export PATH=$HOME/bin:\$PATH" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=$HOME/lib:\$LD_LIBRARY_PATH" >> ~/.bashrc
```

If you're using fish, it's essentially the same:

```fish
cd ~/Downloads
wget https://github.com/gregjm/clang-caen/archive/llvm-7.0.1-2019-03-10.tar.gz
tar xvf llvm-7.0.1-2019-03-10.tar.xz
cp -ar llvm-7.0.1-2019-03-10/. $HOME
set -Ux fish_user_paths $HOME/bin $fish_user_paths
set -Ux LD_LIBRARY_PATH $HOME/lib:$LD_LIBRARY_PATH
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

You will now be SSH'd into a local VM running CentOS 7.6. CMake 3.13.4 and the
newest release of Ninja (1.9.0 at the time of writing) are preinstalled for
you, as is the default C/C++ toolchain - GCC 4.8.5. Inside the machine, run:

```bash
/vagrant/build.sh
tar cfJ /vagrant/llvm-7.0.1.tar.xz ~/llvm-install
```

You should now see the LLVM tarball in this repository's root directory on your
host machine. Use the tarball in the same way as above, but use `scp` or
something to get it onto your target environment (CAEN).
