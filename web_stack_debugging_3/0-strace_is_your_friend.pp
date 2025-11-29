# Puppet manifest to fix the class-wp-locale typo in wp-settings.php

exec { 'fix-wp-locale-typo':
command => '/bin/sed -i "s/class-wp-locale.phpp/class-wp-locale.php/" /var/www/html/wp-settings.php',
onlyif  => '/bin/grep -q "class-wp-locale.phpp" /var/www/html/wp-settings.php',
}
