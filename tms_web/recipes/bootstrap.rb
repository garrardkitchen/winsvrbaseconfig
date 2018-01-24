Chef::Log.info("***************************************************")
Chef::Log.info("** TMS WEB: BOOTSTRAP START                      **")

APP_NAME = "tms_web"
app = search("aws_opsworks_app","deploy:true").first

if app['shortname'] == APP_NAME 
    include_recipe 'shared::bootstrap_web'
end

Chef::Log.info("** TMS WEB: BOOTSTRAP END                        **")
Chef::Log.info("***************************************************")
