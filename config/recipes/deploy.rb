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
