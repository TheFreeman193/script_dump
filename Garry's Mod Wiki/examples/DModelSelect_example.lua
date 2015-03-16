if IsValid(TESTP) && ispanel(TESTP) then TESTP:Remove() end

-- Create a table of models
local models = {
	["models/props_c17/oildrum001_explosive.mdl"] = {}, 
	["models/props_c17/oildrum001.mdl"] = {}, 
	["models/props_junk/TrafficCone001a.mdl"] = {},
	["models/props_c17/gravestone004a.mdl"] = {}
}
	
local frame = vgui.Create("DFrame")
frame:SetSize(220, 220)
frame:SetTitle("DModelSelect Example")
frame:MakePopup()
frame:Center()

local mselect = vgui.Create( "DModelSelect", frame ) 
mselect:SetModelList( models, "", false, true )
mselect:SetSize(150, 150)
mselect:Center()

TESTP = frame
TESTS = mselect