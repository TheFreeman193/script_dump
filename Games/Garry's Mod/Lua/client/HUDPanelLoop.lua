
local function LoopChildren(pnl)
	if pnl.ClassName && pnl.ClassName:lower():find("ki") then print(pnl.ClassName) end
	local tab = pnl.GetChildren && pnl:GetChildren() || false
	if !tab || table.Count(tab)<1 then return end
	for _,v in pairs(tab) do
		LoopChildren(v)
	end
end
LoopChildren(vgui.GetWorldPanel())
LoopChildren(GetHUDPanel())
