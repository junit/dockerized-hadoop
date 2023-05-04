FROM openjdk:8u242-jre-slim

LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"

ARG VERSION=3.2.4
ENV HADOOP_VERSION=$VERSION \
    HADOOP_HOME=/opt/hadoop

ENV HADOOP_PREFIX=$HADOOP_HOME \
    HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop \
    PATH=$PATH:$HADOOP_HOME/bin \
    MULTIHOMED_NETWORK=1

RUN apt-get update && apt-get install -y curl procps build-essential autoconf automake libtool cmake zlib1g-dev pkg-config libssl-dev libsasl2-dev libsnappy1v5 libsnappy-dev bzip2 libbz2-dev fuse libfuse-dev libzstd-dev nasm yasm && rm -rf /var/lib/apt/lists/* && \
curl -SL https://github.com/intel/isa-l/archive/v2.30.0.tar.gz | tar xvz -C /opt && \
cd /opt/isa-l-2.30.0 && \
./autogen.sh && \
./configure && \
make && \
make install && \
curl -SL https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz | tar xvz -C /opt && \
ln -s /opt/hadoop-$HADOOP_VERSION $HADOOP_HOME && \
# remove documentation from container image
rm -r $HADOOP_HOME/share/doc && \
if [ ! -f $HADOOP_CONF_DIR/mapred-site.xml ]; then \
cp $HADOOP_CONF_DIR/mapred-site.xml.template $HADOOP_CONF_DIR/mapred-site.xml; \
fi && \
mkdir -p $HADOOP_HOME/logs


COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
