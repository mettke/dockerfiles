# Supported tags and respective `Dockerfile` links

-	[`0.16.1-1`, `0.16.1`, `latest` (*Dockerfile*)](https://github.com/mettke/dockerfiles/blob/bitcoinabc-alpine_0.16.1-1/bitcoinabc-alpine/Dockerfile)

Tags are supported for up to 1 year. Afterwards they may be removed any time.

### x.x.x-x

Tags like 0.16.1-1 are only updated when the alpine base image is updated. The glibc and bitcoin-abc Version is frozen to allow using a specific version of both.

### x.x.x

Tags like 0.16.1 are updated when the alpine base image or glibc is update. The bitcoin-abc Version is frozen to allow using a specific version.

### latest

The latest tag will be updated when alpine, glibc or bitcoin-abc are updated. It will always point to the newest version (except release candidates)

# What is Bitcoin-ABC?

Bitcoin-ABC is the official Bitcoin Client for BitcoinCash. It allows creating a full-node Server to synchronize and distribute the blockchain between other nodes.

> [bitcoinabc.org](https://www.bitcoinabc.org/)

# How to use this image

## Run bitcoind Server

The Bitcoin Daemon can be started with the following command:

```console
docker run --name BitcoinABC --volume /path/to/bitcoin/datadir:/data --publish 8333:8333 --detach toendeavour/bitcoinabc-alpine
```

It requires a Volume to store the database and the daemon configuration file. Furthermore the Port 8333 has to be published to allow other Nodes to connect.

## Using RPC

The Port 8334 can be published or exposed to allow a Bitcoin Client to connect to the Node. The following command will publish that port to the outside. You may want to consider only exposing it to prevent unwanted access.

```console
docker run --name BitcoinABC --volume /path/to/bitcoin/datadir:/data --publish 8333:8333 --publish 8334:8334 --detach toendeavour/bitcoinabc-alpine
```

To enable the RPC it is necessary to modify (create if not existing) the *bitcoin.conf* file in the datadir like this:

```
server=1
listen=1
rpcuser=bitcoinrpc
rpcpassword=<password>
rpcallowip=<ip-range to allow>
```

A restart is necessary for the Server to reload the configuration file.

## Transaction Database Index

Services like electrum require the *txindex* option to be set. Adding the following lines to the *bitcoin.conf* file in the datadir will enable it:

```
txindex=1
reindex=1
```

A restart is necessary after the modification for the Server to reload the configuration. The *reindex=1* is only required when the server was started before and must be removed after the restart to prevent reindexing on each startup

## docker-compose.yml

Here is an example using docker-compose.yml:

```yaml
bitcoind:
  image: toendeavour/bitcoinabc-alpine
  Restart: always
  Ports:
  - "8333:8333"
  volumes:
  - /path/to/bitcoin/datadir:/data
```
