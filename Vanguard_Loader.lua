-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local mouse = LocalPlayer:GetMouse()

-- SETTINGS
local ESP_SETTINGS = {
	HeadCircleEnabled = true,
	SkeletonEnabled = true,
	TeamCheckEnabled = true,
	NameEnabled = true,
	DistanceEnabled = true,
}

local AIM_SETTINGS = {
	Enabled = true,
	TeamCheck = false,
	AimPart = "Head",
	HoldingAim = false,
	TriggerbotEnabled = false, -- New setting for the triggerbot
	TriggerbotToggleKey = Enum.KeyCode.H,
}

-- Per-player data storage
local ESP_DATA = {}

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESPMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui
ScreenGui.Enabled = true -- This is now enabled from the start

-- MAIN FRAME
local Frame = Instance.new("Frame")
-- Start the frame at a smaller size and a centered position
Frame.Size = UDim2.new(0, 150, 0, 150)
Frame.Position = UDim2.new(0.5, -75, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.BackgroundTransparency = 1 -- Start transparent for the welcome animation

-- HEADER
local Heading = Instance.new("Frame")
Heading.Size = UDim2.new(1,0,0,35)
Heading.Position = UDim2.new(0,0,0,0)
Heading.BackgroundTransparency = 1
Heading.Parent = Frame

-- HEADER LEFT
local HeadingLeft = Instance.new("Frame")
HeadingLeft.Size = UDim2.new(0.25,0,1,0)
HeadingLeft.Position = UDim2.new(0,0,0,0)
HeadingLeft.BackgroundColor3 = Color3.fromRGB(0,0,0)
HeadingLeft.Parent = Heading

-- HEADER RIGHT
local HeadingRight = Instance.new("Frame")
HeadingRight.Size = UDim2.new(0.75,0,1,0)
HeadingRight.Position = UDim2.new(0.25,0,0,0)
HeadingRight.BackgroundColor3 = Color3.fromRGB(25,25,25)
HeadingRight.Parent = Heading

-- WELCOME TEXT (Initial)
local welcomeText = Instance.new("TextLabel")
welcomeText.Size = UDim2.new(1,0,1,0)
welcomeText.Position = UDim2.new(0,0,0,0)
welcomeText.BackgroundTransparency = 1
welcomeText.Text = "Welcome, " .. LocalPlayer.DisplayName
welcomeText.TextColor3 = Color3.new(1,1,1)
welcomeText.TextStrokeColor3 = Color3.fromRGB(128,0,128)
welcomeText.TextStrokeTransparency = 0
welcomeText.TextScaled = true
welcomeText.Font = Enum.Font.GothamBold
welcomeText.Parent = Heading

-- VANGUARD TITLE (Hidden initially)
local HeadingText = Instance.new("TextLabel")
HeadingText.Size = UDim2.new(1,0,1,0)
HeadingText.Position = UDim2.new(0,0,0,0)
HeadingText.BackgroundTransparency = 1
HeadingText.Text = "VANGUARD"
HeadingText.TextColor3 = Color3.new(1,1,1)
HeadingText.TextStrokeColor3 = Color3.fromRGB(128,0,128)
HeadingText.TextStrokeTransparency = 0
HeadingText.TextScaled = true
HeadingText.Font = Enum.Font.GothamBold
HeadingText.Parent = Heading
HeadingText.TextTransparency = 1 -- Start invisible

-- FADE IN WELCOME TEXT, FADE IN FRAME, THEN FADE OUT WELCOME TEXT
-- Tween the frame to its full size and final position
TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
	BackgroundTransparency = 0,
	Size = UDim2.new(0,400,0,400),
	Position = UDim2.new(0,50,0.5,-200),
}):Play()
TweenService:Create(welcomeText, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {TextTransparency = 0}):Play()
task.wait(2)
TweenService:Create(welcomeText, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()
TweenService:Create(HeadingText, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {TextTransparency = 0}):Play()
task.wait(0.5)
welcomeText:Destroy()


-- SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0,100,1,-35)
Sidebar.Position = UDim2.new(0,0,0,35)
Sidebar.BackgroundColor3 = Color3.fromRGB(0,0,0)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Frame

-- CONTENT PANEL
local ContentPanel = Instance.new("Frame")
ContentPanel.Size = UDim2.new(1,-100,1,-35)
ContentPanel.Position = UDim2.new(0,100,0,35)
ContentPanel.BackgroundColor3 = Color3.fromRGB(25,25,25)
ContentPanel.BorderSizePixel = 0
ContentPanel.Parent = Frame

-- CLEAR CONTENT PANEL
local function clearContent()
	for _, child in pairs(ContentPanel:GetChildren()) do child:Destroy() end
end

