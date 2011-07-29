maintainer       "Matthew Kent"
maintainer_email "mkent@magoazul.com"
license          "Apache 2.0"
description      "Distributes a directory of custom ohai plugins"
version          "1.0.0"

recipe "ohai::default", "Distributes a directory of custom ohai plugins"

attribute "ohai/plugin_path",
  :display_name => "Ohai Plugin Path",
  :description => "Distribute plugins to this path.",
  :type => "string",
  :required => "optional",
  :default => "/etc/chef/ohai_plugins"
