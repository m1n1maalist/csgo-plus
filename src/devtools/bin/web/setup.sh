if [[ $(cat /etc/os-release | grep "ID=") == ID=arch ]]; then
	if [[ $(command -v emscripten) == "" ]]; then
		pacman -Syu emscripten
	fi
else
	apt-get install emscripten
fi
