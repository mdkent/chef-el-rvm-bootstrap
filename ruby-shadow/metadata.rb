maintainer       "Matthew Kent"
maintainer_email "mkent@magoazul.com"
license          "Apache 2.0"
description      "Install the shadow extension for ruby"
version          "0.1"

recipe "ruby-shadow", "Install the shadow extension for ruby from packages"
recipe "ruby-shadow::source", "Install the shadow extension for ruby from source"

%w{ centos redhat }.each do |os|
  supports os
end
