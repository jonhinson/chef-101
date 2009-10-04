node[:ssh_keys].each do |key|
  directory "/root/.ssh" do
    owner "root"
    group "root"
    mode 0755
  end
  
  template "/root/.ssh/#{key[:name]}" do
    source "private_key.erb"
    owner "root"
    group "root"
    mode 0644
    variables({
      :private_key => key[:private]
    })
  end
  
  template "/root/.ssh/#{key[:name]}.pub" do
    source "public_key.pub.erb"
    owner "root"
    group "root"
    mode 0644
    variables({
      :public_key => key[:public]
    })
  end
  
  execute "add ssh key" do
    command "ssh-add #{key[:name]}"
    action :nothing
  end
end