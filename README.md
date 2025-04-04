# CSGO+
> [!WARNING]
> This project is still a work-in-progress, and not ready to use. This also contains multiple bugs, and doesn't work on some Linux distributions and Operating systems [information here](#supported-oses)

## What is CSGO+?
**CSGO+** is basically an attempt of modernizing the CSGO leak from April 22nd 2020. This is targetting almost every platform from Linux to the Web. Some notable features is native **Web support**.

## Features
- **Web support** - You can play CSGO on any platform thanks to this!

## Buidling

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
> [!NOTE]
> This is support OSes for compiling, not OSes that can run the game.

|  OS/Distro | Supported | 					Known Bugs			    	   |
| -----------| -------   | --------------------------------------------------------------------------------|
| Windows    | Untested  | Untested					    				   |
| Arch Linux | No        | Seems like there are issues relating to `ccache`, maybe just a dependency issue |
| Debian     | Yes       | Few C++ errors, can be fixed easily						   |
| FreeBSD    | No	 | FreeBSD isn't supported natively in the Source Engine.		           |
