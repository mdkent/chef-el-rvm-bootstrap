maintainer        "Matthew Kent"
maintainer_email  "mkent@magoazul.com"
license           "Apache 2.0"
description       "Installs CouchDB package and starts service"
version           "0.1"
depends           "erlang"
recipe            "couchdb", "Installs and configures CouchDB package"

%w{ centos redhat }.each do |os|
  supports os
end
