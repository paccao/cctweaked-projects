local function getAllItems(shouldPrint)
	local chests = {}

	for _, name in ipairs(peripheral.getNames()) do
		local type = peripheral.getType(name)
		if peripheral.call(name, "list") then
			print("Found inventory peripheral: " .. name .. " (type: " .. type .. ")")
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
		local displayName = data.displayName or ""
		if name:lower():find(searchTerm, 1, true) or displayName:lower():find(searchTerm, 1, true) then
			table.insert(results, { name = name, displayName = displayName, count = data.count })
		end
	end
	return results
end

local function searchItems()
	print("Enter the item name to search for:")
	local searchTerm = read()
	local items = getAllItems(false)
	local results = fuzzySearchItems(items, searchTerm)
	if #results == 0 then
		print("No items found")
		return
	else
		for _, item in ipairs(results) do
			print((item.displayName ~= "" and item.displayName or item.name) .. ": " .. item.count)
		end
	end
end

local function main()
	print("Remote inventory helper")

	print("What would you like to do?")
	print("1. Get all items in the chests")
	print("2. Search chests for a specific item")

	local answer = read()
	if answer == "1" then
		getAllItems(true)
	elseif answer == "2" then
		searchItems()
	end
end

main()
