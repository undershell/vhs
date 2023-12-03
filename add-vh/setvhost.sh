#!/bin/bash

# Check user permissions
if [ "$(whoami)" != "root" ]; then
	echo "Root privileges are required to run this, try running with sudo..."
	exit 2
fi

# Define useful paths
current_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
available_vh_path="/etc/apache2/sites-available/"
enabled_vh_path="/etc/apache2/sites-enabled/"
vhost_skeleton_path="$current_directory/vhost.skeleton.conf"

# User input passed as options
site_domain=""
web_root=""


# if followed by colon (:), it has a required argument. If followed by (::) it's optional
ARGS=$(getopt --options u:d: --long domain:,directory: -- "$@")
if [[ $? -ne 0 ]]; then
    exit 1;
fi


eval set -- "$ARGS"
while true ; do
  case "$1" in
    -u | --domain )
        site_domain=${2}
        shift 2
        ;;
    -d | --directory )
        web_root=${2}
        shift 2
        ;;
    -- ) shift; 
        break 
        ;;
  esac
done


# prompt if not passed as argument
while [ -z $site_domain ] ; do
	read -p "Please enter the desired domain: " site_domain
done


# Check if the vhost exists, suggest to disable it
if [ -f "$enabled_vh_path$site_domain.conf" ]; then
	while true; do
		read -p $enabled_vh_path$site_domain'.conf already exists and will be updated (CTRL+C to cancel).'$'\n''Would you rather like to disable this config file? [y/n]' yn
		case $yn in
			[Yy]* )
				#a2dissite "$site_domain.conf";
				echo `a2dissite $site_domain`
				echo `service apache2 reload`
				logger "[Script] setvhost > Disabling $site_domain"
				exit;;
			[Nn]* ) break;;
			* ) echo "Please answer yes or no.";;
		esac
	done
fi

# prompt if not passed as argument
while [ -z $web_root ] ; do
	read -p "Please enter its web directory (e.g.: /var/www/$site_domain): " web_root
 done


# create directory if it doesn't exists
if [ ! -d "$web_root" ]; then

	# create directory
	`mkdir -p "$web_root/"`
	`chown -R www-data:www-data "$web_root/"`

	# create index file
	indexfile="$web_root/index.html"
	`touch "$indexfile"`
	echo "<html><head></head><body>Welcome!</body></html>" >> "$indexfile"

	echo "Created directory $web_root/"
fi

# update vhost
vhost=`cat "$vhost_skeleton_path"`
vhost=${vhost//@site_domain@/$site_domain}
vhost=${vhost//@site_directory@/$web_root}

`touch $available_vh_path$site_domain.conf`
echo "$vhost" > "$available_vh_path$site_domain.conf"
echo "Updated vhosts in Apache config"

# restart apache
echo "Enabling site in Apache..."
echo `a2ensite $site_domain`

echo "Reloading Apache..."
echo `service apache2 reload`

echo "Process complete, check out the new site at http://$site_domain"
logger "[Script] setvhost > $site_domain was added or updated."
exit 0
