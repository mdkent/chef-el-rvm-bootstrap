# Items removed from 0.9.x -> 0.10.x

service "chef-solr-indexer" do
  action :stop
end

bash "remove chef-solr-indexer from init" do
  cwd "/tmp"
  code <<-EOH
  chkconfig --del chef-solr-indexer
  EOH
  only_if "chkconfig --list | grep chef-solr-indexer"
end

%w{/etc/rc.d/init.d/chef-solr-indexer /etc/logrotate.d/chef-solr-indexer /etc/chef/solr-indexer.rb}.each do |f|
  file f do
    action :delete
  end
end
