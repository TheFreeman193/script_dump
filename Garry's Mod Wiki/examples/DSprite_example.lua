if IsValid(TESTP) then TESTP:Remove() end

local sprite = vgui.Create("DSprite")
sprite:SetMaterial(Material("sprites/sent_ball"))
sprite:SetColor(Color(0, 255, 255))
sprite:Center()
sprite:SetSize(200, 200)

TESTP = sprite
