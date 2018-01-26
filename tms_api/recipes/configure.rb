Chef::Log.info("***************************************************")
Chef::Log.info("** TMS API: CONFIGURE START                      **")

APP_NAME = "tms"
SEEDS = get_list_of_seeds()
Chef::Log.info("List of seeds for #{APP_NAME} = #{SEEDS}")

powershell_script 'Update Seed IPs' do
    cwd "c:/temp/#{APP_NAME}"
    code ". c:/temp/#{APP_NAME}/deploy/Patch-WinServiceAkka.ps1 -Service TMS -SeedIPs '#{SEEDS}' -ErrorAction Stop"        
end

Chef::Log.info("** TMS API: CONFIGURE END                        **")
Chef::Log.info("***************************************************")