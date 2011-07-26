maintainer        "Matthew Kent"
maintainer_email  "mkent@magoazul.com"
license           "Apache 2.0"
description       "Installs erlang, optionally install GUI tools."
version           "0.1"

recipe "erlang", "Installs erlang"

%w{ centos redhat }.each do |os|
  supports os
end
