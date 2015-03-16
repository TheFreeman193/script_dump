local MainCheckbox = vgui.Create('DComboBox', MainFrame)
MainCheckbox:SetSize(221, 221)
MainCheckbox:SetPos(89, 48)
MainCheckbox:CenterHorizontal( )

local Players = player.GetAll()
for i = 1, #Players do
	local plyb = Players[i]
	MainCheckbox:AddChoice( plyb:Nick() )
end 

local LastValue
function MainCheckbox:OnSelect(index, val, data)
	if val == LastValue then return end
	local pl = player.GetAll()
	for i = 1, #pl do
		local ply = pl[i]
		if ply:Nick() == val then
			//Your code for the selected player here.
			
			LastValue = val
		end
	end
end

/*function MainCheckbox:Think()
	if (MainCheckbox:GetSelectedItems() and MainCheckbox:GetSelectedItems()[1]) then
		if (MainCheckbox:GetSelectedItems()[1]:GetValue() ~= LastValue) then
			local Players = player.GetAll()
			for i = 1, table.Count(Players) do
				local ply = Players[i]
				if (MainCheckbox:GetSelectedItems() and MainCheckbox:GetSelectedItems()[1]) then						
					if (ply:Nick() == MainCheckbox:GetSelectedItems()[1]:GetValue()) then
						w,d,h,m,s = timeToStrInd( ply:GetUTime() + CurTime() - ply:GetUTimeStart() )
						CheckWeek:SetValue(w)
						CheckDay:SetValue(d)
						CheckHours:SetValue(h)
						CheckMinutes:SetValue(m)
						CheckSeconds:SetValue(s)
						LastValue = ply:Nick()
					end
				end
			end	
		end
	end
end --function end*/

