

# Variables
set :application, "local.cakephp.com"
set :repository,  "https://github.com/amolkhanorkar-webonise/CakePhp"
set :branch, "develop"
set :scm, "git"
set :deploy_to, "/home/webonise/Projects/Deployment/cakephp-cakephp-0142e5e"
set :use_sudo, false
#set :keep_release, "5"

# Roles

role :web, "192.168.0.27"                         # Your HTTP server, Apache/etc
role :app, "192.168.0.27"  		          # This may be the same as your `Web` server
role :db,  "192.168.0.27", :primary => true       # This is where Rails migrations will run

# Recipes

 task :custommigration do
	desc "custommigration"
	run "cd #{current_release}/app && Console/cake Migrations.migration run all"
	run "cd #{current_release}/app && Console/cake Migrations.migration run all --plugin Codes"
end

 task :customsymlink do
	desc "custom symlink"
	
	run "ln -s #{shared_path}/tmp #{current_release}/app/tmp"
	run "ln -s #{shared_path}/img #{current_release}/app/webroot/img"
	run "ln -s #{shared_path}/files #{current_release}/app/webroot/files"
	run "ln -sf #{shared_path}/config/core.php #{current_release}/app/Config/core.php"
	
	run "rm -rf #{current_release}/public"
	run "ln -sf #{shared_path}/public #{current_release}/public"	

	run "rm -rf #{shared_path}/tmp/cache/models"
	run "rm -rf #{shared path}/tmp/cache/persistent"
	
	run "chmod -R 777 #{current_release}/app/webroot/img"
	run "chmod -R 777 #{current_release}/app/webroot/files"
end

 after 'deploy:update_code', 'customsymlink'

 task :clear_cache do
	desc "clear_cache"
	run "rm -rf #{current_release}/app/tmp/cache/persistent"
	run "rm -rf #{current_release}/app/tmp/cache/models"
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
