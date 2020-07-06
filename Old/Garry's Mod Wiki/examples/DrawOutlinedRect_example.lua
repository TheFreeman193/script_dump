function draw.OutlinedBox( x, y, w, h, thickness, clr )
	surface.SetDrawColor( clr )
	local out = 0
	for i=0, thickness - 1 do
		surface.DrawOutlinedRect( x+i, y+i, w - i * 2, h - i * 2 )
		out = out + 1
	end
end

hook.Remove( "HUDPaint", "193test")
// Usage
local tw,th = ScrW()/2,ScrH()/1.5
local tx,ty = ScrW()/4,ScrH()/3
hook.Add( "HUDPaint", "193test", function()
	//draw.OutlinedBox( tx, ty, tw, th, 8, Color( 0, 180, 180 ) )
	draw.OutlinedBox( 500,500, 150,150, 30, Color( 0, 180, 180 ) )
end )
