maintainer       "Matthew Kent"
maintainer_email "mkent@magoazul.com"
license          "Apache 2.0"
description      "Installs/Configures openssl"
version          "0.1"

recipe "openssl", "Empty, this cookbook provides a library, see README"

%w{ centos redhat }.each do |os|
  supports os
end
