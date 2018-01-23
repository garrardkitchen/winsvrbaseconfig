Chef::Log.info("***************************************************")
Chef::Log.info("** TMS WEB: BOOTSTRAP START                      **")

include_recipe 'shared::bootstrap_web'

Chef::Log.info("** TMS WEB: BOOTSTRAP END                        **")
Chef::Log.info("***************************************************")
