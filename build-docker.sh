#!/bin/bash

VERSION=3.2.4

docker buildx build --progress plain --build-arg VERSION=$VERSION  --target hadoop-base -t junit/hadoop-base:$VERSION hadoop-base
docker buildx build --progress plain --build-arg VERSION=$VERSION -t junit/hdfs-namenode:$VERSION hdfs-namenode
docker buildx build --progress plain --build-arg VERSION=$VERSION -t junit/hdfs-datanode:$VERSION hdfs-datanode

docker tag junit/hadoop-base:$VERSION junit/hadoop-base:latest
docker tag junit/hdfs-namenode:$VERSION junit/hdfs-namenode:latest
docker tag junit/hdfs-datanode:$VERSION junit/hdfs-datanode:latest
