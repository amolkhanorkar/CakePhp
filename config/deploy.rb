set :application, "cakephp deployment"
set :repository,  "https://github.com/amolkhanorkar-webonise/CakePhp"
set :branch, "develop"
set :scm, :git
set :deploy_to, "/home/webonise/Projects/Deployment/cakephp-cakephp-0142e5e"
set :keep_releases, "5"
set :use_sudo, false

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "192.168.0.27"                          # Your HTTP server, Apache/etc
role :app, "192.168.0.27"                          # This may be the same as your `Web` server
#role :db,  " :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

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
after 'deploy:update_code', 'custom_recipes:custom_symlink'
#after 'custom_recipes:custom_symlink', 'custom_recipes:custom_migration'
before 'deploy:restart', 'custom_recipes:clear_cache'

namespace :custom_recipes do
task :custom_migration do 
     desc "custom_migration"     
       run "cd #{current_release}/app && Console/cake Migrations.migration run all"
       run "cd #{current_release}/app && Console/cake Migrations.migration run all --plugin Codes"
end



task :custom_symlink do

   run "ln -s #{shared_path}/app/tmp #{current_release}/app/tmp"

   run "ln -s #{shared_path}/app/Config #{current_release}/app/Config"
#  run "ln -s #{shared_path}/app/Config/database.php #{current_release}/app/Config/database.php"

   run "ln -s #{shared_path}/app/img #{current_release}/app/webroot/img"

   run "ln -s #{shared_path}/app/files #{current_release}/app/webroot/files"

   run "rm -rf #{current_release}/app/tmp"
   run "ln -s #{shared_path}/app/tmp #{current_release}/app/tmp"

   run "chmod -R 777 #{current_release}/app/webroot/img"  
   run "chmod -R 777 #{current_release}/app/webroot/files"

end


task :clear_cache do

   run "rm -rf #{shared_path}/tmp/*"
    # Create TMP folders
   run "mkdir -p #{shared_path}/app/tmp/{cache/{models,persistent,views},sessions,logs,tests}"

end

end
