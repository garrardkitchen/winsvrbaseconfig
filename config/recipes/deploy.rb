file "c:\\inetpub\\wwwroot\\index.html" do
  content IO.binread("C:\\chef\\cookbooks\\index.html")
  action  :create
end

file "c:\\inetpub\\wwwroot\\status.html" do
  content IO.binread("C:\\chef\\cookbooks\\status.html")
  action  :create
end
