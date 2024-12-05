server := "futile@futile.eu"

deploy-server:
    cargo build --release
    scp -pr target/release/incremnet static/index.html {{server}}:/var/www/incremnet/

deploy-caddy:
    scp -pr Caddyfile {{server}}:Caddyfile
    ssh {{server}} 'sudo mv Caddyfile /etc/caddy/Caddyfile.d/incremnet.caddyfile'
    ssh {{server}} 'sudo systemctl reload caddy'

deploy: deploy-server deploy-caddy
