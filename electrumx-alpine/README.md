# Supported tags and respective `Dockerfile` links

-	[`1.2.1-leveldb`, `leveldb` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/electrumx-alpine_1.2.1/electrumx-alpine/Dockerfile-leveldb)
-	[`1.2.1-rocksdb`, `rocksdb` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/electrumx-alpine_1.2.1/electrumx-alpine/Dockerfile-rocksdb)
-	[`1.2-leveldb` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/electrumx-alpine_1.2/electrumx-alpine/Dockerfile-leveldb)
-	[`1.2-rocksdb` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/electrumx-alpine_1.2/electrumx-alpine/Dockerfile-rocksdb)

Tags are supported for up to 1 year. Afterwards they may be removed any time.

### x.x-db

Tags like 1.2-db are only updated when the alpine base image is updated. The electrumx Version is frozen to allow using a specific version.

### latest

There is no latest tag available for this image. Instead it is necessary to choose between leveldb or rocksdb. The tags *leveldb* and *rocksdb* will act like the latest tag for the given database.

# What is ElectrumX?

ElectrumX started as an alternative implementation of the original [electrum-server](https://github.com/spesmilo/electrum-server) from spesmilo. Now the electrum-server is discontinued and ElectrumX is the offical way to create an Electrum Server for Bitcoin, BitcoinCash, Litecoin und many more Coins.

> [github.com/kyuupichan/electrumx](https://github.com/kyuupichan/electrumx)

# How to use this image

## Run ElectrumX Server

The ElectrumX Daemon can be used either with leveldb or rocksdb. The following command will start the Server with leveldb:

```console
docker run --name ElectrumX \
           --env COIN=BitcoinCash \
           --env DAEMON_URL=http://username:password@host:port/ \
           --env NET=mainnet \
           --env HOST="" \
           --volume /path/to/electrumx/db:/db \
           --publish 50001:50001 \
           --publish 50002:50002 \
           --detach toendeavour/electrumx-alpine:leveldb
```

If you want to use rocksdb than you only have to substitute leveldb with rocksdb. The Server requies a Volume to store the database and a few environment Variables. The env is used to tell the Server where the rpc server of a bitcoin full-node is. Furtherfore is specifies which coin and which net (main or test) to use. To allow Connections from the outside it is necessary to open Port 50001 and 50002. *HOST=""* is require for the server to listen to all interfaces and not only to localhost. Remove it if you want your connections to be limited to the localhost interface.

## SSL

ElectrumX can be used with and without a Certificate. If you want your connections to be secured by ssl you will need to add another volume with either a self-signed or a real certificate and its key. It is also necessary to define a few more environment variables:

```console
docker run --name ElectrumX \
           --env COIN=BitcoinCash \
           --env DAEMON_URL=http://username:password@host:port/ \
           --env NET=mainnet \
           --env HOST="" \
           --env SSL_CERTFILE: /certs/cert.crt \
           --env SSL_KEYFILE: /certs/key.key \
           --env TCP_PORT: 50001 \
           --env SSL_PORT: 50002 \
           --volume /path/to/electrumx/db:/db \
           --volume /path/to/electrumx/certs:/certs:ro \
           --publish 50001:50001 \
           --publish 50002:50002 \
           --detach toendeavour/electrumx-alpine:leveldb
```

## Logs

ElectrumX logs by default to the file *current* in the */log* directory. It is necessary to add an additional volume to read it outside of the cointainer:

```console
docker run --name ElectrumX \
           --env COIN=BitcoinCash \
           --env DAEMON_URL=http://username:password@host:port/ \
           --env NET=mainnet \
           --env HOST="" \
           --volume /path/to/electrumx/db:/db \
           --volume /path/to/electrumx/log:/log \
           --publish 50001:50001 \
           --publish 50002:50002 \
           --detach toendeavour/electrumx-alpine:leveldb
```

Afterwarts it is possible to read the log with a command like this:

```console
tail -f /path/to/electrumx/log/current
```

## docker-compose.yml

Here is an example using docker-compose.yml with SSL:

```yaml
electrumX:
  image: toendeavour/electrumx-alpine:leveldb
  restart: always
  ports:
  - "50001:50001"
  - "50002:50002" 
  environment:
    COIN: BitcoinCash
    NET: mainnet
    DAEMON_URL: http://username:password@host:port/
    HOST: ""
    SSL_CERTFILE: /certs/cert.crt
    SSL_KEYFILE: /certs/key.key
    TCP_PORT: 50001
    SSL_PORT: 50002
  volumes:
  - /path/to/electrumx/db:/db
  - /path/to/electrumx/certs:/certs:ro
  - /path/to/electrumx/log:/log
```

## DB_ENGINE and database switch

ElectrumX uses the environment variable *DB_ENGINE* to specify which database to use. Do *not* change the value of that variable as it might lead to errors. Instead use the corresponding tag to ensure that all dependencies are installed. Furthermore before changing the database it is necessary to remove the old one for a complete resync.

## Volume Permission

ElectrumX requires write access to the */log* and *./db* volume. The Server itself is running with the User *electrumx* using UID and GID *1000*. Write Access is therefore a matter of using:

```console
chown 1000:1000 \ 
      /path/to/electrumx/db \
      /path/to/electrumx/log
```
