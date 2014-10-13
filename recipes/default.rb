#
# Cookbook Name:: es
# Recipe:: default
#
# Copyright 2014, GSI HPC Team
#
# All rights reserved - Do Not Redistribute
#

[Chef::Recipe, Chef::Resource].each { |l| l.send :include, ::Extensions }

# Java and ES packages:
%w{openjdk-7-jdk elasticsearch}.each do |pkg|
   package pkg
end

# Set some limits for ES:
template "/etc/security/limits.d/10-elasticsearch.conf" do
  source "10-elasticsearch.conf.erb"
  notifies :restart, 'service[elasticsearch]'
end

# Enable the PAM limits module:
cookbook_file "elasticsearch.pam" do
  source "pam/elasticsearch"
  path "/etc/pam.d/elasticsearch"
  action :create_if_missing
end

# Debian 'default' config:
template "/etc/default/elasticsearch" do
  source "elasticsearch.default.erb"
  notifies :restart, 'service[elasticsearch]'
end

# ES logging file:
template "/etc/elasticsearch/logging.yml" do
  source "logging.yml.erb"
  notifies :restart, 'service[elasticsearch]'
end

# ES config file:
template "/etc/elasticsearch/elasticsearch.yml" do
  source "elasticsearch.yml.erb"
  notifies :restart, 'service[elasticsearch]'
end

# ES Plugins:
if node[:elasticsearch][:plugins_enable] 
  node[:elasticsearch][:plugins].each do | name, config |
    install_plugin name, config
  end
end

service "elasticsearch" do
  supports :status => true, :restart => true
  action [ :enable ]
end
