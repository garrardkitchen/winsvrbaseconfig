file "c:\\inetpub\\wwwroot\\index.html" do
  content IO.binread("index.html")
  action  :create
end

file "c:\\inetpub\\wwwroot\\status.html" do
  content IO.binread("status.html")
  action  :create
end
