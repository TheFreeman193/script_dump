if IsValid(TESTP) then TESTP:Remove() end

local frame = vgui.Create( "DFrame" )
frame:SetSize(400,400)
frame:SetTitle("Test panel")
frame:Center()
frame:MakePopup()

local lbl = vgui.Create( "DLabelURL", frame )lbl:SetPos(50, 50)lbl:SetSize(100, 50)//lbl:SetColor(Color(255,255,255,255)) 
lbl:SetTextStyleColor(Color(100,255,255,255)) lbl:SetText("I Love Gmod") 
lbl:SetURL("http://wiki.garrysmod.com/")

TESTP=frame
TESTL=lbl
