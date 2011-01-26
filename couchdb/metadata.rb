maintainer       "Matthew Kent"
maintainer_email "mkent@magoazul.com"
license          "Apache 2.0"
description      "Installs CouchDB package and starts service"
version          "0.1"

recipe "couchdb", "Installs and configures CouchDB package"
recipe "couchdb::source", "Installs and configures CouchDB from source"

depends "erlang"

%w{ centos fedora }.each do |os|
  supports os
end
