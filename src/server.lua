local inventory = require("inventory")

-- Server: inventory_server.lua
rednet.open("top") -- or the side your modem is on
rednet.host("remote_inventory", "inventory_server")
print("Server started and listening for requests...")

while true do
	local sender, message = rednet.receive()
	local clientLabel = (type(message) == "table" and message.label) or ("ID " .. tostring(sender))
	local action = (type(message) == "table" and message.action) or "unknown"
	local timestamp = (type(message) == "table" and message.timestamp) or "no timestamp"
	print(("Connection from: %s | Action: %s | Timestamp: %s"):format(clientLabel, action, tostring(timestamp)))
	if type(message) == "table" and message.action == "GetAllItems" then
		local items = inventory.GetAllItems(false, false)
		rednet.send(sender, textutils.serialize(items))
	elseif type(message) == "table" and message.action == "SearchItems" then
		local items = inventory.GetAllItems(false, false)
		local results = inventory.FuzzySearchItems(items, message.term)
		rednet.send(sender, textutils.serialize(results))
	end
end
