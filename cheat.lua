--[[
    =========================================
      C00LGUI STYLE - CUSTOM LOCAL SCRIPT
      Functions: Fly, Spin, Noclip, Wall Hack, 
                 Wall Climb, Kill Menu, 
                 Walk Speed, Jump Power,
                 God Mode, Invisible
    =========================================
]]

print("[C00LGUI] Скрипт запущен! Инициализация...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Цвета стиля c00lgui
local COLOR_BG = Color3.fromRGB(0, 0, 0)       -- Черный фон
local COLOR_BORDER = Color3.fromRGB(200, 0, 0) -- Ярко-красная обводка
local COLOR_TEXT = Color3.fromRGB(255, 255, 255)
local COLOR_ON = Color3.fromRGB(0, 255, 0)     -- Зеленый (когда вкл)
local FONT = Enum.Font.Bodoni                  -- Классический строгий шрифт

-- Удаляем старый GUI, если он был
local guiName = "C00lgui_Custom"
local existingGui = player:WaitForChild("PlayerGui"):FindFirstChild(guiName)
if existingGui then
	existingGui:Destroy()
	print("[C00LGUI] Старый GUI удален.")
end

-- Создаем ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

print("[C00LGUI] Базовый ScreenGui создан!")

-- ==========================================
-- ПОСТРОЕНИЕ ИНТЕРФЕЙСА В СТИЛЕ C00LGUI
-- ==========================================

-- Главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 480) -- Увеличил размер для новых кнопок
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -240)
mainFrame.BackgroundColor3 = COLOR_BG 
mainFrame.BorderSizePixel = 4
mainFrame.BorderColor3 = COLOR_BORDER
mainFrame.Parent = screenGui

-- Обновленная функция для создания ячеек
local function createCell(parent, size, pos)
	local cell = Instance.new("Frame")
	cell.Size = size
	if pos then cell.Position = pos end
	cell.BackgroundColor3 = COLOR_BG
	cell.BorderSizePixel = 1
	cell.BorderColor3 = COLOR_BORDER
	cell.Parent = parent
	return cell
end

-- Заголовок "C00Lgui"
local titleCell = createCell(mainFrame, UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 0))
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "C00Lgui"
titleText.TextColor3 = COLOR_TEXT
titleText.TextSize = 28
titleText.Font = FONT
titleText.Parent = titleCell

-- Блок со стрелочками < и >
local arrowContainer = Instance.new("Frame")
arrowContainer.Size = UDim2.new(1, 0, 0, 35)
arrowContainer.Position = UDim2.new(0, 0, 0, 44)
arrowContainer.BackgroundColor3 = COLOR_BG
arrowContainer.BorderSizePixel = 0
arrowContainer.Parent = mainFrame

local arrowGrid = Instance.new("UIGridLayout")
arrowGrid.CellPadding = UDim2.new(0, 0, 0, 0)
arrowGrid.CellSize = UDim2.new(0.5, 0, 1, 0)
arrowGrid.Parent = arrowContainer

local leftArrowCell = createCell(arrowContainer, UDim2.new(1,0,1,0))
local leftArrow = titleText:Clone()
leftArrow.Text = "<"
leftArrow.Parent = leftArrowCell

local rightArrowCell = createCell(arrowContainer, UDim2.new(1,0,1,0))
local rightArrow = titleText:Clone()
rightArrow.Text = ">"
rightArrow.Parent = rightArrowCell

-- Категория "Local Hacks"
local catCell = createCell(mainFrame, UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 83))
local catText = titleText:Clone()
catText.Text = "Local Player Hacks"
catText.TextSize = 18
catText.Font = Enum.Font.SourceSansBold
catText.Parent = catCell

-- Контейнер для сетки кнопок
local buttonsContainer = Instance.new("Frame")
buttonsContainer.Size = UDim2.new(1, 0, 1, -117)
buttonsContainer.Position = UDim2.new(0, 0, 0, 117)
buttonsContainer.BackgroundColor3 = COLOR_BG
buttonsContainer.BorderSizePixel = 0
buttonsContainer.Parent = mainFrame

local buttonGrid = Instance.new("UIGridLayout")
buttonGrid.CellPadding = UDim2.new(0, 0, 0, 0)
buttonGrid.CellSize = UDim2.new(0.5, 0, 0, 40)
buttonGrid.SortOrder = Enum.SortOrder.LayoutOrder
buttonGrid.Parent = buttonsContainer

