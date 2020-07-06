TESTPANEL = vgui.Create("DFrame")
TESTPANEL:SetPos( 0, 0 )
TESTPANEL:SetSize( 500,500 )

TestRulesTab = vgui.Create( "DPanelList", TESTPANEL)
TestRulesTab:Dock(FILL)
TestRulesTab:SetSpacing( 5 )
TestRulesTab:EnableHorizontal( false )
TestRulesTab:EnableVerticalScrollbar( true )

local TestDSPanel = vgui.Create('DScrollPanel', TestRulesTab)
TestDSPanel:Dock(FILL)

TESTPANEL:MakePopup()
