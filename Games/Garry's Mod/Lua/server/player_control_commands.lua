/*----------------------------------------- Player Control ----------------------------------------------
¦									  Developed By TheFreeman193 (2011)								  		¦
¦									Email: thefreeman193@aol.co.uk										¦
-------------------------------------------------------------------------------------------------------*/

local ScriptLoading	= true
local IsSAdmin	= true

concommand.Add("player_control_help", function(ply, _, args)
	print("Player Control Adds Useful Console Commands That Aren't Usually Included In Garry's Mod."..
	"\n\nThese Are:\n\twalkspeed: Walk Speed - Normal Walking Speed - Default Is 250\n\trunspeed: Run Speed - Speed When You Sprint (Usually Shift Key) - Default Is 500"..
	"\n\tjumppower: Jump Power - The Upward Velocity (Speed) When You Jump - Default Is 160\n\thealth: Health - Does This Really Need Explaining? - Default Is 100 (Just In Case You Forgot)"..
	"\n\tduckspeed: Duck Speed - How Long It Takes The Player To Duck/Crouch (In Seconds) - Default Is 0.3"..
	"\n\tunduckspeed: Un-Duck Speed - How Long It Takes To Stand Up After Ducking/Crouching - Default Is 0.2"..
	"\n\tplayer_control_help: This Help Message\n\tplayer_control_reset: Reset Player Settings To Defaults.")
	ply:ChatPrint("Player Control Help/Instruction Have Been Printed In Console")
end)

local function GetVal(com)
	if ScriptLoading then return end
	if !com then return "" end
	com = string.lower(tostring(com))
	if string.Left(com, 6) == "player" then
		com = string.gsub(com, "player_", "")	
	end
	if com == "health" then
		return "100"
	elseif com == "runspeed" then
		return "500"
	elseif com == "walkspeed" then
		return "250"
	elseif com == "jumppower" then
		return "160"
	elseif com == "duckspeed" then
		return "0.30000001192093"
	elseif com == "unduckspeed" then
		return "0.20000000298023"
	else return "" end
end

local function VValue(cmd, args)
	if ScriptLoading then return end
	return { cmd.." "..GetVal(cmd) }
end

local function RSpeed(ply, _, args)
	if ScriptLoading then return end
	if !IsSAdmin && tobool(GetConVarNumber("player_control_adminonly")) then ply:ChatPrint("You can only use this if you're in Singleplayer or the host of a Multiplayer server") return end
	if !args[1] then /*ply:ChatPrint("Please Enter A Value!")*/ ply:PrintMessage(2, "Run Speed: "..ply:GetRunSpeed()) return false end
	ply:SetRunSpeed(tonumber(args[1]))
	ply:ChatPrint("Run Speed Changed To "..tostring(args[1]))
end
concommand.Add("player_runspeed", RSpeed, VValue)
concommand.Add("runspeed", RSpeed, VValue)

local function WSpeed(ply, _, args)
	if ScriptLoading then return end
	if !IsSAdmin && tobool(GetConVarNumber("player_control_adminonly")) then ply:ChatPrint("You can only use this if you're in Singleplayer or the host of a Multiplayer server") return end
	if !args[1] then /*ply:ChatPrint("Please Enter A Value!")*/ ply:PrintMessage(2, "Walk Speed: "..ply:GetWalkSpeed()) return false end
	ply:SetWalkSpeed(tonumber(args[1]))
	ply:ChatPrint("Walk Speed Changed To "..tostring(args[1]))
end
concommand.Add("player_walkspeed", WSpeed, VValue)
concommand.Add("walkspeed", WSpeed, VValue)


local function JPower(ply, _, args)
	if ScriptLoading then return end
	if !IsSAdmin && tobool(GetConVarNumber("player_control_adminonly")) then ply:ChatPrint("You can only use this if you're in Singleplayer or the host of a Multiplayer server") return end
	if !args[1] then /*ply:ChatPrint("Please Enter A Value!")*/ ply:PrintMessage(2, "Jump Power: "..ply:GetJumpPower()) return false end
	ply:SetJumpPower(tonumber(args[1]))
	ply:ChatPrint("Jump Power Changed To "..tostring(args[1]))
