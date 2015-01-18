if SERVER then ErrorNoHalt"Client-only script!" return end
local adds = util.JSONToTable(file.Read("steamworks_vote.txt","DATA")||'{}')
local len = table.Count(adds)
local pos = 0
function steamworks.loopvotes()
	pos = pos + 1
	if pos > len then MsgN(string.rep("=",50).."\n") timer.Simple(0.1, function() steamworks.loopvotes=nil end) return end
	local k,v = unpack(adds[pos])
	if k&&v then 
		if pos == 1 then MsgN("\n\n======== Steam Workshop Votes ("..tostring(len).." addons) =========\n") end
		steamworks.VoteInfo(tostring(v), function(res) MsgN((k||"")..":") PrintTable(res,1) steamworks.loopvotes() end)
	end
end
steamworks.loopvotes()