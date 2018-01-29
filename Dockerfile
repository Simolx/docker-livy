FROM dieudonne/docker-spark
MAINTAINER Dieudonne lx <lx.simon@yahoo.com>

ENV LIVY_VERSION=0.4.0-incubating
# install livy
RUN curl -L http://archive.apache.org/dist/incubator/livy/${LIVY_VERSION}/livy-${LIVY_VERSION}-bin.zip | unzip - -d /opt/distribute
    && mkdir /opt/distribute/livy-${LIVY_VERSION}-bin/logs \
COPY conf/livy/* /opt/distribute/livy-${LIVY_VERSION}-bin/conf/
EXPOSE 8998
CMD ["/opt/distribute/livy-0.4.0-incubating-bin/bin/livy-server"]
