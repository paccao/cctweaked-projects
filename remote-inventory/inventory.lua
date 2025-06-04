local chest = peripheral.find("quark:variant_chest")
if not chest then
	error("No chest found")
end

local items = {}
for slot, item in pairs(chest.list()) do
	if item then
		if not items[item.name] then
			items[item.name] = { count = 0, slots = {} }
		end
		items[item.name].count = items[item.name].count + item.count
		table.insert(items[item.name].slots, slot)
	end
end
print("Items in the chest:")
for name, data in pairs(items) do
	print(name .. ": " .. data.count)
end
