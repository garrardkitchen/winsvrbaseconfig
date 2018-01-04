time =  Time.new.strftime("%Y%m%d%H%M%S")

#file "c:\\inetpub\\wwwroot\\index.html" do
#  content IO.binread("C:\\chef\\cookbooks\\index.html")
#  action  :create
#end

file "c:\\inetpub\\wwwroot\\status.html" do
  content IO.binread("C:\\chef\\cookbooks\\status.html")
  action  :create
end

template "c:\\inetpub\\wwwroot\\index.html" do
  source "index.erb"
  variables(
    time: time,
    instance_id: node["opsworks"]["instance"]["aws_instance_id"],
    id: node["opsworks"]["instance"]["id"],
    ip: node["opsworks"]["instance"]["ip"],
    az: node["opsworks"]["instance"]["availability_zone"],
    host_name: node["opsworks"]["instance"]["hostname"]
    )
end
