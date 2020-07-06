/* ===============================
<<<<<<<< By TheFreeman193 >>>>>>>>
================================*/

//Console Weapon drop
util.AddNetworkString("plywepdrop")
net.Receive("plywepdrop", function(_, ply) // (len, ply)
	local wep = net.ReadEntity()
	ply:DropWeapon(wep)
	timer.Simple(1, function() if wep and IsValid(wep) then wep:Remove() end end)
end)

//Grass for Material tool
list.Add( "OverrideMaterials", "nature/grassfloor001a")
list.Add( "OverrideMaterials", "nature/grassfloor002a")
list.Add( "OverrideMaterials", "nature/grassfloor003a")


concommand.Add("CleanupForSave", function(ply, _, args)
	for _,v in pairs(ents.FindByClass"prop_dynamic") do v:Remove() end
	for _,v in pairs(ents.FindByClass"prop_door*") do v:Remove() end
end)

local function culo(ply, cmd)
	if ply:IsAdmin() || game.SinglePlayer() then
		ply:GetEyeTrace().Entity:Fire(cmd:Replace("ent_",""))
	end
end
concommand.Add("ent_close", culo)
concommand.Add("ent_unlock", culo)
concommand.Add("ent_lock", culo)
concommand.Add("ent_open", culo)
