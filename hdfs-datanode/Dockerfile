ARG VERSION=3.2.4
FROM junit/hadoop-base:$VERSION

LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"

COPY run.sh /run.sh

ENV HDFS_CONF_dfs_datanode_data_dir=file:///hadoop/dfs/data

RUN groupadd -g 114 -r hadoop && \
    useradd --comment "Hadoop HDFS" -u 201 --shell /bin/bash -M -r --groups hadoop --home /var/lib/hadoop/hdfs hdfs && \
    mkdir -p /hadoop/dfs/data && \
    chown -R hdfs:hadoop /hadoop && \
    chown -LR hdfs:hadoop $HADOOP_HOME && \
    chown -R hdfs:hadoop $HADOOP_CONF_DIR

USER hdfs
WORKDIR $HADOOP_HOME

VOLUME /hadoop


CMD ["/run.sh"]
