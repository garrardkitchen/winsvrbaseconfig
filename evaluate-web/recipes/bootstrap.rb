Chef::Log.info("***************************************************")
Chef::Log.info("** EVALUATE-WEB: BOOTSTRAP START                 **")

include_recipe 'shared::bootstrap_web'
include_recipe 'shared::set_environment_variables'


Chef::Log.info("** EVALUATE-WEB: BOOTSTRAP END                   **")
Chef::Log.info("***************************************************")
