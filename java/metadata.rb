maintainer        "Matthew Kent"
maintainer_email  "mkent@magoazul.com"
license           "Apache 2.0"
description       "Installs java via openjdk."
version           "0.1"

recipe "java", "Installs Java runtime"
recipe "java::openjdk", "Installs the OpenJDK flavor of Java"
recipe "java::sun", "Installs the Sun flavor of Java"

%w{ centos redhat }.each do |os|
  supports os
end
