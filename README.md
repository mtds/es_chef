Elasticsearch Cookbook
======================

This cookbook will install Elasticsearch and configure
it. Only the very basic functionality are covered:
- install the ES package (it should be available on the APT repos);
- adjust the configuration files through the templates;


Requirements
------------

#### packages
- `openjdk-7-jdk` - Java is needed to run Elasticsearch (in this case the latest OpenJDK version). 

Attributes
----------

The default attributes are used:
- inside the ES Debian default file;
- elasticsearch.yml (default configuration file).

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

