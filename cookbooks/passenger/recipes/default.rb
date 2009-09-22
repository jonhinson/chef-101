gem_package 'passenger'

execute "install-passenger-and-nginx" do
  command "passenger-install-nginx-module --auto --auto-download --prefix=#{node[:nginx][:dir]}"
  action :nothing
end

execute "run-install-passenger-and-nginx" do
  command "echo installing passenger"
  notifies :run, [ resources(:execute => "install-passenger-and-nginx") ], :immediately
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

template "nginx.conf" do
  path "#{node[:nginx][:dir]}/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

template "#{node[:nginx][:dir]}/sites-available/default" do
  source "default-site.erb"
  owner "root"
  group "root"
  mode 0644
end