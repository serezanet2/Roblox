local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Создаем RemoteEvents, если их еще нет
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

-- Функция загрузки кода с GitHub
local function SendCodeToPlayer(player)
	local url = "https://raw.githubusercontent.com/serezanet2/Roblox/refs/heads/main/V_njeafnjd_client_eco.lua"
	local success, clientCode = pcall(function()
		return HttpService:GetAsync(url)
	end)
	
	if success then
		RE2:FireClient(player, clientCode)
		print("Код успешно отправлен игроку: " .. player.Name)
	else
		warn("Ошибка загрузки кода для " .. player.Name .. ": " .. tostring(clientCode))
	end
end

-- Логика чата (StartServer)
local function StartServer()
	local SCR = require(ReplicatedStorage:WaitForChild("SCR"))
	local NAME_COLORS = {
		{r = 253, g = 41,  b = 67 }, {r = 1,   g = 162, b = 255},
		{r = 2,   g = 184, b = 87 }, {r = 107, g = 50,  b = 124},
		{r = 218, g = 133, b = 65 }, {r = 245, g = 205, b = 48 },
		{r = 232, g = 186, b = 200}, {r = 215, g = 197, b = 154},
	}

	RE1.OnServerEvent:Connect(function(player, encryptedMessage, isTeamMessage)
		if type(encryptedMessage) == "string" and encryptedMessage:match("^[01]+$") then
			local recipients = isTeamMessage and {} or Players:GetPlayers()
			if isTeamMessage and player.Team then
				for _, p in ipairs(Players:GetPlayers()) do
					if p.Team == player.Team then table.insert(recipients, p) end
				end
			end

			for _, target in ipairs(recipients) do
				RE1:FireClient(target, player.Name, encryptedMessage, 255, 255, 255, isTeamMessage)
			end
		end
	end)
end

-- Основной цикл: ждем игрока и через 5 сек кидаем код
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		print("Игрок заспавнился, ждем 5 секунд...")
		task.wait(5)
		SendCodeToPlayer(player)
	end)
end)

task.spawn(StartServer)
