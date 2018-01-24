Chef::Log.info("***************************************************")
Chef::Log.info("** SEED: BOOTSTRAP START                         **")

APP_NAME = "seed"
app = search("aws_opsworks_app","deploy:true").first

if app['shortname'] == APP_NAME 
    include_recipe 'shared::bootstrap_web'
end

Chef::Log.info("** SEED: BOOTSTRAP END                           **")
Chef::Log.info("***************************************************")
