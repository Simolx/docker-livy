FROM dieudonne/docker-spark
MAINTAINER Dieudonne lx <lx.simon@yahoo.com>

ENV LIVY_VERSION=0.5.0-incubating \
    LIVY_HOME=/opt/distribute/livy-bin
# install livy
RUN curl -O -L http://archive.apache.org/dist/incubator/livy/${LIVY_VERSION}/livy-${LIVY_VERSION}-bin.zip && \
    unzip livy-${LIVY_VERSION}-bin.zip -d /opt/distribute && \
    rm -f livy-${LIVY_VERSION}-bin.zip && \
    mv /opt/distribute/livy-${LIVY_VERSION}-bin ${LIVY_HOME} && \
    mkdir ${LIVY_HOME}/logs
COPY conf/livy/* ${LIVY_HOME}/conf/
EXPOSE 18998
CMD ["/opt/distribute/livy-bin/bin/livy-server"]
