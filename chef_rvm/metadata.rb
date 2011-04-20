maintainer       "Matthew Kent"
maintainer_email "mkent@magoazul.com"
license          "Apache 2.0"
description      "Installs and configures Chef for chef-client and chef-server"
version          "0.1"

recipe "chef_rvm", "Default recipe is empty, use one of the other recipes."
recipe "chef_rvm::client", "Sets up a client to talk to a chef-server"
recipe "chef_rvm::client_service", "Sets up a client daemon to run periodically"
recipe "chef_rvm::delete_validation", "Deletes validation.pem after client registers"
recipe "chef_rvm::server", "Configures a chef API server as a merb application"
recipe "chef_rvm::server_proxy", "Configures Apache2 proxy for API and WebUI"

%w{ couchdb rabbitmq_chef apache2 openssl zlib xml java }.each do |cb|
  depends cb
end

%w{ centos redhat }.each do |os|
  supports os
end
