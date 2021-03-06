# Purpose: To install ms sql server at server boot time
#
Chef::Log.info("***************************************************")
Chef::Log.info("** DATABASE: BOOTSTRAP START                     **")

APP_NAME = "database"
app = search("aws_opsworks_app","deploy:true").first

if app['shortname'] == APP_NAME 

  include_recipe 'shared::set_environment_variables'

  Chef::Log.info("** Install mssqlodbc driver")

  directory "c:\\temp" do  
    rights :full_control, 'Administrators', :applies_to_children => true
    rights :write, 'Everyone', :applies_to_children => true
    action :create
  end

  directory "c:\\temp\\db" do  
    rights :full_control, 'Administrators', :applies_to_children => true
    rights :write, 'Everyone', :applies_to_children => true
    action :create
  end

  cookbook_file 'c:/temp/db/install-mssqlodbc-driver.ps1' do
    source 'install-mssqlodbc-driver.ps1'  
    action :create  
    not_if "test-path c:/temp/db/install-mssqlodbc-driver.ps1"
  end

  powershell_script 'install mssqlodbc driver' do
    cwd "c:/temp/db"
    code ". c:\temp\db\install-mssqlodbc-driver.ps1"
    only_if "(Get-WmiObject -Class Win32_Product | sort-object Name | select Name | where { $_.Name -match 'Microsoft ODBC Driver 13 for SQL Server'}) -eq $null"
  end

end

Chef::Log.info("** DATABASE: BOOTSTRAP END                       **")
Chef::Log.info("***************************************************")

