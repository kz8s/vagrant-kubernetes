Vagrant.configure("2") do |c|
  c.ssh.forward_agent = true
  c.ssh.insert_key = false
  c.vm.define 'centos-7.1-x64' do |v|
    v.vm.hostname = 'k8s'
    v.vm.box = 'centos71-kubernetes'
    v.vm.box_url = './box/virtualbox/centos71-kubernetes-x64-1.0.0.box'
    v.vm.box_check_update = 'true'
    v.vm.synced_folder '.', '/vagrant', disabled: true
    v.vm.network :public_network
    v.vm.network "forwarded_port", guest: 8080, host: 8080
    v.vm.provider :virtualbox do |vb|
      vb.customize ['modifyvm', :id, '--memory', '1024', '--cpus', '1']
    end
  end
end
