setup:
    sudo cp Caddyfile /etc/caddy/Caddyfile.d/increm.net.caddyfile
    sudo systemctl reload caddy

run:
    git pull
    -sudo podman stop --time 0 incremnet
    sudo podman build --tag incremnet .
    sudo podman run --replace --detach --tty --name incremnet --publish 1337:1337 --volume ./users.redb:/project/users.redb:z incremnet
