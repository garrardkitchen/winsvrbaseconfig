Chef::Log.info("***************************************************")
Chef::Log.info("** INTELLISEARCH: BOOTSTRAP START                **")

include_recipe 'shared::bootstrap_web'

Chef::Log.info("** INTELLISEARCH: BOOTSTRAP END                  **")
Chef::Log.info("***************************************************")
