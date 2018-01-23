Chef::Log.info("***************************************************")
Chef::Log.info("** STATUS: BOOTSTRAP START                       **")

include_recipe 'shared::bootstrap_web'

Chef::Log.info("** STATUS: BOOTSTRAP END                         **")
Chef::Log.info("***************************************************")
