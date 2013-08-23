set :application, "installer"

set :repository, "."
set :scm, :none
set :deploy_via, :copy
set :copy_exclude, [".git"]

set :deploy_to, "/etc/puppet/#{application}"
set :module_dir, "/etc/puppet/environments/production/modules"

set :user, "root"
set :use_sudo, false
set :gateway, "radon.usersys.redhat.com"

hosts = Dir.glob("answers/*.yaml").map { |p| p =~ /answers-(.+)\.yaml/ && $1 || nil }.compact
role :foreman, *hosts

after "deploy:restart", "deploy:copy_to_module_dir"

namespace :deploy do
  task :finalize_update do
  end

  task :copy_to_module_dir do
    # This actually only needs to run the first time the master is deployed
    # but there isn't a good way in cap to test for existence. This is a hack.
    # We can't use a symlink as the puppet::server class enforces a directory
    # so just sync up the files
    run("rsync -aqx --delete-after --exclude=.git #{current_path}/ #{module_dir}/")
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
