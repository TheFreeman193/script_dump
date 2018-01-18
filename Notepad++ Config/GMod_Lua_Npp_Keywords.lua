-- outputs functions and keywords in Notepad++ xml format
-- updated by TheFreeman193 Jan 2018
-- original at https://sourceforge.net/projects/npp-plugins

local __a,__b,__c=debug.gethook()
debug.sethook()

local oldprint=print
local function print(...)
	oldprint("[Notepad++ Keywords] ",...)
end

local output = {}

output.libraries = {}
output.libraryMethods = {}

output.objectMethods = {}

output.globalMethods = {}

output.constants = {}

output.flags = {}

output.scriptedFunctions = {}
output.scriptedVariables = {}

local _started

if (SERVER) then
	if file.Exists("npp_gmod_cl.txt","DATA") then
		_started = file.Read("npp_gmod_cl.txt","DATA")
		file.Delete("npp_gmod_cl.txt")
	end
else
	if file.Exists("npp_gmod_sv.txt","DATA") then
		_started = file.Read("npp_gmod_sv.txt","DATA")
		file.Delete("npp_gmod_sv.txt")
	end
end

if _started then
	for _, v in pairs(string.Explode("`", _started)) do
		local all = string.Explode("~", v)

		for _,g in pairs(string.Explode("%", all[2])) do
			table.insert(output[all[1]], g)
		end
	end
end

local function GetFunctions(tab)
	local functions = {}
	local const = {}

	for k, v in pairs(tab) do
		if (type(v) == "function") then
			table.insert(functions, tostring(k))
		elseif (type(v) == "string") then
			table.insert(const, tostring(k))
		end
	end

	--table.sort(functions)
	return functions, const
end

local Ignores = { "mathx", "stringx", "_G", "_R", "_E", "GAMEMODE", "g_SBoxObjects", "tablex", "color_black",
				  "color_white", "color_transparent", "utilx", "_LOADLIB", "_LOADED", "func", "DOF_Ents",
				  "Morph", "_ENT" }

if CLIENT then
	local dermaControls = {}

	for _,v in pairs(derma.GetControlList()) do
		table.insert(dermaControls, v.ClassName)
		--table.insert(Ignores, v.ClassName)
	end

	for _,k in pairs(dermaControls) do
		for _,method in pairs(GetFunctions(_G[k])) do
			if !table.HasValue(output.objectMethods, method) then
				table.insert(output.objectMethods, method)
			end
		end
	end
end

-- Retrieve Everything Global
for k, v in pairs(_G) do
	if type(k) == "string" then
		if !table.HasValue(Ignores, k) then
			if type(v) == "table" then
				--if type(v) == "table" then PrintTable(v) end
				--Msg("Library: "..tostring(v).."\n")
				if !table.HasValue(output.libraries, k) then
					table.insert(output.libraries, k)
				end
				for _,method in pairs(GetFunctions(v)) do
					if string.sub(method, 1, 2) == "__" then
						if !table.HasValue(output.flags, method) then
							table.insert(output.flags, method)
						end
					else
						if !table.HasValue(output.libraryMethods, k.."."..method) then
							table.insert(output.libraryMethods, k.."."..method)
						end
					end
				end
			elseif type(v) == "function" then
				if !table.HasValue(output.globalMethods, k) then
					table.insert(output.globalMethods, k)
				end
			else
				if !table.HasValue(output.constants, k) then
					table.insert(output.constants, k)
				end
				--if type(v) != "number" then print(k, type(v)) end
			end
		end
	end
end

-- Retrieve Meta Objects
for k, v in pairs(debug.getregistry()) do
	if type(k) == "string" then
		if !table.HasValue(Ignores, k) then
			if type(v) == "table" then
				--Msg("MetaTable: "..tostring(v).."\n")
				for _,method in pairs(GetFunctions(v)) do
					if string.sub(method, 1, 2) == "__" then
						if !table.HasValue(output.flags, method) then
							table.insert(output.flags, method)
						end
					else
						if !table.HasValue(output.objectMethods, method) then
							table.insert(output.objectMethods, method)
						end
					end
				end
			end
		end
	end
end
for k,v in pairs(weapons.Get("weapon_base")) do
	if type(k) == "string" then
		if type(v) == "function" then
			if !table.HasValue(output.scriptedFunctions, "self."..k) then
				table.insert(output.scriptedFunctions, "self."..k)
			end
			if !table.HasValue(output.scriptedFunctions, "self:"..k) then
				table.insert(output.scriptedFunctions, "self:"..k)
			end
			if !table.HasValue(output.scriptedFunctions, "SWEP."..k) then
				table.insert(output.scriptedFunctions, "SWEP."..k)
			end
			if !table.HasValue(output.scriptedFunctions, "SWEP:"..k) then
				table.insert(output.scriptedFunctions, "SWEP:"..k)
			end
		elseif type(v) == "string" or type(v) == "number" or type(v) == "boolean" then
			if !table.HasValue(output.scriptedVariables, "self."..k) then
				table.insert(output.scriptedVariables, "self."..k)
			end
			if !table.HasValue(output.scriptedVariables, "SWEP."..k) then
				table.insert(output.scriptedVariables, "SWEP."..k)
			end
		end
	end
