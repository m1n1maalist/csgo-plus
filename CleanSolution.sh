#!/bin/bash

find . -name "*_linux64.mak" -exec rm {} \;
find . -name "*_linux32.mak" -exec rm {} \;
find . -name "*.vpc_crc" -exec rm {} \;
find . -name "*.vpc_cache" -exec rm {} \;
rm csgo_partner.mak
