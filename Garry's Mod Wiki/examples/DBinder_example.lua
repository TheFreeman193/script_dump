if IsValid(TESTP) && ispanel(TESTP) then TESTP:Remove() end

local frame = vgui.Create("DFrame")
frame:SetSize(250,100)
frame:Center()
frame:SetTitle("DBinder Example")
frame:MakePopup()

local binder = vgui.Create( "DBinder", frame )
binder:SetSize( 200, 50 )
binder:SetPos( 25, 35 )

function binder:SetSelectedNumber( num )
	self.m_iSelectedNumber = num -- Preserve original functionality
	LocalPlayer():ChatPrint("New bound key: "..input.GetKeyName( num ))
end

TESTP = frame
TESTB = binder
