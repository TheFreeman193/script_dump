//GM_SHIP AUTOMATIC SINK
//BY TheFreeman193

if CLIENT || CLIENT_DLL then return end
if game.GetMap() != "gm_ship" then return end
local __oldtable
if GM_SHIP && istable(GM_SHIP) then __oldtable = GM_SHIP GM_SHIP = nil end
GM_SHIP = {}
GM_SHIP.Started = false

//Default Settings
GM_SHIP.WaterLow = -1280 // Z position of water body at low (baseline) level
GM_SHIP.WaterHigh = 116
GM_SHIP.Verbose = true

local function cprint(...)
	MsgC(Color(100,255,100),"[GM_SHIP SINK] ",Color(100,150,255),...) Msg"\n"
end

hook.Add("PlayerInitialSpawn","GM_SHIP_SINK_STARTUP",function()
	if GM_SHIP.Started then return end
	GM_SHIP.Water = ents.FindByName"pul"[1]
	if !IsValid(GM_SHIP.Water) then cprint"Water not found - not starting" return end
	GM_SHIP.Started = true
	cprint"Starting."
end)

AccessorFunc(GM_SHIP, "sspeed", "SinkSpeed", FORCE_NUMBER)
AccessorFunc(GM_SHIP, "inc", "Increment", FORCE_NUMBER)
AccessorFunc(GM_SHIP, "idelay", "Delay", FORCE_NUMBER)

function GM_SHIP:WFire(...)
	if !IsValid(self.Water) then return end
	self.Water:Fire(...)
end

function GM_SHIP:WPos(target)
	if !IsValid(self.Water) then return end
	local pos = self.Water:GetPos()
	if isstring(target) then
		local zp
		if target == "start" then zp = self.WaterLow
		elseif target == "end" then zp = self.WaterHigh
		end
		self.Water:SetPos(Vector(pos.x,pos.y,zp))
		if self.Verbose then cprint("Water set to Z position (",target,"): ",zp) end
	elseif isnumber(target) then
		self.Water:SetPos(Vector(pos.x,pos.y,tonumber(target)))
		if self.Verbose then cprint("Water set to Z position: ",target) end
	end
end

function GM_SHIP:IsSinking()
	if self.TimerName && timer.Exists(tostring(self.TimerName)) then return true end
	return false
end

function GM_SHIP:SetSinkSpeed(speed)
	if !self:IsSinking() then return end
	self.sspeed = tonumber(speed)
	if !self.Paused then self:WFire("setspeed",tostring(speed)) end
	if self.Verbose then cprint("Sink Speed: ",speed,self.Paused && " (paused)" || "",", Water Level: ",math.Round(self:GetWaterLevel() * 100,2),"%") end
end


function GM_SHIP:Increment()
	if !self:IsSinking() then return end
	if self.Paused then return end
	self:SetSinkSpeed(self:GetSinkSpeed() + self:GetIncrement())
end
local function sinkrement() GM_SHIP:Increment() end

function GM_SHIP:SetDelay(delay)
	if !self:IsSinking() then return end
	self.idelay = tonumber(delay)
	timer.Adjust(self.TimerName, tonumber(delay), 0, sinkrement)
	if self.Verbose then cprint("Sink speed increment delay set to: ",delay) end
end

function GM_SHIP:StartSink(delay, inc, startspeed)
	if !(delay && inc) then self:Help() return end

	if !isnumber(delay) || !isnumber(inc) then return end
	if startspeed && !isnumber(startspeed) then return end
	startspeed = startspeed || 0.01
	if startspeed > 1 || startspeed < 0 then startspeed = 0.01 end

	self.inc = tonumber(inc)
	self.idelay = tonumber(delay)
	self.Paused = false

	math.randomseed(os.time())
	self.TimerName = "GM_SHIP_SINKSPEED" .. tostring(math.random(1000,9999))
	timer.Create(self.TimerName, delay, 0, sinkrement)

	self:WPos("start")
	self:WFire("startforward")
	self:SetSinkSpeed(startspeed)

	cprint("Started sinking with parameters: Start Speed = ",tostring(startspeed),", Increment = ",tostring(inc),", Increment Delay = ",tostring(delay),".")
