set windows-shell := ["pwsh", "-NoLogo", "-Command"]

server := "futile@futile.eu"
deploy-dir := "~/incremnet"
site-dir := "/var/www/incremnet-site"

backup:
    ssh {{server}} 'cd {{deploy-dir}} && cp users.redb users.bak.redb'
    -mkdir -p backups
    scp futile@futile.eu:{{deploy-dir}}/users.bak.redb backups/users.bak.redb
    cargo run --release --quiet --bin tools dump backups/users.bak.redb backups/users.json

deploy-site:
    scp -pr www/* incremnet/static/bg.png {{server}}:{{site-dir}}

deploy-caddy:
    scp -pr Caddyfile {{server}}:Caddyfile
    ssh {{server}} 'sudo mv Caddyfile /etc/caddy/Caddyfile.d/incremnet.caddyfile'
    ssh {{server}} 'sudo systemctl reload caddy'

deploy: backup deploy-site deploy-caddy
