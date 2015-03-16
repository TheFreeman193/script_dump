local tbl = { two = 2, one = 1, "alpha", "bravo", [3] = "charlie", [5] = "echo", [6] = "foxtrot" }

print( "pairs:" )
for k, v in pairs( tbl ) do
	print( k, v )
end

print( "\nipairs:" )
for k, v in ipairs( tbl ) do
	print( k, v )
end

/*
pairs:
1	alpha
2	bravo
3	charlie
5	echo
6	foxtrot
one	1
two	2

ipairs:
1	alpha
2	bravo
3	charlie
*/