-- Функция создания кнопки
local function createButton(name, layoutOrder, isToggle, onClick)
	local btnCell = createCell(buttonsContainer, UDim2.new(1,0,1,0))
	btnCell.LayoutOrder = layoutOrder

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = name
	btn.TextColor3 = COLOR_TEXT
	btn.TextSize = 16
	btn.Font = Enum.Font.SourceSansBold
	btn.Parent = btnCell

	local toggled = false
	btn.MouseButton1Click:Connect(function()
		if isToggle then
			toggled = not toggled
			btn.TextColor3 = toggled and COLOR_ON or COLOR_TEXT
		end
		onClick(toggled)
	end)
	return btn
end

-- ==========================================
-- СКРИПТ ПЛАВНОГО ПЕРЕТАСКИВАНИЯ ОКОН
-- ==========================================
local function makeDraggable(frame)
	local dragging, dragInput, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end
makeDraggable(mainFrame)

-- ==========================================
-- ЛОГИКА ФУНКЦИЙ
-- ==========================================

local flyConnection, spinObj, noclipConnection, climbConnection, espConnection, godConnection

-- 1. FLY
local flySpeed = 50
local isFlying = false
local function toggleFly(state)
	isFlying = state
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local hrp = char.HumanoidRootPart

	if isFlying then
		char.Humanoid.PlatformStand = true
		local bv = Instance.new("BodyVelocity")
		bv.Name = "FlyVelocity"
		bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		bv.Velocity = Vector3.new(0, 0, 0)
		bv.Parent = hrp

		local bg = Instance.new("BodyGyro")
		bg.Name = "FlyGyro"
		bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.CFrame = hrp.CFrame
		bg.Parent = hrp

		flyConnection = RunService.RenderStepped:Connect(function()
			if not isFlying or not char:FindFirstChild("HumanoidRootPart") then return end
			local camCF = camera.CFrame
			local moveDir = Vector3.new(0, 0, 0)

			if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.E) then moveDir = moveDir + Vector3.new(0, 1, 0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveDir = moveDir - Vector3.new(0, 1, 0) end

			if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
			bv.Velocity = moveDir * flySpeed
			bg.CFrame = camCF
		end)
	else
		char.Humanoid.PlatformStand = false
		if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
		if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
		if flyConnection then flyConnection:Disconnect() end
	end
end
createButton("Fly", 1, true, toggleFly)

-- 2. SPIN
local spinSpeed = 150
local function toggleSpin(state)
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local hrp = char.HumanoidRootPart

	if state then
		spinObj = Instance.new("BodyAngularVelocity")
		spinObj.Name = "SpinHacks"
		spinObj.MaxTorque = Vector3.new(0, 9e9, 0)
		spinObj.AngularVelocity = Vector3.new(0, spinSpeed, 0)
		spinObj.Parent = hrp
	else
		if hrp:FindFirstChild("SpinHacks") then hrp.SpinHacks:Destroy() end
		if spinObj then spinObj:Destroy() end
	end
end
createButton("Spin", 2, true, toggleSpin)

-- 3. NOCLIP
local isNoclip = false
local function toggleNoclip(state)
	isNoclip = state
	local char = player.Character
	if not char then return end

	if isNoclip then
		noclipConnection = RunService.Stepped:Connect(function()
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") and part.CanCollide then
					part.CanCollide = false
				end
			end
		end)
	else
		if noclipConnection then noclipConnection:Disconnect() end
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
end
createButton("Noclip", 3, true, toggleNoclip)

-- 4. WALL HACK (ESP)
local espEnabled = false
local espObjects = {}

local function createESP(plr)
	if plr == player or not plr.Character then return end

	local highlight = Instance.new("Highlight")
	highlight.Name = "ESP_Highlight"
	highlight.FillColor = Color3.fromRGB(255, 0, 0)
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.FillTransparency = 0.5
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Parent = plr.Character
	table.insert(espObjects, highlight)

	local head = plr.Character:FindFirstChild("Head")
	if head then
		local bill = Instance.new("BillboardGui")
		bill.Name = "ESP_Name"
		bill.AlwaysOnTop = true
		bill.Size = UDim2.new(0, 100, 0, 40)
		bill.ExtentsOffset = Vector3.new(0, 2, 0)

		local txt = Instance.new("TextLabel")
		txt.Size = UDim2.new(1, 0, 1, 0)
		txt.BackgroundTransparency = 1
		txt.Text = plr.Name
		txt.TextColor3 = Color3.fromRGB(0, 255, 0)
		txt.TextStrokeTransparency = 0
		txt.Font = Enum.Font.SourceSansBold
		txt.TextSize = 14
		txt.Parent = bill

		bill.Parent = head
		table.insert(espObjects, bill)
	end
