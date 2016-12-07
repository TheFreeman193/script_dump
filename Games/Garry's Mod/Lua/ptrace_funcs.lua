function _G.ptrace(id)
	return player.GetByID(id||1):GetEyeTrace()
end

function _G.ptent(id)
	return player.GetByID(id||1):GetEyeTrace().Entity || NULL
end

function _G.gply(id)
	return player.GetByID(id||1)
end

local ptab = FindMetaTable"Player"

function ptab:tent()
	return self:GetEyeTrace().Entity
end
