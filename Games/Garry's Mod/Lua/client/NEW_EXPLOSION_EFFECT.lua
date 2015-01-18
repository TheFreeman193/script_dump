if !ConVarExists("alternative_explosion") then CreateConVar("alternative_explosion", "1") end
function Splode()
	if !(ConVarExists("alternative_explosion") && tobool(GetConVarNumber("alternative_explosion"))) then return end
	local explode = ents.FindByClass("env_explosion")
	for k,v in pairs( explode ) do
		if( v:IsValid() ) then
			local Pos = v:LocalToWorld( v:OBBCenter( ) )
			ParticleEffect("dusty_explosion_rockets", Pos, Angle(0,0,0), nil)
			v:Remove()
		end
	end
end

hook.Add("Think", "Splode", Splode)