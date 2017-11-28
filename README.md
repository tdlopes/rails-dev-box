# A Virtual Machine for Ruby on Rails Development

## Introduction

This project automates the setup of a development environment for working on a Ruby on Rails application.

## Requirements

* [VirtualBox](https://www.virtualbox.org)

* [Vagrant](http://vagrantup.com)

## How To Build The Virtual Machine

Building the virtual machine:

    host $ git clone https://github.com/tdlopes/rails-dev-box.git
    host $ cd rails-dev-box
    host $ vagrant up

After the installation has finished, you can access the virtual machine with

    host $ vagrant ssh

Port 3000 in the host computer is forwarded to port 3000 in the virtual machine. Thus, applications running in the virtual machine can be accessed via localhost:3000 in the host computer. Be sure the web server is bound to the IP 0.0.0.0, instead of 127.0.0.1, so it can access all interfaces:

    bin/rails server -b 0.0.0.0

## RAM and CPUs

By default, the VM launches with 2 GB of RAM and 2 CPUs.

These can be overridden by setting the environment variables `RAILS_DEV_BOX_RAM` and `RAILS_DEV_BOX_CPUS`, respectively. Settings on VM creation don't matter, the environment variables are checked each time the VM boots.

`RAILS_DEV_BOX_RAM` has to be expressed in megabytes, so configure 4096 if you want the VM to have 4 GB of RAM.

## What's In The Box

* Development tools

* Git

* rbenv with Ruby 2.4.2 installed

* System dependencies for nokogiri, mysql, mysql2

* MySQL

* Demo rails application

* Databases for development and testing for the demo rils application

* Memcached

* Redis

* An ExecJS runtime

## Recommended Workflow

The recommended workflow is

* edit in the host computer and

* run and test app within the virtual machine.

## Setup new rails projects

By default the demo rails application at https://github.com/tdlopes/rordemo.git is cloned in the machine with all gems installed in an isolated ruby environment version 2.4.2.

Vagrant mounts the local directory as _/vagrant_ within the virtual machine:

    vagrant@rails-dev-box:~$ ls /vagrant
    rordemo bootstrap.sh MIT-LICENSE rails README.md Vagrantfile ...

New projects can be started with _rails new_ or cloned in the _/vagrant_ folder.

You can set the ruby version of a project like so:

		vagrant@rails-dev-box:~$ cd /vagrant/project
		vagrant@rails-dev-box:/vagrant/project$ rbenv local 2.4.2

To install new ruby versions use _rbenv install [version]_

Install gem dependencies for a rails project with _bundle install_:

    vagrant@rails-dev-box:~$ cd /vagrant/rails_project
    vagrant@rails-dev-box:/vagrant/rails_project$ bundle install

We are ready to go to edit in the host, and test in the virtual machine.

## RubyMine integration

In order for RubyMine to access the machine without problems the vagrant machine ssh config must be added to the host ssh configs by running the following command inside the folder where the Vagrantfile resides:

    vagrant ssh-config | sed 's/^Host default/Host 127.0.0.1/' >> ~/.ssh/config

To set up a remote ruby interpreter for a project go to _Settings - Ruby SDK and Gems_ and press _+_.
Choose _New remote..._ option and in the new dialog box click the Vagrant radio button option.
RubyMine will try to populate the fields with a local Vagrantfile.
Because the Vagrantfile is in the parent _/vagrant_ projects have no Vagrantfile, and so the fields have to be manually populated:

    Vagrant Instance Folder: [path on the host machine to repository root where the Vagranfile resides]
    Ruby interpreter: /home/vagrant/.rbenv/versions/2.4.2/bin/ruby

If the project is using a different version then the version number of the ruby interpreter path above must be changed accordingly.

**As the interpreter is added it will start to check for the gem set, allow this process to finish before applying the changes to the Ruby interpreter.**
While the new remote interpreter is selected the side pane should show all the gems present in the gem set, otherwise ensure that the vagrant machine is running and with the ssh-config present in the host machine ssh configs, then repeat the process.
If all is good, make sure to check the radio box of the newly added ruby interpreter in order to set it the default interpreter for the project, and apply the changes.
RubyMine will initiate some more processes for indexing and checking project gem requirements.

Afterwards RubyMine should be able to execute all tools such as running the development server, IRB tool, or Rails console as well as running rake tasks on the remote ruby interpreter.

### Adding new gems to a rails project

Simply edit the Gemfile and go to _Tools - Bundler_ and select install.
RubyMine will ask if the bundler should run with any arguments and/or with elevated permissions, leave these options in blank and click install to perform the tasks on the remote machine.

**Attention**
For debugging purposes RubyMine requires two gems: _ruby-debug-ide_, and _debase_.
For RuboCop linter inspections RubyMine requires the _rubocop_ gem.
These gems are already present in the Gemfile of the included demo rails application.
New projects are recommended to add these gems in their Gemfile for a debugging and linter inspection with RubyMine.

## Virtual Machine Management

When done just log out with `^D` and suspend the virtual machine

    host $ vagrant suspend

then, resume to hack again

    host $ vagrant resume

Run

    host $ vagrant halt

to shutdown the virtual machine, and

    host $ vagrant up

to boot it again.

You can find out the state of a virtual machine anytime by invoking

    host $ vagrant status

Finally, to completely wipe the virtual machine from the disk **destroying all its contents**:

    host $ vagrant destroy # DANGER: all is gone

Please check the [Vagrant documentation](http://docs.vagrantup.com/v2/) for more information on Vagrant.

## Troubleshooting

On `vagrant up`, it's possible to get this error message:

```
The box 'ubuntu/yakkety64' could not be found or
could not be accessed in the remote catalog. If this is a private
box on HashiCorp's Atlas, please verify you're logged in via
vagrant login. Also, please double-check the name. The expanded
URL and error message are shown below:

URL: ["https://atlas.hashicorp.com/ubuntu/yakkety64"]
Error:
```

And a known work-around (https://github.com/Varying-Vagrant-Vagrants/VVV/issues/354) can be:

    sudo rm /opt/vagrant/embedded/bin/curl

## License

Released under the MIT License, Copyright (c) 2017 Tiago Lopes.
