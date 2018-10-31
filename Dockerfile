FROM islandoracollabgroup/isle-tomcat:serverjre8

ENV SOLR_HOME=/usr/local/solr \
    SOLR_VERSION=4.10.4 \
    CATALINA_BASE=/usr/local/tomcat \
    JAVA_MAX_MEM=${JAVA_MAX_MEM:-2G} \
    JAVA_MIN_MEM=${JAVA_MIN_MEM:-512M} \
    ## Per Gavin, we are no longer using -XX:+UseConcMarkSweepGC, instead G1GC.
    JAVA_OPTS='-Djava.awt.headless=true -server -Xmx${JAVA_MAX_MEM} -Xms${JAVA_MIN_MEM} -XX:+UseG1GC -XX:+UseStringDeduplication -XX:MaxGCPauseMillis=200 -XX:InitiatingHeapOccupancyPercent=70 -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true'

###
# Solr Installation
RUN mkdir -p $SOLR_HOME && \
    cd /tmp && \
    git clone -b 4.10.x https://github.com/discoverygarden/basic-solr-config.git && \
    curl -O -L http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz && \
    tar -xvzf /tmp/solr-$SOLR_VERSION.tgz && \
    cp -v /tmp/solr-$SOLR_VERSION/dist/solr-$SOLR_VERSION.war $CATALINA_HOME/webapps/solr.war && \
    unzip -o /usr/local/tomcat/webapps/solr.war -d $CATALINA_HOME/webapps/solr/ && \
    cp -rv /tmp/solr-$SOLR_VERSION/example/solr/* $SOLR_HOME && \
    cp -v /tmp/basic-solr-config/conf/* $SOLR_HOME/collection1/conf && \
    cp -rv /tmp/solr-$SOLR_VERSION/example/lib/ext/* $CATALINA_HOME/webapps/solr/WEB-INF/lib/ && \
    cp -v /tmp/solr-$SOLR_VERSION/contrib/analysis-extras/lib/icu4j-53.1.jar $CATALINA_HOME/webapps/solr/WEB-INF/lib/ && \
    cp -v /tmp/solr-$SOLR_VERSION/contrib/analysis-extras/lucene-libs/lucene-analyzers-icu-$SOLR_VERSION.jar $CATALINA_HOME/webapps/solr/WEB-INF/lib/ && \
    ## Cleanup phase.
    rm -rf /tmp/*

# Labels
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="ISLE Solr Image" \
      org.label-schema.description="Apache Solr Image. Search your Islandora Collection. Powered by Lucene™, Solr enables powerful matching capabilities including phrases, wildcards, joins, grouping and much more across any data type" \
      org.label-schema.url="https://islandora-collaboration-group.github.io" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/Islandora-Collaboration-Group/isle-solr" \
      org.label-schema.vendor="Islandora Collaboration Group (ICG) - islandora-consortium-group@googlegroups.com" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0" \
      traefik.port="8080"

COPY rootfs /

VOLUME /usr/local/solr

EXPOSE 8080 8983

ENTRYPOINT ["/init"]