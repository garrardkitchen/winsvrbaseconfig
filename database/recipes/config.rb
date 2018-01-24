
Chef::Log.info("***************************************************")
Chef::Log.info("** DATABASE: CONFIGURE START                     **")

APP_NAME = "database"
app = search("aws_opsworks_app","deploy:true").first

if app['shortname'] == APP_NAME 
    search("aws_opsworks_instance").each do |instance|    
        Chef::Log.info("********** For instance '#{instance['ec2_instance_id']}', the instance's public IP address is '#{instance['public_ip']}', private IP address is '#{instance['private_ip']}' **********")    
    end
end

Chef::Log.info("** DATABASE: CONFIGURE END                       **")
Chef::Log.info("***************************************************")