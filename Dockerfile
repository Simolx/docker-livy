FROM centos:7
MAINTAINER Dieudonne,simolx@163.com

ENV TZ Asia/Shanghai
ENV LC_ALL en_US.UTF-8
ENV SPARK_VERSION 2.2.1
ENV HADOOP_VERSION 2.7.2
ENV SPARK_HADOOP_VERSION 2.7
ENV JAVA_HOME /opt/sparkdistribute/jdk1.8.0_151
ENV PATH $JAVA_HOME/bin:/opt/anaconda/bin:$PATH
ENV HADOOP_CONF_DIR /opt/sparkdistribute/hadoop-${HADOOP_VERSION}/conf

RUN /bin/cp -f /usr/share/zoneinfo/$TZ /etc/localtime
RUN yum -y update \
    && yum install -y which openssh openssh-clients openssh-server bzip2 vim sudo \
    && yum clean all \
    && rm -rf /var/cache/yum
RUN localedef -i en_US -f UTF-8 en_US.UTF-8
RUN mkdir -p ${HADOOP_CONF_DIR}
# install jdk
RUN curl -O -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.tar.gz \
    && tar -xzf jdk-8u151-linux-x64.tar.gz -C /opt/sparkdistribute && \
    rm -f jdk-8u151-linux-x64.tar.gz
# install anaconda3
RUN curl -O https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh && \
    bash Anaconda3-5.0.1-Linux-x86_64.sh -b -f -p /opt/anaconda && \
    rm -f Anaconda3-5.0.1-Linux-x86_64.sh
RUN pip install --upgrade pip setuptools \
    && pip install kafka-python jieba \
    && rm -rf ~/.cache/pip/*
# install spark
RUN curl -O -L https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz \
    && tar -xzf spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz -C /opt/sparkdistribute \
    && rm -f spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz
# add hadoop configuration
RUN curl -O -L https://archive.apache.org/dist/hadoop/core/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz \
    && tar -xzf hadoop-${HADOOP_VERSION}.tar.gz -C /opt/sparkdistribute \
    && rm -rf hadoop-${HADOOP_VERSION}.tar.gz /opt/sparkdistribute/hadoop-${HADOOP_VERSION}/!(etc) \
    && mv /opt/sparkdistribute/hadoop-${HADOOP_VERSION}/etc/hadoop /opt/sparkdistribute/hadoop-${HADOOP_VERSION}/conf \
    && rm -r /opt/sparkdistribute/hadoop-${HADOOP_VERSION}/etc 
# install livy
RUN curl -O -L http://archive.apache.org/dist/incubator/livy/0.4.0-incubating/livy-0.4.0-incubating-bin.zip \
    && unzip livy-0.4.0-incubating-bin.zip -d /opt/sparkdistribute \
    && rm -f livy-0.4.0-incubating-bin.zip
RUN sed -i -e '/Defaults    requiretty/{ s/.*/# Defaults    requiretty/ }' /etc/sudoers
RUN useradd elasticsearch \
    && useradd gdata
WORKDIR /opt/baitu

VOLUME [ "${HADOOP_CONF_DIR", "/opt/baitu" ]
EXPOSE 8998
CMD ["/opt/sparkdistribute/livy-0.4.0-incubating-bin/bin/livy-server"]
