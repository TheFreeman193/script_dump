local total = 0
local trials = 100
for i = 0, trials do
	local _clock=os.clock()
	local ops=0
	local value=39
	repeat
		value=value/(1.999999999+value) 
		ops=ops+1 
		//if ops % 262144 ==0 then print(value) end
	until (value==0||ops>=131072)
	local nt = os.clock()-_clock
	total = total + nt
	print("Took "..tostring(nt).. " seconds and "..tostring(ops).." operations.")
end
print("Average time: "..total/trials.. " seconds.")
print("Total time: "..total.. " seconds.")