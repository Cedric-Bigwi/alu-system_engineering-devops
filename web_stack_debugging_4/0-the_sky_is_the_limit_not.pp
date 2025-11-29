# 0-the_sky_is_the_limit_not.pp

# This Puppet manifest ensures the existing Nginx service is running and optimizes its configuration for high traffic loads.

# Ensure Nginx service is running and enabled at boot

service { 'nginx':
ensure => running,
enable => true,
}

# Apply optimized Nginx main configuration

file { '/etc/nginx/nginx.conf':
ensure  => file,
owner   => 'root',
group   => 'root',
mode    => '0644',
content => "user www-data;\n
worker_processes auto;\n
worker_rlimit_nofile 65535;\n
\nevents {\n
worker_connections 4096;\n
multi_accept on;\n
}\n
\nhttp {\n
include       mime.types;\n
default_type  application/octet-stream;\n
sendfile      on;\n
tcp_nopush    on;\n
tcp_nodelay   on;\n
keepalive_timeout 65;\n
gzip on;\n
server_tokens off;\n
include /etc/nginx/conf.d/*.conf;\n
include /etc/nginx/sites-enabled/*;\n
}\n",
notify  => Service['nginx'],
}

# Apply optimized default site configuration

file { '/etc/nginx/sites-available/default':
ensure  => file,
owner   => 'root',
group   => 'root',
mode    => '0644',
content => "server {\n
listen 80 default_server;\n
listen [::]:80 default_server;\n
\n
root /var/www/html;\n
index index.html index.htm;\n
\n
server_name _;\n
\n
location / {\n
try_files ${uri} ${uri}/ =404;\n
}\n
\n
access_log /var/log/nginx/access.log;\n
error_log /var/log/nginx/error.log;\n
}\n",
notify  => Service['nginx'],
}
