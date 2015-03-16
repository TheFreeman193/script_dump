if ispanel(TESTP) && IsValid(TESTP) then TESTP:Remove() end

local frame = vgui.Create( "DFrame" )
frame:SetSize( 500, 250 )
frame:SetSizable( true )
frame:Center()
frame:MakePopup()
frame:SetTitle( "DFileBrowser Example" )

local browser = vgui.Create( "DFileBrowser", frame )
browser:Dock(FILL)
browser:SetName( "models" ) -- Name to display in tree
browser:SetModels( true ) -- Use SpawnIcons instead of buttons
browser:SetPath( "models" ) -- Directory to use
browser:SetFiles( "*.mdl" ) -- File type filter

function browser:OnSelect(path, icon) -- Called when a SpawnIcon/Button is clicked
	RunConsoleCommand("gm_spawn", path) -- Spawn the model we clicked
	frame:Close()
end

TESTP = frame
TESTB = browser