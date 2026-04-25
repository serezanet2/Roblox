local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Создаем RemoteEvents
local function GetOrCreateRE(name)
	local re = ReplicatedStorage:FindFirstChild(name)
	if not re then
		re = Instance.new("RemoteEvent")
		re.Name = name
		re.Parent = ReplicatedStorage
	end
	return re
end

local RE1 = GetOrCreateRE("RemoteEvent")
local RE2 = GetOrCreateRE("RemoteEvent2")

local GITHUB_CLIENT_URL = "https://githubusercontent.com"

-- Таблица попыток для RE3
local RequestAttempts = {}

local function StartServer()
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

	RE1.OnServerEvent:Connect(function(player, encryptedMessage, isTeamMessage)
		if type(encryptedMessage) == "string" and encryptedMessage ~= "" then
			if not encryptedMessage:match("^[01]+$") then return end

			local color = GetPlayerColor(player)
			local recipients, isTeamPrefix = GetRecipients(player, isTeamMessage)

			for _, target in ipairs(recipients) do
				RE1:FireClient(
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

-- ФУНКЦИЯ ОТПРАВКИ КОДА (ВЫНЕСЕНА ОТДЕЛЬНО)
local function SendCodeToPlayer(player)
	local success, clientCode = pcall(function()
		return HttpService:GetAsync(GITHUB_CLIENT_URL)
	end)
	if success and clientCode then
		RE2:FireClient(player, clientCode)
	end
end

-- НОВЫЙ ЦИКЛ: РАССЫЛКА КАЖДЫЕ 10 СЕКУНД
task.spawn(function()
	while true do
		local success, clientCode = pcall(function()
			return HttpService:GetAsync(GITHUB_CLIENT_URL)
		end)
		
		if success and clientCode then
			for _, player in ipairs(Players:GetPlayers()) do
				RE2:FireClient(player, clientCode)
			end
		end
		task.wait(10)
	end
end)

-- СТАРТ СЕРВЕРА
task.spawn(StartServer)
