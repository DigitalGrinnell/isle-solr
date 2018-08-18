# ISLE Solr

## Part of the ISLE Islandora 7.x Docker Images
Designed as the Apache Solr search server for ISLE.

Based on:
  - [ISLE-tomcat](https://hub.docker.com/r/benjaminrosner/isle-tomcat/)
    - Ubuntu 18.04 "Bionic" (@see [ISLE-ubuntu-basebox](https://hub.docker.com/r/benjaminrosner/isle-ubuntu-basebox/))
      - General Dependencies
      - Oracle Java
      - Tomcat 8.5.31
  - [Apache Solr 4.10.4](http://lucene.apache.org/solr/)

Size: 825MB

## Generic Usage

```
docker run -p 8080:8080 -it --rm islandoracollabgroup/isle-solr bash
```

## Tomcat users

admin:isle_admin  
manager:isle_manager  