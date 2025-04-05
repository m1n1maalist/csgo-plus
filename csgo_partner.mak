# VPC MASTER MAKEFILE


ifneq "$(LINUX_TOOLS_PATH)" ""
TOOL_PATH = $(LINUX_TOOLS_PATH)/
SHELL := $(TOOL_PATH)bash
else
SHELL := /bin/bash
endif

ifdef MAKE_CHROOT
    ifneq ("$(wildcard /etc/schroot/chroot.d/$(MAKE_CHROOT).conf)","")
        export CHROOT_NAME ?= $(MAKE_CHROOT)
    endif
    export CHROOT_NAME ?= $(subst /,_,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
    CHROOT_CONF := /etc/schroot/chroot.d/$(CHROOT_NAME).conf
    ifeq "$(CHROOT_NAME)" "steamrt_scout_amd64"
        CHROOT_DIR := /var/chroots
    else
        CHROOT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/tools/runtime/linux)
    endif
    RUNTIME_NAME ?= steamrt_scout_amd64
    ifneq ("$(SCHROOT_CHROOT_NAME)", "$(CHROOT_NAME)")
        SHELL:=schroot --chroot $(CHROOT_NAME) -- /bin/bash
    endif

    CHROOT_TARBALL = $(CHROOT_DIR)/$(RUNTIME_NAME).tar.xz
    CHROOT_TIMESTAMP_FILE = $(CHROOT_DIR)/$(RUNTIME_NAME)/timestamp

    ifneq ("$(wildcard $(CHROOT_TIMESTAMP_FILE))","")
        ifneq ("$(wildcard $(CHROOT_TARBALL))","")
            CHROOT_DEPENDENCY = $(CHROOT_CONF)
        endif
    endif
endif
ECHO = $(TOOL_PATH)echo
ETAGS = $(TOOL_PATH)etags
FIND = $(TOOL_PATH)find
UNAME = $(TOOL_PATH)uname
XARGS = $(TOOL_PATH)xargs

# to control parallelism, set the MAKE_JOBS environment variable
ifeq ($(strip $(MAKE_JOBS)),)
    ifeq ($(shell $(UNAME)),Darwin)
        CPUS := $(shell /usr/sbin/sysctl -n hw.ncpu)
    endif
    ifeq ($(shell $(UNAME)),Linux)
        CPUS := $(shell $(TOOL_PATH)grep processor /proc/cpuinfo | $(TOOL_PATH)wc -l)
    endif
    MAKE_JOBS := $(CPUS)
endif

ifeq ($(strip $(MAKE_JOBS)),)
    MAKE_JOBS := 8
endif

# All projects (default target)
all: $(CHROOT_DEPENDENCY)
	$(MAKE) -f $(lastword $(MAKEFILE_LIST)) -j$(MAKE_JOBS) all-targets

all-targets : appframework bitmap bitmap_byteswap bonesetup bsppack Bzip2 choreoobjects Client_CSGO datacache Dedicated Dmxloader engine filesystem_stdio havana_constraints hk_base hk_math inputsystem interfaces ivp_compactbuilder ivp_physics launcher launcher_main localize lzma Matchmaking_CSGO Matchmaking_DS_CSGO matchmakingbase matchmakingbase_ds materialsystem matsys_controls meshutils particles quickhull Raytrace resourcefile responserules_runtime ScaleformUI SceneFileCache Server_CSGO shaderapidx9 shaderapiempty shaderlib soundemittersystem soundsystem_lowlevel stdshader_dx9 studiorender tier0 tier1 tier2 tier3 valve_avi VAudio_Miles vgui_controls vgui_surfacelib vgui2 vguimatsurface videocfg vphysics vpklib vscript vstdlib vtf 


# Individual projects + dependencies

appframework : 
	@$(ECHO) "Building: appframework"
	@+$(MAKE) -C /home/universe/csgo-plus/appframework -f appframework_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

bitmap : 
	@$(ECHO) "Building: bitmap"
	@+$(MAKE) -C /home/universe/csgo-plus/bitmap -f bitmap_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

