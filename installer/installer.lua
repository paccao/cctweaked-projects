local stdin = _G.io.stdin

local mode = stdin('install, update or uninstall? ')
if not mode then
  error('No input provided')
end
if not mode:match('^%s*(install|update|uninstall)%s*$') then
  error('Invalid input, expected "install", "update", or "uninstall"')
end

if mode == 'update' then
  fs.delete('sys')
end

local version = stdin('Choose a version (default is main):')
if not version or version:match('^%s*$') then
  version = 'main'
end

print('Downloading Installer...')

local url = "https://raw.githubusercontent.com/paccao/cctweaked-projects/" .. version .. "/installer/installer.lua"
local req = _G.http.get(url)
if not req then
  error('Failed to download installer')
end

local contents = req.readAll()
if not contents then
  error('Failed to download installer')
end

local fn, msg = load(contents, 'Installer.lua', nil, _ENV)
if not fn then
  error(msg)
else
  local args = { ... }
  fn(args[1])
end
