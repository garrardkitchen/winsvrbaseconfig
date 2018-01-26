Chef::Log.info("***************************************************")
Chef::Log.info("** INTELLISEARCH: BOOTSTRAP START                **")

# APP_NAME = "intellisearch"
# app = search("aws_opsworks_app","deploy:true").first

# if app['shortname'] == APP_NAME 
    inclde_recipe 'shared::bootstrap_web'
# end

Chef::Log.info("** INTELLISEARCH: BOOTSTRAP END                  **")
Chef::Log.info("***************************************************")
