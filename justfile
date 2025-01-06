set windows-shell := ["pwsh", "-NoLogo", "-Command"]

server := "futile@futile.eu"
deploy := "/var/www/incremnet"

backup:
    ssh {{server}} 'cd {{deploy}} && cp users.redb users.bak.redb'
    -mkdir -p backups
    scp futile@futile.eu:{{deploy}}/users.bak.redb backups/users.bak.redb
    cargo run --release --quiet --bin tools dump backups/users.bak.redb backups/users.json

deploy-server: backup
    cargo build --release --quiet
    scp -pr target/release/incremnet www/ {{server}}:{{deploy}}
    scp -pr incremnet/static/bg.png {{server}}:{{deploy}}/www

deploy-caddy:
    scp -pr Caddyfile {{server}}:Caddyfile
    ssh {{server}} 'sudo mv Caddyfile /etc/caddy/Caddyfile.d/incremnet.caddyfile'
    ssh {{server}} 'sudo systemctl reload caddy'

deploy: deploy-server deploy-caddy
