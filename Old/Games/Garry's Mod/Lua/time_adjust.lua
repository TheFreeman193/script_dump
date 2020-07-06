_G.GCMD = function(cmd)
	if CLIENT then return end
	if !cmd || #cmd < 1 then return end
	game.ConsoleCommand(tostring(cmd).."\n")
end;

_G.GMSG = function(msg)
	if !msg || #msg < 1 then return end
	if SERVER then
		for _, ply in pairs(player.GetAll()) do
			ply:ChatPrint("[GAME] "..tostring(msg))
		end
	elseif CLIENT then
		LocalPlayer():ChatPrint("[GAME] "..tostring(msg))
	end
end;

if SERVER then
	local Locked = false
	local Last
	local modes = {"SlowMotion", "StopMotion", "FastMotion"}
	local function SpeedOperator(ply, com)
		if !ply:IsAdmin() then return false end
		com = (com || ""):lower()
		local mode
		for i=1,#modes do
			mode = com:match(modes[i]:lower().."$")
			if mode then break end
		end
		//local mode = string.match(com:lower(), "slowmotion$") || string.match(com:lower(), "fastmotion$")
		if !mode then return end
		local op = string.Left(com, 1)
		if op == "+" then
			if Locked && mode == Last then
				Locked = false; return
			else
				Locked = ply:KeyDown(IN_SPEED)
				if mode == "slowmotion" then
					GCMD("host_timescale 0.25")
					GMSG("Slow Motion Activated")
				elseif mode == "fastmotion" then
					GCMD("host_timescale 2.5")
					GMSG("Fast Motion Activated")
				elseif mode == "stopmotion" then
					GCMD("host_timescale 0.0000000000000000000000000000001")
					GMSG("Game Stopped")
				end
			end
		elseif op == "-" then
			if !Locked then
				GCMD("host_timescale 1")
				GMSG("Regular Game Speed Resumed")
			end
		else return end
		Last = mode
	end;
	for i=1,#modes do
		concommand.Add("+"..modes[i],SpeedOperator)
		concommand.Add("-"..modes[i],SpeedOperator)
	end
end;
