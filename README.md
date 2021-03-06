Elasticsearch Cookbook
======================

This cookbook will install Elasticsearch and configure
it. Only the very basic functionality are covered:
- install the ES package (it should be available on the APT repos);
- adjust the configuration files through the templates;


Requirements
------------

#### breaking changes

Till version '0.1.10' this cookbook can be used with ES up to version 1.7.x.
In order to use ES version 2.x it is necessary to use version '0.1.11'.

#### packages
- `openjdk-7-jdk` - Java is needed to run Elasticsearch (in this case the latest OpenJDK version). 

Attributes
----------

The default attributes are used:
- inside the ES Debian default file;
- elasticsearch.yml (default configuration file).

**NOTE**: The value of attributes related to threadpools, heap size and so on are based on
          the recommendations on the official guide.
          https://www.elastic.co/guide/en/elasticsearch/guide/current/administration.html

Usage
-----
#### elasticsearch::default

Just include `elasticsearch` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[elasticsearch]"
  ]
}
```

