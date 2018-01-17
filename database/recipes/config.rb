Chef::Log.info("********** CONFIG: START **********")

chef_gem "aws-sdk" do
  compile_time false
  action :install
end

Chef::Log.info("********** CONFIG: STAGE 1 **********")

ruby_block "test ssm parameter" do
    block do
      require 'aws-sdk'
    
      Chef::Log.info("********** CONFIG: STAGE 2 **********")
      
      #1
      Aws.config[:ssl_ca_bundle] = 'C:\ProgramData\Git\bin\curl-ca-bundle.crt'

      Chef::Log.info("********** CONFIG: STAGE 3 **********")
      
      #2
      ssm = Aws::SSM::Client.new(region: "us-east-1")

      Chef::Log.info("********** CONFIG: STAGE 4 **********")
      
      #3
      resp = ssm.get_parameter({
        name: "evaluate-mssql-dev-connstring",
        with_decryption: true
      })
      
      Chef::Log.info("********** OUTPUT **********")
      Chef::Log.info("  ssm name  = #{resp.parameter.name} ")
      Chef::Log.info("  ssm value = #{resp.parameter.value} ")

    end
    action :run
  end

Chef::Log.info("********** CONFIG: END **********")