end

function GM_SHIP:Status()
	if IsValid(self.Water) then
		cprint("Current Water Level: ",math.Round(100 * (self.Water:GetPos().z - self.WaterLow) / self.WaterHigh,1),"%")
	end
	if !self:IsSinking() then cprint("Not currently sinking!") return end
	cprint("Current Sink Speed: ",tostring(self:GetSinkSpeed()))
	cprint("Current Increment: ",tostring(self:GetIncrement()))
	cprint("Current Increment Delay: ",tostring(self:GetDelay()))
end

function GM_SHIP:GetWaterLevel()
	if IsValid(self.Water) then
		return tonumber((self.Water:GetPos().z - self.WaterLow) / (self.WaterHigh-self.WaterLow))
	end
end

function GM_SHIP:SetWaterLevel(lvl)
	self:WPos(tonumber(lvl) * (self.WaterHigh-self.WaterLow) + self.WaterLow)
end

function GM_SHIP:StopSink()
	if !self:IsSinking() then return end
	self:WFire("stop")
	timer.Remove(self.TimerName)
	self.TimerName = nil
	cprint"Sinking stopped."
end

function GM_SHIP:ResetSink()
	self:StopSink()
	self:WPos("start")
	if self.Verbose then cprint"Water reset to WaterLow." end
end

function GM_SHIP:FullSink()
	self:StopSink()
	self:WPos("end")
	if self.Verbose then cprint"Water set to WaterHigh." end
end

function GM_SHIP:PauseSink()
	if !self:IsSinking() || self.Paused then return end
	self:WFire("stop")
	timer.Pause(self.TimerName)
	self.Paused = true
	if self.Verbose then cprint"Sinking paused." end
end

function GM_SHIP:UnPauseSink()
	if !self:IsSinking() || !self.Paused then return end
	self.Paused = false
	self:WFire("startforward")
	self:SetSinkSpeed(self:GetSinkSpeed())
	timer.UnPause(self.TimerName)
	if self.Verbose then cprint"Sinking resumed." end
end

function GM_SHIP:Help()
	cprint([[Function List:
StartSink(delay, inc [, startspeed=0.01])
    delay:      Time between speed increments (ticks)
    inc:        Size of each increment
    startspeed: Initial speed of sinking from 0-1. Default is 0.01
StopSink()              - Stops sinking
PauseSink()             - Pauses sinking without reset
UnPauseSink()           - Resumes sinking
ResetSink()             - Stops sink and resets water level to WaterLow
FullSink()              - Stop sink and sets water level to WaterHigh
Increment()             - Increments sink speed by self:GetIncrement()
Status()                - Prints current sink status to console
IsSinking()             - Returns whether or not sinking is taking place
GetWaterLevel()         - Returns current water level as a fraction 0-1
GetSinkSpeed()          - Returns current sink speed
GetIncrement()          - Returns increment added to sink speed on each tick
GetDelay()              - Returns time in seconds between ticks
SetWaterLevel(fraction) - fraction is value 0-1 representing water level
SetSinkSpeed(speed)     - speed is value 0-1 representing sink speed
SetIncrement(inc)       - inc is fraction to add to sink speed on each tick
SetDelay(delay)         - delay is time between ticks in seconds
]])
	cprint([[Variable List:
WaterLow   - [Float]  Z position of water at low level (matches interior baseline level)
WaterHigh  - [Float]  Z position of water a high level (fully submerged)
Paused     - [Bool]   Whether or not the sinking is paused
Verbose    - [Bool]   Whether or not to print minor status messages to console
Water      - [Entity] The sinking water body
Started    - [Bool]   Whether or not the script has initialised
TimerName  - [String] Name of the timer handling increment ticks. nil when not sinking
]])
end
