local T, C, L, G = unpack( Tukui )


local string = string
local gsub = string.gsub
local strsub = string.sub
local strfind = string.find
local format = string.format
local strlower = string.lower
local Wrapper = "|cff00AAFF[%s]|r"
local WordList = {string.lower(T.myname)	}

-- Finding the word in a URL breaks the hyperlink, so check & exclude them
local FindURL = function(msg)
	local String, Found = gsub(msg, "(%a+)://(%S+)%s?", "%1://%2")
	if Found > 0 then return String end

	String, Found = gsub(msg, "www%.([_A-Za-z0-9-]+)%.(%S+)%s?", "www.%1.%2")
	if Found > 0 then return String end

	String, Found = gsub(msg, "([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", "%1@%2%3%4")
	if Found > 0 then return String end
end

local WordFilter = function(self, event, message, author, ...)
	local msg = strlower(message)

	for i = 1, #WordList do
		if strfind(msg, WordList[i]) then
			local Word = strsub(message, strfind(msg, WordList[i]))
			local Link = FindURL(message)

			if (not Link) or (Link and not strfind(Link, Word)) then
				return false, gsub(message, Word, format(Wrapper, Word)), author, ...
			end
		end
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", WordFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", WordFilter)

ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", WordFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", WordFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", WordFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", WordFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", WordFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", WordFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", WordFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND_LEADER", WordFilter)