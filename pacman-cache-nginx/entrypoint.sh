#!/bin/bash
upstream_entries=""
server_entries=""
current_port=8001

if [ -z "${MIRRORS}" ]; then
    echo \
"The MIRRORS environment variable is required. It specifies mirrors to fetch packages from. They 
will be used round-robin and must store files using the same url (/archlinux/\$repo/os/\$arch)
To use a single Mirror use MIRRORS=\"https://archlinux.surlyjake.com\".
To use multiple Mirrors use MIRRORS=\"https://archlinux.surlyjake.com http://mirrors.evowise.com\"
You can also specify backup mirrors using BACKUP_MIRRORS. They are defined the same way and will
only be used when no mirror from MIRRORS is availale."
    exit 1
fi

function process_mirror () {
    echo "Adding mirror ${mirror}${1}"
    host="$(echo ${mirror} | sed 's/.*:\/\/\([^/]*\)/\1/')"
    upstream_entries+="    server localhost:${current_port}${1};\n"
    server_entries+="server
{
    listen      ${current_port};
    server_name localhost;

    location / {
        proxy_pass       ${mirror}\$request_uri;
        proxy_set_header Host ${host};
    }
}\n"
    current_port=$((current_port+1))
}

for mirror in ${MIRRORS}; do 
    process_mirror
done
for mirror in ${BACKUP_MIRRORS}; do 
    process_mirror " backup"
done

echo -e \
"# nginx may need to resolve domain names at run time
resolver 8.8.8.8 8.8.4.4;

# Pacman Cache
server
{
    listen      80;
    server_name cache.domain.local;
    root        /cache;
    autoindex   on;

    # Requests for package db and signature files should redirect upstream without caching
    location ~ \.(db|sig|files)$ {
        proxy_pass http://mirrors\$request_uri;
    }

    # Requests for actual packages should be served directly from cache if available.
    # If not available, retrieve and save the package from an upstream mirror.
    location ~ \.tar(|\.gz|\.bz2|\.xz|\.lzo|\.lrz|\.Z)$ {
        try_files \$uri @pkg_mirror;
    }

    # Retrieve package from upstream mirrors and cache for future requests
    location @pkg_mirror {
        proxy_cache_lock on;
        proxy_cache_revalidate on;
        proxy_next_upstream error timeout http_404;
        proxy_pass          http://mirrors\$request_uri;
        proxy_redirect off;
        proxy_store    on;
        proxy_store_access  user:rw group:rw all:r;
        proxy_intercept_errors on;
        error_page 301 302 307 = @handle_redirects;
    }

    # Handle redirects so they won't be transfered back to the client but cached as well
    location @handle_redirects {
        #store the current state of the world
        set \$orig_loc \$upstream_http_location;

        # nginx goes to fetch the value from the upstream Location header
        proxy_pass \$orig_loc;
        proxy_cache_lock on;
        proxy_cache_revalidate on;
        proxy_next_upstream error timeout http_404;
        proxy_redirect off;
        proxy_store    on;
        proxy_store_access  user:rw group:rw all:r;
    }
}

# Upstream Arch Linux Mirrors
# - Configure as many backend mirrors as you want in the blocks below
# - Servers are used in a round-robin fashion by nginx
# - Add \"backup\" if you want to only use the mirror upon failure of the other mirrors
# - Separate \"server\" configurations are required for each upstream mirror so we can set the \"Host\" header appropriately
upstream mirrors {
${upstream_entries}
}

${server_entries}" > /etc/nginx/conf.d/cache.conf

nginx -g "daemon off;"
