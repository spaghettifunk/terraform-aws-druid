![](http://www.malinga.me/wp-content/uploads/2017/08/Druid_MasterLogo_Full-ColorTransparent.png)

# Druid Docker

## Build

You can do the docker build using

```bash
docker build -t . druid-image:latest
```

This use the default value to DRUID_VERSION, that you can read inside Dockerfile. If you want to download other druid version you can configure using docker build args:

```bash
docker build --build-arg DRUID_VERSION=0.11.0 -t druid:latest .
```

## Druid Configuration

The druid docker by default use derby metadata-storage and local deep storage. You can change it, to do it you could mount a volume with the new configuration into the folder `/opt/druid/conf`.

## Environments

* **ZOOKEEPER_SERVER**
The zookeeper server address.

* **DRUID_SERVICE**
The name of the druid service [`broker`, `historical`, `coordinator`, `overlord`, `middleManager`]

* **DRUID_HOST**
The advertiser address that uses druid to expose the service on zookeeper.

* **DRUID_SERVICE_PORT**
The service port where bind the druid service.

* **DRUID_JVM_ARGS**
The JVM arguments to execute the druid services.

* **DRUID_PULL_EXTENSION**
The druid extension to download, this download is performed at running time. You need to pass the extension with whitespace: `extension1:extension1:version extension2:extension2:version`

* **AWS_REGION**
AWS region this is needed to work with AWS S3 extension.

## Examples

* **Coordinator**

```bash
docker run -it -e ZOOKEEPER_SERVER=192.168.0.102 -e DRUID_SERVICE=coordinator -e DRUID_HOST=192.168.0.102 -e DRUID_SERVICE_PORT=8081 -e DRUID_JVM_ARGS="-server -Xms256m -Xmx256m -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager -Dderby.stream.error.file=var/druid/derby.log" druid:latest
```

* **Broker**

```bash
docker run -it -e ZOOKEEPER_SERVER=192.168.0.102 -e DRUID_SERVICE=broker -e DRUID_HOST=192.168.0.102 -e DRUID_SERVICE_PORT=8080 -e DRUID_JVM_ARGS="-server -Xms6g -Xmx6g -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager -XX:NewSize=512m -XX:MaxNewSize=512m -XX:MaxDirectMemorySize=6g -XX:+UseG1GC -XX:+PrintGCDetails -XX:+PrintGCTimeStamps" druid:latest
```

* **Historical**

```bash
docker run -it -e ZOOKEEPER_SERVER=192.168.0.102 -e DRUID_SERVICE=historical -e DRUID_HOST=192.168.0.102 -e DRUID_SERVICE_PORT=8081 -e DRUID_JVM_ARGS="-server -Xms2g -Xmx2g -XX:MaxDirectMemorySize=3g -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager -XX:NewSize=1g -XX:MaxNewSize=1g -XX:+UseConcMarkSweepGC -XX:+PrintGCDetails -XX:+PrintGCTimeStamps" druid:latest
```

* **Overlord**

```bash
docker run -it -e ZOOKEEPER_SERVER=192.168.0.102 -e DRUID_SERVICE=overlord -e DRUID_HOST=192.168.0.102 -e DRUID_SERVICE_PORT=8084 -e DRUID_JVM_ARGS="-server -Xms256m -Xmx256m -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager" druid:latest
```

* **MiddleManager**

```bash
docker run -it -e ZOOKEEPER_SERVER=192.168.0.102 -e DRUID_SERVICE=middleManager -e DRUID_HOST=192.168.0.102 -e DRUID_SERVICE_PORT=8091 -e DRUID_JVM_ARGS="-server -Xms64m -Xmx64m -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager" druid:latest
```
