Chef::Log.info("***************************************************")
Chef::Log.info("** TMS API: BOOTSTRAP START                      **")

# APP_NAME = "tms"
# app = search("aws_opsworks_app","deploy:true").first

# if app['shortname'] == APP_NAME 
    include_recipe 'shared::bootstrap_web'
# end

Chef::Log.info("** TMS API: BOOTSTRAP END                        **")
Chef::Log.info("***************************************************")
