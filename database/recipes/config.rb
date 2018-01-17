Chef::Log.info("********** STAGE 1 **********")

chef_gem "aws-sdk" do
  compile_time false
  action :install
end

ssm = Aws::SSM::Client.new(
  region: "us-east-1"
)

resp = ssm.get_parameter({
  name: "evaluate-mssql-dev-connstring",
  with_decryption: true,
})

Chef::Log.info("********** STAGE 2 **********")

Chef::Log.info("********** OUTPUT **********")
Chef::Log.info("  ssm name  = #{resp.parameter.name} ")
Chef::Log.info("  ssm value = #{resp.parameter.value} ")

Chef::Log.info("********** END **********")

