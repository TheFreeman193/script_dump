if IsValid(TESTP) && ispanel(TESTP) then TESTP:Remove() end

local button = vgui.Create( "DButton" )
button:SetSize( 100, 35 )
button:SetText( "Say your nickname" )
button:Center()
button:MakePopup()
button:SetConsoleCommand( "say", LocalPlayer():Nick() )

TESTP = button
