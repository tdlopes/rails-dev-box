# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure('2') do |config|
  # FIXME: When upgrading to a future version of Ubuntu check if the workaround
  # near the top of bootstrap.sh is still needed. If not, please delete it.
  config.vm.box      = 'ubuntu/artful64' # 17.10
  config.vm.hostname = 'rails-dev-box'

  config.vm.network :forwarded_port, guest: 3000, host: 3000

  config.vm.provision :shell, path: 'bootstrap.sh', name: 'bootstrap', keep_color: true
  config.vm.provision :shell, path: 'setup-ruby.sh', name: 'ruby', keep_color: true, privileged: false
  config.vm.provision :shell, path: 'setup-project.sh', name: 'project', keep_color: true, privileged: false

  config.vm.provider 'virtualbox' do |v|
    v.memory = ENV.fetch('RAILS_DEV_BOX_RAM', 1024).to_i
    v.cpus   = ENV.fetch('RAILS_DEV_BOX_CPUS', 2).to_i
  end
end
