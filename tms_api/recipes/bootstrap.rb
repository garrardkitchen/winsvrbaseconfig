Chef::Log.info("***************************************************")
Chef::Log.info("** TMS API: BOOTSTRAP START                      **")

include_recipe 'shared::bootstrap_web'

Chef::Log.info("** TMS API: BOOTSTRAP END                        **")
Chef::Log.info("***************************************************")
