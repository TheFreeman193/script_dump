
concommand.Add("physcannon_mega", function(ply, _, args)
	if !args[1] then return end
	args[1] = tostring(args[1])
	if args[1] == "1" || args[1] == "enable" || args[1] == "true" then
		if !ply.SPhysCannonEnabled then
			ply:ConCommand("physcannon_maxforce 99999")
			ply:ConCommand("physcannon_pullforce 99999")
			ply:ConCommand("physcannon_maxmass 100000")
			ply:ConCommand("physcannon_tracelength 12000")
			ply.SPhysCannonEnabled = true
			ply:ChatPrint("Super Gravity Gun (Physics Cannon) Enabled")
		end
	elseif args[1] == "0" || args[1] == "disable" || args[1] == "false" then
		if ply.SPhysCannonEnabled then
			ply:ConCommand("physcannon_maxforce 1500")
			ply:ConCommand("physcannon_pullforce 4000")
			ply:ConCommand("physcannon_maxmass 250")
			ply:ConCommand("physcannon_tracelength 250")
			ply.SPhysCannonEnabled = false
			ply:ChatPrint("Super Gravity Gun (Physics Cannon) Disabled")
		end
	else return end
end, function(c, args) return { c.." 0", c.." 1" } end)


/*
physcannon_maxforce 99999
physcannon_pullforce 99999
physcannon_maxmass 100000
physcannon_tracelength 12000
*/
