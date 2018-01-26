Chef::Log.info("***************************************************")
Chef::Log.info("** STATUS: CONFIGURE START                       **")

APP_NAME = "status-web"
SEEDS = get_list_of_seeds()
Chef::Log.info("List of seeds for #{APP_NAME} = #{SEEDS}")

powershell_script 'Update Seed IPs' do
    cwd "c:/temp/#{APP_NAME}"
    code ". c:/temp/#{APP_NAME}/deploy/Patch-WebAkka.ps1 -Web Status -SeedIPs #{SEEDS} -ErrorAction Stop"        
end

Chef::Log.info("** STATUS: CONFIGURE END                         **")
Chef::Log.info("***************************************************")