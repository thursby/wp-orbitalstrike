#!/bin/bash

tmp_dir=`mktemp -d`
echo Work Directory: $tmp_dir

files_to_keep=("wp-config.php" "wp-content/uploads")

for i in ${files_to_keep[@]}; do
  echo "Copying ${i}"
  cp -R ${i} $tmp_dir  # Replace with mv for speed once it's working right
done

echo "Backing up WordPress Database and saving data"
wp db export $tmp_dir/database.sql
wp core version > $tmp_dir/wp_version.txt
wp plugin list --format=csv > $tmp_dir/wp_plugins.txt
wp theme list --format=csv > $tmp_dir/wp_themes.txt

do_not_compress=".tiff:.gif:.snd:.png:.jpg:.jpeg:.mp3:.tif"

zip --suffixes $do_not_compress -1 -r $tmp_dir/backup.zip -x@"exclude.txt" .

echo "Finished backing up to: $tmp_dir"
