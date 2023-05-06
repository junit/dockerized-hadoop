FROM openjdk:8-jre-slim

LABEL maintainer="cgiraldo@gradiant.org" \
      organization="gradiant.org"

ARG VERSION=3.3.5
ENV HADOOP_VERSION=$VERSION \
    HADOOP_HOME=/opt/hadoop

ENV HADOOP_PREFIX=$HADOOP_HOME \
    HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop \
    PATH=$PATH:$HADOOP_HOME/bin \
    MULTIHOMED_NETWORK=1 \
    CLUSTER_NAME=hadoop \
    HDFS_CONF_dfs_namenode_name_dir=file:///dfs/name \
    HDFS_CONF_dfs_datanode_data_dir=file:///dfs/data \
    USER=hdfs


RUN apt-get update && apt-get install -y curl procps build-essential autoconf automake libtool cmake zlib1g-dev pkg-config libssl-dev libsasl2-dev libsnappy1v5 libsnappy-dev bzip2 libbz2-dev fuse libfuse-dev libzstd-dev liblz4-tool nasm yasm && rm -rf /var/lib/apt/lists/* && \
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
    groupadd -g 114 -r hadoop && \
    useradd --comment "Hadoop HDFS" -u 201 --shell /bin/bash -M -r --groups hadoop --home /var/lib/hadoop/hdfs hdfs && \
    mkdir -p /dfs && \
    mkdir -p $HADOOP_HOME/logs && \
    chown -R hdfs:hadoop /dfs && \
    chown -LR hdfs:hadoop $HADOOP_HOME
   

COPY entrypoint.sh /entrypoint.sh

USER hdfs
WORKDIR $HADOOP_HOME

VOLUME /dfs

EXPOSE 8020 

# HDFS 2.x web interface
EXPOSE 50070

# HDFS 3.x web interface
EXPOSE 9870

ENTRYPOINT ["/entrypoint.sh"]
