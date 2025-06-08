# incremnet
an 88x31 that you can click<br>
![](www/assets/screenshot.png)

*visit [increm.net](https://increm.net) to get your own!*

## project structure
- [**incremnet**](incremnet/) - the main project, serves at [increm.net/badge](https://increm.net/badge?key=changeme)
- [**redb_wrapper**](redb_wrapper/) - a wrapper library for basic redb get and set logic, shared by **incremnet** and **tools**
- [**tools**](tools/) - various tools for incremnet, such as dumping to json or setting a user's amount
- [**www**](www/) - the demo website at [increm.net](https://increm.net)

## running
```bash
git clone https://codeberg.org/futile/incremnet
podman build -t incremnet .
podman run --name incremnet -dt -p 1337:1337 -v ./users.redb:/project/users.redb:z incremnet
```

## basic backup
```bash
scp futile@192.168.178.3:/opt/incremnet/users.redb backups/users.redb
cargo run --bin tools dump backups/users.redb backups/users.json
```
