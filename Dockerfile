FROM benjaminrosner/isle-tomcat:preRC

LABEL "io.github.islandora-collaboration-group.name"="isle-solr" 
LABEL "io.github.islandora-collaboration-group.description"="ISLE Solr container, a powerful search engine responsible for handling user searches through your Islandora collections."
LABEL "io.github.islandora-collaboration-group.license"="Apache-2.0" 
LABEL "io.github.islandora-collaboration-group.vcs-url"="git@github.com:Islandora-Collaboration-Group/ISLE.git" 
LABEL "io.github.islandora-collaboration-group.vendor"="Islandora Collaboration Group (ICG) - islandora-consortium-group@googlegroups.com"
LABEL "io.github.islandora-collaboration-group.maintainer"="Islandora Collaboration Group (ICG) - islandora-consortium-group@googlegroups.com" 

ENV SOLR_HOME=/usr/local/solr

RUN GEN_DEP_PACKS="git" && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get install -y --no-install-recommends $GEN_DEP_PACKS && \
    ## Cleanup phase.
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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
    apt-get purge --auto-remove git -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY rootfs /

VOLUME /usr/local/solr

EXPOSE 8080 8983

ENTRYPOINT ["/init"]