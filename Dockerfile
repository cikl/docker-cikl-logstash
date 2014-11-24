FROM cikl/base:0.0.2
MAINTAINER Mike Ryan <falter@gmail.com>

RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  gpg --keyserver keyserver.ubuntu.com --recv D88E42B4 && \
  gpg --export --armor D88E42B4 | apt-key add - && \ 
  echo "deb http://packages.elasticsearch.org/logstash/1.4/debian stable main" > /etc/apt/sources.list.d/logstash.list && \
  apt-get update && \
  apt-get install -y --no-install-recommends -y openjdk-7-jre-headless logstash logstash-contrib && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Define mountable directories.
VOLUME [ "/data" ]

ENV LS_PLUGIN_DIR /opt/cikl-logstash/logstash-plugins
ENV LS_HOME /data
ENV LS_CONFIG /opt/cikl-logstash/logstash.conf
ENV LS_HEAP_SIZE 500m
ENV LS_JAVA_OPTS -Djava.io.tmpdir=/data
ENV JAVA_OPTS -Djava.io.tmpdir=/data

# Define working directory.
WORKDIR /data

ADD files /opt/cikl-logstash

ADD logstash-command.sh /etc/docker-entrypoint/commands.d/logstash
ADD logstash-pre.sh /etc/docker-entrypoint/pre.d/logstash-pre.sh
RUN chmod a+x /etc/docker-entrypoint/commands.d/logstash

CMD [ "logstash" ]
