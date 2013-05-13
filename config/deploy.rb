set :application, "installer"

set :repository, "."
set :scm, :none
set :deploy_via, :copy
set :copy_exclude, [".git"]

set :deploy_to, "/etc/puppet/modules/production/#{application}"
set :current_path, "/etc/puppet/modules/production/modules"

set :user, "root"
set :use_sudo, false
set :gateway, "radon.usersys.redhat.com"

hosts = Dir.glob("answers/*.yaml").map { |p| p =~ /answers-(.+)\.yaml/ && $1 || nil }.compact
role :foreman, *hosts

namespace :deploy do
  task :finalize_update do
  end
end

namespace :installer do
  task :puppet, :roles => :foreman, :except => { :no_release => true } do
    run %Q{#{try_sudo} echo -e "class { 'foreman_installer': answers => '#{current_path}/answers/answers-`hostname`.yaml' }" | puppet apply --modulepath #{current_path}}
  end

  task :noop, :roles => :foreman, :except => { :no_release => true } do
    run %Q{#{try_sudo} echo -e "class { 'foreman_installer': answers => '#{current_path}/answers/answers-`hostname`.yaml' }" | puppet apply --modulepath #{current_path} --noop}
  end
end
