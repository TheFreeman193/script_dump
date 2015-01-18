if IsValid(TESTP) then TESTP:Remove() end

local frame = vgui.Create("DFrame")
frame:SetSize(200,200)
frame:Center()
frame:SetTitle("DKillIcon Example")

local icon = vgui.Create("DKillIcon", frame)
icon:SetName("weapon_crowbar")
icon:SizeToContents()
icon:Center()

TESTP=frame
TESTI=icon