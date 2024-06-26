#!/bin/bash
#
# Discord updater
# 
# Written by: Noam Alum
# Visit docs.alum.sh for more scripts like this :)

# wait
sleep 30

# Trap errors
function CatchErrors {
    local ExitCode=$?
    local ErrorMessage="$BASH_COMMAND exited with status $ExitCode"
    echo "ERROR: $ErrorMessage"
}

# Allocate data
Latest_MD5=$(curl -LIs 'https://discord.com/api/download?platform=linux&format=deb' | awk -F 'x-goog-hash: md5=' {'print $2'} | tr -d '[:space:]')
[ -z "$Latest_MD5" ] && echo "$(date) - Latest discord MD5 hash could not be allocated, exiting." && exit 1

Discord_Config_dir="$(for di in $(find /home -type d -name 'discord' -exec find {} -type f -name 'quotes.json' \;);do dirname $di; done | head -n 1)"
[ -z "$Discord_Config_dir" ] || [ ! -e "$Discord_Config_dir" ] && echo "$(date) - Discord configuration directory was not found, exiting." && exit 1

Sudo_User_Name="USER"
[ "$(id "$Sudo_User_Name" &> /dev/null; echo $?)" != "0" ] && echo "$(date) - User $Sudo_User_Name does not exist, exiting" && exit 1

Sudo_User_Password="PASSWORD"
[ "$(sudo -Su "$Sudo_User_Name" sudo -Sv <<< "$Sudo_User_Password" &> /dev/null; echo $?)" != "0" ] && echo "$(date) - Password is wrong for user $Sudo_User_Name, exiting." && exit 1
[ "$(echo "$Sudo_User_Password" | sudo -u $Sudo_User_Name -S sh -c "id -Gn | grep 'sudo'" &> /dev/null; echo $?)" != "0" ] && echo "$(date) - User $Sudo_User_Name is not a sudoer, exiting" && exit 1

# Create Current MD5 if not exists
if [ ! -e "$Discord_Config_dir/Current_MD5.txt" ]; then
    if [ $(dpkg -s discord &> /dev/null;echo $?) -eq 0 ]; then
        trap 'CatchErrors' ERR
        echo "$Sudo_User_Password" | sudo -S sh -c "
        dpkg -r discord
        curl -Ls -o '/tmp/Latest_discord_installation.deb' 'https://discord.com/api/download?platform=linux&format=deb'
        dpkg -i  /tmp/Latest_discord_installation.deb
        echo "$Latest_MD5" > $Discord_Config_dir/Current_MD5.txt
        rm -rf /tmp/Latest_discord_installation.deb" &> /dev/null
        echo "$(date) - updated discord ($DIMD5 -> $Latest_MD5)"
    else
        echo "$(date) - Couldn't find discord installation using dpkg."       
    fi
fi

# Update discord
DIMD5=$( cat $Discord_Config_dir/Current_MD5.txt )
if [ "$DIMD5" != "$Latest_MD5" ]; then
    if [ $(dpkg -s discord &> /dev/null;echo $?) -eq 0 ]; then
        trap 'CatchErrors' ERR
        echo "$Sudo_User_Password" | sudo -S sh -c "
        dpkg -r discord
        curl -Ls -o '/tmp/Latest_discord_installation.deb' 'https://discord.com/api/download?platform=linux&format=deb'
        dpkg -i  /tmp/Latest_discord_installation.deb
        echo $Latest_MD5 > $Discord_Config_dir/Current_MD5.txt
        rm -rf /tmp/Latest_discord_installation.deb" &> /dev/null
	echo "$(date) - updated discord ($DIMD5 -> $Latest_MD5)"
    else
        echo "$(date) - Couldn't find discord installation using dpkg."
    fi
fi
