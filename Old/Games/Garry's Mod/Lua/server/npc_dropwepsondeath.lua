CreateConVar("npc_allow_weapon_drop", 1, { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED })

hook.Add("OnNPCKilled", "RemoveWeaponsFromNPC", function(KilledNPC)
    if tobool(GetConVarNumber("npc_allow_weapon_drop")) then return end
    for _, W in pairs(ents.GetAll()) do
        if (W:IsWeapon() || string.find(W:GetClass(), "item_ammo_")) && W:GetOwner() == KilledNPC then
            W:Remove()
        end
    end
end)
