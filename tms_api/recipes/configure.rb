Chef::Log.info("***************************************************")
Chef::Log.info("** TMS API: CONFIGURE START                      **")

APP_NAME = "tms_web"
UPDATE_PS = "Install-TMS.ps1"
SEEDS = get_list_of_seeds()
Chef::Log.info("List of seeds for #{APP_NAME} = #{SEEDS}")

powershell_script 'Update Seeds for #{APP_NAME}' do
    cwd "c:/temp/#{APP_NAME}"
    #code ". c:/temp/#{APP_NAME}/deploy/#{UPDATE_PS} -Region #{REGION} -SeedIPs #{SEEDS} -ErrorAction Stop"        
end

Chef::Log.info("** TMS API: CONFIGURE END                        **")
Chef::Log.info("***************************************************")