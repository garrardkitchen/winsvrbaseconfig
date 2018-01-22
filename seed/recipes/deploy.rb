Chef::Log.info("***************************************************")
Chef::Log.info("** SEED: BOOTSTRAP START                         **")

time =  Time.new.strftime("%Y%m%d%H%M%S")

chef_gem "aws-sdk" do
  compile_time false
  action :install
end

app = search("aws_opsworks_app", "shortname:seed").first
app_name = "seed" 

if app['shortname'] == 'evaluate' && app['app_source']['url'] != ''
  
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
    rights :full_control, 'Administrators', :applies_to_children => true
    rights :write, 'Everyone', :applies_to_children => true
    action :create
  end

  ruby_block "download-object" do
    block do
      require 'aws-sdk'

      #1
      Aws.config[:ssl_ca_bundle] = 'C:\ProgramData\Git\bin\curl-ca-bundle.crt'

      #2
      s3region = "US-EAST-1"
      s3bucket = s3_bucket
      s3filename = s3_remote_path

      #3
      s3_client = Aws::S3::Client.new(region: s3region)
      s3_client.get_object(bucket: s3bucket,
                            key: s3filename,
                            response_target: 'C:\\temp\\#{app_name}.zip')

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
    Unzip "C:\\temp\\#{app_name}.zip" "c:\\temp"
    EOH
  end
end  

Chef::Log.info("** SEED: BOOTSTRAP END                           **")
Chef::Log.info("***************************************************")