require 'capistrano-unicorn'

set :application, "karma"

set :user, "ubuntu"

set :scm, :git
set :repository, "git@github.com:whitecratedog/shout.git"
set :scm_passphrase, ""
set :branch, "master"
set :deploy_via, :copy

set :normalize_asset_timestamps, false

set :use_sudo, false
set :rails_env,       "production"

server "ec2-50-18-97-19.us-west-1.compute.amazonaws.com", :web, :app, :db, primary: true
ssh_options[:keys] = ["./.ec2/karma.pem"]

set :deploy_to, "/home/ubuntu/apps/#{application}"

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
      
    end
  end

  
 task :assets, roles: :app do
   run "cd #{current_path} && bundle exec rake assets:precompile"
 end  

  task :restart, roles: :app do
    sudo "/etc/init.d/unicorn_karma stop"
    sudo "/etc/init.d/unicorn_karma start"
  end  

  
  after "deploy:finalize_update", "deploy:symlink_config"
#  before "deploy:restart", "deploy:assets"


  task :symlink_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
  end
  
end

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end