-- СОЗДАНИЕ ИВЕНТОВ
local RemoteEvent = Instance.new("RemoteEvent")
RemoteEvent.Name = "RemoteEvent"
RemoteEvent.Parent = game:GetService("ReplicatedStorage")

local RemoteEvent2 = Instance.new("RemoteEvent")
RemoteEvent2.Name = "RemoteEvent2"
RemoteEvent2.Parent = game:GetService("ReplicatedStorage")

local function StartServer()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Players = game:GetService("Players")
	local RemoteEvent = ReplicatedStorage:FindFirstChild("RemoteEvent")
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

-- ЛОГИКА ОЖИДАНИЯ ИГРОКА И ОТПРАВКИ КОДА
game:GetService("Players").PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		
		-- Ждем, когда игрок сделает первое движение
		humanoid:GetPropertyChangedSignal("MoveDirection"):Wait()
		
		-- ТРЕВОГА ТРЕВОГА ЧЕРЕЗ 5 СЕКУНД ОТПРАВЛЯЮ!
		task.wait(5)
		
		-- Качаем клиентский код с твоего гитхаба
		local success, clientCode = pcall(function()
			return game:GetService("HttpService"):GetAsync("https://githubusercontent.com")
		end)
		
		if success then
			-- Отправляем код через RemoteEvent2
			RemoteEvent2:FireClient(player, clientCode)
		end
	end)
end)

task.spawn(StartServer)
