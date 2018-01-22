env "q-foo" do
    value "BOO2"
end


# powershell_script 'set var' do
#     code "[Environment]::SetEnvironmentVariable(\"q-foo\", \"BOO\",\"Process\")"
       
# end


powershell_script 'stuff' do
    code <<-EOH
    foreach($key in [System.Environment]::GetEnvironmentVariables('Process').Keys) {
        if ([System.Environment]::GetEnvironmentVariable($key, 'Machine') -eq $null) {
            $value = [System.Environment]::GetEnvironmentVariable($key, 'Process')
            [System.Environment]::SetEnvironmentVariable($key, $value, 'Machine')
        }
    }
    EOH
end

ENV.each_pair do |k, v|
    Chef::Log.info("ENV['#{k}'] = '#{v}'")
end
