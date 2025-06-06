local function clearScreen()
	term.clear()
	term.setCursorPos(1, 1)
end

local function pagedPrint(items, formatFunc, pageSize)
	pageSize = pageSize or 15
	local i = 1
	while i <= #items do
		term.clear()
		term.setCursorPos(1, 1)
		for j = 0, pageSize - 1 do
			if i + j > #items then break end
			print(formatFunc(items[i + j]))
		end
		if i + pageSize > #items then
			print("\nEnd of list. Press any key to return.")
			os.pullEvent("key")
			break
		else
			print("\nPress any key for next page...")
			os.pullEvent("key")
			i = i + pageSize
		end
	end
end

local sides = { "top", "bottom", "left", "right", "front", "back" }
for _, side in ipairs(sides) do
	if peripheral.getType(side) == "modem" then
		rednet.open(side)
	end
end
local serverID = rednet.lookup("remote_inventory", "inventory_server")

if not serverID then
	error(
		"Failed to connect to the remote inventory server. Please ensure that the server is running and the modem is connected.")
	return
end

print("Remote inventory helper")

while true do
	print("What would you like to do?")
	print("( 1 ) Get all items in the chests")
	print("( 2 / ENTER ) Search chests at home for a specific item")

	local itemList = {}
	local answer = read()
	local label = os.getComputerLabel() or tostring(os.getComputerID())
	local timestamp = os.epoch and os.epoch("utc") or os.time() -- fallback if os.epoch not available

	if answer == "1" then
		rednet.send(serverID, {
			action = "GetAllItems",
			label = label,
			timestamp = timestamp
		})
		local _, response = rednet.receive()
		local items = textutils.unserialize(response)

		if #items == 0 then
			print("No items found")
		else
			clearScreen()
			for _, item in pairs(items) do
				table.insert(itemList, item)
			end
			pagedPrint(itemList, function(item) return (item.displayName or item.name) .. ": " .. item.count end)
		end
	elseif answer == "2" or answer == "" then
		print("Enter the item name to search for:")
		local searchTerm = read()
		rednet.send(serverID, {
			action = "SearchItems",
			term = searchTerm,
			label = label,
			timestamp = timestamp
		})
		local _, response = rednet.receive()
		local items = textutils.unserialize(response)

		if #items == 0 then
			print("No items found")
		else
			clearScreen()
			for _, item in pairs(items) do
				table.insert(itemList, item)
			end
			pagedPrint(itemList, function(item) return (item.displayName or item.name) .. ": " .. item.count end)
		end
	else
		print("Invalid option selected.")
	end
	print("")
	print("Press any key...")
	read()
	clearScreen()
end
