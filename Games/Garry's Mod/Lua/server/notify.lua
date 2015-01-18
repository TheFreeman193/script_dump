//if NotifyMessage then NotifyMessage = nil end
function NotifyMessage(ply, _, args)
	if !args[1] then MsgN("No Message Specified\n"..[[
---------------------------------------------------------------------
	Messages are:
	generic		--		Generic Notification
	error		--		Error Notification
	undo		--		Object Undo Notification
	cleanup		--		Object Cleanup Notification
	hint		--		Game Hint Notification
---------------------------------------------------------------------
]]) return end
	local NtF = tostring(args[1])
	if NtF == "generic" then
		ply:SendLua('GAMEMODE:AddNotify("Generic", NOTIFY_GENERIC, 5) end')
	elseif NtF == "error" then
		ply:SendLua('GAMEMODE:AddNotify("Error", NOTIFY_ERROR, 5)')
	elseif NtF == "undo" then
		ply:SendLua('GAMEMODE:AddNotify("Undo", NOTIFY_UNDO, 5)')
	elseif NtF == "cleanup" then
		ply:SendLua('GAMEMODE:AddNotify("Cleanup", NOTIFY_CLEANUP, 5)')
	elseif NtF == "hint" then
		ply:SendLua('GAMEMODE:AddNotify("Hint", NOTIFY_HINT, 5)')
	else return end
	NtF = nil
	//timer.Simple(3, function() gamemode:AddNotify("DONE!", NOTIFY_GENERIC, 1)
end
//concommand.Remove("notify_msg")
concommand.Add("notify_msg", NotifyMessage)

function SendMessageToPlayers(ply, _, args)
	if ply:EntIndex() != 1 then return false end
	if args[1] && (args[1] == "?" || args[1] == "") then
		ply:PrintMessage(HUD_PRINTCONSOLE, '\nPLAYER_SENDMSG USAGE:\n\t<TARGET\'S ENT INDEX> <"MESSAGE"> <"MESSAGE TYPE"> <TIMEOUT (NOTIFY)>')
	return end
	if !args[1] || !args[2] || !args[3] then return end
	//args1 = target player's Ent Index
	//args2 = message
	//args3 = message type
	//args4 = timeout (ADDNOTIFY ONLY)
	local TgtPly = player.GetByID(args[1])
	if !TgtPly:IsValid() then return elseif !TgtPly:IsPlayer() then return end
	local Message = args[2]
	local MType = args[3]
	if MType == "NOTIFY_GENERIC" || MType == "HUD_PRINTCENTER" || MType == "HUD_PRINTTALK" || MType == "HUD_PRINTCONSOLE" || MType == "NOTIFY_HINT" || MType == "NOTIFY_UNDO" || MType == "NOTIFY_ERROR" || MType == "NOTIFY_CLEANUP" then else return end
	if string.Left(MType,4) == "HUD_" then
		TgtPly:SendLua('player.GetByID('..TgtPly:EntIndex()..'):PrintMessage('..MType..', "'..Message..'")')
	elseif string.Left(MType,7) == "NOTIFY_" then
		if !args[4] then return end
		local TimeOut = args[4]
		TimeOut = tonumber(TimeOut)
		TgtPly:SendLua('GAMEMODE:AddNotify("'..Message..'", '..MType..', '..TimeOut..')')
	else return end
end
concommand.Add("player_sendmsg", SendMessageToPlayers)
