game.TextChatService.ChatInputBarConfiguration.Enabled = false

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local SCR = require(ReplicatedStorage:WaitForChild("SCR"))
local StarterGui = game:GetService("StarterGui")
local whitelist = require(ReplicatedStorage:WaitForChild("List"))

if SCR.AFAP or whitelist[LocalPlayer.UserId] then

	local GuiService = game:GetService("GuiService")
	local TextChatService = game:GetService("TextChatService")
	local mutedPlayers = {}

	local GUI = {};
	GUI["0"] = 0.3 * (GuiService.PreferredTransparency or 1)
	GUI["1"] = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"));
	GUI["1"]["DisplayOrder"] = -1;
	GUI["1"]["Name"] = [[Text Bar]];
	GUI["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
	GUI["1"]["ResetOnSpawn"] = false;
	GUI["3"] = Instance.new("Frame", GUI["1"]);
	GUI["3"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
	GUI["3"]["Size"] = UDim2.new(0.4, 0, 0.25, 0);
	GUI["3"]["Position"] = UDim2.new(0, 8, 0, 4);
	GUI["3"]["Name"] = [[appLayout]];
	GUI["3"]["BackgroundTransparency"] = 1;
	GUI["4"] = Instance.new("UIListLayout", GUI["3"]);
	GUI["4"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
	GUI["4"]["Name"] = [[layout]];
	GUI["5"] = Instance.new("Frame", GUI["3"]);
	GUI["5"]["ZIndex"] = 2;
	GUI["5"]["BorderSizePixel"] = 0;
	GUI["5"]["BackgroundColor3"] = Color3.fromRGB(26, 28, 30);
	GUI["5"]["AutomaticSize"] = Enum.AutomaticSize.Y;
	GUI["5"]["Size"] = UDim2.new(1, 0, 0, 0);
	GUI["5"]["Name"] = [[chatInputBar]];
	GUI["5"]["LayoutOrder"] = 3;
	GUI["5"]["BackgroundTransparency"] = GUI["0"];
	GUI["6"] = Instance.new("Frame", GUI["5"]);
	GUI["6"]["BackgroundColor3"] = Color3.fromRGB(26, 28, 30);
	GUI["6"]["AutomaticSize"] = Enum.AutomaticSize.XY;
	GUI["6"]["Size"] = UDim2.new(1, 0, 0, 0);
	GUI["6"]["Name"] = [[Background]];
	GUI["6"]["BackgroundTransparency"] = 0.2;
	GUI["7"] = Instance.new("UICorner", GUI["6"]);
	GUI["7"]["Name"] = [[Corner]];
	GUI["7"]["CornerRadius"] = UDim.new(0, 3);
	GUI["8"] = Instance.new("UIStroke", GUI["6"]);
	GUI["8"]["Transparency"] = 0.8;
	GUI["8"]["Color"] = Color3.fromRGB(255, 255, 255);
	GUI["8"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;
	GUI["8"]["Name"] = [[Border]];
	GUI["9"] = Instance.new("Frame", GUI["6"]);
	GUI["9"]["AutomaticSize"] = Enum.AutomaticSize.Y;
	GUI["9"]["Size"] = UDim2.new(1, 0, 0, 0);
	GUI["9"]["Name"] = [[Container]];
	GUI["9"]["BackgroundTransparency"] = 1;
	GUI["a"] = Instance.new("Frame", GUI["9"]);
	GUI["a"]["AutomaticSize"] = Enum.AutomaticSize.Y;
	GUI["a"]["Size"] = UDim2.new(1, -30, 0, 0);
	GUI["a"]["Name"] = [[TextContainer]];
	GUI["a"]["BackgroundTransparency"] = 1;
	GUI["b"] = Instance.new("UIPadding", GUI["a"]);
	GUI["b"]["PaddingTop"] = UDim.new(0, 10);
	GUI["b"]["PaddingRight"] = UDim.new(0, 10);
	GUI["b"]["PaddingLeft"] = UDim.new(0, 10);
	GUI["b"]["PaddingBottom"] = UDim.new(0, 10);
	GUI["c"] = Instance.new("Frame", GUI["a"]);
	GUI["c"]["AnchorPoint"] = Vector2.new(1, 0);
	GUI["c"]["AutomaticSize"] = Enum.AutomaticSize.Y;
	GUI["c"]["Size"] = UDim2.new(1, -8, 0, 0);
	GUI["c"]["Position"] = UDim2.new(1, 0, 0, 0);
	GUI["c"]["Name"] = [[TextBoxContainer]];
	GUI["c"]["BackgroundTransparency"] = 1;
	GUI["d"] = Instance.new("TextBox", GUI["c"]);
	GUI["d"]["TextStrokeTransparency"] = 0.5;
	GUI["d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
	GUI["d"]["PlaceholderColor3"] = Color3.fromRGB(179, 179, 179);
	GUI["d"]["ZIndex"] = 2;
	GUI["d"]["TextWrapped"] = true;
	GUI["d"]["TextSize"] = 18;
	GUI["d"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
	GUI["d"]["TextYAlignment"] = Enum.TextYAlignment.Top;
	GUI["d"]["FontFace"] = Font.new([[rbxasset://fonts/families/BuilderSans.json]], Enum.FontWeight.Medium, Enum.FontStyle.Normal);
	GUI["d"]["AutomaticSize"] = Enum.AutomaticSize.XY;
	GUI["d"]["ClearTextOnFocus"] = false;
	GUI["d"]["PlaceholderText"] = [[To chat click here or press / key]];
	GUI["d"]["Size"] = UDim2.new(1, 0, 0, 0);
	GUI["d"]["Text"] = [[]];
	GUI["d"]["BackgroundTransparency"] = 1;
	GUI["e"] = Instance.new("TextButton", GUI["a"]);
	GUI["e"]["TextWrapped"] = true;
	GUI["e"]["TextSize"] = 14;
	GUI["e"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
	GUI["e"]["FontFace"] = Font.new([[rbxasset://fonts/families/BuilderSans.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
	GUI["e"]["BackgroundTransparency"] = 1;
	GUI["e"]["AutomaticSize"] = Enum.AutomaticSize.XY;
	GUI["e"]["Size"] = UDim2.new(0, 0, 1, 0);
	GUI["e"]["Text"] = [[]];
	GUI["e"]["Name"] = [[TargetChannelChip]];
	GUI["e"]["Visible"] = false;
	GUI["f"] = Instance.new("TextButton", GUI["9"]);
	GUI["f"]["AnchorPoint"] = Vector2.new(1, 0);
	GUI["f"]["BackgroundTransparency"] = 1;
	GUI["f"]["Size"] = UDim2.new(0, 30, 1, 0);
	GUI["f"]["LayoutOrder"] = 2;
	GUI["f"]["Text"] = [[]];
	GUI["f"]["Name"] = [[SendButton]];
	GUI["f"]["Position"] = UDim2.new(1, 0, 0, 0);
	GUI["10"] = Instance.new("TextLabel", GUI["f"]);
	GUI["10"]["ZIndex"] = 2;
	GUI["10"]["TextSize"] = 24;
	GUI["10"]["TextTransparency"] = 0.5;
	GUI["10"]["FontFace"] = Font.new([[rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
	GUI["10"]["TextColor3"] = Color3.fromRGB(179, 179, 179);
	GUI["10"]["BackgroundTransparency"] = 1;
	GUI["10"]["Size"] = UDim2.new(0, 30, 0, 30);
	GUI["10"]["Text"] = [[paper-airplane]];
	GUI["10"]["Name"] = [[SendIcon]];
	GUI["11"] = Instance.new("UIListLayout", GUI["f"]);
	GUI["11"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
	GUI["11"]["VerticalAlignment"] = Enum.VerticalAlignment.Center;
	GUI["11"]["Name"] = [[Layout]];
	GUI["12"] = Instance.new("UIPadding", GUI["5"]);
	GUI["12"]["PaddingRight"] = UDim.new(0, 8);
	GUI["12"]["PaddingLeft"] = UDim.new(0, 8);
	GUI["13"] = Instance.new("ImageLabel", GUI["3"]);
	GUI["13"]["SliceCenter"] = Rect.new(8, 8, 24, 32);
	GUI["13"]["ScaleType"] = Enum.ScaleType.Slice;
	GUI["13"]["BackgroundColor3"] = Color3.fromRGB(26, 28, 30);
	GUI["13"]["ImageTransparency"] = GUI["0"];
	GUI["13"]["ImageColor3"] = Color3.fromRGB(26, 28, 30);
	GUI["13"]["Image"] = [[rbxasset://textures/ui/TopRoundedRect8px.png]];
	GUI["13"]["Size"] = UDim2.new(1, 0, 0, 8);
	GUI["13"]["BackgroundTransparency"] = 1;
	GUI["13"]["LayoutOrder"] = 2;
	GUI["13"]["Name"] = [[topBorder]];
	GUI["14"] = Instance.new("UISizeConstraint", GUI["13"]);
	GUI["14"]["Name"] = [[uiSizeConstraint]];
	GUI["14"]["MaxSize"] = Vector2.new(475, math.huge);
	GUI["15"] = Instance.new("UISizeConstraint", GUI["3"]);
	GUI["15"]["Name"] = [[uiSizeConstraint]];
	GUI["15"]["MaxSize"] = Vector2.new(475, math.huge);
	GUI["16"] = Instance.new("Frame", GUI["3"]);
	GUI["16"]["BorderSizePixel"] = 0;
	GUI["16"]["BackgroundColor3"] = Color3.fromRGB(26, 28, 30);
	GUI["16"]["Size"] = UDim2.new(1, 0, 1, 0);
	GUI["16"]["Position"] = UDim2.new(0, 0, 0.08556, 0);
	GUI["16"]["Name"] = [[FrameScale1]];
	GUI["16"]["LayoutOrder"] = 1;
	GUI["16"]["BackgroundTransparency"] = 1;
	GUI["17"] = Instance.new("ImageLabel", GUI["3"]);
	GUI["17"]["SliceCenter"] = Rect.new(8, 0, 24, 16);
	GUI["17"]["ScaleType"] = Enum.ScaleType.Slice;
	GUI["17"]["ImageTransparency"] = GUI["0"];
	GUI["17"]["ImageColor3"] = Color3.fromRGB(26, 28, 30);
	GUI["17"]["Image"] = [[rbxasset://textures/ui/BottomRoundedRect8px.png]];
	GUI["17"]["Size"] = UDim2.new(1, 0, 0, 8);
	GUI["17"]["BackgroundTransparency"] = 1;
	GUI["17"]["LayoutOrder"] = 5;
	GUI["17"]["Name"] = [[bottomBorder]];
	GUI["18"] = Instance.new("UISizeConstraint", GUI["17"]);
	GUI["18"]["Name"] = [[uiSizeConstraint]];
	GUI["18"]["MaxSize"] = Vector2.new(475, math.huge);
	GUI["19"] = Instance.new("Frame", GUI["3"]);
	GUI["19"]["BorderSizePixel"] = 0;
	GUI["19"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
	GUI["19"]["Size"] = UDim2.new(1, 0, 0, 24);
	GUI["19"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
	GUI["19"]["Name"] = [[FrameScale2]];
	GUI["19"]["BackgroundTransparency"] = 1;

	GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function()
		local t = 0.3 * GuiService.PreferredTransparency
		GUI["0"] = t
		GUI["5"]["BackgroundTransparency"] = t
		GUI["13"]["ImageTransparency"] = t
		GUI["17"]["ImageTransparency"] = t
	end)

	GUI["1"].Enabled = true

	local uis = game:GetService("UserInputService")
	local players = game:GetService("Players")
	local starterGui = game:GetService("StarterGui")
	local localPlayer = players.LocalPlayer

	local RemoteEvent = game.ReplicatedStorage:WaitForChild("RemoteEvent")
	local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

	local function base64_encode(data)
		return ((data:gsub('.', function(x)
			local r, b = '', x:byte()
			for i = 8, 1, -1 do
				r = r .. (b % 2^i - b % 2^(i-1) > 0 and '1' or '0')
			end
			return r
		end) .. '0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
			if (#x < 6) then return '' end
			local c = 0
			for i = 1, 6 do
				c = c + (x:sub(i,i) == '1' and 2^(6-i) or 0)
			end
			return b64chars:sub(c+1, c+1)
		end) .. ({ '', '==', '=' })[#data % 3 + 1])
	end

	local function base64_decode(data)
		data = string.gsub(data, '[^'..b64chars..'=]', '')
		return (data:gsub('.', function(x)
			if (x == '=') then return '' end
			local r, f = '', (b64chars:find(x) - 1)
			for i = 6, 1, -1 do
				r = r .. (f % 2^i - f % 2^(i-1) > 0 and '1' or '0')
			end
			return r
		end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
			if (#x ~= 8) then return '' end
			local c = 0
			for i = 1, 8 do
				c = c + (x:sub(i,i) == '1' and 2^(8-i) or 0)
			end
			return string.char(c)
		end))
	end

	local function stringToBinary(str)
		local result = ""
		for i = 1, #str do
			local byte = string.byte(str, i)
			for j = 7, 0, -1 do
				result = result .. (math.floor(byte / 2^j) % 2 == 1 and "1" or "0")
			end
		end
		return result
	end

	local function binaryToString(bin)
		local result = ""
		for i = 1, #bin, 8 do
			local byte = bin:sub(i, i + 7)
			if #byte == 8 then
				local num = 0
				for j = 1, 8 do
					num = num + (byte:sub(j, j) == "1" and 2^(8-j) or 0)
				end
				result = result .. string.char(num)
			end
		end
		return result
	end

	local function openConsole()
		pcall(function()
			StarterGui:SetCore("DevConsoleVisible", true)
		end)
	end

	local function showHelp()
		local helpText = [[
=== Available Commands ===
/help - Show this message
/clear or /c - Clear chat
/console - Open developer console
/mute [name] or /m [name] - Mute a player (local only)
/unmute [name] or /um [name] - Unmute a player
/team or /t - Toggle team chat
]]
		pcall(function()
			local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
			if channel then
				channel:DisplaySystemMessage(helpText)
			else
				starterGui:SetCore("ChatMakeSystemMessage", {
					Text = helpText,
					Color = Color3.fromRGB(100, 200, 255),
				})
			end
		end)
	end

	local function mutePlayer(playerName)
		local targetPlayer = players:FindFirstChild(playerName)
		if not targetPlayer then
			return false
		end

		if mutedPlayers[targetPlayer.Name] then
			return false
		end

		mutedPlayers[targetPlayer.Name] = true
		return true
	end

	local function unmutePlayer(playerName)
		if mutedPlayers[playerName] then
			mutedPlayers[playerName] = nil
			return true
		end
		return false
	end

	local text_box = GUI["d"]
	local send_button = GUI["f"]

	local isTeamMode = false
	local ignoreTextChanged = false
	local lastMessageAfterPrefix = ""
	local function clearchat()
		local invisibleChar = "\u{200B}" 
		local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")

		for i = 1, 50 do
			local message = string.rep(invisibleChar, i)

			if channel then
				channel:DisplaySystemMessage(message)
			else
				pcall(function()
					starterGui:SetCore("ChatMakeSystemMessage", {
						Text = message,
					})
				end)
			end
		end
	end



	local function sendMessage()
		local message = text_box.Text or ""
		local trimmed = message:match("^%s*(.-)%s*$")
		if trimmed:sub(1, 1) == "/" then
			local parts = {}
			for word in trimmed:gmatch("%S+") do
				table.insert(parts, word)
			end
			local cmd = parts[1]:lower()
			if cmd == "/team" or cmd == "/t" then
				ignoreTextChanged = true
				if not localPlayer.Team then
					text_box.Text = ""
					isTeamMode = false
				else
					isTeamMode = true
					lastMessageAfterPrefix = ""
					text_box.Text = "[TEAM]"
				end
				ignoreTextChanged = false
				text_box:ReleaseFocus()
				return
			end
			if cmd == "/console" then
				openConsole()
				text_box.Text = ""
				text_box:ReleaseFocus()
				return
			end

			if cmd == "/clear" or cmd == "/c" then
				clearchat()
				text_box.Text = ""
				text_box:ReleaseFocus()
				return
			end
			if cmd == "/help" then
				showHelp()
				text_box.Text = ""
				text_box:ReleaseFocus()
				return
			end

			if cmd == "/mute" or cmd == "/m" then
				local targetName = parts[2]
				if targetName then
					mutePlayer(targetName)
				end
				text_box.Text = ""
				text_box:ReleaseFocus()
				return
			end

			if cmd == "/unmute" or cmd == "/um" then
				local targetName = parts[2]
				if targetName then
					unmutePlayer(targetName)
				end
				text_box.Text = ""
				text_box:ReleaseFocus()
				return
			end

			text_box.Text = ""
			text_box:ReleaseFocus()
			return
		end

		local actualMessage = message
		local teamSend = false

		if isTeamMode and message:sub(1, 6) == "[TEAM]" then
			actualMessage = message:sub(7)
			teamSend = true
		end

		actualMessage = actualMessage:match("^%s*(.-)%s*$")
		if actualMessage == "" then return end

		local b64 = base64_encode(actualMessage)
		local encrypted = stringToBinary(b64)
		RemoteEvent:FireServer(encrypted, teamSend)

		ignoreTextChanged = true
		lastMessageAfterPrefix = ""
		if isTeamMode then
			text_box.Text = "[TEAM]"
		else
			text_box.Text = ""
		end
		ignoreTextChanged = false
		text_box:ReleaseFocus()
	end

	send_button.MouseButton1Click:Connect(sendMessage)

	text_box:GetPropertyChangedSignal("Text"):Connect(function()
		if ignoreTextChanged then return end

		local text = text_box.Text or ""

		if isTeamMode then
			if text:sub(1, 6) == "[TEAM]" then
				lastMessageAfterPrefix = text:sub(7)
			else
				isTeamMode = false
				ignoreTextChanged = true
				text_box.Text = lastMessageAfterPrefix
				ignoreTextChanged = false
			end
		end
	end)

	local function showInRealChat(playerName, message, colorR, colorG, colorB)
		if mutedPlayers[playerName] then
			return
		end

		if message == " " or message == "" then
			return
		end

		local shown = false
		pcall(function()
			local tcs = game:GetService("TextChatService")
			local channel = tcs.TextChannels:FindFirstChild("RBXGeneral")
			if channel then
				local richText = string.format(
					'<font color="rgb(%d,%d,%d)"><b>%s</b></font>: %s',
					math.floor(colorR),
					math.floor(colorG),
					math.floor(colorB),
					playerName,
					message
				)
				channel:DisplaySystemMessage(richText)
				shown = true
			end
		end)
		if not shown then
			pcall(function()
				starterGui:SetCore("ChatMakeSystemMessage", {
					Text = "[" .. playerName .. "]: " .. message,
					Color = Color3.fromRGB(colorR, colorG, colorB),
					Font = Enum.Font.SourceSansBold,
					FontSize = Enum.FontSize.Size18,
				})
			end)
		end
	end

	RemoteEvent.OnClientEvent:Connect(function(playerName, encryptedMessage, colorR, colorG, colorB, teamMsg)
		if mutedPlayers[playerName] then
			return
		end

		local b64 = binaryToString(encryptedMessage)
		local decrypted = base64_decode(b64)

		local speaker = players:FindFirstChild(playerName)

		local nameToDisplay
		if SCR.PN == "DisplayName" then
			nameToDisplay = speaker and speaker.DisplayName or playerName
		elseif SCR.PN == "Name" then
			nameToDisplay = playerName
		else
			nameToDisplay = SCR.PN
		end

		local displayName = teamMsg and ("[TEAM] " .. nameToDisplay) or nameToDisplay

		showInRealChat(displayName, decrypted, colorR, colorG, colorB)

		if SCR.Bubble and speaker and speaker.Character and speaker.Character:FindFirstChild("Head") then
			pcall(function()
				local tcs = game:GetService("TextChatService")
				if tcs.ChatVersion == Enum.ChatVersion.TextChatService then
					tcs:DisplayBubble(speaker.Character.Head, decrypted)
				else
					game:GetService("Chat"):Chat(speaker.Character.Head, decrypted, Enum.ChatColor.White)
				end
			end)
		end
	end)

	text_box.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			sendMessage()
		end
	end)

	uis.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed then
			if input.KeyCode == Enum.KeyCode.Slash then
				task.wait()
				text_box:CaptureFocus()
			end
		end
	end)

end
