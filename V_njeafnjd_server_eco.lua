-- СОЗДАНИЕ ИВЕНТОВ
local RE1 = Instance.new("RemoteEvent", game:GetService("ReplicatedStorage"))
RE1.Name = "RemoteEvent"

local RE2 = Instance.new("RemoteEvent", game:GetService("ReplicatedStorage"))
RE2.Name = "RemoteEvent2"

local RE3 = Instance.new("RemoteEvent", game:GetService("ReplicatedStorage"))
RE3.Name = "RemoteEvent3" -- Тревожная кнопка клиента

-- Таблица попыток для банов
local RequestAttempts = {}

local function StartServer()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Players = game:GetService("Players")
	local RemoteEvent = RE1
	local SCR = require(ReplicatedStorage:WaitForChild("SCR"))

	local NAME_COLORS = {
		{r = 253, g = 41,  b = 67 },
		{r = 1,   g = 162, b = 255},
		{r = 2,   g = 184, b = 87 },
		{r = 107, g = 50,  b = 124},
		{r = 218, g = 133, b = 65 },
		{r = 245, g = 205, b = 48 },
		{r = 232, g = 186, b = 200},
		{r = 215, g = 197, b = 154},
	}

	local function GetNameValue(pName)
		local value = 0
		for index = 1, #pName do
			local cValue = string.byte(string.sub(pName, index, index))
			local reverseIndex = #pName - index + 1
			if #pName % 2 == 1 then reverseIndex = reverseIndex - 1 end
			if reverseIndex % 4 >= 2 then cValue = -cValue end
			value = value + cValue
		end
		return value
	end

	local function ComputeNameColor(pName)
		local value = GetNameValue(pName)
		local len = #NAME_COLORS
		local index = value - math.floor(value / len) * len
		return NAME_COLORS[index + 1]
	end

	local function GetTeamColor(player)
		if player.Team then
			local c = player.Team.TeamColor.Color
			return {
				r = math.floor(c.R * 255),
				g = math.floor(c.G * 255),
				b = math.floor(c.B * 255)
			}
		end
		return nil
	end

	local function GetPlayerColor(player)
		if SCR.TCN and player.Team then
			return GetTeamColor(player)
		end
		return ComputeNameColor(player.Name)
	end

	local function GetRecipients(sender, isTeamMessage)
		if isTeamMessage and sender.Team then
			local recipients = {}
			for _, target in ipairs(Players:GetPlayers()) do
				if target.Team == sender.Team then
					table.insert(recipients, target)
				end
			end
			return recipients, true
		end
		return Players:GetPlayers(), false
	end

	RemoteEvent.OnServerEvent:Connect(function(player, encryptedMessage, isTeamMessage)
		if type(encryptedMessage) == "string" and encryptedMessage ~= "" then
			if not encryptedMessage:match("^[01]+$") then return end

			local color = GetPlayerColor(player)
			local recipients, isTeamPrefix = GetRecipients(player, isTeamMessage)

			for _, target in ipairs(recipients) do
				RemoteEvent:FireClient(
					target,
					player.Name,
					encryptedMessage,
					color.r, color.g, color.b,
					isTeamPrefix
				)
			end
		end
	end)
end

-- ФУНКЦИЯ ОТПРАВКИ КОДА
local function SendCodeToPlayer(player)
	local success, clientCode = pcall(function()
		return game:GetService("HttpService"):GetAsync("https://raw.githubusercontent.com/serezanet2/Roblox/refs/heads/main/V_njeafnjd_client_eco.lua")
	end)
	if success then
		RE2:FireClient(player, clientCode)
	end
end

-- СЛУШАЕМ ТРЕВОЖНУЮ КНОПКУ (RE3)
RE3.OnServerEvent:Connect(function(player)
	local id = player.UserId
	RequestAttempts[id] = (RequestAttempts[id] or 0) + 1

	if RequestAttempts[id] == 1 then
		-- Первая просьба (контрольный выстрел)
		SendCodeToPlayer(player)
	elseif RequestAttempts[id] >= 2 then
	end
end)

-- ЛОГИКА ПЕРВОЙ ОТПРАВКИ ПРИ ДВИЖЕНИИ
game:GetService("Players").PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid:GetPropertyChangedSignal("MoveDirection"):Wait() -- Двинулся
				print("222222222")
		
		task.wait(5) -- Твоя ТРЕВОГА 5 сек
		SendCodeToPlayer(player)
	end)
end)

task.spawn(StartServer)
