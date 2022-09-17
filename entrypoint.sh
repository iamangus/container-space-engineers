#!/bin/bash
# VARIABLES
INSTANCE_NAME="se"
GAME_DIR="/home/steam/space-engineers/gameserver"
CONFIG_PATH="/home/steam/space-engineers/gamesave/SpaceEngineers-Dedicated.cfg"
INSTANCE_IP=$(hostname -I | sed "s= ==g")

echo "-------------------------------INSTALL & UPDATE------------------------------"
steamcmd +force_install_dir ${GAME_DIR} +login anonymous +@sSteamCmdForcePlatformType windows +app_update 298740 +quit

echo "---------------------------------UPDATE CONFIG-------------------------------"
# update IP to host external ip
CURRENT_IP=$(grep -oEi '<IP>(.*)</IP>' ${CONFIG_PATH} | sed "s=<IP>==g" | sed "s=</IP>==g")
sed -i "s=<IP>.*</IP>=<IP>${INSTANCE_IP}</IP>=g" ${CONFIG_PATH}

# update world save path
CURRENT_WORLDNAME=$(grep -oEi '<WorldName>(.*)</WorldName>' ${CONFIG_PATH} | sed "s=<WorldName>==g" | sed "s=</WorldName>==g")
SAVE_PATH="Z:\\\\home\\\\steam\\\\space-engineers\\\\gamesave\\\\Saves\\\\${CURRENT_WORLDNAME}";
sed -i "s=<LoadWorld>.*</LoadWorld>=<LoadWorld>${SAVE_PATH}</LoadWorld>=g" ${CONFIG_PATH}

echo "-----------------------------CURRENT CONFIGURATION---------------------------"
echo "GAME_DIR=$GAME_DIR"
echo "CONFIG_PATH=$CONFIG_PATH"
echo "INSTANCE_IP=$INSTANCE_IP"
echo "CURRENT_IP=$CURRENT_IP"
echo "CURRENT_WORLDNAME=$CURRENT_WORLDNAME"
echo "SAVE_PATH=$SAVE_PATH"
## END UPDATES ##
env WINEARCH=win64 WINEDEBUG=-all WINEPREFIX=/home/steam/wineserver DISPLAY=:5.0 wine64 --version
echo "----------------------------------START GAME---------------------------------"
cd ${GAME_DIR}/DedicatedServer64/
env WINEARCH=win64 WINEDEBUG=-all WINEPREFIX=/home/steam/wineserver DISPLAY=:5.0 wine64 SpaceEngineersDedicated.exe -noconsole -ignorelastsession -path Z:\\home\\steam\\space-engineers\\gamesave
echo "-----------------------------------END GAME----------------------------------"
sleep 10
echo "-----------------------------------BYE !!!!----------------------------------"