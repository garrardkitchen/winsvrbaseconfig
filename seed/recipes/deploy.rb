Chef::Log.info("***************************************************")
Chef::Log.info("** SEED: DEPLOY START                            **")

chef_gem "aws-sdk" do
  compile_time false
  action :install
end

APP_NAME = "seed"
REGION = node['region']
app = search("aws_opsworks_app","deploy:true").first
time =  Time.new.strftime("%Y%m%d%H%M%S")
instance = search("aws_opsworks_instance", "self:true").first
rds_db_instance = search("aws_opsworks_rds_db_instance").first
 
if node['allow_changes'] == true 

  Chef::Log.info("** Allowing changes")
   
    if app['shortname'] == APP_NAME && app['app_source']['url'] != ''
      
      app["environment"].each do |env|
        Chef::Log.info("   >>>> The env: '#{env}' is '#{app['environment'][env]}' <<<<")  
      end
      
      Chef::Log.info("********** RUNNING **********")
      Chef::Log.info("********** The app's deploy is '#{app['deploy']}' **********")
      Chef::Log.info("********** The app's short name is '#{app['shortname']}' **********")
      Chef::Log.info("********** The app's URL is '#{app['app_source']['url']}' **********")  

      #app = search(:aws_opsworks_app).first      

      create_folder("c:\\temp")
      create_folder("c:\\temp\\#{APP_NAME}", true)

      get_remote_file(URI.parse(app["app_source"]["url"]),"US-EAST-1","c:\\temp\\#{APP_NAME}.zip")

      unzip_file("c:\\temp\\#{APP_NAME}.zip", "c:\\temp\\#{APP_NAME}")
      
      Chef::Log.info("********** INSTALLING #{APP_NAME} **********")

      SEED = get_private_ip() + ":9000"

      powershell_script 'install db' do
        cwd "c:/temp/#{APP_NAME}"
        code ". c:/temp/#{APP_NAME}/deploy/Install-Seed.ps1 -Region #{REGION} -SeedIPs #{SEED} -ErrorAction Stop"        
      end

      Chef::Log.info("********** INSTALLED #{APP_NAME} **********")

    end  
 
else
  Chef::Log.info("** Not allowing changes")
end

Chef::Log.info("** SEED: DEPLOY END                              **")
Chef::Log.info("***************************************************")