end

local function toggleESP(state)
	espEnabled = state
	if espEnabled then
		espConnection = task.spawn(function()
			while espEnabled do
				for _, obj in pairs(espObjects) do
					if obj then obj:Destroy() end
				end
				espObjects = {}
				for _, plr in pairs(Players:GetPlayers()) do
					createESP(plr)
				end
				task.wait(1)
			end
		end)
	else
		for _, obj in pairs(espObjects) do
			if obj then obj:Destroy() end
		end
		espObjects = {}
	end
end
createButton("Wall Hack", 4, true, toggleESP)

-- 5. WALL CLIMB
local isClimbing = false
local climbSpeed = 25
local function toggleClimb(state)
	isClimbing = state
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end

	if isClimbing then
		climbConnection = RunService.RenderStepped:Connect(function()
			if not isClimbing then return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then return end

			local rayOrigin = hrp.Position
			local rayDirection = hrp.CFrame.LookVector * 2.5
			local rayParams = RaycastParams.new()
			rayParams.FilterDescendantsInstances = {char}
			rayParams.FilterType = Enum.RaycastFilterType.Exclude

			local rayResult = workspace:Raycast(rayOrigin, rayDirection, rayParams)

			if rayResult and UserInputService:IsKeyDown(Enum.KeyCode.W) then
				hrp.Velocity = Vector3.new(hrp.Velocity.X, climbSpeed, hrp.Velocity.Z)
			end
		end)
	else
		if climbConnection then climbConnection:Disconnect() end
	end
end
createButton("Wall Climb", 5, true, toggleClimb)

-- 6. GOD MODE
local function toggleGod(state)
	local hum = player.Character and player.Character:FindFirstChild("Humanoid")
	if hum then
		hum.MaxHealth = state and math.huge or 100
		hum.Health = hum.MaxHealth
	end
end
createButton("God Mode", 6, true, toggleGod)

-- 7. INVISIBLE
local function toggleInvisible(state)
	local char = player.Character
	if not char then return end
	for _, part in pairs(char:GetDescendants()) do
		if part:IsA("BasePart") or part:IsA("Decal") then
			part.Transparency = state and 1 or 0
		end
	end
end
createButton("Invisible", 7, true, toggleInvisible)

-- 8. KILL MENU
local killMenuFrame = Instance.new("Frame")
killMenuFrame.Name = "KillMenuFrame"
killMenuFrame.Size = UDim2.new(0, 200, 0, 300)
killMenuFrame.Position = UDim2.new(0.5, 170, 0.5, -190)
killMenuFrame.BackgroundColor3 = COLOR_BG
killMenuFrame.BorderSizePixel = 4
killMenuFrame.BorderColor3 = COLOR_BORDER
killMenuFrame.Visible = false
killMenuFrame.Parent = screenGui
makeDraggable(killMenuFrame)

local kmTitleCell = createCell(killMenuFrame, UDim2.new(1, 0, 0, 40), UDim2.new(0,0,0,0))
local kmTitleText = titleText:Clone()
kmTitleText.Text = "Kill Player"
kmTitleText.TextSize = 22
kmTitleText.Parent = kmTitleCell

local kmScroll = Instance.new("ScrollingFrame")
kmScroll.Size = UDim2.new(1, 0, 1, -44)
kmScroll.Position = UDim2.new(0, 0, 0, 44)
kmScroll.BackgroundColor3 = COLOR_BG
kmScroll.BorderSizePixel = 0
kmScroll.ScrollBarThickness = 6
kmScroll.ScrollBarImageColor3 = COLOR_BORDER
kmScroll.Parent = killMenuFrame

local kmListLayout = Instance.new("UIListLayout")
kmListLayout.SortOrder = Enum.SortOrder.Name
kmListLayout.Padding = UDim.new(0, 2)
kmListLayout.Parent = kmScroll

