template "/etc/hosts" do
  source "hosts.erb"
end

template "/etc/hostname" do
  source "hostname.erb"
end