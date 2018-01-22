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
        Chef::Log.info(" connstring = #{resp.parameter.value}")
        ENV['q-db-connstring'] = resp.parameter.value       
        ENV['q-delete-me-1'] = "DELETE ME 1"
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
        Chef::Log.info(" billing api-key = #{resp.parameter.value}")
        ENV['q-billing-api-key'] = resp.parameter.value
    end
    action :run
end

# env "q-api-key" do
#     value billing_api_key
# end

# env "q-db-connstring" do
#     value resp.parameter.value
# end

rds_db_instance = search("aws_opsworks_rds_db_instance").first

env "q-db-dns" do
    value rds_db_instance['address']
end

env "q-db-port" do
    value rds_db_instance['port'].to_s
end

env "q-db-name" do
    value rds_db_instance['db_instance_identifier']
end

env "q-db-sys-username" do
    value rds_db_instance['db_user']
end

env "q-db-sys-password" do
    value rds_db_instance['db_password']
end

env "q-delete-me-2" do
    value "DELETE ME 2"
    key_name "q-delete-me-2a"
    action :create
end

Chef::Log.info("** SHARED: ENV VARS START")

ENV.each_pair do |k, v|
    Chef::Log.info("ENV['#{k}'] = '#{v}'")
end

Chef::Log.info("** SHARED: ENV VARS END")

# app = search("aws_opsworks_app", "shortname:database").first

# app[:environment_variables].each do |key, value|
#     Chef::Log.info("[#{key}] = #{value}")        
# end

search("aws_opsworks_app").each do |app|     
    if app['shortname'] == 'database'     
        app["environment"].each do |k,v|
            Chef::Log.info("   >>>> The env: '#{k} is '#{v}' <<<<")  
        end
    end
end

db_app = search("aws_opsworks_app", "shortname:database").first
ep1 = db_app["environment"]["Q_TEMP_1"]
ep2 = db_app["environment"]["Q_TEMP_2"]
ep3 = db_app["environment"]["Q_TEMP_3"]
Chef::Log.info(" Q_TEMP_1 = #{ep1}  ")  
Chef::Log.info(" Q_TEMP_2 = #{ep2}  ")  
Chef::Log.info(" Q_TEMP_3 = #{ep3}  ")  

# Chef::Log.info("Q_TEMP_1: #{node[:deploy]['Database'][:environment_variables]['Q_TEMP_1']}")
# Chef::Log.info("Q_TEMP_2: #{node[:deploy]['Database'][:environment_variables]['Q_TEMP_2']}")
# Chef::Log.info("Q_TEMP_3: #{node[:deploy]['Database']['environment_variables']['Q_TEMP_3']}")
