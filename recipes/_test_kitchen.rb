#
# Cookbook Name:: dirsrv
# Recipe:: _test_kitchen
#
# Copyright 2014 Riot Games, Inc.
# Author:: Alan Willis <alwillis@riotgames.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Test non-replication related LWRPs

include_recipe "dirsrv"

dirsrv_instance node[:hostname] + '_389' do
  is_cfgdir     true
  has_cfgdir    true
  cfgdir_addr   node[:ipaddress]
  cfgdir_domain 'kitchen'
  cfgdir_ldap_port 389
  add_sample_entries true
  host         node[:fqdn]
  suffix       'o=kitchen'
  action       [ :create, :start ]
end

# For each resource: remove, create, remove, create
# Exercises the code in creation and removal before and after its initial existence

## Entry

ldap_entry "ou=test,o=kitchen" do
  attributes ({ objectClass: [ 'organizationalUnit', 'top' ], ou: 'test' })
  action :delete
end

ldap_entry "ou=test,o=kitchen"

ldap_entry "ou=test,o=kitchen" do
  action :delete
end

ldap_entry "ou=test,o=kitchen"

## Config

dirsrv_config "nsslapd-auditlog-logging-enabled" do
  value  'on'
  action :disable
end

dirsrv_config "nsslapd-auditlog-logging-enabled"

dirsrv_config "nsslapd-auditlog-logging-enabled" do
  action :disable
end

dirsrv_config "nsslapd-auditlog-logging-enabled"

## Plugin

dirsrv_plugin "MemberOf Plugin" do
  action :disable
end

dirsrv_plugin "MemberOf Plugin"

dirsrv_plugin "MemberOf Plugin" do
  action :disable
end

dirsrv_plugin "MemberOf Plugin"

## Index
# No disable
dirsrv_index "uid" do
  equality true
  presence true
  substring true
end

## User

ldap_user "awillis" do
  basedn "o=kitchen"
  surname 'Willis'
  home "/home/alan"
  shell "/bin/bash"
  is_extensible true
  password "Super Cool Passwords Are Super Cool!!!!!"
  action :delete
end

ldap_user "awillis"

ldap_user "awillis" do
  action :delete
end

ldap_user "awillis"

dirsrv_aci 'test aci' do
  distinguished_name 'o=kitchen'
end

#dirsrv_aci 'Engineering Group Permissions' do
#  distinguished_name 'ou=people,o=kitchen'
#end

#dirsrv_aci 'Enable Group Expansion' do
#  distinguished_name 'o=netscaperoot'
#end
