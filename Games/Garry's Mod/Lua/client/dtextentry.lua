local ParentPanel = vgui.Create("DFrame")
	ParentPanel:SetSize(ScrW()/7, ScrH()/12)
	ParentPanel:Center()
	ParentPanel:SetTitle("ConVarChanged Test")
	ParentPanel:SetDeleteOnClose(true)
	ParentPanel:MakePopup()
 
local TextEntry = vgui.Create( "DTextEntry", ParentPanel )
	TextEntry:SetSize(ScrW()/9, ScrH()/30)
	TextEntry:SetValue("OnGetFocus Test")
	TextEntry:SetPos(ParentPanel:GetWide()/2-TextEntry:GetWide()/2,
	ParentPanel:GetTall()/2-TextEntry:GetTall()/5)
	TextEntry:SetEnterAllowed(true)
	TextEntry:SetConVar("some_console_variable") -- Console variable should exist already
	TextEntry.ConVarChanged = function(TextEntryObject, NewValue)
		LocalPlayer():ChatPrint("ConVar value changed to: "..NewValue)
	end
