# frozen_string_literal: true

def determine_bridge
  if RbConfig::CONFIG['host_os'] =~ /mswin32|mingw32/
    'Ethernet'
  else
    'eth0'
  end
end

def read_or_determine_bridge
  if File.exist?('tmp/ethernet-device.txt')
    File.read('tmp/ethernet-device.txt').chomp
  else
    bridge = determine_bridge
    File.write('tmp/ethernet-device.txt', bridge + "\n")
    bridge
  end
end

def determine_hostname
  if RbConfig::CONFIG['host_os'] =~ /mswin32|mingw32/
    # TODO: Make this work on Windows.
    'rs'
  else
    hostname = `. configuration/project.sh && echo "${PROJECT_NAME_INITIALS}"`
    hostname.chomp
  end
end

def read_or_determine_hostname
  if File.exist?('tmp/hostname.txt')
    File.read('tmp/hostname.txt').chomp
  else
    hostname = determine_hostname
    File.write('tmp/hostname.txt', bridge + "\n")
    hostname
  end
end

def determine_domain
  if RbConfig::CONFIG['host_os'] =~ /mswin32|mingw32/
    # TODO: Make this work on Windows.
    'example.org'
  else
    domain = `hostname -f`
    domain.chomp
  end
end

def read_or_determine_domain
  if File.exist?('tmp/domain.txt')
    File.read('tmp/domain.txt').chomp
  else
    domain = determine_domain
    File.write('tmp/domain.txt', domain + "\n")
    domain
  end
end

Vagrant.configure('2') do |c|
  c.vm.box = 'debian/buster64'
  # TODO: Add a way to switch without having to rewrite this file.
  # c.vm.box = 'centos/7'
  c.ssh.forward_agent = true
  Dir.mkdir('tmp') unless File.exist?('tmp')
  bridge = read_or_determine_bridge
  hostname = read_or_determine_hostname
  domain = read_or_determine_domain

  c.vm.network :public_network, bridge: bridge
  c.vm.network :private_network, ip: '192.168.42.3'

  c.vm.synced_folder '.', '/vagrant', type: 'nfs'

  c.vm.provider :virtualbox do |v|
    v.name = 'ruby-utility'
    v.cpus = 2
    v.memory = 2048
    v.customize ['modifyvm', :id, '--vram', '12']
  end

  c.vm.provision :shell, path: 'script/vagrant/update-system.sh'
  c.vm.provision :shell, path: 'script/vagrant/provision.sh'

  unless RbConfig::CONFIG['host_os'] =~ /mswin32|mingw32/
    c.vm.provision :ansible do |a|
      a.playbook = 'playbook.yaml'
      a.compatibility_mode = '2.0'
      a.extra_vars = {
        'ansible_python_interpreter': '/usr/bin/python3',
        'git': {
          'protocol': 'ssh'
        },
        'ethernet_device': 'eth1',
        'domain': domain
      }
      # Allow remote_user: root.
      a.force_remote_user = false
      # Uncomment for more verbosity.
      # a.verbose = true
      # a.verbose = 'vv'
      # a.verbose = 'vvv'
    end
  end

  c.vm.synced_folder 'salt-provisioning', '/srv/salt', type: 'nfs'

  c.vm.provision :shell do |s|
    s.path = 'script/vagrant/salt.sh'
    s.args = [hostname + '.' + domain, '/vagrant/tmp/salt/minion.conf']

    # Install upstream Salt package.
    # s.path = 'tmp/bootstrap-salt.sh'
    # Jessie versions: https://repo.saltstack.com/apt/debian/8/amd64
    # Stretch versions: https://repo.saltstack.com/apt/debian/9/amd64
    # Buster versions: http://repo.saltstack.com/py3/debian/10/amd64
    s.args = [
      '-U',
      '-i', hostname + '.' + domain,
      '-c', '/vagrant/tmp/salt',
      'stable',
      '2018.3.3'
    ]
  end

  c.vm.provision :shell, inline: 'salt-call state.highstate'
end
