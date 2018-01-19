Chef::Log.info("***************************************************")
Chef::Log.info("** DATABASE: BOOTSTRAP START                     **")

include_recipe 'shared::set_environment_variables'

Chef::Log.info("** Install mssqlodbc driver")

cookbook_file 'c:/temp/db/install-mssqlodbc-driver.ps1' do
  source 'install-mssqlodbc-driver.ps1'  
  action :create
end

powershell_script 'install ms sql odbc driver' do
  cwd "c:/temp/db"
  code ". c:\temp\db\install-mssqlodbc-driver.ps1"
end

Chef::Log.info("** DATABASE: BOOTSTRAP END                       **")
Chef::Log.info("***************************************************")

