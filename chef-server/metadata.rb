maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures Chef Server"
version           "0.1"
recipe            "chef-server", "Compacts the Chef Server CouchDB."
recipe            "chef-server::rubygems-install", "Set up rubygem installed chef server."
recipe            "chef-server::apache-proxy", "Configures Apache2 proxy for API and WebUI"

%w{ redhat centos }.each do |os|
  supports os
end

%w{ chef-client couchdb apache2 openssl zlib xml java gecode }.each do |cb|
  depends cb
end
