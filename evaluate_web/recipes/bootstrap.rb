Chef::Log.info("***************************************************")
Chef::Log.info("** EVALUATE-WEB: BOOTSTRAP START                 **")

APP_NAME = "evaluate_web"
app = search("aws_opsworks_app","deploy:true").first

if app['shortname'] == APP_NAME 
    include_recipe 'shared::bootstrap_web'
    include_recipe 'shared::set_environment_variables'
end

Chef::Log.info("** EVALUATE-WEB: BOOTSTRAP END                   **")
Chef::Log.info("***************************************************")
