Chef::Log.info("***************************************************")
Chef::Log.info("** BILLING: BOOTSTRAP START                      **")

# APP_NAME = "billing"
# app = search("aws_opsworks_app","deploy:true").first

#if app['shortname'] == APP_NAME 
    include_recipe 'shared::bootstrap_web'
#end

Chef::Log.info("** BILLING: BOOTSTRAP END                        **")
Chef::Log.info("***************************************************")
