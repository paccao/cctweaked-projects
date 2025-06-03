local req = _G.http.get("https://raw.githubusercontent.com/paccao/cctweaked-projects/main/setup/installer.lua")
local file = _G.fs.open('installer.lua', 'w')
file.write(req.close())
file.close()
req.close()
return
