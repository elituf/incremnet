server := "futile@futile.eu"
deploy := "/var/www/incremnet/"

deploy-server:
    cargo build --release
    ssh {{server}} 'cd {{deploy}} && cp users.redb users.bak.redb'
    scp -pr target/release/incremnet static/index.html {{server}}:{{deploy}}

deploy-caddy:
    scp -pr Caddyfile {{server}}:Caddyfile
    ssh {{server}} 'sudo mv Caddyfile /etc/caddy/Caddyfile.d/incremnet.caddyfile'
    ssh {{server}} 'sudo systemctl reload caddy'

deploy: deploy-server deploy-caddy
