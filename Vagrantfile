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

Vagrant.configure('2') do |config|
  config.vm.box = 'debian/stretch64'
  Dir.mkdir('tmp') unless File.exist?('tmp')
  File.write('tmp/hostname.txt', "rs\n") unless File.exist?(
    'tmp/hostname.txt'
  )
  bridge = read_or_determine_bridge
  config.vm.network :public_network, bridge: bridge
  config.vm.network :private_network, ip: '192.168.42.3'

  if RbConfig::CONFIG['host_os'] =~ /mswin32|mingw32/
    config.vm.synced_folder '.', '/vagrant', type: 'virtualbox'
  else
    config.vm.synced_folder '.', '/vagrant', type: 'nfs'
  end

  config.vm.provider :virtualbox do |v|
    v.name = 'ruby-utility'
    v.cpus = 1
    v.memory = 1024
  end

  config.vm.provision :shell, path: 'script/vagrant/update-system.sh'
  config.vm.provision :shell, path: 'script/vagrant/provision.sh'
end

# vim: ft=ruby