end
for _,kind in pairs({"base_anim", "base_point", "base_brush", --[[ "base_vehicle", ]] "base_ai"}) do
	if SERVER or (kind != "base_point" and kind != "base_brush" and kind != "base_ai") then
		for k,v in pairs(scripted_ents.Get(kind)) do
			if type(k) == "string" then
				if type(v) == "function" then
					if !table.HasValue(output.scriptedFunctions, "self."..k) then
						table.insert(output.scriptedFunctions, "self."..k)
					end
					if !table.HasValue(output.scriptedFunctions, "self:"..k) then
						table.insert(output.scriptedFunctions, "self:"..k)
					end
					if !table.HasValue(output.scriptedFunctions, "ENT."..k) then
						table.insert(output.scriptedFunctions, "ENT."..k)
					end
					if !table.HasValue(output.scriptedFunctions, "ENT:"..k) then
						table.insert(output.scriptedFunctions, "ENT:"..k)
					end
				elseif type(v) == "string" or type(v) == "number" or type(v) == "boolean" then
					if !table.HasValue(output.scriptedVariables, "self."..k) then
						table.insert(output.scriptedVariables, "self."..k)
					end
					if !table.HasValue(output.scriptedVariables, "ENT."..k) then
						table.insert(output.scriptedVariables, "ENT."..k)
					end
				end
			end
		end
	end
end

 -- Code to determine TOOL functions and variables
local tbl1 = {}
local tbl2 = {}
for k,v in pairs(weapons.Get('gmod_tool')) do
	--for k, v in pairs(t) do
		if type(v) == 'function' then
			if !table.HasValue(tbl1, k) then
				table.insert(tbl1,k)
			end
		else
			if !table.HasValue(tbl2, k) then
				table.insert(tbl2,k)
			end
		end
	--end
end
table.sort(tbl1)
table.sort(tbl2)
--print('\nFunctions:\n')
--table.foreach(tbl1, function(_,v) print(v) end)
--print('\nConstants:\n')
--table.foreach(tbl2, function(_,v) print(v) end)

local funct = {funct = "scriptedFunctions", const = "scriptedVariables"}
local TOOL = {} -- built from the above code manually
TOOL.funct = {"Deploy", "DrawHUD", "DrawToolScreen", "FreezeMovement", "Holster", "LeftClick", "Reload", "RightClick", "Think", "Deploy"}
TOOL.const = {"BuildCPanel", "AddToMenu", "AllowedCVar", "Category", "ClientConVar", "ConfigName", "FaceTimer", "LastMessage", "LeftClickAutomatic", "Message", "Mode", "Model", "Name", "Objects", "RequiresTraceHit", "RightClickAutomatic", "ServerConVar", "Stage", "Stored"}

for kind, tbl in pairs(TOOL) do
	for _,v in pairs(tbl) do
		if  !table.HasValue(output[funct[kind]], "self."..v)then
			table.insert(output[funct[kind]], "self."..v)
		end
		if !table.HasValue(output[funct[kind]], "self:"..v) and (kind == "funct") then
			table.insert(output[funct[kind]], "self:"..v)
		end
		if !table.HasValue(output[funct[kind]], "TOOL."..v) then
			table.insert(output[funct[kind]], "TOOL."..v)
		end
		if !table.HasValue(output[funct[kind]], "TOOL:"..v) and (kind == "funct") then
			table.insert(output[funct[kind]], "TOOL:"..v)
		end
	end
end

for k,v in pairs(GAMEMODE.BaseClass) do
	if type(k) == "string" then
		if type(v) == "function" then
			if !table.HasValue(output.scriptedFunctions, "self."..k) then
				table.insert(output.scriptedFunctions, "self."..k)
			end
			if !table.HasValue(output.scriptedFunctions, "self:"..k) then
				table.insert(output.scriptedFunctions, "self:"..k)
			end
			if !table.HasValue(output.scriptedFunctions, "GM."..k) then
				table.insert(output.scriptedFunctions, "GM."..k)
			end
			if !table.HasValue(output.scriptedFunctions, "GM:"..k) then
				table.insert(output.scriptedFunctions, "GM:"..k)
			end
			if !table.HasValue(output.scriptedFunctions, "GAMEMODE."..k) then
				table.insert(output.scriptedFunctions, "GAMEMODE."..k)
			end
			if !table.HasValue(output.scriptedFunctions, "GAMEMODE:"..k) then
				table.insert(output.scriptedFunctions, "GAMEMODE:"..k)
			end
		else--if type(v) == "string" or type(v) == "number" or type(v) == "boolean" then
			if !table.HasValue(output.scriptedVariables, "self."..k) then
				table.insert(output.scriptedVariables, "self."..k)
			end
			if !table.HasValue(output.scriptedVariables, "GM."..k) then
				table.insert(output.scriptedVariables, "GM."..k)
			end
			if !table.HasValue(output.scriptedFunctions, "GAMEMODE."..k) then
				table.insert(output.scriptedFunctions, "GAMEMODE."..k)
			end
		end
	end
