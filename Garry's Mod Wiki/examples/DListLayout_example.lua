if IsValid(TESTP) then TESTP:Remove() end

local frame = vgui.Create("DFrame")
frame:SetSize(250, 250)
frame:SetTitle("DListLayout Example")
frame:MakePopup()
frame:Center()

local layout = vgui.Create("DListLayout", frame)
layout:SetSize(100, 100)
layout:SetPos(20, 50)

//Draw a background so we can see what it's doing
layout:SetDrawBackground(true)
layout:SetBackgroundColor(Color(0, 100, 100))

layout:MakeDroppable("unique_name") -- Allows us to rearrange children

for i = 1, 8 do
	layout:Add(Label(" Label " .. i))
end

TESTP = frame