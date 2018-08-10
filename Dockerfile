FROM benjaminrosner/isle-tomcat:latest

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
      traefik.enable="true" \
      traefik.port="8080" \
      traefik.backend="isle-solr"

ENV SOLR_HOME=/usr/local/solr

###
# Solr Installation
RUN mkdir -p $SOLR_HOME && \
    cd /tmp && \
    git clone -b 4.10.x https://github.com/discoverygarden/basic-solr-config.git && \
    wget "http://archive.apache.org/dist/lucene/solr/4.10.4/solr-4.10.4.tgz" && \
    tar -xvzf /tmp/solr-4.10.4.tgz && \
    cp -v /tmp/solr-4.10.4/dist/solr-4.10.4.war $CATALINA_HOME/webapps/solr.war && \
    unzip -o /usr/local/tomcat/webapps/solr.war -d $CATALINA_HOME/webapps/solr/ && \
    cp -rv /tmp/solr-4.10.4/example/solr/* $SOLR_HOME && \
    cp -v /tmp/basic-solr-config/conf/* $SOLR_HOME/collection1/conf && \
    cp -rv /tmp/solr-4.10.4/example/lib/ext/* $CATALINA_HOME/webapps/solr/WEB-INF/lib/ && \
    cp -v /tmp/solr-4.10.4/contrib/analysis-extras/lib/icu4j-53.1.jar $CATALINA_HOME/webapps/solr/WEB-INF/lib/ && \
    cp -v /tmp/solr-4.10.4/contrib/analysis-extras/lucene-libs/lucene-analyzers-icu-4.10.4.jar $CATALINA_HOME/webapps/solr/WEB-INF/lib/ && \
    ## Cleanup phase.
    rm -rf /tmp/*

COPY rootfs /

VOLUME /usr/local/solr

EXPOSE 8080 8983

ENTRYPOINT ["/init"]