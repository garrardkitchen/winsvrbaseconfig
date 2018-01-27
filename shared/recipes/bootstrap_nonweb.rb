Chef::Log.info("** BOOTSTRAP START                      **")

create_folder("c:\\temp")

remote_file 'c:/temp/AWSCLI64.msi' do
  source 'https://s3.amazonaws.com/aws-cli/AWSCLI64.msi'
  action :create
end

windows_package 'AWS Command Line Interface' do    
  source "c:/temp/AWSCLI64.msi"
  options '/quiet /passive /qn'
end

powershell_script 'Install NET-Framework-45-Core' do
  code 'Add-WindowsFeature NET-Framework-45-Core'
  guard_interpreter :powershell_script
  not_if "(Get-WindowsFeature -Name NET-Framework-45-Core).Installed"
end