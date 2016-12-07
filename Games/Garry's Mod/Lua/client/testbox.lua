local cf = vgui.Create"DPanel"
cf:SetVisible(true)
cf:SetSize(ScrW()/5,ScrH()/20)
cf:SetPos(
	ScrW()/2-cf:GetWide()/2,
	ScrH()-cf:GetTall()
)
function cf:Paint()
	local x,y
	x,y = self:ScreenToLocal(0, 0)
	
	surface.SetMaterial(Material"pp/blurx")
	surface.SetDrawColor(Color(255, 255, 255, 5))
	surface.DrawTexturedRect(x, y, ScrW(), ScrH())
	
	x,y = self:GetPos()
	x,y = self:ScreenToLocal(x, y)

	draw.RoundedBox(6, x, y, self:GetWide(), self:GetTall(), Color(0,0,0,200))
	return true
end

timer.Simple(10, cf.Remove, cf)
