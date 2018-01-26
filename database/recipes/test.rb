# done = create_folder("c:\\temp").to_s
# Chef::Log.info("Folder created = #{done}")

SEEDS = []
SEEDS.push("A")
SEEDS.push("B")
list_of_seeds = SEEDS.join(",")
powershell_script 'Run echo' do
    code "echo '#{list_of_seeds}'"        
end 