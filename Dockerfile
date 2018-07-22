FROM benjaminrosner/isle-tomcat:refactor

LABEL "io.github.islandora-collaboration-group.name"="isle-solr" 
LABEL "io.github.islandora-collaboration-group.description"="ISLE Solr container, a powerful search engine responsible for handling user searches through your Islandora collections."
LABEL "io.github.islandora-collaboration-group.license"="Apache-2.0" 
LABEL "io.github.islandora-collaboration-group.vcs-url"="git@github.com:Islandora-Collaboration-Group/ISLE.git" 
LABEL "io.github.islandora-collaboration-group.vendor"="Islandora Collaboration Group (ICG) - islandora-consortium-group@googlegroups.com"
LABEL "io.github.islandora-collaboration-group.maintainer"="Islandora Collaboration Group (ICG) - islandora-consortium-group@googlegroups.com" 

###
# Solr Installation
RUN cd /tmp && \
    wget "http://archive.apache.org/dist/lucene/solr/4.10.4/solr-4.10.4.tgz" && \
    tar -xvzf /tmp/solr-4.10.4.tgz && \
    cp -v /tmp/solr-4.10.4/dist/solr-4.10.4.war /usr/local/tomcat/webapps/solr.war && \
    unzip -o /usr/local/tomcat/webapps/solr.war -d /usr/local/tomcat/webapps/solr/ && \
    cp -rv /tmp/solr-4.10.4/example/solr/. /usr/local/solr/ && \
    cp -rv /tmp/solr-4.10.4/example/lib/ext/. /usr/local/tomcat/webapps/solr/WEB-INF/lib/ && \
    cp -v /tmp/solr-4.10.4/contrib/analysis-extras/lib/icu4j-53.1.jar /usr/local/tomcat/webapps/solr/WEB-INF/lib/ && \
    cp -v /tmp/solr-4.10.4/contrib/analysis-extras/lucene-libs/lucene-analyzers-icu-4.10.4.jar /usr/local/tomcat/webapps/solr/WEB-INF/lib/ && \
    ## Cleanup phase.
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY rootfs /

VOLUME /usr/local/solr

EXPOSE 8080 8983
CMD ["catalina.sh", "run"]