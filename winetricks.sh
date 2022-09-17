#!/bin/bash

Xvfb :5 -screen 0 1024x768x16 &
env WINEARCH=win64 WINEDEBUG=-all WINEPREFIX=/home/steam/wineserver WINEDLLOVERRIDES="mscoree=d" wineboot --init /nogui 
env WINEARCH=win64 WINEDEBUG=-all WINEPREFIX=/home/steam/wineserver winetricks corefonts 
env WINEARCH=win64 WINEDEBUG=-all WINEPREFIX=/home/steam/wineserver winetricks sound=disabled 
env WINEARCH=win64 WINEDEBUG=-all WINEPREFIX=/home/steam/wineserver DISPLAY=:5.0 winetricks -q vcrun2017 
env WINEARCH=win64 WINEDEBUG=-all WINEPREFIX=/home/steam/wineserver DISPLAY=:5.0 winetricks -q --force dotnet48