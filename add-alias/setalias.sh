#!/usr/bin/env bash

if [ "$(whoami)" != 'root' ]; then
	echo "You have to execute this script as root user"
exit 1;


vh="/etc/apache2/sites-available/saas.example.com.conf"
main="saas.example.com"

if [ $# -eq 2 ]; then
    if [ "$1" = "add" ]; then
		  echo "Adding $2 to $main"
		  grep -rl 'ServerAlias' $vh | xargs sed -i "s/ServerAlias/ServerAlias $2/g"
		  echo `service apache2 reload`
		  logger "[Script] setAlias > Adding $2 to $vh"
    elif [[ "$1" == "delete" || "$1" == "remove" ]]; then
		  echo "Removing $2 from $main"
		  grep -rl $2 $vh | xargs sed -i "s/ $2//g"
		  echo `service apache2 reload`
		  logger "[Script] setAlias > Adding $2 to $vh"
    else
    	echo "[Error] First argument is unknown."
    fi
else
   echo "[Error] Check again your arguments."
fi

