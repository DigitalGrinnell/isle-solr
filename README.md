# ISLE Solr

## Part of the ISLE Islandora 7.x Docker Images
Designed as the Apache Solr search server for ISLE.

Based on:
  - [ISLE-tomcat](https://hub.docker.com/r/benjaminrosner/isle-tomcat/)
    - Ubuntu 18.04 "Bionic" (@see [ISLE-ubuntu-basebox](https://hub.docker.com/r/benjaminrosner/isle-ubuntu-basebox/))
      - General Dependencies
      - Oracle Java 8 Server JRE
      - Tomcat 8.5.x
  - [Apache Solr 4.10.4](http://lucene.apache.org/solr/)

## Generic Usage

```
docker run -p 8080:8080 -it --rm islandoracollabgroup/isle-solr bash
```

### Default Login information

Tomcat Admin
  - Username: admin
  - Password: isle_admin 

Tomcat Manager
  - Username: manager
  - Password: isle_manager  
