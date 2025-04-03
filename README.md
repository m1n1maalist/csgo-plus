# CSGO+
**CSGO+** is an attempt of modernizing the CSGO leak from April 22nd 2020.
## Features
- Fixed some VPC groups.

## Planned Features
- Deferred Lighting
- Web Port (Emscripten)
- PBR shaders.
- Android support.
- Forward+ Renderer
- Vulkan Support.

## Building
1. Firstly, add this script under the name "p4" in /usr/local/bin:
```bash
#!/bin/bash
echo "$@" >> /tmp/p4req.txt # logs arguments passed to a file.
```
2. Run `chmod +x -R ./devtools/` inside the Git repository.
3. Run the VPC creation script.
4. Finally run `MAKE_JOBS=1 make -f csgo_partner.mak -j1`, change the -j(x) to your liking.
