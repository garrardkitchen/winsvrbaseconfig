chef_gem "aws-sdk" do
    compile_time false
    action :install
end

ruby_block "get db connection string from ssm parameter store" do
    block do        
        require 'aws-sdk'
        Aws.config[:ssl_ca_bundle] = 'C:\ProgramData\Git\bin\curl-ca-bundle.crt'
        ssm = Aws::SSM::Client.new(region: "us-east-1")
        resp = ssm.get_parameter({
            name: "evaluate-mssql-dev-connstring",
            with_decryption: true
        })
        ENV['q-db-connstring'] = resp.parameter.value       
    end
    action :run
end

ruby_block "get billing api key from ssm parameter store" do
    block do
        require 'aws-sdk'
        Aws.config[:ssl_ca_bundle] = 'C:\ProgramData\Git\bin\curl-ca-bundle.crt'
        ssm = Aws::SSM::Client.new(region: "us-east-1")
        resp = ssm.get_parameter({
            name: "evaluate-billing-api-key",
            with_decryption: true
        })
        ENV['q-billing-api-key'] = resp.parameter.value
    end
    action :run
end

rds_db_instance = search("aws_opsworks_rds_db_instance").first

env "q-db-dns" do
    key_name "q-db-dns"
    value rds_db_instance['address']
    action :create
end

env "q-db-port" do
    key_name "q-db-port" 
    value rds_db_instance['port'].to_s
    action :create
end

env "q-db-name" do
    key_name "q-db-name"
    value rds_db_instance['db_instance_identifier']
    action :create
end

env "q-db-sys-username" do
    key_name "q-db-sys-username"
    value rds_db_instance['db_user']
    action :create
end

env "q-db-sys-password" do
    key_name "q-db-sys-password"
    value rds_db_instance['db_password']
    action :create
end

Chef::Log.info("** SHARED: ENV VARS START")

ENV.each_pair do |k, v|
    Chef::Log.info("ENV['#{k}'] = '#{v}'")
end

Chef::Log.info("** SHARED: ENV VARS END")

# search("aws_opsworks_app").each do |app|     
#     if app['shortname'] == 'database'     
#         app["environment"].each do |k,v|
#             Chef::Log.info("   >>>> The env: '#{k} is '#{v}' <<<<")  
#         end
#     end
# end

# db_app = search("aws_opsworks_app", "shortname:database").first
# ep1 = db_app["environment"]["Q_TEMP_1"]
# ep2 = db_app["environment"]["Q_TEMP_2"]
# ep3 = db_app["environment"]["Q_TEMP_3"]
# Chef::Log.info(" Q_TEMP_1 = #{ep1}  ")  
# Chef::Log.info(" Q_TEMP_2 = #{ep2}  ")  
# Chef::Log.info(" Q_TEMP_3 = #{ep3}  ")  

