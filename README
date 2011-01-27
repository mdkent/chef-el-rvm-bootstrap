Chef Enterprise Linux Bootstrap
===============================

Alternative CentOS/RHEL Chef client/server rubygems bootstrap using rvm.


About
-----

This repository provides a number of Chef cookbooks used to bootstrap a rubygems based Chef client or server installation on Enterprise Linux (CentOS/RHEL) using rvm. 

These cookbooks were originally duplicated from the official Opscode repository and have been modified to remove support for other distributions that may not be compatible with this approach and for which I don't have time to test.


Goal
----

The goal of this project is to provide an install of Chef that's nearly contained to /usr/local and doesn't conflict with any existing rpm installed ruby-* or rubygem-* packages. The aim is to make this a more palatable alternative for environments typically only comfortable with rpm packaged software.


History
-------

Until recently I've been maintaining a series of rpm packages for Chef and it's many dependencies for those, such as my employer and myself, who were uncomfortable with a purely rubygems based install of any critical software. These packages functioned reasonably well initially but overtime have become problematic as Chef has to add strict dependencies on certain gems due to a lack of backwards compatibility (typically). These strict dependencies effectively freeze the version I can provide in the rpms. The rpms then grow ever outdated making them impossible to submit for inclusion in distributions like Fedora or even conflicting with other software that may need a newer version of the gem. It really boils down to a fundamental incompatibility between rubygems being able to happily install multiple versions of the same gem and rpm only able to install one.


Support
-------

Please do not contact Opscode via their ticketing system or irc channels. Please contact me directly via the github Issue tracker or directly at mkent@magoazul.com

git pull requests welcome :)


Credit
------

The cookbooks used in this repository have been duplicated from the official Opscode cookbooks (http://github.com/opscode/cookbooks) and modified. 


Getting Started
---------------


