if SERVER then return end

local panel = nil
local function drawpanel()
	panel = vgui.Create"DLabel"
	panel:SetDrawBackground(true)
	panel:SetPaintBackgroundEnabled(true)
	panel:SetTextColor(color_black)
	panel:SetFont"DermaLarge"
	panel:SetText(string.rep(" ",64).."Press Any Key...")
	panel:SetSize(ScrW(),ScrH())
	panel:SetDrawOnTop(true)
	panel:Center()
end
local function killpanel()
	if ispanel(panel) && IsValid(panel) then panel:Remove() end
	panel = nil
end
RunConsoleCommand"cancelselect"
//LocalPlayer():ChatPrint"Press Any Key..."
drawpanel()
input.StartKeyTrapping()
hook.Add("Think", "keytrap_getkeycode", function()
	local code = input.CheckKeyTrapping()
	if code then
		hook.Remove("Think", "keytrap_getkeycode")
		killpanel()
		print("Code for key ("..(input.GetKeyName(code)||"").."): "..code)
		RunConsoleCommand"showconsole"
	end
end)