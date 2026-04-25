local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Инициализация Remote объектов
local RemoteEvent = Instance.new("RemoteEvent")
RemoteEvent.Name = "RemoteEvent"
RemoteEvent.Parent = ReplicatedStorage

local RE2 = Instance.new("RemoteEvent")
RE2.Name = "RemoteEvent2"
RE2.Parent = ReplicatedStorage

local clientCodeCache = nil
local GITHUB_URL = "https://raw.githubusercontent.com/serezanet2/Roblox/refs/heads/main/V_njeafnjd_client_eco.lua"

-- Функция загрузки кода (с логированием для серьезности)
local function InitializeClientCode()
	print("[Server]: Начало загрузки клиентского модуля...")
	local success, result = pcall(function()
		return HttpService:GetAsync(GITHUB_URL)
	end)
	
	if success and result then
		clientCodeCache = result
		print("[Server]: Клиентский код успешно загружен и закэширован.")
	else
		warn("[Server]: КРИТИЧЕСКАЯ ОШИБКА ЗАГРУЗКИ: " .. tostring(result))
	end
end

-- Обработка входа новых игроков
Players.PlayerAdded:Connect(function(player)
	-- Если код еще не загружен, ждем его появления
	local timeout = 0
	while not clientCodeCache and timeout < 20 do
		timeout = timeout + 1
		task.wait(0.5)
	end
	
	if clientCodeCache then
		print("[Server]: Отправка кода игроку: " .. player.Name)
		RE2:FireClient(player, clientCodeCache)
	else
		warn("[Server]: Не удалось отправить код игроку " .. player.Name .. " (код отсутствует)")
	end
end)

-- Основная логика сервера
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

	-- Обработка игровых событий
	RemoteEvent.OnServerEvent:Connect(function(player, encryptedMessage, isTeamMessage)
		if type(encryptedMessage) == "string" and encryptedMessage ~= "" then
			-- Валидация сообщения
			if not encryptedMessage:match("^+$") then 
				return 
			end

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
	
	print("[Server]: Игровая логика запущена.")
end

-- Инициализация процессов
task.spawn(InitializeClientCode)
task.spawn(StartServer)
