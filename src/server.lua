local inventory = require("inventory")

local function formatTimestamp(ts, tzOffset)
	if type(ts) ~= "number" then return tostring(ts) end
	if ts > 1e10 then ts = ts / 1000 end
	tzOffset = tzOffset or 1 -- default to UTC + 1 if not provided
	local hours = ((ts % 86400) / 3600) + tzOffset
	if hours < 0 then hours = hours + 24 end
	if hours >= 24 then hours = hours - 24 end
	return textutils.formatTime(hours, true)
end

-- Server: inventory_server.lua
rednet.open("top") -- or the side your modem is on
rednet.host("remote_inventory", "inventory_server")
print("Server started and listening for requests...")

while true do
	local sender, message = rednet.receive()
	local clientLabel = (type(message) == "table" and message.label) or ("ID " .. tostring(sender))
	local action = (type(message) == "table" and message.action) or "unknown"
	local timestamp = (type(message) == "table" and message.timestamp) or "no timestamp"
	if timestamp then
		print(("Connection from: %s | Action: %s | Timestamp: %s"):format(
			clientLabel, action, formatTimestamp(timestamp, 2)
		))
	end
	if type(message) == "table" and message.action == "GetAllItems" then
		local items = inventory.GetAllItems(false, false)
		rednet.send(sender, textutils.serialize(items))
	elseif type(message) == "table" and message.action == "SearchItems" then
		local items = inventory.GetAllItems(false, false)
		local results = inventory.FuzzySearchItems(items, message.term)
		rednet.send(sender, textutils.serialize(results))
	end
end
