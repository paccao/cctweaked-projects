local sides = { "top", "bottom", "left", "right", "front", "back" }
for _, side in ipairs(sides) do
	if peripheral.getType(side) == "modem" then
		rednet.open(side)
	end
end
local serverID = rednet.lookup("remote_inventory", "inventory_server")

print("Connecting to remote inventory server...")
if not serverID then
	print(
		"Failed to connect to the remote inventory server. Please ensure that the server is running and the modem is connected.")
	return
end

print("Remote inventory helper")
print("What would you like to do?")
print("( 1 ) Get all items in the chests")
print("( 2 / ENTER ) Search chests at home for a specific item")

local answer = read()
if answer == "1" then
	rednet.send(serverID, { action = "GetAllItems", shouldPrint = false, debugMode = false })
	local _, response = rednet.receive()
	local items = textutils.unserialize(response)
	print("Items in the chest:")
	for name, data in pairs(items) do
		print(name .. ": " .. data.count)
	end
elseif answer == "2" or answer == "" then
	print("Enter the item name to search for:")
	local searchTerm = read()
	rednet.send(serverID, { action = "SearchItems", term = searchTerm })
	local _, response = rednet.receive()
	local results = textutils.unserialize(response)
	if #results == 0 then
		print("No items found")
	else
		inventory.ClearScreen()
		for _, item in ipairs(results) do
			print(item.displayName .. ": " .. item.count)
		end
	end
else
	print("Invalid option selected.")
end
