module Shared_helper    
  
      #include Chef::Mixin::ShellOut
  
      # create_folder ("c:\\temp")
      def create_folder(name)

        directory name do  
            rights :full_control, 'Administrators', :applies_to_children => true
            rights :write, 'Everyone', :applies_to_children => true
            action :create
        end

        true
      end

      # get_remote_file(app["app_source"]["url"], "US-EAST-1", "C:\\temp\\#{app_name}.zip")
      def get_remote_file(uri, s3region, to_where)
        
        uri_path_components = uri.path.split("/").reject{ |p| p.empty? }
        virtual_host_match = uri.host.match(/\A(.+)\.s3(?:[-.](?:ap|eu|sa|us)-(?:.+-)\d|-external-1)?\.amazonaws\.com/i)
        s3_base_uri = uri.dup

        if virtual_host_match
            s3_bucket = virtual_host_match[1]
            s3_base_uri.path = "/"
        else
            s3_bucket = uri_path_components[0]
            s3_base_uri.path = "/#{uri_path_components.shift}"
        end

        s3_remote_path = uri_path_components.join("/")
        Chef::Log.info("**********The uri is: '#{uri}'**********")
        Chef::Log.info("**********The s3_remote_path is: '#{s3_remote_path}'**********")
        Chef::Log.info("**********The s3_bucket is: '#{s3_bucket}'**********")

        ruby_block "download-object" do
            block do
            require 'aws-sdk'

            #1
            Aws.config[:ssl_ca_bundle] = 'C:\ProgramData\Git\bin\curl-ca-bundle.crt'

            #2           
            s3bucket = s3_bucket
            s3filename = s3_remote_path

            #3
            s3_client = Aws::S3::Client.new(region: s3region)
            s3_client.get_object(bucket: s3bucket,
                                    key: s3filename,
                                    response_target: to_where)

            end
            action :run
        end

        true
      end      
    
      # unzip_file("C:\\temp\\#{app_name}.zip", "c:\\temp")
      def unzip_file(file, to_where) 
        powershell_script 'unzip zip file' do
            code <<-EOH
            Add-Type -AssemblyName System.IO.Compression.FileSystem
            function Unzip
            {
                param([string]$zipfile, [string]$outpath)
        
                [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
            }
            Unzip #{file} #{to_where}
            EOH
        end

        true
    end
end

Chef::Recipe.send(:include, Shared_helper)
Chef::Resource.send(:include, Shared_helper)
Chef::Provider.send(:include, Shared_helper) 