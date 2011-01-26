maintainer       "Matthew Kent"
maintainer_email "mkent@magoazul.com"
license          "Apache 2.0"
description      "Installs xml"
version          "0.1"

recipe "xml", "Installs libxml development packages"

%w{ centos redhat }.each do |os|
  supports os
end
