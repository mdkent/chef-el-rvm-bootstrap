maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Manages aspects of only chef-client"
version           "0.1"
recipe            "chef-client", "Includes the service recipe by default."
recipe            "chef-client::config", "Configures the client.rb from a template."
recipe            "chef-client::service", "Sets up a client daemon to run periodically"
recipe            "chef-client::delete_validation", "Deletes validation.pem after client registers"

%w{ redhat centos }.each do |os|
  supports os
end
