execute "install-passenger-and-nginx" do
  command "passenger-install-nginx-module --auto --auto-download --prefix=/opt/nginx"
  action :nothing
end