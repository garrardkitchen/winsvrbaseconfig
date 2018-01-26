Chef::Log.info("***************************************************")
Chef::Log.info("** STATUS: BOOTSTRAP START                       **")

APP_NAME = "status-web"
app = search("aws_opsworks_app","deploy:true").first

if app['shortname'] == APP_NAME 
    include_recipe 'shared::bootstrap_web'
end

Chef::Log.info("** STATUS: BOOTSTRAP END                         **")
Chef::Log.info("***************************************************")
