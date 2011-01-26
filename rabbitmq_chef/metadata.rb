maintainer       "Matthew Kent"
maintainer_email "mkent@magoazul.com"
license          "Apache 2.0"
description      "Installs the RabbitMQ AMQP Broker for use on a Chef Server."
version          "0.1"

recipe "rabbitmq_chef", "Install and configure rabbitmq specifically for a Chef Server"

depends "erlang"

%w{ centos redhat }.each do |os|
  supports os
end
