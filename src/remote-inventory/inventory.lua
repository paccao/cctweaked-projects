local inventory = {}

function inventory.GetAllItems()
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
			table.insert(chests, peripheral.wrap(name))
		end
	end

	if #chests == 0 then
		print("No chests found connected to the computer.")
		return
	end

	local items = {}
	local seen = {}

	for _, chest in ipairs(chests) do
		for slot, item in pairs(chest.list()) do
			if item then
				if not seen[item.name] then
					local detail = chest.getItemDetail(slot)
					seen[item.name] = detail and detail.displayName or item.name
				end
				if not items[item.name] then
					items[item.name] = { count = 0, slots = {}, displayName = seen[item.name] }
				end
				items[item.name].count = items[item.name].count + item.count
				table.insert(items[item.name].slots, slot)
			end
		end
	end

	return items
end

function inventory.FuzzySearchItems(items, searchTerm)
	searchTerm = searchTerm:lower()
	local results = {}
	for name, data in pairs(items) do
		if name:lower():find(searchTerm, 1, true) then
			table.insert(results, { name = name, count = data.count, displayName = data.displayName })
		end
	end
	return results
end

return inventory
