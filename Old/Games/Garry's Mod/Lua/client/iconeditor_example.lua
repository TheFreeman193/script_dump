local frame = vgui.Create( "DFrame" ) -- Container for the SpawnIcon
frame:SetPos( 100, 200 )
frame:SetSize( 200, 200 )
frame:SetTitle( "Icon Editor Example" )
frame:MakePopup()

local icon = vgui.Create( "SpawnIcon" , frame ) -- SpawnIcon, with blue barrel model
icon:Center()
-- It is important below to include the SkinID (0 = default skin); the IconEditor will not work otherwise
icon:SetModel( "models/props_borealis/bluebarrel001.mdl", 0 )

local editor = vgui.Create( "IconEditor" ) -- Create IconEditor
editor:SetIcon( icon ) -- Set the SpawnIcon to modify
editor:Refresh() -- Sets up the DAdjustableModelPanel and internal SpawnIcon
editor:MakePopup()
editor:Center()
