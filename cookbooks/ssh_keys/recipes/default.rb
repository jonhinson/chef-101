node[:ssh_keys].each do |key|
  template "~/.ssh/#{key[:name]}" do
    source "private_key.erb"
    owner "root"
    group "root"
    mode 0644
    variables({
      :private_key => key[:private]
    })
  end
  
  template "~/.ssh/#{key[:name]}.pub" do
    source "public_key.erb"
    owner "root"
    group "root"
    mode 0644
    variables({
      :public_key => key[:public]
    })
  end
end