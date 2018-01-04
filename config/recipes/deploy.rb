time =  Time.new.strftime("%Y%m%d%H%M%S")

#file "c:\\inetpub\\wwwroot\\index.html" do
#  content IO.binread("C:\\chef\\cookbooks\\index.html")
#  action  :create
#end

file "c:\\inetpub\\wwwroot\\status.html" do
  content IO.binread("C:\\chef\\cookbooks\\status.html")
  action  :create
end

#windowsserver = search(:aws_opsworks_instance, "hostname:web*").first
instance = search("aws_opsworks_instance", "self:true").first
Chef::Log.info("**********The public IP address is: '#{instance[:public_ip]}'**********")
Chef::Log.info("**********The private IP address is: '#{instance[:private_ip]}'**********")
Chef::Log.info("**********The ec2_instance_id is: '#{instance[:ec2_instance_id]}'**********")
Chef::Log.info("**********The availability_zone is: '#{instance[:availability_zone]}'**********")
Chef::Log.info("**********The hostname is: '#{instance[:hostname]}'**********")
Chef::Log.info("**********The time is: '#{time}'**********")

template "c:\\inetpub\\wwwroot\\index.html" do
  source "index.erb"
  variables(
    time: time,
    instance_id: instance[:ec2_instance_id],
    id: instance[:instance_id],
    ip: instance[:private_ip],
    az: instance[:availability_zone],
    host_name: instance[:hostname]
    )
end

chef_gem "aws-sdk" do
  compile_time false
  action :install
end

chef_gem "zipfile" do
  compile_time false
  action :install
end



app = search(:aws_opsworks_app).first
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


directory "c:\temp" do  
  rights :full_control, 'Administrators', :applies_to_children => true
  rights :write, 'Everyone', :applies_to_children => true
  action :create
end

ruby_block "download-object" do
  block do
    require 'aws-sdk'
    require 'zipfile'   

    #1
    Aws.config[:ssl_ca_bundle] = 'C:\ProgramData\Git\bin\curl-ca-bundle.crt'

    #2
    query = Chef::Search::Query.new
    app = query.search(:aws_opsworks_app, "type:other").first
    s3region = "US-EAST-1"
    #s3bucket = "deleteme-evaluate-releases"
    s3bucket = s3_bucket
#    s3filename = "20171214.1.zip"
    s3filename = s3_remote_path

    #3
    s3_client = Aws::S3::Client.new(region: s3region)
    s3_client.get_object(bucket: s3bucket,
                         key: s3filename,
                         response_target: 'C:\temp\evaluate.zip')
    
    zipfile "C:\temp\evaluate.zip" do
      into "C:\temp"
      overwrite true
    end
    
#     aws_s3_file "temp/evaluate.zip" do
#       bucket s3_bucket
#       remote_path s3_remote_path
#       retries 3
#     end
    
  end
  action :run
end



#app = search(:aws_opsworks_app).first
#app_path = "/srv/#{app['shortname']}"

# uri = URI.parse(app["app_source"]["url"])
# uri_path_components = uri.path.split("/").reject{ |p| p.empty? }
# virtual_host_match = uri.host.match(/\A(.+)\.s3(?:[-.](?:ap|eu|sa|us)-(?:.+-)\d|-external-1)?\.amazonaws\.com/i)
# s3_base_uri = uri.dup

# if virtual_host_match
#   s3_bucket = virtual_host_match[1]
#   s3_base_uri.path = "/"
# else
#   s3_bucket = uri_path_components[0]
#   s3_base_uri.path = "/#{uri_path_components.shift}"
# end

# s3_remote_path = uri_path_components.join("/")
# s3_base_uri.to_s.chomp!("/")

# tmpdir = Dir.mktmpdir("temp")
# directory tmpdir do
#   action :create
# end

#ruby_block "download-object" do
#  block do
#    require 'aws-sdk'
#application app_path do
  
   
#     aws_s3_file "#{tmpdir}/archive" do
#       bucket s3_bucket
#       remote_path s3_remote_path
#       retries 3
#     end

#     zipfile "#{tmpdir}/archive" do
#       into "#{app_path}"
#       overwrite true
#     end

#   link "#{app_path}/server.js" do
#     to "#{app_path}/index.js"
#   end

#   npm_install
#   npm_start do
#     action [:stop, :enable, :start]
#   end
#  end
#  action :run
#end
