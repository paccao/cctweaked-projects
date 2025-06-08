local function downloadAndInstall(name, files)
  for _, name in ipairs(files) do
    local url = "https://raw.githubusercontent.com/paccao/cctweaked-projects/main/src/" .. name
    local req = _G.http.get(url)
    if req then
      local h = _G.fs.open(name, "w")
      h.write(req.readAll())
      h.close()
      req.close()
    else
      print("Failed to download " .. name)
    end
  end
end

local function getCurrentDir()
  local dir = shell.dir()
  if dir == "." then
    return ""
  else
    return dir
  end
end

local treeFarmFiles = {
  "turtle.lua",
}

local remoteInventoryFiles = {
  "inventory.lua",
  "client.lua",
  "server.lua",
}

local options = {
  'remote-inventory',
  'tree-farm'
}

local function clearScreen()
  term.clear()
  term.setCursorPos(1, 1)
end


print('Choose an option (install | update | uninstall)')
local mode = read()

if not mode then
  error('No input provided')
end

if mode ~= 'install' and mode ~= 'update' and mode ~= 'uninstall' then
  error('Invalid input, expected "install", "update", or "uninstall"')
end

local currentDir = getCurrentDir()
shell.setDir("")

if mode == 'update' or mode == 'uninstall' then
  for _i, option in ipairs(options) do
    fs.delete(option)
  end
end

if mode == 'uninstall' then
  return print('Uninstalled remote')
end

while true do
  clearScreen()
  print('What do you want to install?')

  print('0. Download all apps')
  for i, option in ipairs(options) do
    print(i + 1 .. '. ' .. option)
  end
  local choice

  local input = read()
  if not input then
    print('No input provided, please try again.')
  else
    choice = tonumber(input)
    if choice and choice >= 0 and choice <= #options + 1 then
      break
    else
      print('Invalid choice, please enter a number between 0 and ' .. (#options + 1))
    end
  end
end

if choice == 0 then
  print('Downloading all apps...')

  downloadAndInstall('remote-inventory', remoteInventoryFiles)
  downloadAndInstall('tree-farm', treeFarmFiles)
else
  local selectedApp = options[choice - 1]
  print('Downloading ' .. selectedApp .. '...')
  local files
  if selectedApp == 'remote-inventory' then
    files = remoteInventoryFiles
  elseif selectedApp == 'tree-farm' then
    files = treeFarmFiles
  else
    error('Unknown app: ' .. selectedApp)
  end
  downloadAndInstall(selectedApp, files)
end

if currentDir == "" or fs.exists(currentDir) then
  shell.setDir(currentDir)
else
  print("Warning: Original directory '" .. currentDir .. "' no longer exists. Returning to root.")
  shell.setDir("")
end
