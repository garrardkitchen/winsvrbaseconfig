cookbook_file 'c:/temp/db/install-mssqlodbc-driver.ps1' do
  source 'install-mssqlodbc-driver.ps1'  
  action :create
end

powershell_script 'install ms sql odbc driver' do
  cwd "c:/temp/db"
  code <<-EOH  
  .\\install-mssqlodbc-driver.ps1
  EOH
end
