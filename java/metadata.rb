maintainer       "Matthew Kent"
maintainer_email "mkent@magoazul.com"
license          "Apache 2.0"
description      "Installs java via openjdk."
version          "0.1"

recipe "java", "Installs openjdk to provide Java"

%w{ centos redhat }.each do |os|
  supports os
end
