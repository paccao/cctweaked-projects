local stdin = _G.io.stdin

local mode = stdin('install, update or uninstall? ')
if not mode then
  error('No input provided')
end
if not mode:match('^%s*(install|update|uninstall)%s*$') then
  error('Invalid input, expected "install", "update", or "uninstall"')
end

if mode == 'update' or mode == 'uninstall' then
  fs.delete('cctweaked-projects')
end

if mode == 'uninstall' then
  return print('Uninstalled cctweaked-projects')
end

local version = stdin('Choose a version (default is main):')
if not version or version:match('^%s*$') then
  version = 'main'
end

print('Downloading Installer...')

local url = "https://raw.githubusercontent.com/paccao/cctweaked-projects/" ..
    version .. "/remote-inventory/"
local req = _G.http.get(url)
if not req then
  error('Failed to download installer')
end

local contents = req.readAll()
if not contents then
  error('Failed to download installer')
end

print('printing contents...')
print(contents)
req.close()
print('Writing to disk...')
local folder = _G.fs.open('cctweaked-projects', 'w')
if not folder then
  error('Failed to open cctweaked-projects for writing')
end
folder.write(contents)
folder.close()
print('Done!')
