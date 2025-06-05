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

print("Items in the chest:")
for name, data in pairs(items) do
	print(name .. ": " .. data.count)
end