bitmap_byteswap : 
	@$(ECHO) "Building: bitmap_byteswap"
	@+$(MAKE) -C /home/universe/csgo-plus/bitmap -f bitmap_byteswap_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

bonesetup : 
	@$(ECHO) "Building: bonesetup"
	@+$(MAKE) -C /home/universe/csgo-plus/bonesetup -f bonesetup_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

bsppack : interfaces lzma tier0 tier1 tier2 vstdlib 
	@$(ECHO) "Building: bsppack"
	@+$(MAKE) -C /home/universe/csgo-plus/utils/bsppack -f bsppack_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

Bzip2 : 
	@$(ECHO) "Building: Bzip2"
	@+$(MAKE) -C /home/universe/csgo-plus/utils/bzip2 -f bzip2_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

choreoobjects : 
	@$(ECHO) "Building: choreoobjects"
	@+$(MAKE) -C /home/universe/csgo-plus/choreoobjects -f choreoobjects_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

Client_CSGO : bitmap bonesetup Bzip2 choreoobjects Dmxloader interfaces matsys_controls meshutils particles Raytrace resourcefile tier0 tier1 tier2 tier3 vgui_controls videocfg vpklib vstdlib vtf 
	@$(ECHO) "Building: Client_CSGO"
	@+$(MAKE) -C /home/universe/csgo-plus/game/client -f client_linux64_srv_csgo.mak $(CLEANPARAM) SHELL=$(SHELL)

datacache : interfaces tier0 tier1 tier2 tier3 vstdlib 
	@$(ECHO) "Building: datacache"
	@+$(MAKE) -C /home/universe/csgo-plus/datacache -f datacache_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

Dedicated : appframework Dmxloader interfaces tier0 tier1 tier2 tier3 vpklib vstdlib 
	@$(ECHO) "Building: Dedicated"
	@+$(MAKE) -C /home/universe/csgo-plus/dedicated -f dedicated_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

Dmxloader : 
	@$(ECHO) "Building: Dmxloader"
	@+$(MAKE) -C /home/universe/csgo-plus/dmxloader -f dmxloader_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

engine : appframework bitmap Bzip2 Dmxloader interfaces quickhull tier0 tier1 tier2 tier3 vstdlib vtf 
	@$(ECHO) "Building: engine"
	@+$(MAKE) -C /home/universe/csgo-plus/engine -f engine_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

filesystem_stdio : interfaces tier0 tier1 tier2 vpklib vstdlib 
	@$(ECHO) "Building: filesystem_stdio"
	@+$(MAKE) -C /home/universe/csgo-plus/filesystem -f filesystem_stdio_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

havana_constraints : 
	@$(ECHO) "Building: havana_constraints"
	@+$(MAKE) -C /home/universe/csgo-plus/ivp/havana -f havana_constraints_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

hk_base : 
	@$(ECHO) "Building: hk_base"
	@+$(MAKE) -C /home/universe/csgo-plus/ivp/havana/havok/hk_base -f hk_base_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

hk_math : 
	@$(ECHO) "Building: hk_math"
	@+$(MAKE) -C /home/universe/csgo-plus/ivp/havana/havok/hk_math -f hk_math_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

inputsystem : interfaces tier0 tier1 tier2 vstdlib 
	@$(ECHO) "Building: inputsystem"
	@+$(MAKE) -C /home/universe/csgo-plus/inputsystem -f inputsystem_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

interfaces : 
	@$(ECHO) "Building: interfaces"
	@+$(MAKE) -C /home/universe/csgo-plus/interfaces -f interfaces_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

ivp_compactbuilder : 
	@$(ECHO) "Building: ivp_compactbuilder"
	@+$(MAKE) -C /home/universe/csgo-plus/ivp/ivp_compact_builder -f ivp_compactbuilder_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

ivp_physics : 
	@$(ECHO) "Building: ivp_physics"
	@+$(MAKE) -C /home/universe/csgo-plus/ivp/ivp_physics -f ivp_physics_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

