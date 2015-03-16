local function test()
	aisj()
end

local function catch( err )
	print( "ERROR: ", err )
end

print( "Output: ", xpcall( test, catch ) )

/*
ERROR: &#09;lua/wiki/xpcall_example.lua:2: attempt to call global 'aisj' (a nil value)
Output:&#09;false &#09;nil
*/