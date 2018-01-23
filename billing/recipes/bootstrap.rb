Chef::Log.info("***************************************************")
Chef::Log.info("** EVALUATE-WEB: BOOTSTRAP START                 **")

include_recipe 'shared::bootstrap_web'

Chef::Log.info("** EVALUATE-WEB: BOOTSTRAP END                   **")
Chef::Log.info("***************************************************")