-- CHECKBOX CREATION
local function createCheckbox(name, default, callback)
	local boxFrame = Instance.new("Frame")
	boxFrame.Size = UDim2.new(0,200,0,30)
	boxFrame.Position = UDim2.new(0,10,0,#ContentPanel:GetChildren()*45 + 10)
	boxFrame.BackgroundTransparency = 1
	boxFrame.Parent = ContentPanel -- FIXED: Parented to ContentPanel

	local checkbox = Instance.new("Frame")
	checkbox.Size = UDim2.new(0,20,0,20)
	checkbox.Position = UDim2.new(0,0,0,5)
	checkbox.BackgroundColor3 = default and Color3.fromRGB(255,183,197) or Color3.fromRGB(50,50,50)
	checkbox.BorderSizePixel = 0
	checkbox.Parent = boxFrame

	local uic = Instance.new("UICorner")
	uic.CornerRadius = UDim.new(0,5)
	uic.Parent = checkbox

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0,150,0,30)
	label.Position = UDim2.new(0,30,0,0)
	label.Text = name
	label.TextColor3 = Color3.new(1,1,1)
	label.TextScaled = true
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamSemibold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = boxFrame

	local function toggle()
		default = not default
		checkbox.BackgroundColor3 = default and Color3.fromRGB(255,183,197) or Color3.fromRGB(50,50,50)
		callback(default)
	end

	label.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then toggle() end
	end)
	checkbox.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then toggle() end
	end)
end

-- HINT FUNCTION for toggle feedback
local function showHint(message)
	local hint = Instance.new("TextLabel")
	hint.Size = UDim2.new(0,200,0,30)
	hint.Position = UDim2.new(0.5,-100,0.9,-15)
	hint.BackgroundTransparency = 1
	hint.Text = message
	hint.TextColor3 = Color3.new(1,1,1)
	hint.TextScaled = true
	hint.Font = Enum.Font.GothamBold
	hint.Parent = game.CoreGui
	
	task.delay(1.5, function() hint:Destroy() end)
end

