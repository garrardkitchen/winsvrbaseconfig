Chef::Log.info("***************************************************")
Chef::Log.info("** SEED: BOOTSTRAP START                         **")

include_recipe 'shared::bootstrap_web'

Chef::Log.info("** SEED: BOOTSTRAP END                           **")
Chef::Log.info("***************************************************")
