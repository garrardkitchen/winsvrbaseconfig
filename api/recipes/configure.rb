Chef::Log.info("***************************************************")
Chef::Log.info("** API: CONFIGURE START                          **")

APP_NAME = "api"
SEEDS = get_list_of_seeds()
app = search("aws_opsworks_app","deploy:true").first
Chef::Log.info("List of seeds for #{APP_NAME} = #{SEEDS}. App is #{app['shortname']}")

if app['shortname'] == "seed" 
    powershell_script 'Update Seed IPs for TMS API' do
        cwd "c:/temp/"
        code ". c:/temp/deploy/Patch-APIAkka.ps1 -SeedIPs '#{SEEDS}' -ErrorAction Stop"        
    end
end

Chef::Log.info("** API: CONFIGURE END                            **")
Chef::Log.info("***************************************************")