-- SIDEBAR BUTTON
local function createSidebarButton(name, onClick)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,-10,0,40)
	btn.Position = UDim2.new(0,5,0,(#Sidebar:GetChildren()-0.5)*50)
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.BorderSizePixel = 0
	btn.Text = name
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.Parent = Sidebar
	btn.MouseButton1Click:Connect(onClick)
end

-- ESP CATEGORY
local function openESP()
	clearContent()
	createCheckbox("Player Distance", ESP_SETTINGS.DistanceEnabled, function(val) ESP_SETTINGS.DistanceEnabled = val end)
	createCheckbox("Player Bone", ESP_SETTINGS.SkeletonEnabled, function(val) ESP_SETTINGS.SkeletonEnabled = val end)
	createCheckbox("Player Head", ESP_SETTINGS.HeadCircleEnabled, function(val) ESP_SETTINGS.HeadCircleEnabled = val end)
	createCheckbox("Player Name", ESP_SETTINGS.NameEnabled, function(val) ESP_SETTINGS.NameEnabled = val end)
	createCheckbox("Team Check", ESP_SETTINGS.TeamCheckEnabled, function(val) ESP_SETTINGS.TeamCheckEnabled = val end)
end

-- AIM CATEGORY
local function openAim()
	clearContent()
	createCheckbox("Aimbot", AIM_SETTINGS.Enabled, function(val) AIM_SETTINGS.Enabled = val end)
	createCheckbox("Team Check", AIM_SETTINGS.TeamCheck, function(val) AIM_SETTINGS.TeamCheck = val end)
	
	-- Triggerbot Checkbox
	createCheckbox("Triggerbot", AIM_SETTINGS.TriggerbotEnabled, function(val) AIM_SETTINGS.TriggerbotEnabled = val end)
	
	-- AimPart Option
	local aimPartLabel = Instance.new("TextLabel")
	aimPartLabel.Size = UDim2.new(0,150,0,30)
	aimPartLabel.Position = UDim2.new(0,10,0, #ContentPanel:GetChildren()*45 + 10)
	aimPartLabel.Text = "Aim Part: " .. AIM_SETTINGS.AimPart
	aimPartLabel.TextColor3 = Color3.new(1,1,1)
	aimPartLabel.TextScaled = true
	aimPartLabel.BackgroundTransparency = 1
	aimPartLabel.Font = Enum.Font.GothamSemibold
	aimPartLabel.TextXAlignment = Enum.TextXAlignment.Left
	aimPartLabel.Parent = ContentPanel

	local function changeAimPart()
		if AIM_SETTINGS.AimPart == "Head" then
			AIM_SETTINGS.AimPart = "HumanoidRootPart"
		else
			AIM_SETTINGS.AimPart = "Head"
		end
		aimPartLabel.Text = "Aim Part: " .. AIM_SETTINGS.AimPart
	end

	aimPartLabel.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			changeAimPart()
		end
	end)
end

-- CREDITS CATEGORY
local function openCredits()
	clearContent()
	local creditLabel = Instance.new("TextLabel")
	creditLabel.Size = UDim2.new(1, -20, 0, 50)
	creditLabel.Position = UDim2.new(0, 10, 0, 10)
	creditLabel.Text = "Made by Nocturnal"
	creditLabel.TextColor3 = Color3.new(1,1,1)
	creditLabel.TextScaled = true
	creditLabel.Font = Enum.Font.GothamBold
	creditLabel.BackgroundTransparency = 1
	creditLabel.Parent = ContentPanel
end

-- CREATE SIDEBAR BUTTONS
createSidebarButton("ESP", openESP)
createSidebarButton("Aim", openAim)
createSidebarButton("Credits", openCredits)

-- OPEN DEFAULT TAB
openESP()

-- DRAGGING
local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Frame.InputBegan:Connect(function(input, processed)
	-- Only begin dragging if the input was not processed by a child element.
	if processed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
Frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then update(input) end
end)

-- TOGGLE MENU AND TRIGGERBOT
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.Insert then
		ScreenGui.Enabled = not ScreenGui.Enabled
	elseif input.KeyCode == AIM_SETTINGS.TriggerbotToggleKey then
		AIM_SETTINGS.TriggerbotEnabled = not AIM_SETTINGS.TriggerbotEnabled
		showHint("Triggerbot Toggled: " .. tostring(AIM_SETTINGS.TriggerbotEnabled))
		-- Update the checkbox in the GUI
		openAim()
	end
end)

-- DRAW HELPERS
local function createLine()
	local line = Drawing.new("Line")
	line.Thickness = 1.5
	line.Color = Color3.fromRGB(255,183,197) -- pink
	line.Visible = false
	return line
end

local function createCircle()
	local circle = Drawing.new("Circle")
	circle.Thickness = 1.5
	circle.NumSides = 30
	circle.Color = Color3.new(1,1,1) -- white
	circle.Filled = false
	circle.Visible = false
	return circle
end

-- REMOVE ESP
local function removeESP(player)
	local data = ESP_DATA[player]
	if data then
		if data.NameTag then data.NameTag:Remove() end
		if data.Distance then data.Distance:Remove() end
		if data.HeadCircle then data.HeadCircle:Remove() end
		for _, line in pairs(data.Skeleton or {}) do line:Remove() end
		ESP_DATA[player] = nil
	end
end

-- SETUP CHARACTER ESP
local function setupCharacterESP(player,char)
	removeESP(player)
	local humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid",5)
	if not humanoid then return end

	local rigType = humanoid.RigType
	local distanceTag = Drawing.new("Text")
	distanceTag.Size = 14
	distanceTag.Center = true
	distanceTag.Outline = true
	distanceTag.Color = Color3.new(0.6,0.6,0.6)
	distanceTag.Visible = ESP_SETTINGS.DistanceEnabled

	local nameTag = Drawing.new("Text")
	nameTag.Size = 14
	nameTag.Center = true
	nameTag.Outline = true
	nameTag.Color = Color3.fromRGB(255,0,0)
	nameTag.Visible = ESP_SETTINGS.NameEnabled

	local headCircle = createCircle()
	local skeletonLines = {}
	local bonePairs = {}

	if rigType == Enum.HumanoidRigType.R15 then
		bonePairs = {
			{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
			{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
			{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
			{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
			{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}
		}
	else
		bonePairs = {{"Head","Torso"},{"Torso","Left Arm"},{"Left Arm","Left Leg"},{"Torso","Right Arm"},{"Right Arm","Right Leg"}}
	end

	for _, pair in ipairs(bonePairs) do
		local id = table.concat(pair,"_")
		skeletonLines[id] = createLine()
	end

	ESP_DATA[player] = {
		Distance = distanceTag,
		NameTag = nameTag,
		HeadCircle = headCircle,
		Skeleton = skeletonLines,
		BonePairs = bonePairs,
		Character = char
	}

	humanoid.Died:Connect(function() removeESP(player) end)
end

-- SETUP PLAYER ESP
local function setupESP(player)
	if player == LocalPlayer then return end
	player.CharacterAdded:Connect(function(char) setupCharacterESP(player,char) end)
	if player.Character then setupCharacterESP(player,player.Character) end
end

-- PLAYER EVENTS
Players.PlayerAdded:Connect(setupESP)
Players.PlayerRemoving:Connect(removeESP)
for _, player in pairs(Players:GetPlayers()) do setupESP(player) end

-- AIMBOT LOGIC
local function getClosestPlayer()
	local closestPlayer = nil
	local closestMagnitude = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		if player == LocalPlayer then continue end
		if AIM_SETTINGS.TeamCheck and player.Team == LocalPlayer.Team then continue end

		local character = player.Character
		if not character then continue end
		
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local hrp = character:FindFirstChild("HumanoidRootPart")
		
		if not humanoid or humanoid.Health <= 0 or not hrp then continue end

		local screenPoint, onScreen = Camera:WorldToViewportPoint(hrp.Position)
		if onScreen then
			local mousePos = UserInputService:GetMouseLocation()
			local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
			
			if distance < closestMagnitude then
				closestMagnitude = distance
				closestPlayer = player
			end
		end
	end
	return closestPlayer
end

UserInputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		AIM_SETTINGS.HoldingAim = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		AIM_SETTINGS.HoldingAim = false
	end
end)

-- Aimbot main loop
RunService.RenderStepped:Connect(function()
	if AIM_SETTINGS.HoldingAim and AIM_SETTINGS.Enabled then
		local closestPlayer = getClosestPlayer()
		if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild(AIM_SETTINGS.AimPart) then
			local targetPart = closestPlayer.Character[AIM_SETTINGS.AimPart]
			-- Snappy aimbot
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
		end
	end
end)

-- Triggerbot main loop
RunService.RenderStepped:Connect(function()
	-- Check if triggerbot is enabled and the mouse has a valid target
	local target = mouse.Target
	if AIM_SETTINGS.TriggerbotEnabled and target then
		-- Find the target's character and player
		local targetCharacter = target:FindFirstAncestorOfClass("Model")
		local targetPlayer = targetCharacter and Players:GetPlayerFromCharacter(targetCharacter)
		
		-- Check if the target is a valid enemy
		if targetPlayer and targetPlayer ~= LocalPlayer and (not AIM_SETTINGS.TeamCheck or targetPlayer.Team ~= LocalPlayer.Team) then
			local humanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.Health > 0 then
				mouse1press()
				repeat
					RunService.RenderStepped:Wait()
				until not mouse.Target or mouse.Target.Parent ~= targetCharacter
				mouse1release()
			end
		end
	end
end)

-- RENDER LOOP for ESP
RunService.RenderStepped:Connect(function()
	for player,data in pairs(ESP_DATA) do
		local char = data.Character
		if not char then continue end
		local head = char:FindFirstChild("Head")
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not head or not hrp then continue end

		-- TEAM CHECK
		if ESP_SETTINGS.TeamCheckEnabled and player.Team == LocalPlayer.Team then
			data.HeadCircle.Visible = false
			for _,line in pairs(data.Skeleton) do line.Visible = false end
			data.NameTag.Visible = false
			data.Distance.Visible = false
			continue
		end

		local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
		if onScreen then
			-- HEAD CIRCLE
			data.HeadCircle.Visible = ESP_SETTINGS.HeadCircleEnabled
			data.HeadCircle.Position = Vector2.new(screenPos.X, screenPos.Y)
			local offsetPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0.5,0,0))
			data.HeadCircle.Radius = (Vector2.new(offsetPos.X, offsetPos.Y)-Vector2.new(screenPos.X,screenPos.Y)).Magnitude*2

			-- DISTANCE
			data.Distance.Visible = ESP_SETTINGS.DistanceEnabled
			data.Distance.Text = tostring(math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)).." studs"
			data.Distance.Position = Vector2.new(screenPos.X, screenPos.Y - 30)

			-- NAME
			data.NameTag.Visible = ESP_SETTINGS.NameEnabled
			data.NameTag.Text = player.Name
			data.NameTag.Position = Vector2.new(screenPos.X, screenPos.Y - 45)
		else
			data.HeadCircle.Visible = false
			data.Distance.Visible = false
			data.NameTag.Visible = false
		end

		-- SKELETON
		for _,pair in ipairs(data.BonePairs) do
			local p1 = char:FindFirstChild(pair[1])
			local p2 = char:FindFirstChild(pair[2])
			local line = data.Skeleton[table.concat(pair,"_")]
			if ESP_SETTINGS.SkeletonEnabled and p1 and p2 then
				local sp1,on1 = Camera:WorldToViewportPoint(p1.Position)
				local sp2,on2 = Camera:WorldToViewportPoint(p2.Position)
				if on1 and on2 then
					line.From = Vector2.new(sp1.X, sp1.Y)
					line.To = Vector2.new(sp2.X, sp2.Y)
					line.Visible = true
				else
					line.Visible = false
				end
			else
				line.Visible = false
			end
		end
	end
end)