launcher : appframework interfaces tier0 tier1 tier2 tier3 vstdlib 
	@$(ECHO) "Building: launcher"
	@+$(MAKE) -C /home/universe/csgo-plus/launcher -f launcher_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

launcher_main : interfaces tier1 
	@$(ECHO) "Building: launcher_main"
	@+$(MAKE) -C /home/universe/csgo-plus/launcher_main -f launcher_main_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

localize : interfaces tier0 tier1 tier2 vstdlib 
	@$(ECHO) "Building: localize"
	@+$(MAKE) -C /home/universe/csgo-plus/localize -f localize_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

lzma : 
	@$(ECHO) "Building: lzma"
	@+$(MAKE) -C /home/universe/csgo-plus/utils/lzma -f lzma_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

Matchmaking_CSGO : interfaces matchmakingbase tier0 tier1 tier2 tier3 vstdlib 
	@$(ECHO) "Building: Matchmaking_CSGO"
	@+$(MAKE) -C /home/universe/csgo-plus/matchmaking -f matchmaking_linux64_srv_csgo.mak $(CLEANPARAM) SHELL=$(SHELL)

Matchmaking_DS_CSGO : interfaces matchmakingbase_ds tier0 tier1 tier2 tier3 vstdlib 
	@$(ECHO) "Building: Matchmaking_DS_CSGO"
	@+$(MAKE) -C /home/universe/csgo-plus/matchmaking -f matchmaking_ds_linux64_srv_csgo.mak $(CLEANPARAM) SHELL=$(SHELL)

matchmakingbase : 
	@$(ECHO) "Building: matchmakingbase"
	@+$(MAKE) -C /home/universe/csgo-plus/matchmaking -f matchmakingbase_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

matchmakingbase_ds : 
	@$(ECHO) "Building: matchmakingbase_ds"
	@+$(MAKE) -C /home/universe/csgo-plus/matchmaking -f matchmakingbase_ds_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

materialsystem : bitmap interfaces shaderlib tier0 tier1 tier2 tier3 vstdlib vtf 
	@$(ECHO) "Building: materialsystem"
	@+$(MAKE) -C /home/universe/csgo-plus/materialsystem -f materialsystem_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

matsys_controls : 
	@$(ECHO) "Building: matsys_controls"
	@+$(MAKE) -C /home/universe/csgo-plus/vgui2/matsys_controls -f matsys_controls_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

meshutils : 
	@$(ECHO) "Building: meshutils"
	@+$(MAKE) -C /home/universe/csgo-plus/meshutils -f meshutils_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

particles : 
	@$(ECHO) "Building: particles"
	@+$(MAKE) -C /home/universe/csgo-plus/particles -f particles_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

quickhull : 
	@$(ECHO) "Building: quickhull"
	@+$(MAKE) -C /home/universe/csgo-plus/thirdparty/quickhull -f quickhull_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

Raytrace : 
	@$(ECHO) "Building: Raytrace"
	@+$(MAKE) -C /home/universe/csgo-plus/raytrace -f raytrace_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

resourcefile : 
	@$(ECHO) "Building: resourcefile"
	@+$(MAKE) -C /home/universe/csgo-plus/resourcefile -f resourcefile_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

responserules_runtime : 
	@$(ECHO) "Building: responserules_runtime"
	@+$(MAKE) -C /home/universe/csgo-plus/responserules/runtime -f responserules_runtime_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

ScaleformUI : bitmap interfaces tier0 tier1 tier2 tier3 vstdlib vtf 
	@$(ECHO) "Building: ScaleformUI"
	@+$(MAKE) -C /home/universe/csgo-plus/scaleformui -f scaleformui_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

SceneFileCache : interfaces tier0 tier1 vstdlib 
	@$(ECHO) "Building: SceneFileCache"
	@+$(MAKE) -C /home/universe/csgo-plus/scenefilecache -f scenefilecache_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

Server_CSGO : bitmap bonesetup choreoobjects Dmxloader interfaces particles responserules_runtime tier0 tier1 tier2 tier3 vgui_controls vstdlib 
	@$(ECHO) "Building: Server_CSGO"
	@+$(MAKE) -C /home/universe/csgo-plus/game/server -f server_linux64_srv_csgo.mak $(CLEANPARAM) SHELL=$(SHELL)

