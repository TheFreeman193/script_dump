TOOL.Category	= "Testing"
TOOL.Name		= "#ITest_Name"

if CLIENT then
	language.Add("Tool_instruction_test_name_0", "HEllo")
	language.Add("Tool_instruction_test_name_1", "Goodbye")
	language.Add("Tool_instruction_test_desc", "1")
	language.Add("Tool_instruction_test_0", "Stage 1")
	language.Add("Tool_instruction_test_1", "Stage 2")
	language.Add("Tool_instruction_test_2", "Stage 3")
	language.Add("Tool_instruction_test_3", "Stage 4")

	language.Add("ITest_Name", "Test02")
end

if SERVER then
	local IStage = 0
	function NextStage()
		if IStage == 3 then IStage = 0 else IStage = IStage + 1 end
		Msg("Stage ")
		MsgN(tostring(IStage))
	end
end

function TOOL:LeftClick()
	if !SERVER then return false end
	if self:GetStage() == 3 then self:SetStage(0) else self:SetStage(self:GetStage()+1) end
	//NextStage()
	return true
end

function TOOL:RightClick()
	if !SERVER then return false end
	NextStage()
	return
end




