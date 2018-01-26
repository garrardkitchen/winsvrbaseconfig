# done = create_folder("c:\\temp").to_s
# Chef::Log.info("Folder created = #{done}")

SEEDS = []
SEEDS.push("A")
SEEDS.push("B")
list_of_seeds = SEEDS.join(",")
powershell_script 'Run echo' do
    code "echo '#{list_of_seeds}'"        
end 

#include_recipe 'shared::bootstrap_web'

windows_package 'aws cli' do    
    installer_type :msi    
    source 'https://s3.amazonaws.com/aws-cli/AWSCLI64.msi'    
    action :install
end