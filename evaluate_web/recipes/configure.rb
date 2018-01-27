Chef::Log.info("***************************************************")
Chef::Log.info("** EVALUATE-WEB: CONFIGURE START                 **")

APP_NAME = "web"
SEEDS = get_list_of_seeds()
Chef::Log.info("List of seeds for #{APP_NAME} = #{SEEDS}")

powershell_script 'Update Seed IPs for Evalaute Web' do
    cwd "c:/temp/#{APP_NAME}"
    code ". c:/temp/#{APP_NAME}/deploy/Patch-WebAkka.ps1 -Web Evaluate -SeedIPs #{SEEDS} -ErrorAction Stop"        
end

Chef::Log.info("** EVALUATE-WEB: CONFIGURE END                   **")
Chef::Log.info("***************************************************")