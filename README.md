# Counter-Strike: Global Offensive Plus

![LOGO](https://github.com/user-attachments/assets/30e4751c-be55-4982-8d88-bd307feefb26)
> [!WARNING]
> This project is still a work-in-progress, and not ready to use. This also contains multiple bugs, and doesn't work on some Linux distributions and Operating systems [information here](#supported-oses)

## What is CSGO+?
**CSGO+** is basically an attempt of modernizing the CSGO leak from April 22nd 2020. This is targetting almost every platform from Linux to the Web. Some notable features is native **Web support**.

## Features
- **Web support** - You can play CSGO on any platform thanks to this!

## FAQ
- Q: What are some supported Operating Systems?
- A: All supported OSes for compiling can be found [here](#supported-oses)
- Q: Does this even compile?
- A: Yes, this compiles on some Linux distributions. But I am skeptical with Windows since I haven't tested it.
- Q: Does this have a Discord server?
- A: [Yes](https://discord.gg/5Gpr5TSkJ4).

## Buidling
Firstly, if you're on an [Arch Linux](https://archlinux.org/download/)-based distribution, install the following dependencies:
```bash
pacman -S apt base-devel dpkg gcc g++
```
But if you're on [Debian Linux](https://www.debian.org/distrib/)-based distribution, install the following dependencies:
```bash
apt-get install build-essential gcc-multilib libgl-dev g++-multilib
```
Secondly, as `root`, go to the `/` directory, and run the following commands:
```bash
mkdir -p /valve/bin64/
cd /valve/bin64/
ln -s $(which ar) ar
ln -s $(which gcc) gcc-4.6
ln -s $(which g++) g++-4.6
#this part comes from cryptopp
mkdir -p /valve/steam-runtime/bin
cd /valve/steam-runtime/bin
ln -s $(which g++) g++
ln -s $(which gcc) gcc
```
> [!TIP]
> Tip: Run `ln -s usr/include/linux/sysctl.h /usr/include/sys/sysctl.h`, to avoid errors. This will be fixed in the future.

### Building (Linux)
1. Firstly, add this script under the name "p4" in /usr/local/bin:
```bash
#!/bin/bash
echo "$@" >> /tmp/p4req.txt # logs arguments passed to a file.
```
2. Run `chmod +x -R ./devtools/` inside the Git repository.
3. Run the VPC creation script.
4. Finally run `MAKE_JOBS=1 make -f csgo_partner.mak -j1`, change the -j(x) to your liking.

### Building (Emscripten)
1. This is based on the Linux guide, since this only works with Linux. So follow all of those steps.
2. In the VPC creation script, add `/define:EMSCRIPTEN`, and rerun that script.
3. Run `MAKE_JOBS=1 make -f csgo_partner.mak -j1`
4. And finally run `emrun --no_browser --port 8080 .`

## Supported OSes

|  OS/Distro | Supported | 					Known Bugs			    	   |
| -----------| -------   | --------------------------------------------------------------------------------|
| Windows    | Untested  | Untested					    				   |
| Arch Linux | Yes        | |
| Debian     | Yes       | Few C++ errors, can be fixed easily						   |
| FreeBSD    | No	 | FreeBSD isn't supported natively in the Source Engine.		           |