local function updateKillMenu()
	for _, child in pairs(kmScroll:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end

	local pList = Players:GetPlayers()
	kmScroll.CanvasSize = UDim2.new(0, 0, 0, #pList * 32)

	for _, p in pairs(pList) do
		local pBtn = Instance.new("TextButton")
		pBtn.Size = UDim2.new(1, -10, 0, 30)
		pBtn.BackgroundColor3 = COLOR_BG
		pBtn.BorderColor3 = COLOR_BORDER
		pBtn.BorderSizePixel = 1
		pBtn.Text = p.Name
		pBtn.Font = Enum.Font.SourceSansBold
		pBtn.TextSize = 14

		if p == player then
			pBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
			pBtn.Text = p.Name .. " (You)"
		else
			pBtn.TextColor3 = COLOR_TEXT
		end
		pBtn.Parent = kmScroll

		pBtn.MouseButton1Click:Connect(function()
			if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local expl = Instance.new("Explosion")
				expl.Position = p.Character.HumanoidRootPart.Position
				expl.BlastRadius = 10
				expl.Parent = workspace
				if p.Character:FindFirstChild("Humanoid") then
					p.Character.Humanoid.Health = 0
				end
			end
		end)
	end
end

createButton("Kill Menu >", 8, false, function()
	killMenuFrame.Visible = not killMenuFrame.Visible
	if killMenuFrame.Visible then
		updateKillMenu()
	end
end)


-- ==========================================
-- ФУНКЦИИ: WALK SPEED И JUMP POWER
-- ==========================================

local currentWalkSpeed = 16
local currentJumpPower = 50

local function createInputMenu(title, defaultVal, posYOffset, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 160, 0, 90)
	frame.Position = UDim2.new(0.5, -340, 0.5, posYOffset) 
	frame.BackgroundColor3 = COLOR_BG
	frame.BorderSizePixel = 4
	frame.BorderColor3 = COLOR_BORDER
	frame.Visible = false
	frame.Parent = screenGui
	makeDraggable(frame)

	local topCell = createCell(frame, UDim2.new(1, 0, 0, 30), UDim2.new(0,0,0,0))
	local topText = titleText:Clone()
	topText.Text = title
	topText.TextSize = 18
	topText.Parent = topCell

	local textBox = Instance.new("TextBox")
	textBox.Size = UDim2.new(1, -20, 0, 30)
	textBox.Position = UDim2.new(0, 10, 0, 45)
	textBox.BackgroundColor3 = COLOR_BG
	textBox.BorderColor3 = COLOR_BORDER
	textBox.BorderSizePixel = 1
	textBox.TextColor3 = COLOR_TEXT
	textBox.Font = Enum.Font.SourceSansBold
	textBox.TextSize = 18
	textBox.Text = tostring(defaultVal)
	textBox.ClearTextOnFocus = false
	textBox.Parent = frame

	textBox.FocusLost:Connect(function()
		local num = tonumber(textBox.Text)
		if num then
			callback(num)
			textBox.TextColor3 = COLOR_ON 
			task.wait(0.5)
			textBox.TextColor3 = COLOR_TEXT
		else
			textBox.Text = tostring(defaultVal)
		end
	end)

	return frame
end

local wsMenu = createInputMenu("Walk Speed", 16, -190, function(val)
	currentWalkSpeed = val
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = val
	end
end)

createButton("Walk Speed >", 9, false, function()
	wsMenu.Visible = not wsMenu.Visible
end)

local jpMenu = createInputMenu("Jump Power", 50, -80, function(val)
	currentJumpPower = val
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.UseJumpPower = true
		player.Character.Humanoid.JumpPower = val
	end
end)

createButton("Jump Power >", 10, false, function()
	jpMenu.Visible = not jpMenu.Visible
end)


-- ==========================================
-- УПРАВЛЕНИЕ И СБРОС (RightShift для скрытия)
-- ==========================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
		mainFrame.Visible = not mainFrame.Visible
		if not mainFrame.Visible then 
			killMenuFrame.Visible = false 
			wsMenu.Visible = false
			jpMenu.Visible = false
		end
	end
end)

Players.PlayerAdded:Connect(function() if killMenuFrame.Visible then updateKillMenu() end end)
Players.PlayerRemoving:Connect(function() if killMenuFrame.Visible then updateKillMenu() end end)

player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	if isFlying then toggleFly(true) end
	if spinObj and spinObj.Parent == nil then toggleSpin(true) end

	local hum = char:WaitForChild("Humanoid", 3)
	if hum then
		if currentWalkSpeed ~= 16 then hum.WalkSpeed = currentWalkSpeed end
		if currentJumpPower ~= 50 then 
			hum.UseJumpPower = true
			hum.JumpPower = currentJumpPower 
		end
	end
end)

print("[C00LGUI] Все интерфейсы и функции загружены успешно!")
