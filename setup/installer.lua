print('Choose an option (install | update | uninstall)')

local mode = read()
if not mode then
  error('No input provided')
end
if mode ~= 'install' and mode ~= 'update' and mode ~= 'uninstall' then
  error('Invalid input, expected "install", "update", or "uninstall"')
end

if mode == 'update' or mode == 'uninstall' then
  fs.delete('cctweaked-projects')
end

if mode == 'uninstall' then
  return print('Uninstalled cctweaked-projects')
end

print('Downloading Installer...')

local files = {
  "inventory.lua",
}

for _, name in ipairs(files) do
  local url = "https://raw.githubusercontent.com/paccao/cctweaked-projects/main/remote-inventory/" .. name
  local req = _G.http.get(url)
  if req then
    local h = _G.fs.open("cctweaked-projects/" .. name, "w")
    h.write(req.readAll())
    h.close()
    req.close()
  else
    print("Failed to download " .. name)
  end
end
