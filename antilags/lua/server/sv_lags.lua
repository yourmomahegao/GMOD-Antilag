print( "-----------------------" )
print("Antilag loading...")

util.AddNetworkString( "SendChatWarning" )

----------------- CONFIG -----------------
-- Sensivity of antilag
local Sensivity = 1 -- Set from 1 to 10
------------------------------------------

-- Отправляет сообщение в чат
function SendMSG(str)
	net.Start("SendChatWarning")
	net.WriteString(str)
	net.Broadcast()
end

-- Фризит конфликтные ентити
function FreezeConflicts()
	for i,e in ipairs(ents.GetAll()) do
		local phys = e:GetPhysicsObject()

		if IsValid(phys) and phys:GetStress() > 5000 and !e:IsPlayer() then
			phys:EnableMotion(false)
			e:SetRenderMode(1)
			e:SetCollisionGroup(1)
			e:SetColor(ColorAlpha(e:GetColor(),100))
		end
	end
end

-- Фризит ентити
function FreezeProps()
	for i,e in ipairs(ents.GetAll()) do
		local phys = e:GetPhysicsObject()

		if IsValid(phys) then
			phys:EnableMotion(false)
		end
	end
end

-- Останавливает Expression 2
function StopE2() 
	for i,e in ipairs( ents.FindByClass("gmod_wire_expression2") ) do
		if IsValid(e) then
			e:PCallHook( "destruct" )
		end
	end
end

-- Удаляет Starfall
function StopSF() 
	for i,e in ipairs( ents.FindByClass("starfall_processor") ) do
		if IsValid(e) then
			e:Remove()
		end
	end
end

local Tickrate = engine.TickInterval()
local TicksCount = 0
local LastCheckTime = SysTime()
local TickAddTime = SysTime()
local NormalizedLagLevel = 0

-- Lags levels
local FirstLevel = false
local SecondLevel = false
local ThirdLevel = false
local FourthLevel = false
local FifthLevel = false

-- Function to detect lags
function AddTick()
	TickAddTime = SysTime()
	TicksCount = TicksCount + 1

	if TicksCount - Tickrate then
		NormalizedLagLevel = math.Round(-(LastCheckTime - TickAddTime) / Tickrate, 0)
		LastCheckTime = SysTime()
		TicksCount = 0
	end


	if NormalizedLagLevel > Sensivity then
		if FirstLevel == false then
			FreezeConflicts()
			-- SendMSG("Заморожены конфликтные ентити")
			FirstLevel = true
		elseif SecondLevel == false then
			FreezeProps()
			SendMSG("Заморожены все пропы")
			SecondLevel = true
		elseif ThirdLevel == false then
			StopE2()
			SendMSG("Остановлены все Expression 2")
			ThirdLevel = true
		elseif FourthLevel == false then
			StopSF()
			SendMSG("Остановлены все Starfall")
			FourthLevel = true
		elseif FifthLevel == false then
			game.CleanUpMap(false, {})
			SendMSG("Очищена карта")
			FourthLevel = true
		end
	else
		FirstLevel = false
		SecondLevel = false
		ThirdLevel = false
		FourthLevel = false
		FifthLevel = false
	end
end
hook.Add("Tick", "AntilagSystem", AddTick)