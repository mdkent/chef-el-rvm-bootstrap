maintainer       "Matthew Kent"
maintainer_email "mkent@magoazul.com"
license          "Apache 2.0"
description      "Installs zlib"
version          "0.1"

recipe "zlib", "Installs zlib development package"

%w{ centos redhat }.each do |os|
  supports os
end