shaderapidx9 : bitmap Bzip2 interfaces tier0 tier1 tier2 videocfg vstdlib vtf 
	@$(ECHO) "Building: shaderapidx9"
	@+$(MAKE) -C /home/universe/csgo-plus/materialsystem/shaderapidx9 -f shaderapidx9_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

shaderapiempty : interfaces tier0 tier1 vstdlib 
	@$(ECHO) "Building: shaderapiempty"
	@+$(MAKE) -C /home/universe/csgo-plus/materialsystem/shaderapiempty -f shaderapiempty_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

shaderlib : 
	@$(ECHO) "Building: shaderlib"
	@+$(MAKE) -C /home/universe/csgo-plus/materialsystem/shaderlib -f shaderlib_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

soundemittersystem : interfaces tier0 tier1 tier2 vstdlib 
	@$(ECHO) "Building: soundemittersystem"
	@+$(MAKE) -C /home/universe/csgo-plus/soundemittersystem -f soundemittersystem_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

soundsystem_lowlevel : 
	@$(ECHO) "Building: soundsystem_lowlevel"
	@+$(MAKE) -C /home/universe/csgo-plus/soundsystem/lowlevel -f soundsystem_lowlevel_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

stdshader_dx9 : interfaces shaderlib tier0 tier1 vstdlib 
	@$(ECHO) "Building: stdshader_dx9"
	@+$(MAKE) -C /home/universe/csgo-plus/materialsystem/stdshaders -f stdshader_dx9_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

studiorender : bitmap interfaces tier0 tier1 tier2 tier3 vstdlib 
	@$(ECHO) "Building: studiorender"
	@+$(MAKE) -C /home/universe/csgo-plus/studiorender -f studiorender_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

tier0 : 
	@$(ECHO) "Building: tier0"
	@+$(MAKE) -C /home/universe/csgo-plus/tier0 -f tier0_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

tier1 : 
	@$(ECHO) "Building: tier1"
	@+$(MAKE) -C /home/universe/csgo-plus/tier1 -f tier1_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

tier2 : 
	@$(ECHO) "Building: tier2"
	@+$(MAKE) -C /home/universe/csgo-plus/tier2 -f tier2_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

tier3 : 
	@$(ECHO) "Building: tier3"
	@+$(MAKE) -C /home/universe/csgo-plus/tier3 -f tier3_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

valve_avi : interfaces tier0 tier1 tier2 tier3 vstdlib 
	@$(ECHO) "Building: valve_avi"
	@+$(MAKE) -C /home/universe/csgo-plus/avi -f valve_avi_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

VAudio_Miles : interfaces tier0 tier1 vstdlib 
	@$(ECHO) "Building: VAudio_Miles"
	@+$(MAKE) -C /home/universe/csgo-plus/engine/voice_codecs/miles -f vaudio_miles_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

vgui_controls : 
	@$(ECHO) "Building: vgui_controls"
	@+$(MAKE) -C /home/universe/csgo-plus/vgui2/vgui_controls -f vgui_controls_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

vgui_surfacelib : 
	@$(ECHO) "Building: vgui_surfacelib"
	@+$(MAKE) -C /home/universe/csgo-plus/vgui2/vgui_surfacelib -f vgui_surfacelib_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

vgui2 : interfaces tier0 tier1 tier2 tier3 vgui_surfacelib vstdlib 
	@$(ECHO) "Building: vgui2"
	@+$(MAKE) -C /home/universe/csgo-plus/vgui2/src -f vgui_dll_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

vguimatsurface : bitmap Dmxloader interfaces tier0 tier1 tier2 tier3 vgui_controls vgui_surfacelib vstdlib 
	@$(ECHO) "Building: vguimatsurface"
	@+$(MAKE) -C /home/universe/csgo-plus/vguimatsurface -f vguimatsurface_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

