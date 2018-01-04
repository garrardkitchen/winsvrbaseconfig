time =  Time.new.strftime("%Y%m%d%H%M%S")

#file "c:\\inetpub\\wwwroot\\index.html" do
#  content IO.binread("C:\\chef\\cookbooks\\index.html")
#  action  :create
#end

file "c:\\inetpub\\wwwroot\\status.html" do
  content IO.binread("C:\\chef\\cookbooks\\status.html")
  action  :create
end

windowsserver = search(:aws_opsworks_instance, "hostname:web*").first
Chef::Log.info("**********The public IP address is: '#{windowsserver[:public_ip]}'**********")
Chef::Log.info("**********The private IP address is: '#{windowsserver[:private_ip]}'**********")
Chef::Log.info("**********The ec2_instance_id is: '#{windowsserver[:ec2_instance_id]}'**********")
Chef::Log.info("**********The availability_zone is: '#{windowsserver[:availability_zone]}'**********")
Chef::Log.info("**********The hostname is: '#{windowsserver[:hostname]}'**********")
Chef::Log.info("**********The time is: '#{time}'**********")

template "c:\\inetpub\\wwwroot\\index.html" do
  source "index.erb"
  variables(
    time: time,
    instance_id: windowsserver[:ec2_instance_id],
    id: windowsserver[:instance_id],
    ip: windowsserver[:private_ip],
    az: windowsserver[:availability_zone],
    host_name: windowsserver[:hostname]
    )
end
