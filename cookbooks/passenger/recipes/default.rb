execute "install-passenger-and-nginx" do
  command "passenger-install-nginx-module --auto --auto-download --prefix=/opt/nginx"
  action :nothing
end

execute "run-install-passenger-and-nginx" do
  command "echo installing passenger"
  notifies :run, [ resources(:execute => "install-passenger-and-nginx") ], :immediately
end