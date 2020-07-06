/* ===============================
<<<<<<<< By TheFreeman193 >>>>>>>>
================================*/

concommand.Add("dropweapon", function(ply, _, args)
	if !IsValid(ply) then return end
	if !ply:IsAdmin() then return end
	local wep
	if args[1] then
		for _, w in pairs(ply:GetWeapons()) do
			if w:GetClass() == args[1] then wep = w end
		end
	else wep = ply:GetActiveWeapon()
	end
	net.Start("plywepdrop")
		net.WriteEntity(wep)
	net.SendToServer()
end)
