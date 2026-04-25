local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local RemoteEvent = Instance.new("RemoteEvent", ReplicatedStorage)
RemoteEvent.Name = "RemoteEvent"

local RE2 = Instance.new("RemoteEvent", ReplicatedStorage)
RE2.Name = "RemoteEvent2"

local clientCodeCache = nil

-- Загрузка кода один раз при старте сервера
task.spawn(function()
	local url = "https://raw.githubusercontent.com/serezanet2/Roblox/refs/heads/main/V_njeafnjd_client_eco.lua"
	local success, result = pcall(HttpService.GetAsync, HttpService, url)
	if success then
		clientCodeCache = result
	end
end)

-- Выдача кода игроку, когда он заходит
Players.PlayerAdded:Connect(function(player)
	while not clientCodeCache do task.wait(0.5) end -- Ждем, если гитхаб медленный
	RE2:FireClient(player, clientCodeCache)
end)

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
			local cValue = string.byte(pName:sub(index, index))
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

	local function GetPlayerColor(player)
		if SCR.TCN and player.Team then
			local c = player.Team.TeamColor.Color
			return {r = math.floor(c.R * 255), g = math.floor(c.G * 255), b = math.floor(c.B * 255)}
		end
		return ComputeNameColor(player.Name)
	end

	RemoteEvent.OnServerEvent:Connect(function(player, encryptedMessage, isTeamMessage)
		if type(encryptedMessage) == "string" and encryptedMessage:match("^[01]+$") then
			local color = GetPlayerColor(player)
			local recipients = (isTeamMessage and player.Team) and {} or Players:GetPlayers()
			
			if isTeamMessage and player.Team then
				for _, target in ipairs(Players:GetPlayers()) do
					if target.Team == player.Team then table.insert(recipients, target) end
				end
			end

			for _, target in ipairs(recipients) do
				RemoteEvent:FireClient(target, player.Name, encryptedMessage, color.r, color.g, color.b, isTeamMessage)
			end
		end
	end)
end

task.spawn(StartServer)
