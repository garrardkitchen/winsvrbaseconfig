Chef::Log.info("***************************************************")
Chef::Log.info("** STATUS: DEPLOY START                          **")

APP_NAME = "status-web"
REGION = node['region']

time =  Time.new.strftime("%Y%m%d%H%M%S")

instance = search("aws_opsworks_instance", "self:true").first

chef_gem "aws-sdk" do
  compile_time false
  action :install
end

rds_db_instance = search("aws_opsworks_rds_db_instance").first
 
if node['allow_changes'] == true 

  Chef::Log.info("** Allowing changes")

  search("aws_opsworks_app").each do |app| 
    
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

      get_remote_file(URI.parse(app["app_source"]["url"]),"US-EAST-1","c:\\temp\\#{APP_NAME}.zip")

      unzip_file("c:\\temp\\#{APP_NAME}.zip", "c:\\temp")
      
      Chef::Log.info("********** INSTALLING #{APP_NAME} **********")

      powershell_script 'install db' do
        cwd "c:/temp/#{APP_NAME}"
        code ". c:/temp/#{APP_NAME}/deploy/Install-StatusWeb.ps1 -Region #{REGION} -ErrorAction Stop"        
      end

      Chef::Log.info("********** INSTALLED #{APP_NAME} **********")

    #else
    #  Chef::Log.info("********** SKIPPING **********")
    end  
    
  end

else
  Chef::Log.info("** Not allowing changes")
end

Chef::Log.info("** STATUS: DEPLOY END                            **")
Chef::Log.info("***************************************************")