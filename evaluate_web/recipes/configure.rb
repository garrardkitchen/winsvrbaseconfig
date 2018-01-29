Chef::Log.info("***************************************************")
Chef::Log.info("** EVALUATE-WEB: CONFIGURE START                 **")

APP_NAME = "web"
SEEDS = get_list_of_seeds()
app = search("aws_opsworks_app","deploy:true").first
Chef::Log.info("List of seeds for #{APP_NAME} = #{SEEDS}. App is #{app['shortname']}")

if app['shortname'] == "seed" 
    powershell_script 'Update Seed IPs for Evalaute Web' do
        cwd "c:/temp/"
        code ". c:/temp/deploy/Patch-WebAkka.ps1 -Web Evaluate -SeedIPs '#{SEEDS}' -ErrorAction Stop"        
    end
end

Chef::Log.info("** EVALUATE-WEB: CONFIGURE END                   **")
Chef::Log.info("***************************************************")