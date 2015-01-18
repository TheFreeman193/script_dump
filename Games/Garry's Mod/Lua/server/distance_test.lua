concommand.Add("setvehicle", function(ply)
	local V = ply:GetEyeTrace().Entity
	if !(V && IsValid(V) && IsEntity(V)) then print("You're Looking At Something Invalid!") return end
	Vehicle = V
	print("Vehicle Selected: "..Vehicle:GetClass())
end)

concommand.Add("TestDistance", function(ply)
	if !Vehicle then print("Please select a valid vehicle first!") return end
	print("Position in relation to vehicles center: "..tostring(Vehicle:WorldToLocal(ply:GetPos())))
end)