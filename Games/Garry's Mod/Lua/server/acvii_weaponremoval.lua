if SERVER then
	function ACVII_CleanupWeapons(ply,_,args)
		for _, v in pairs(ents.GetAll()) do
			if v:IsWeapon() then
				local CanDelete = true
				for _, Cply in pairs(player.GetAll()) do
					if v:GetPos() == Cply:GetPos() then
						CanDelete = nil
					end
				end
				if CanDelete then v:Remove() end
				CanDelete = nil
			end
		end
		timer.Simple(0.5, function()
			ply:PrintMessage(HUD_PRINTCONSOLE, "ACVII: All Weapons Cleaned Up\n")
			ply:ConCommand('acvii_sendsound "buttons/blip1.wav"')
			ply:ConCommand('acvii_notify "All Weapons Cleaned Up" CLEANUP 8')
		end)
	end
	//concommand.Add("CleanupWeapons", ACVII_CleanupWeapons)
end