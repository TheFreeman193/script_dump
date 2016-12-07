if SERVER then return end
function AddMaxMinButtons(pnl)
	
	pnl.btnMaxim.DoClick = function(btn)
		local pnl = btn:GetParent()
		if pnl.PreMaxBounds then
			local x,y,w,h = unpack(pnl.PreMaxBounds)
			if pnl.MaxMinAnim then
				pnl:SizeTo(w,h,0.3,0)
				pnl:MoveTo(x,y,0.3,0)
			else
				pnl:SetSize(w,h)
				pnl:SetPos(x,y)
			end
			pnl:SetDraggable(pnl.PreMaxDraggable)
			pnl.PreMaxBounds = nil
		else
			pnl.PreMaxBounds = {pnl:GetBounds()}
			pnl.PreMaxDraggable = pnl:GetDraggable()
			pnl:SetDraggable(false)
			if pnl.MaxMinAnim then
				pnl:SizeTo(ScrW(),ScrH(),0.3,0)
				pnl:MoveTo(0,0,0.3,0)
			else
				pnl:SetSize(ScrW(),ScrH())
				pnl:SetPos(0,0)
			end
		end
	end
	pnl.btnMaxim:SetDisabled(false)
end
