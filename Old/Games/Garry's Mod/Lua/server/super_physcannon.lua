local SETTINGS = {
	{
		maxmass 	= 50000,
		maxforce 	= 3000,
		pullforce	= 5000,
		tracelength	= 1800,
		chargetime	= 1,
		minforce	= 1000
	},
	{
		maxmass 	= 250,
		maxforce 	= 1500,
		pullforce	= 4000,
		tracelength	= 250,
		chargetime	= 2,
		minforce	= 700
	}
};

if SERVER then
	concommand.Add("physcannon_mega", function(ply, _, args)
		if !ply:IsAdmin() then return end
		if !args[1] then return end
		args[1] = tostring(args[1])
		if args[1] == "1" || args[1] == "enable" || args[1] == "true" then
			if !ply.SPhysCannonEnabled then
				for k,v in pairs(SETTINGS[1]) do
					ply:ConCommand("physcannon_"..k.." "..tostring(v))
				end
				ply.SPhysCannonEnabled = true
				ply:ChatPrint("Super Gravity Gun (Physics Cannon) Enabled")
			end
		elseif args[1] == "0" || args[1] == "disable" || args[1] == "false" then
			if ply.SPhysCannonEnabled then
				for k,v in pairs(SETTINGS[2]) do
					ply:ConCommand("physcannon_"..k.." "..tostring(v))
				end
				ply.SPhysCannonEnabled = false
				ply:ChatPrint("Super Gravity Gun (Physics Cannon) Disabled")
			end
		else return end
	end, function(c, args) return { c.." 0", c.." 1" } end)
end
