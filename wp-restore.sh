#!/bin/bash

source_dir=$1

wp_core_version=`cat "$source_dir/wp_version.txt"`

# Download and extract the WordPress core
wp core download --version=$wp_core_version

# Read the list of themes from the file we created earlier
INPUT=$source_dir/wp_themes.txt
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read -r line
do
	theme=`echo $line | awk -F"," '{ print $1 }'`
	isactive=`echo $line | awk -F"," '{ print $2 }'`
	version_number=`echo $line | awk -F"," '{ print $4 }'`
	
	if [ "$isactive" = "active" ]
	then
		isactive="--activate"
	else
		isactive=""
	fi
	if [ "$theme" != "name" ]
	then
		wp theme install $theme --version=$version_number $isactive
	fi
done < $INPUT

# Read the plugins from the file we created earlier
INPUT=$source_dir/wp_plugins.txt
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read -r line
do
	plugin=`echo $line | awk -F"," '{ print $1 }'`
	isactive=`echo $line | awk -F"," '{ print $2 }'`
	version_number=`echo $line | awk -F"," '{ print $4 }'`
	
	if [ "$isactive" = "active" ]
	then
		isactive="--activate"
	else
		isactive=""
	fi
	if [ "$plugin" != "name" ]
	then
		wp plugin install $plugin --version=$version_number $isactive
	fi
done < $INPUT

# Copy the wp-config and uploads directories back.
cp $source_dir/wp-config.php .
mkdir wp-content
cp -R $source_dir/uploads wp-content/uploads

# Reset WordPress security keys
# Found on StackOverflow http://stackoverflow.com/a/16389269/6060612
# Not even marked as the correct answer, but this does the trick even with existing keys

find . -name wp-config.php -print | while read line
do
    curl http://api.wordpress.org/secret-key/1.1/salt/ > wp_keys.txt
    sed -i.bak -e '/put your unique phrase here/d' -e \
    '/AUTH_KEY/d' -e '/SECURE_AUTH_KEY/d' -e '/LOGGED_IN_KEY/d' -e '/NONCE_KEY/d' -e \
    '/AUTH_SALT/d' -e '/SECURE_AUTH_SALT/d' -e '/LOGGED_IN_SALT/d' -e '/NONCE_SALT/d' $line
    cat wp_keys.txt >> $line
    rm wp_keys.txt
done
