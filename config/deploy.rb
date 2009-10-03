set :application, "chef_recipes"
set :scm_user, ENV['USER']
set :repository, "git://github.com/jonhinson/chef-101.git"
set :deploy_to, "/var/chef_recipes"
set :scm, :git
 
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]
set :group_writeable, true
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
 
require 'capistrano/ext/multistage'
 
desc "Install essential packages for chef"
task :bootstrap do
  run "apt-get update"
  run "apt-get install wget build-essential ruby1.8 ruby1.8-dev irb1.8 rdoc1.8 zlib1g-dev libopenssl-ruby1.8 libopenssl-ruby libzlib-ruby libssl-dev git-core libxml2-dev libxslt1-dev"
  run "ln -s /usr/bin/ruby1.8 /usr/bin/ruby"
  run "ln -s /usr/bin/irb1.8 /usr/bin/irb"
  install_rubygems
  run "sudo gem sources -a http://gems.opscode.com && gem sources -a http://gems.github.com"
  install_chef
  
end
 
desc "Install rubygems"
task :install_rubygems do
  run "cd /tmp && wget http://rubyforge.org/frs/download.php/45904/rubygems-update-1.3.1.gem && sudo gem install rubygems-update-1.3.1.gem && sudo /var/lib/gems/1.8/bin/update_rubygems"
end
 
desc "Install latest chef"
task :install_chef do
  run "gem install rspec json --no-rdoc --no-ri"
  run "git clone git://github.com/opscode/ohai.git"
  run "cd ohai && rake install"
  run "git clone git://github.com/opscode/chef.git"
  run "cd chef && rake install"
end
 
desc "Update chef"
task :update_chef do
  run "cd ~/chef && git pull && rake install"
  run "cd ~/ohai && git pull && rake install"
end
 
desc "Update recipes"
task :update_recipes do
  run "cd #{deploy_to} && rake install"
end
 
desc "Create tarball for chef solo"
task :create_tarball do
  run "cd /var/chef && tar czvf /u/www/cookbooks.tgz cookbooks"
end
 
desc "Run chef solo"
task :run_solo do
  run "cd #{deploy_to} && chef-solo -c config/solo.rb -j config/backup.json"
end
 
after "deploy", "update_recipes"
after "update_recipes", "create_tarball"
 
deploy.task :default, :except => {:no_release => true} do
  run "cd #{deploy_to} && git config remote.origin.url #{repository} && git pull"
  sudo "chmod -R g+w #{deploy_to}"
end
