gem_package 'passenger'

execute "install-passenger-and-nginx" do
  command "passenger-install-nginx-module --auto --auto-download --prefix=#{node[:nginx][:dir]}"
  action :nothing
end

execute "run-install-passenger-and-nginx" do
  command "echo installing passenger"
  notifies :run, [ resources(:execute => "install-passenger-and-nginx") ], :immediately
end

template "#{node[:nginx][:dir]}/nginx.conf" do
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

template "/etc/init.d/nginx" do
  source "nginx.erb"
  owner "root"
  group "root"
  mode 0755
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end