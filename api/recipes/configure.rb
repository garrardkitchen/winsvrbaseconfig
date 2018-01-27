Chef::Log.info("***************************************************")
Chef::Log.info("** TMS API: CONFIGURE START                      **")

APP_NAME = "api"
SEEDS = get_list_of_seeds()
Chef::Log.info("List of seeds for #{APP_NAME} = #{SEEDS}")

powershell_script 'Update Seed IPs for TMS API' do
    cwd "c:/temp/#{APP_NAME}"
    code ". c:/temp/#{APP_NAME}/deploy/Patch-APIAkka.ps1 -SeedIPs '#{SEEDS}' -ErrorAction Stop"        
end

# powershell_script 'Update Seed IPs for TMS API' do
#     cwd "c:/temp/#{APP_NAME}"
#     code ". c:/temp/#{APP_NAME}/deploy/Patch-WinServiceAkka.ps1 -Service TMS -SeedIPs '#{SEEDS}' -ErrorAction Stop"        
# end

# powershell_script 'Update Seed IPs for IntelliSearch' do
#     cwd "c:/temp/#{APP_NAME}"
#     code ". c:/temp/#{APP_NAME}/deploy/Patch-WinServiceAkka.ps1 -Service IntelliSearch -SeedIPs '#{SEEDS}' -ErrorAction Stop"        
# end

# powershell_script 'Update Seed IPs for TMS Web' do
#     cwd "c:/temp/#{APP_NAME}"
#     code ". c:/temp/#{APP_NAME}/deploy/Patch-WebAkka.ps1 -Web TMS -SeedIPs '#{SEEDS}' -ErrorAction Stop"        
# end

Chef::Log.info("** TMS API: CONFIGURE END                        **")
Chef::Log.info("***************************************************")