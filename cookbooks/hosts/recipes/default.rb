template "/etc/hosts" do
  source "hosts.erb"
end

template "/etc/hostname" do
  source "hostname.erb"
end

execute "hostname" do
  command "hostname -F /etc/hostname"
  action :nothing
end

execute "run-install-passenger-and-nginx" do
  command "echo updating hostname"
  notifies :run, [ resources(:execute => "hostname") ], :immediately
end