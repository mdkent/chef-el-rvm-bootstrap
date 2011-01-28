Chef Enterprise Linux Bootstrap
===============================

Alternative CentOS/RHEL Chef client/server rubygems bootstrap using
[rvm](http://rvm.beginrescueend.com/).


About
-----

This repository provides a number of Chef cookbooks used to bootstrap a
rubygems based Chef client or server installation on Enterprise Linux
(CentOS/RHEL) using rvm.

These cookbooks were originally duplicated from the official Opscode repository
and have been modified to remove support for other distributions that may not
be compatible with this approach and for which I don't have time to test.


Goal
----

The goal of this project is to provide an install of Chef that's nearly
contained to /usr/local and doesn't conflict with any existing rpm installed
ruby- or rubygem- packages. The aim is to make this a more palatable
alternative for environments typically only comfortable with rpm packaged
software.


Supported Distributions
-----------------------

* CentOS 5.5


Getting Started
---------------

Assuming root access on a fresh, basic, CentOS 5.5 install:

1. Install the EPEL repositories for git

       rpm -Uvh http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-4.noarch.rpm

2. Install packages to support rvm's installation

       yum install -y curl git

3. Install rvm system wide (http://rvm.beginrescueend.com/deployment/system-wide/)

       bash < <( curl -L http://bit.ly/rvm-install-system-wide )

   This will install the most current version of rvm into /usr/local/rvm.

   > Alternately if you need to install this on a server with no internet
   > connectivity or simply want to lock into a specific rvm version you can
   > clone the rvm repository, change the clone location in
   > contrib/install-system-wide and install using curl in the same fashion.

4. Install packages so rvm can build ruby

       yum install -y gcc-c++ patch readline readline-devel zlib zlib-devel \
           libyaml-devel libffi-devel openssl-devel bzip2 make which

5. Chose a ruby version and install, 1.9.2 is the default for the bootstrap.

       rvm list known
       rvm install 1.9.2

   > By default rvm will connect to the internet to download the ruby packages
   > to compile. If this is a problem you should install your own copy of rvm
   > from your own repository (see above) where you can modify the config/db
   > file to point at an internal server.

6. Next we use rvm to create an isolated gemset for Chef and install it

       rvm 1.9.2 exec rvm gemset create chef
       rvm 1.9.2@chef gem install chef

7. Now we can move on to the actual Chef install. First we need a temporary
   config for chef-solo to do it's work:

       cat<<EOF>solo.rb
       file_cache_path "/tmp/chef-solo"
       cookbook_path "/tmp/chef-solo/cookbooks"
       EOF

8. Next we either chose a type of chef server or a client install. First time
   users should setup a 'Standard Server'. You can either download and modify
   the following JSON or pass it to chef-solo directly
   * [Standard Server](https://github.com/mdkent/chef-el-bootstrap/raw/master/chef-server-api-webui.json)
     - API and WebUI
   * [Standard Server + Proxy](https://github.com/mdkent/chef-el-bootstrap/raw/master/chef-server-api-webui-proxy.json)
     - API and WebUI with an Apache proxy in front good for public facing access
   * [Minimal Server](https://github.com/mdkent/chef-el-bootstrap/raw/master/chef-server-api.json)
     - only API

   Alternately a client install can be
   [obtained here](https://github.com/mdkent/chef-el-bootstrap/raw/master/chef-client.json
   though this will likely need to be modified for the correct server_url.

9. Finally we get to the bootstrap cookbooks. You can either
   download them from
   [the packages page here](https://github.com/mdkent/chef-el-bootstrap/archives/master),
   build them from this repository with

       rake build_bootstrap

   or, by picking the right url to make chef-solo happy (open-uri doesn't like
   the github redirect), reference them directly via

   http://cloud.github.com/downloads/mdkent/chef-el-bootstrap/chef-el-bootstrap-0.9.12-1.tar.gz

10. We are all set to run the Chef bootstrap. chef-solo can be invoked purely local:

        rvm 1.9.2@chef exec chef-solo -c solo.rb \
            -j chef-server-api-webui.json \
            -r chef-el-bootstrap-0.9.12-1.tar.gz 

    or looking at remote example urls:

        rvm 1.9.2@chef exec chef-solo -c solo.rb \
            -j https://github.com/mdkent/chef-el-bootstrap/raw/master/chef-server-api-webui.json \
            -r http://cloud.github.com/downloads/mdkent/chef-el-bootstrap/chef-el-bootstrap-0.9.12-1.tar.gz 

Assuming chef-solo completes without incident you should now have a fully
configured and functioning chef server or client.

The server bootstrap does *not* enable the chef-client service by default as
some may prefer to run it on demand. The chef::client_service recipe must be
added to the server's run list to enable this.


Post Config
-----------

Among the many things the bootstrap setups up some notable items are

* chef configs - /etc/chef/
* init scripts - /etc/init.d/chef-*
* logrotate configs - /etc/logrotate.d/chef-*
* rvm wrappers - /usr/bin/chef-*,knife,ohai,shef
* logs - /var/log/chef/

The cookbooks used in the bootstrap should be suitable to form the base of a
Chef cookbook repository to upload to the server and have it maintain itself.


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
