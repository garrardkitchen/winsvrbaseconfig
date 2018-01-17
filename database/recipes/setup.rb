Chef::Log.info("********** STAGE 1 **********")

cookbook_file 'c:/temp/db/install-mssqlodbc-driver.ps1' do
  source 'install-mssqlodbc-driver.ps1'  
  action :create
end

Chef::Log.info("********** STAGE 2 **********")

powershell_script 'install ms sql odbc driver' do
  cwd "c:/temp/db"
  code ". c:\temp\db\install-mssqlodbc-driver.ps1"
end

Chef::Log.info("********** END **********")
