Chef::Log.info("***************************************************")
Chef::Log.info("** EVALUATE WEB: DEPLOY START                    **")

chef_gem "aws-sdk" do
  compile_time false
  action :install
end

APP_NAME = "evaluate_web"
REGION = node['region']
app = search("aws_opsworks_app","deploy:true").first
time =  Time.new.strftime("%Y%m%d%H%M%S")
rds_db_instance = search("aws_opsworks_rds_db_instance").first

# file "c:\\inetpub\\wwwroot\\status.html" do
#   content IO.binread("C:\\chef\\cookbooks\\status.html")
#   action  :create
# end

# #windowsserver = search(:aws_opsworks_instance, "hostname:web*").first
# instance = search("aws_opsworks_instance", "self:true").first
# Chef::Log.info("**********The public IP address is: '#{instance[:public_ip]}'**********")
# Chef::Log.info("**********The private IP address is: '#{instance[:private_ip]}'**********")
# Chef::Log.info("**********The ec2_instance_id is: '#{instance[:ec2_instance_id]}'**********")
# Chef::Log.info("**********The availability_zone is: '#{instance[:availability_zone]}'**********")
# Chef::Log.info("**********The hostname is: '#{instance[:hostname]}'**********")
# Chef::Log.info("**********The time is: '#{time}'**********")

# template "c:\\inetpub\\wwwroot\\index.html" do
#   source "index.erb"
#   variables(
#     time: time,
#     instance_id: instance[:ec2_instance_id],
#     id: instance[:instance_id],
#     ip: instance[:private_ip],
#     az: instance[:availability_zone],
#     host_name: instance[:hostname]
#     )
# end

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

    SEEDS = get_list_of_seeds()

    powershell_script 'install db' do
      cwd "c:/temp/#{APP_NAME}"
      code ". c:/temp/#{APP_NAME}/deploy/Install-EvaluateWeb.ps1 -Region #{REGION} -SeedIPs #{SEEDS} -ErrorAction Stop"        
    end

    Chef::Log.info("********** INSTALLED #{APP_NAME} **********")

  end  

else
  Chef::Log.info("** Not allowing changes")
end

Chef::Log.info("** EVALUATE WEB: DEPLOY END                      **")
Chef::Log.info("***************************************************")