videocfg : 
	@$(ECHO) "Building: videocfg"
	@+$(MAKE) -C /home/universe/csgo-plus/videocfg -f videocfg_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

vphysics : havana_constraints hk_base hk_math interfaces ivp_compactbuilder ivp_physics tier0 tier1 tier2 vstdlib 
	@$(ECHO) "Building: vphysics"
	@+$(MAKE) -C /home/universe/csgo-plus/vphysics -f vphysics_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

vpklib : 
	@$(ECHO) "Building: vpklib"
	@+$(MAKE) -C /home/universe/csgo-plus/vpklib -f vpklib_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

vscript : interfaces tier0 tier1 vstdlib 
	@$(ECHO) "Building: vscript"
	@+$(MAKE) -C /home/universe/csgo-plus/vscript -f vscript_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

vstdlib : interfaces tier0 tier1 
	@$(ECHO) "Building: vstdlib"
	@+$(MAKE) -C /home/universe/csgo-plus/vstdlib -f vstdlib_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

vtf : 
	@$(ECHO) "Building: vtf"
	@+$(MAKE) -C /home/universe/csgo-plus/vtf -f vtf_linux64_srv.mak $(CLEANPARAM) SHELL=$(SHELL)

# this is a bit over-inclusive, but the alternative (actually adding each referenced c/cpp/h file to
# the tags file) seems like more work than it's worth.  feel free to fix that up if it bugs you. 
TAGS:
	@$(TOOL_PATH)rm -f TAGS
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.cpp' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append
	@$(FIND)  -name '*.h' -print0 | $(XARGS) -r0 $(ETAGS) --language=c++ --declarations --ignore-indentation --append
	@$(FIND)  -name '*.c' -print0 | $(XARGS) -r0 $(ETAGS) --declarations --ignore-indentation --append



# Mark all the projects as phony or else make will see the directories by the same name and think certain targets 

.PHONY: TAGS all all-targets showtargets regen showregen clean cleantargets cleanandremove relink appframework bitmap bitmap_byteswap bonesetup bsppack Bzip2 choreoobjects Client_CSGO datacache Dedicated Dmxloader engine filesystem_stdio havana_constraints hk_base hk_math inputsystem interfaces ivp_compactbuilder ivp_physics launcher launcher_main localize lzma Matchmaking_CSGO Matchmaking_DS_CSGO matchmakingbase matchmakingbase_ds materialsystem matsys_controls meshutils particles quickhull Raytrace resourcefile responserules_runtime ScaleformUI SceneFileCache Server_CSGO shaderapidx9 shaderapiempty shaderlib soundemittersystem soundsystem_lowlevel stdshader_dx9 studiorender tier0 tier1 tier2 tier3 valve_avi VAudio_Miles vgui_controls vgui_surfacelib vgui2 vguimatsurface videocfg vphysics vpklib vscript vstdlib vtf 



# The standard clean command to clean it all out.

clean: 
	@$(MAKE) -f $(lastword $(MAKEFILE_LIST)) -j$(MAKE_JOBS) all-targets CLEANPARAM=clean



# clean targets, so we re-link next time.

cleantargets: 
	@$(MAKE) -f $(lastword $(MAKEFILE_LIST)) -j$(MAKE_JOBS) all-targets CLEANPARAM=cleantargets



# p4 edit and remove targets, so we get an entirely clean build.

cleanandremove: 
	@$(MAKE) -f $(lastword $(MAKEFILE_LIST)) -j$(MAKE_JOBS) all-targets CLEANPARAM=cleanandremove



#relink

relink: cleantargets 
	@$(MAKE) -f $(lastword $(MAKEFILE_LIST)) -j$(MAKE_JOBS) all-targets



# Here's a command to list out all the targets