end
concommand.Add("player_jumppower", JPower, VValue)
concommand.Add("jumppower", JPower, VValue)

local function PHealth(ply, _, args)
	if ScriptLoading then return end
	if !IsSAdmin && tobool(GetConVarNumber("player_control_adminonly")) then ply:ChatPrint("You can only use this if you're in Singleplayer or the host of a Multiplayer server") return end
	if !args[1] then /*ply:ChatPrint("Please Enter A Value!")*/ ply:PrintMessage(2, "Health: "..ply:Health()) return false end
	ply:SetHealth(tonumber(args[1]))
	ply:ChatPrint("Health Changed To "..tostring(args[1]))
end
concommand.Add("player_health", PHealth, VValue)
concommand.Add("health", PHealth, VValue)

local function DSpeed(ply, _, args)
	if ScriptLoading then return end
	if !IsSAdmin && tobool(GetConVarNumber("player_control_adminonly")) then ply:ChatPrint("You can only use this if you're in Singleplayer or the host of a Multiplayer server") return end
	if !args[1] then /*ply:ChatPrint("Please Enter A Value!")*/ ply:PrintMessage(2, "Duck Speed: "..ply:GetDuckSpeed()) return false end
	ply:SetDuckSpeed(tonumber(args[1]))
	ply:ChatPrint("Duck Speed Changed To "..tostring(args[1]))
end
concommand.Add("player_duckspeed", DSpeed, VValue)
concommand.Add("duckspeed", DSpeed, VValue)

local function UDSpeed(ply, _, args)
	if ScriptLoading then return end
	if !IsSAdmin && tobool(GetConVarNumber("player_control_adminonly")) then ply:ChatPrint("You can only use this if you're in Singleplayer or the host of a Multiplayer server") return end
	if !args[1] then /*ply:ChatPrint("Please Enter A Value!")*/ ply:PrintMessage(2, "Un-duck Speed: "..ply:GetUnDuckSpeed()) return false end
	ply:SetUnDuckSpeed(tonumber(args[1]))
	ply:ChatPrint("Un-Duck (Stand Up) Speed Changed To "..tostring(args[1]))
end
concommand.Add("player_unduckspeed", UDSpeed, VValue)
concommand.Add("unduckspeed", UDSpeed, VValue)

concommand.Add("player_control_reset", function(ply, _, args)
	if ScriptLoading then return end
	if !IsSAdmin && tobool(GetConVarNumber("player_control_adminonly")) then ply:ChatPrint("You can only use this if you're in Singleplayer or the host of a Multiplayer server") return end
	ply:SetRunSpeed(500)
	ply:SetWalkSpeed(250)
	ply:SetJumpPower(160)
	ply:SetDuckSpeed(0.30000001192093)
	ply:SetUnDuckSpeed(0.20000000298023)
	ply:ChatPrint("Player Settings Reset")
end)

local function ShowFirstTimeMessage(ply)
	if ScriptLoading then return end
	file.Write("player_control_data.txt", "\"Data\"\n{\n\t\"DisableMessage\"\t\"1\"\n}", "DATA")
	ply:SendLua('notification.AddLegacy("Player Control Installed.       |||", _, 5)')
	ply:SendLua('timer.Simple(2, notification.AddLegacy, "Type player_control_help Into The Developer Console For More Info       |||", _, 10)')
end

hook.Add("PlayerSpawn", "player_control_playerspawn", function(ply)
	if ScriptLoading then
		ScriptLoading = nil
		if !game.SinglePlayer() && ply:EntIndex() != 1 then IsSAdmin = nil end
		if game.SinglePlayer() || (!game.SinglePlayer() && ply:EntIndex() == 1) then
			ply:SendLua('CreateClientConVar("player_control_adminonly", 1)')
		end
		if file.Exists("player_control_data.txt", "DATA") then
			local Data = util.KeyValuesToTable(file.Read("player_control_data.txt", "DATA"))
			if tonumber(Data.disablemessage) != 1 then
				ShowFirstTimeMessage(ply)
			end
		else ShowFirstTimeMessage(ply) end
	else return end
end)