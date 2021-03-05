# initial-config

## Postgres steps

open the file pg_hba.conf for Ubuntu it will be in /etc/postgresql/x/main and change this line:

```txt
    local   all             postgres                                peer
```

to

```txt
    local   all             postgres                                trust
```

Then, restart the server

`sudo service postgresql restart`