showtargets: 
	@$(ECHO) '-------------------' && \
	$(ECHO) '----- TARGETS -----' && \
	$(ECHO) '-------------------' && \
	$(ECHO) 'clean' && \
	$(ECHO) 'regen' && \
	$(ECHO) 'showregen' && \
	$(ECHO) 'appframework' && \
	$(ECHO) 'bitmap' && \
	$(ECHO) 'bitmap_byteswap' && \
	$(ECHO) 'bonesetup' && \
	$(ECHO) 'bsppack' && \
	$(ECHO) 'Bzip2' && \
	$(ECHO) 'choreoobjects' && \
	$(ECHO) 'Client_CSGO' && \
	$(ECHO) 'datacache' && \
	$(ECHO) 'Dedicated' && \
	$(ECHO) 'Dmxloader' && \
	$(ECHO) 'engine' && \
	$(ECHO) 'filesystem_stdio' && \
	$(ECHO) 'havana_constraints' && \
	$(ECHO) 'hk_base' && \
	$(ECHO) 'hk_math' && \
	$(ECHO) 'inputsystem' && \
	$(ECHO) 'interfaces' && \
	$(ECHO) 'ivp_compactbuilder' && \
	$(ECHO) 'ivp_physics' && \
	$(ECHO) 'launcher' && \
	$(ECHO) 'launcher_main' && \
	$(ECHO) 'localize' && \
	$(ECHO) 'lzma' && \
	$(ECHO) 'Matchmaking_CSGO' && \
	$(ECHO) 'Matchmaking_DS_CSGO' && \
	$(ECHO) 'matchmakingbase' && \
	$(ECHO) 'matchmakingbase_ds' && \
	$(ECHO) 'materialsystem' && \
	$(ECHO) 'matsys_controls' && \
	$(ECHO) 'meshutils' && \
	$(ECHO) 'particles' && \
	$(ECHO) 'quickhull' && \
	$(ECHO) 'Raytrace' && \
	$(ECHO) 'resourcefile' && \
	$(ECHO) 'responserules_runtime' && \
	$(ECHO) 'ScaleformUI' && \
	$(ECHO) 'SceneFileCache' && \
	$(ECHO) 'Server_CSGO' && \
	$(ECHO) 'shaderapidx9' && \
	$(ECHO) 'shaderapiempty' && \
	$(ECHO) 'shaderlib' && \
	$(ECHO) 'soundemittersystem' && \
	$(ECHO) 'soundsystem_lowlevel' && \
	$(ECHO) 'stdshader_dx9' && \
	$(ECHO) 'studiorender' && \
	$(ECHO) 'tier0' && \
	$(ECHO) 'tier1' && \
	$(ECHO) 'tier2' && \
	$(ECHO) 'tier3' && \
	$(ECHO) 'valve_avi' && \
	$(ECHO) 'VAudio_Miles' && \
	$(ECHO) 'vgui_controls' && \
	$(ECHO) 'vgui_surfacelib' && \
	$(ECHO) 'vgui2' && \
	$(ECHO) 'vguimatsurface' && \
	$(ECHO) 'videocfg' && \
	$(ECHO) 'vphysics' && \
	$(ECHO) 'vpklib' && \
	$(ECHO) 'vscript' && \
	$(ECHO) 'vstdlib' && \
	$(ECHO) 'vtf'



# Here's a command to regenerate this makefile


regen: 
	devtools/bin/vpc_linux /csgo /no_steam +game -togl -mathlib -gcsdk -mathlib_extended -jpeglib -dedicated -dedicated_main -datamodel -stdshader_dbg -game_controls -movieobjects /linux64 /mksln csgo_partner 


# Here's a command to list out all the targets


showregen: 
	@$(ECHO) devtools/bin/vpc_linux /csgo /no_steam +game -togl -mathlib -gcsdk -mathlib_extended -jpeglib -dedicated -dedicated_main -datamodel -stdshader_dbg -game_controls -movieobjects /linux64 /mksln csgo_partner 

ifdef CHROOT_DEPENDENCY
$(CHROOT_DEPENDENCY): $(CHROOT_TIMESTAMP_FILE)
$(CHROOT_TIMESTAMP_FILE): $(CHROOT_TARBALL)
	@echo "chroot ${CHROOT_NAME} at $(CHROOT_DIR) is out of date"
	@echo You need to re-run sudo src/tools/runtime/linux/configure_runtime.sh ${CHROOT_NAME}
endif
