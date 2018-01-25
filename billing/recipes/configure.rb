Chef::Log.info("***************************************************")
Chef::Log.info("** BILLING: CONFIGURE START                      **")

APP_NAME = "tms_web"
SEEDS = get_list_of_seeds()
Chef::Log.info("List of seeds for #{APP_NAME} = #{SEEDS}")

powershell_script 'Update Seed IPs' do
    cwd "c:/temp/#{APP_NAME}"
    code ". c:/temp/#{APP_NAME}/deploy/Patch-WinServiceAkka.ps1 -Service Billing -SeedIPs #{SEEDS} -ErrorAction Stop"        
end

Chef::Log.info("** BILLING: CONFIGURE END                        **")
Chef::Log.info("***************************************************")