Chef::Log.info("***************************************************")
Chef::Log.info("** DATABASE: DEPLOY START                        **")

time =  Time.new.strftime("%Y%m%d%H%M%S")

Chef::Log.info("********** STAGE 1 **********")

instance = search("aws_opsworks_instance", "self:true").first

chef_gem "aws-sdk" do
  compile_time false
  action :install
end

rds_db_instance = search("aws_opsworks_rds_db_instance").first
 
search("aws_opsworks_app").each do |app| 
  
  if app['shortname'] == 'database' && app['app_source']['url'] != ''
    
    app["environment"].each do |env|
      Chef::Log.info("   >>>> The env: '#{env}' is '#{app['environment'][env]}' <<<<")  
    end
    
    Chef::Log.info("********** RUNNING **********")
    Chef::Log.info("********** The app's deploy is '#{app['deploy']}' **********")
    Chef::Log.info("********** The app's short name is '#{app['shortname']}' **********")
    Chef::Log.info("********** The app's URL is '#{app['app_source']['url']}' **********")  

    #app = search(:aws_opsworks_app).first
    app_path = "/srv/#{app['shortname']}"
    uri = URI.parse(app["app_source"]["url"])
    uri_path_components = uri.path.split("/").reject{ |p| p.empty? }
    virtual_host_match = uri.host.match(/\A(.+)\.s3(?:[-.](?:ap|eu|sa|us)-(?:.+-)\d|-external-1)?\.amazonaws\.com/i)
    s3_base_uri = uri.dup

    if virtual_host_match
      s3_bucket = virtual_host_match[1]
      s3_base_uri.path = "/"
    else
      s3_bucket = uri_path_components[0]
      s3_base_uri.path = "/#{uri_path_components.shift}"
    end

    s3_remote_path = uri_path_components.join("/")
    Chef::Log.info("**********The uri is: '#{uri}'**********")
    Chef::Log.info("**********The s3_remote_path is: '#{s3_remote_path}'**********")
    Chef::Log.info("**********The s3_bucket is: '#{s3_bucket}'**********")


    directory "c:\\temp" do        
      recursive true
      action :delete
    end
    
    directory "c:\\temp" do  
      rights :full_control, 'Administrators', :applies_to_children => true
      rights :write, 'Everyone', :applies_to_children => true
      action :create
    end

    ruby_block "download-object" do
      block do
        require 'aws-sdk'
        #require 'zipfile'   

        #1
        Aws.config[:ssl_ca_bundle] = 'C:\ProgramData\Git\bin\curl-ca-bundle.crt'

        #2
        #query = Chef::Search::Query.new
        #app = query.search(:aws_opsworks_app, "type:other").first
        s3region = "US-EAST-1"
        s3bucket = s3_bucket
        s3filename = s3_remote_path

        #3
        s3_client = Aws::S3::Client.new(region: s3region)
        s3_client.get_object(bucket: s3bucket,
                             key: s3filename,
                             response_target: 'C:\\temp\\db.zip')

      end
      action :run
    end

    powershell_script 'unzip zip file' do
      code <<-EOH
      Add-Type -AssemblyName System.IO.Compression.FileSystem
      function Unzip
      {
          param([string]$zipfile, [string]$outpath)
          [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
      }
      Unzip "C:\\temp\\db.zip" "c:\\temp"
      EOH
    end

    #Chef::Log.info("********** CREATE install-db.ps1 **********")

    #cookbook_file 'c:/temp/db/install-db.ps1' do
    #  source 'install-db.ps1'  
    #  action :create
    #end

    Chef::Log.info("********** INSTALLING DB **********")

    powershell_script 'install db' do
      cwd "c:/temp/db"
      code ". c:\temp\db\install-db.ps1 -DbName #{rds_db_instance['db_instance_identifier']} -DbDns #{rds_db_instance['address']} -DbLoginName #{rds_db_instance['db_user']} -DbPassword #{rds_db_instance['db_password']}"
    end

  #else
  #  Chef::Log.info("********** SKIPPING **********")
  end  
  
end

Chef::Log.info("** DATABASE: DEPLOY END                          **")
Chef::Log.info("***************************************************")