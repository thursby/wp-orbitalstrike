# WordPress Orbital Strike
Grab your gear and head to the ship! Nuke your WordPress from orbit, it's the only way to be sure.

## Overview
It happens to the best of us. In spite of our efforts to keep our WordPress instances up-to-date, a plugin or theme falls behind and some miscreant uses that to ruin things.

At that point, it’s tempting to just remove the bad stuff and move along. However even if a thorough job is done, and WordPress core matches checksums, it’s entirely possible for the attacker to waltz right back in unless the WordPress security keys in wp-config.php are updated.

Since every WordPress installation is different, there’s no way to completely automate the process of cleaning up after a compromise, but this doesn’t mean we can’t sharpen our tools for the manual work.

## Keep the good stuff
It should go without saying that a backup should be made before doing any of this. While part of the process is to try and ensure everything is backed up, that shouldn’t be good enough; make another backup.

Note that all of these scripts assume you’re running them from the document root of the WordPress installation.

```
cd <wordpress directory>
./wp-backup.sh
```

Smile while you wait, and you're left with an archive containing your database, files, and information about your install.

## Get rid of the compromised stuff
Now the next step is to delete the WordPress installation. It’s at this point you’d need to make sure to keep any extra directories like a downloads folder, or any subdirectories that might contain other web applications. This part is up to you, but should be totally safe because you created that backup previously, *right*?

## Reinstall From the WordPress Repository
Here comes the cool part. We’ll need to read the info in the files we created earlier, and use WP-CLI to reinstall WordPress, themes, and plugins. Care is taken to record and reinstall the correct version. As long as the plugin is published correctly in the WordPress repository, this will result in a nicely working installation.

Of course if you’re using plugins or themes that aren’t in the repository, you’ll need to manually download and reinstall those.

```
wp-restore.sh
```

And there you have it! This should be a working WordPress installation. Note that we dumped the database but didn’t do anything with it. The same database is present. This means that for the small percentage of compromises that persist in the database, more work is necessary to get things back into shape.