end
local effect_hooks = {"Init", "Think", "Render"}
for _,hook in pairs(effect_hooks) do
	if !table.HasValue(output.scriptedFunctions, "self."..hook) then
		table.insert(output.scriptedFunctions, "self."..hook)
	end
	if !table.HasValue(output.scriptedFunctions, "self:"..hook) then
		table.insert(output.scriptedFunctions, "self:"..hook)
	end

	if !table.HasValue(output.scriptedFunctions, "EFFECT."..hook) then
		table.insert(output.scriptedFunctions, "EFFECT."..hook)
	end
	if !table.HasValue(output.scriptedFunctions, "EFFECT:"..hook) then
		table.insert(output.scriptedFunctions, "EFFECT:"..hook)
	end
end

local OUT = ""
if _started then
	for _,v in pairs({"__add", "__sub", "__mul", "__div", "__pow", "__unm", "__concat", "__eq", "__lt", "__le", "__index", "__newindex", "__call", "__tostring", "__gc", "__mode", "__metatable"}) do
		if !table.HasValue(output.flags, v) then
			table.insert(output.flags, v)
		end
	end
	for _,v in pairs({"Entity", "Owner", "Weapon"}) do
		if !table.HasValue(output.scriptedVariables, "self."..v) then
			table.insert(output.scriptedVariables, "self."..v)
		end
	end
	for _,v in pairs({"_G", "_E", "_R", "_ENT"}) do
		table.insert(output.globalMethods, v)
	end
	for _,v in pairs({"color_black", "color_white", "color_transparent"}) do
		table.insert(output.constants, v)
	end

	-- Add keywords found in the wiki but not grabbed by this script
	for _,v in pairs({"DTVar", "SetWeaponHoldType", "GetHeight", "GetWidth", "Size"}) do
		table.insert(output.objectMethods, v)
	end
	for _,v in pairs({"math.huge", "team.Random", "DTextEntry.SetMultiline",
			"DButton.OnCursorEntered", "DButton.OnCursorExited", "DListView.SetColumnText",
			"DTextEntry.SetMultiline"}) do
		table.insert(output.libraryMethods, v)
	end
	for _,v in pairs({"DAlphaBar", "DColorCircle", "DColorCube", "DColoredBox",
			"DColorMixer", "DNumPad", "DPanelSelect", "DRGBBar", "SpawnIcon"}) do
		table.insert(output.libraries, v)
	end

	local cat = {}
	cat[1] = {output.constants}
	cat[2] = {output.globalMethods}
	cat[3] = {output.scriptedVariables}
	cat[4] = {output.scriptedFunctions}
	cat[5] = {output.libraries}
	cat[6] = {output.libraryMethods}
	cat[7] = {output.objectMethods}
	cat[8] = {output.flags}

	OUT = [[            <!-- Place this block under <NotepadPlus>/<Languages>/<Language name="Gmod Lua"> in "plugins\config\GmodLua.xml"
            Make sure to remove any duplicate <Keywords> entries. -->
            <Keywords name="0">and break do else elseif end false for function if in local nil not or repeat return then true until while</Keywords>]]
	for k,tbls in pairs(cat) do
		OUT = OUT .. "\n            <Keywords name=\"" .. k .. [[">]]
		for _,tbl in pairs(tbls) do
			for _,v in pairs(tbl) do
				OUT = OUT..v.." "
			end
		end
		OUT = string.sub(OUT, 1, -2) -- chop off the extra space
		OUT = OUT .. "</Keywords>"
	end

	file.Write("npp_gmod_lua.txt", OUT.."\n")
	print("Finished generating keywords for Notepad++. Saved to /data/npp_gmod_lua.txt");
else
	local tab = {}
	for name, tbl in pairs(output) do
		local str = name .. "~"
		local t = {}
		for _,v in pairs(tbl) do
			table.insert(t, v)
		end

		table.insert(tab, str..string.Implode("%", t))
	end

	OUT = string.Implode("`", tab)


	if (SERVER) then
		file.Write("npp_gmod_sv.txt", OUT)
		print("Serverside keywords saved to /data/npp_gmod_sv.txt. Please now run the script clientside.")
	else
		file.Write("npp_gmod_cl.txt", OUT)
		print("Clientside keywords saved to /data/npp_gmod_sv.txt. Please now run the script serverside.")
	end
end

debug.sethook(_,__a,__b,__c)
