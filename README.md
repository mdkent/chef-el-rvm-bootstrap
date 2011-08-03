Chef Enterprise Linux RVM Bootstrap
===================================

Alternative CentOS/RHEL Chef client/server rubygems bootstrap using
[rvm](http://rvm.beginrescueend.com/).


About
-----

This repository provides a number of Chef cookbooks used to bootstrap a
rubygems based Chef client or server installation on Enterprise Linux
(CentOS/RHEL) using rvm.

These cookbooks were originally duplicated from the official Opscode repository
and have been modified to remove support for other distributions that may not
be compatible with this approach and for which I don't have time to test. The
README files have also been stripped, as they often don't reflect the current
state of the cookbooks.


Goal
----

The goal of this project is to provide an install of Chef that's nearly
contained to /usr/lib/rvm and doesn't conflict with any existing rpm installed
ruby- or rubygem- packages. The aim is to make this a more palpable
alternative for environments typically only comfortable with rpm packaged
software.

This method should not override or interfere with the distribution approved
ruby or its dependencies.


Supported Distributions
-----------------------

* CentOS 5.6
* CentOS 5.5


Getting Started
---------------

If you used the previous 0.9.* series Chef Enterprise Linux RVM Bootstrap please
see the Upgrading sections below.

Assuming root access on a fresh, basic, CentOS 5.6 install:


1. Disable SELinux 

        sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/sysconfig/selinux
        setenforce 0

2. Install the EPEL repositories for git

        rpm -Uvh http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-4.noarch.rpm

3. Install the rvm package

        wget --no-check-certificate https://github.com/mdkent/rvm-rpm/raw/master/RPMS/noarch/rvm-ruby-1.6.3-1.el5.noarch.rpm
        yum localinstall --nogpgcheck rvm-ruby-1.6.3-1.el5.noarch.rpm

    This should install all the dependencies to build ruby

4. Chose a ruby version and install, 1.9.2-p290 is the default for the bootstrap.

        rvm install 1.9.2-p290

    > By default rvm will connect to the internet to download the ruby packages
    > to compile. If this is a problem you should install your own copy of rvm
    > from your own repository (see above) where you can modify the config/db
    > file to point at an internal server.

5. Next we use rvm to create an isolated gemset for Chef and install it

        rvm 1.9.2-p290@chef gem install chef -v 0.10.2

6. Now we can move on to the actual Chef install. First we need a temporary
   config for chef-solo to extract and execute our bootstrap cookbooks:

        cat<<EOF>solo.rb
        file_cache_path "/tmp/chef-solo"
        cookbook_path "/tmp/chef-solo/cookbooks"
        cache_options({ :path => "/tmp/chef-solo/checksums", :skip_expires => true })
        file_backup_path "/tmp/chef-solo/backup"
        umask 0022
        EOF

7. Next we either chose a type of chef server or a client install. First time
   users should setup a 'Standard Server'. You can either download and modify
   the following JSON or pass it to chef-solo directly
   * [Standard Server](https://github.com/mdkent/chef-el-rvm-bootstrap/raw/master/chef-server-api-webui.json)
     - API and WebUI
   * [Standard Server + Proxy](https://github.com/mdkent/chef-el-rvm-bootstrap/raw/master/chef-server-api-webui-proxy.json)
     - API and WebUI with an Apache proxy in front good for public facing access
   * [Minimal Server](https://github.com/mdkent/chef-el-rvm-bootstrap/raw/master/chef-server-api.json)
     - only API

    Alternately a client install can be
    [obtained here](https://github.com/mdkent/chef-el-rvm-bootstrap/raw/master/chef-client.json)
    though this will likely need to be modified for the correct server_url.

8. Finally we get to the bootstrap cookbooks. You can either
   download them from
   [the packages page here](https://github.com/mdkent/chef-el-rvm-bootstrap/archives/master),
   build them from this repository with

        rake build_bootstrap

    or, by picking the right url to make chef-solo happy (open-uri doesn't like
    the github redirect), reference them directly via

    http://cloud.github.com/downloads/mdkent/chef-el-rvm-bootstrap/chef-el-rvm-bootstrap-0.10.2-1.tar.gz

9. We are all set to run the Chef bootstrap. chef-solo can be invoked with
    local files:

        rvm 1.9.2-p290@chef exec chef-solo -c solo.rb \
            -j chef-server-api-webui.json \
            -r chef-el-rvm-bootstrap-0.10.2-1.tar.gz 

    or looking at remote urls:

        rvm 1.9.2-p290@chef exec chef-solo -c solo.rb \
            -j https://raw.github.com/mdkent/chef-el-rvm-bootstrap/master/chef-server-api-webui.json \
            -r http://cloud.github.com/downloads/mdkent/chef-el-rvm-bootstrap/chef-el-rvm-bootstrap-0.10.2-1.tar.gz

If the process stops with a complaint and some instructions, such as an
existing apache install, complete the instructions and run chef-solo again with
the same parameters.

Assuming chef-solo (eventually) completes without incident you should now have
a fully configured and functioning chef server or client.

The server bootstrap does *not* enable the chef-client service by default as
some may prefer to run it on demand. The chef-client::service recipe must be
added to the server's run list to enable this.

Also, before testing your server, be sure to disable the default firewall if
it's running with 

    service iptables stop

Congratulations, the bootstrap is done - you can now move on to configuring
your copy of 
[knife](http://help.opscode.com/kb/chefbasics/knife)
as per the
[Opscode wiki](http://wiki.opscode.com/display/chef/Bootstrap+Chef+RubyGems+Installation#BootstrapChefRubyGemsInstallation-ConfiguretheCommandLineClient)
and start uploading some cookbooks!


Server Upgrade
--------------

Unfortunately there's not one clear path to upgrading because of the
flexibility of this install process. There are a couple typical scenarios
though:

If you've used this bootstrap to setup a server which doesn't manage itself via 
chef-client, you can probably rerun the bootstrap while adding the
"chef-server::upgrade" recipe to the run list. In testing this installed
properly overtop of the existing server after a few repeated chef-solo runs - 
although chef-server and chef-server-webui did need a manual restart.

If you've used this boostrap and its cookbooks as a base for your own cookbook
repository you'll need to manually diff the cookbooks for any changes against
your own copies. You'll then need to handle the split of chef_rvm into
chef-server/chef-client, and likely employ something like 
[chef-rvm](https://github.com/fnichol/chef-rvm) to handle the ruby upgrade. 
You'll likely want to expand on the "chef-server::upgrade" recipe to handle this
process. This will be time consuming. 

Alternately you can always fire up a new chef-server and import your existing
data.


Client Upgrade
--------------

This is dependant on your existing install, you can run the bootstrap overtop
of your existing setup or use the updated cookbooks in your Chef repository to
automate the upgrade. Please see the Server Upgrade section for more
background.


Helpful Hints
-------------

* Among the many items the bootstrap sets up some notable points are
  * chef configs - /etc/chef/
  * init scripts - /etc/init.d/chef-*
  * logrotate configs - /etc/logrotate.d/chef-*
  * rvm wrappers - /usr/bin/chef-*,knife,ohai,shef
  * logs - /var/log/chef/
* The cookbooks used in the bootstrap should be suitable to form the base of a
  Chef cookbook repository to upload to the server and have it maintain itself.
* No cookbook is provided for management of rvm itself or to leverage it for
  future app deploys. For this 
  [I suggest chef-rvm](https://github.com/fnichol/chef-rvm).
  Though be warned with this setup: a broken rvm install means a broken Chef!


History
-------

Until recently I've been maintaining a series of rpm packages for Chef and it's
many dependencies for those, such as my employer and myself, who were
uncomfortable with a purely rubygems based install of any critical software.
These packages functioned reasonably well initially but overtime have become
problematic as Chef has to add strict dependencies on certain gems due to a
lack of backwards compatibility (typically). These strict dependencies
effectively freeze the version I can provide in the rpms. The rpms then grow
ever outdated making them impossible to submit for inclusion in distributions
like Fedora or even conflicting with other software that may need a newer
version of the gem. 

It really boils down to a fundamental incompatibility between rubygems being
able to happily install multiple versions of the same gem and rpm only able to
install one.


Support
-------

For issues with this bootstrap please contact me via the github Issue tracker
or directly at mkent@magoazul.com.

Opscode Inc, their mailing lists, irc channels and issue tracker provide no
support for this repository.

git pull requests welcome :)


Credit
------

The cookbooks used in this repository have been duplicated from the official
Opscode cookbooks (http://github.com/opscode/cookbooks) and modified.
