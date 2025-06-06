local function getAllItems(shouldPrint, debugMode)
	local chests = {}

	-- We ignore all peripheral types that are not relevant for inventory management
	local ignoreTypes = {
		modem = true,
		monitor = true,
		speaker = true,
		printer = true,
		drive = true,
		turtle = true,
		computer = true,
		command = true,
		chatBox = true,
		sensor = true,
		energy_storage = true,
		redstoneIntegrator = true,
		playerDetector = true,
		disk_drive = true,
	}

	for _, name in ipairs(peripheral.getNames()) do
		local type = peripheral.getType(name)
		if not ignoreTypes[type] and peripheral.call(name, "list") then
			if debugMode then
				print("Debug: Found peripheral " .. name .. " of type " .. type)
			end
			table.insert(chests, peripheral.wrap(name))
		end
	end

	if #chests == 0 then
		print("No chests found connected to the computer.")
		return
	end

	local items = {}
	for _, chest in ipairs(chests) do
		for slot, item in pairs(chest.list()) do
			if item then
				if not items[item.name] then
					items[item.name] = { count = 0, slots = {} }
				end
				items[item.name].count = items[item.name].count + item.count
				table.insert(items[item.name].slots, slot)
			end
		end
	end

	if shouldPrint then
		print("Items in the chest:")
		print("")
		for name, data in pairs(items) do
			print(name .. ": " .. data.count)
		end
		return
	end
	return items
end

local function fuzzySearchItems(items, searchTerm)
	searchTerm = searchTerm:lower()
	local results = {}
	for name, data in pairs(items) do
		if name:lower():find(searchTerm, 1, true) then
			table.insert(results, { name = name, count = data.count })
		end
	end
	return results
end

local function searchItems()
	print("Enter the item name to search for:")
	local searchTerm = read()
	local items = getAllItems(false, false)
	local results = fuzzySearchItems(items, searchTerm)
	if #results == 0 then
		print("No items found")
		return
	else
		for _, item in ipairs(results) do
			print(item.name .. ": " .. item.count)
		end
	end
end

local function clearScreen()
	term.clear()
	term.setCursorPos(1, 1)
end

local function main()
	print("Remote inventory helper")

	print("What would you like to do? (Write the number or press Enter)")
	print("( 1 ) Get all items in the chests")
	print("( 2 | Enter ) Search chests for a specific item")

	local answer = read()
	if answer == "1" then
		clearScreen()
		getAllItems(true)
	elseif answer == "2" or answer == "" then
		clearScreen()
		searchItems()
	elseif answer == "debug" then
		clearScreen()
		getAllItems(true, true)
	else
		print("Invalid option selected.")
	end
end

main()
