local inventory = require("inventory")

-- Server: inventory_server.lua
rednet.open("top") -- or the side your modem is on
rednet.host("remote_inventory", "inventory_server")
print("Server started and listening for requests...")

while true do
	local sender, message = rednet.receive()
	if type(message) == "table" and message.action == "GetAllItems" then
		local items = inventory.GetAllItems(false, false)
		rednet.send(sender, textutils.serialize(items))
	elseif type(message) == "table" and message.action == "SearchItems" then
		local items = inventory.GetAllItems(false, false)
		local results = inventory.FuzzySearchItems(items, message.term)
		rednet.send(sender, textutils.serialize(results))
	end
end
