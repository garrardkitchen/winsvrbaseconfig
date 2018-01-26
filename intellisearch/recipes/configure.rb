Chef::Log.info("***************************************************")
Chef::Log.info("** INTELLISEARCH: CONFIGURE START                **")

APP_NAME = "intellisearch"
SEEDS = get_list_of_seeds()
Chef::Log.info("List of seeds for #{APP_NAME} = #{SEEDS}")

powershell_script 'Update Seed IPs' do
    cwd "c:/temp/#{APP_NAME}"
    code ". c:/temp/#{APP_NAME}/deploy/Patch-WinServiceAkka.ps1 -Service IntelliSearch -SeedIPs '#{SEEDS}' -ErrorAction Stop"        
end

Chef::Log.info("** INTELLISEARCH: CONFIGURE END                  **")
Chef::Log.info("***************************************************")