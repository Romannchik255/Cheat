-- STREAMING_CHUNK: Инициализация сервисов и локальных переменных
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- БАГФИКС: Удаляем старое меню, чтобы не было фантомных дубликатов после смерти
local oldGui = player:WaitForChild("PlayerGui"):FindFirstChild("C00lGui_Reborn")
if oldGui then
	oldGui:Destroy()
end

-- STREAMING_CHUNK: Создание ScreenGui и главного окна
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "C00lGui_Reborn"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Увеличили размер окна до 380, чтобы влезла кнопка Wall Climb
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 380)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -145)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- STREAMING_CHUNK: Создание заголовка главного меню
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "c00lgui v1"
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local separator = Instance.new("Frame")
separator.Size = UDim2.new(1, 0, 0, 2)
separator.Position = UDim2.new(0, 0, 0, 30)
separator.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
separator.BorderSizePixel = 0
separator.Parent = mainFrame

-- STREAMING_CHUNK: Создание окна Kill Menu
local killFrame = Instance.new("Frame")
killFrame.Name = "KillFrame"
killFrame.Size = UDim2.new(0, 200, 0, 250)
killFrame.Position = UDim2.new(0.5, 120, 0.5, -125)
killFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
killFrame.BorderSizePixel = 0
killFrame.Visible = false
killFrame.Parent = screenGui

local killCorner = Instance.new("UICorner")
killCorner.CornerRadius = UDim.new(0, 8)
killCorner.Parent = killFrame

local killTitle = Instance.new("TextLabel")
killTitle.Size = UDim2.new(1, 0, 0, 30)
killTitle.BackgroundTransparency = 1
killTitle.Text = "Select Target"
killTitle.TextColor3 = Color3.fromRGB(255, 50, 50)
killTitle.TextSize = 18
killTitle.Font = Enum.Font.GothamBold
killTitle.Parent = killFrame

-- STREAMING_CHUNK: Настройка прокрутки для Kill Menu
local killSeparator = Instance.new("Frame")
killSeparator.Size = UDim2.new(1, 0, 0, 2)
killSeparator.Position = UDim2.new(0, 0, 0, 30)
killSeparator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
killSeparator.BorderSizePixel = 0
killSeparator.Parent = killFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -40)
scrollFrame.Position = UDim2.new(0, 5, 0, 35)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 4
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = killFrame

local scrollLayout = Instance.new("UIListLayout")
scrollLayout.Padding = UDim.new(0, 5)
scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
scrollLayout.Parent = scrollFrame

-- STREAMING_CHUNK: Логика перетаскивания окон (Drag)
local function makeDraggable(frame)
	local dragging, dragInput, mousePos, framePos

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			mousePos = input.Position
			framePos = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
		end
	end)


end

makeDraggable(mainFrame)
makeDraggable(killFrame)

-- STREAMING_CHUNK: Создание контейнера кнопок и функции createButton
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, -20, 1, -40)
buttonContainer.Position = UDim2.new(0, 10, 0, 40)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = buttonContainer

local function createButton(name, text, parent)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(1, 0, 0, 35)
	button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 16
	button.Font = Enum.Font.GothamSemibold
	button.AutoButtonColor = false
	button.Parent = parent

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = button

	-- Анимация наведения
	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
	end)
	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
	end)

	return button


end

-- STREAMING_CHUNK: Инициализация кнопок меню
local flyButton = createButton("FlyButton", "Fly [OFF]", buttonContainer)
local spinButton = createButton("SpinButton", "Spin [OFF]", buttonContainer)
local noclipButton = createButton("NoclipButton", "Noclip [OFF]", buttonContainer)
local wallHackButton = createButton("WallHackButton", "Wall Hack [OFF]", buttonContainer)
local wallClimbButton = createButton("WallClimbButton", "Wall Climb [OFF]", buttonContainer)
local openKillMenuBtn = createButton("KillMenuBtn", "Kill Menu >", buttonContainer)

-- Базовые красные цвета для специфичных кнопок при старте
noclipButton.TextColor3 = Color3.fromRGB(255, 50, 50)
wallHackButton.TextColor3 = Color3.fromRGB(255, 50, 50)
wallClimbButton.TextColor3 = Color3.fromRGB(255, 50, 50)
openKillMenuBtn.TextColor3 = Color3.fromRGB(255, 100, 100)

-- STREAMING_CHUNK: Переменные состояния читов
local flying = false
local flySpeed = 50
local flyCtrl = {f = 0, b = 0, l = 0, r = 0, u = 0, d = 0}

local spinning = false
local spinSpeed = 150
local spinVelocity = nil

local noclipping = false
local wallHackOn = false

local wallClimbOn = false
local wallClimbBV = nil

-- STREAMING_CHUNK: Функции Kill Menu (Бомба)
local function executeKill(targetPlayer)
	if targetPlayer and targetPlayer.Character then
		local char = targetPlayer.Character
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChild("Humanoid")

		if hrp and hum then
			-- Создаем взрыв (Бомбу)
			local explosion = Instance.new("Explosion")
			explosion.Position = hrp.Position
			explosion.BlastRadius = 12
			explosion.BlastPressure = 500000
			explosion.DestroyJointRadiusPercent = 1
			explosion.Parent = Workspace

			-- Убиваем игрока
			hum.Health = 0
		end
	end


end

local function refreshKillList()
	-- Очищаем старый список
	for _, child in pairs(scrollFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	-- Добавляем всех текущих игроков
	local yOffset = 0
	for _, p in pairs(Players:GetPlayers()) do
		local pBtn = createButton(p.Name.."_Btn", p.Name, scrollFrame)
		pBtn.Size = UDim2.new(1, -10, 0, 30)

		if p == player then
			pBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
			pBtn.Text = p.Name .. " (You)"
		end

		pBtn.MouseButton1Click:Connect(function()
			executeKill(p)
		end)

		yOffset = yOffset + 35
	end

	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)


end

-- STREAMING_CHUNK: Функции Spin (Кручение без падений)
local function startSpin()
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end
	local hrp = character.HumanoidRootPart

	-- Используем BodyAngularVelocity и применяем силу ТОЛЬКО по оси Y
	spinVelocity = Instance.new("BodyAngularVelocity")
	spinVelocity.Name = "SpinVelocity"
	spinVelocity.AngularVelocity = Vector3.new(0, spinSpeed, 0)
	-- MaxTorque на X и Z равен 0, поэтому мы не будем падать!
	spinVelocity.MaxTorque = Vector3.new(0, 9e9, 0)
	spinVelocity.Parent = hrp


end

local function stopSpin()
	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		local hrp = character.HumanoidRootPart
		if hrp:FindFirstChild("SpinVelocity") then
			hrp.SpinVelocity:Destroy()
		end
	end
	if spinVelocity then
		spinVelocity:Destroy()
		spinVelocity = nil
	end
end

-- STREAMING_CHUNK: Функции Fly (Плавный полет)
local bg, bv

local function startFly()
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Humanoid") then return end
	local hrp = character.HumanoidRootPart

	bg = Instance.new("BodyGyro", hrp)
	bg.P = 9e4
	bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	bg.cframe = hrp.CFrame

	bv = Instance.new("BodyVelocity", hrp)
	bv.velocity = Vector3.new(0,0,0)
	bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

	character.Humanoid.PlatformStand = true


end

local function stopFly()
	local character = player.Character
	if character and character:FindFirstChild("Humanoid") then
		character.Humanoid.PlatformStand = false
	end
	if bg then bg:Destroy() end
	if bv then bv:Destroy() end
end

-- STREAMING_CHUNK: Логика Noclip (Сквозь стены)
RunService.Stepped:Connect(function()
	if noclipping and player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- STREAMING_CHUNK: Логика Wall Hack (ESP)
task.spawn(function()
	while task.wait(1) do
		if wallHackOn then
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local char = p.Character

					if not char:FindFirstChild("ESP_Highlight") then
						local hl = Instance.new("Highlight")
						hl.Name = "ESP_Highlight"
						hl.FillColor = Color3.fromRGB(255, 50, 50)
						hl.OutlineColor = Color3.fromRGB(255, 255, 255)
						hl.FillTransparency = 0.5
						hl.OutlineTransparency = 0
						hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						hl.Parent = char
					end

					if not char:FindFirstChild("ESP_Name") then
						local bgui = Instance.new("BillboardGui")
						bgui.Name = "ESP_Name"
						bgui.AlwaysOnTop = true
						bgui.Size = UDim2.new(0, 200, 0, 50)
						bgui.StudsOffset = Vector3.new(0, 3, 0)
						bgui.Adornee = char:FindFirstChild("Head") or char.HumanoidRootPart

						local txt = Instance.new("TextLabel")
						txt.Size = UDim2.new(1, 0, 1, 0)
						txt.BackgroundTransparency = 1
						txt.Text = p.Name
						txt.TextColor3 = Color3.fromRGB(0, 255, 0)
						txt.TextStrokeTransparency = 0
						txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
						txt.TextSize = 14
						txt.Font = Enum.Font.GothamBold
						txt.Parent = bgui

						bgui.Parent = char
					end
				end
			end
		end
	end


end)

-- STREAMING_CHUNK: Логика Wall Climb (Виртуальная лестница)
RunService.RenderStepped:Connect(function()
	if wallClimbOn and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
		local hrp = player.Character.HumanoidRootPart
		local hum = player.Character.Humanoid

		-- Выпускаем невидимый луч (Raycast) вперед, чтобы найти стену
		local rayParams = RaycastParams.new()
		rayParams.FilterDescendantsInstances = {player.Character}
		rayParams.FilterType = Enum.RaycastFilterType.Exclude

		-- Луч длиной 2.5 стада вперед
		local rayResult = Workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 2.5, rayParams)

		-- Если уперлись в стену и идем вперед (зажата W)
		if rayResult and UserInputService:IsKeyDown(Enum.KeyCode.W) then
			-- Создаем тягу вверх (эффект лестницы)
			if not wallClimbBV then
				wallClimbBV = Instance.new("BodyVelocity")
				wallClimbBV.Name = "WallClimb_BV"
				wallClimbBV.MaxForce = Vector3.new(0, 100000, 0)
				wallClimbBV.Velocity = Vector3.new(0, 25, 0) -- Скорость подъема по стене
				wallClimbBV.Parent = hrp
			end
			-- Включаем анимацию карабканья!
			if hum:GetState() ~= Enum.HumanoidStateType.Climbing then
				hum:ChangeState(Enum.HumanoidStateType.Climbing)
			end
		else
			-- Убираем тягу, если отпустили стену или W
			if wallClimbBV then
				wallClimbBV:Destroy()
				wallClimbBV = nil
			end
		end
	end


end)

-- STREAMING_CHUNK: Ввод для полета
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.W then flyCtrl.f = 1
	elseif input.KeyCode == Enum.KeyCode.S then flyCtrl.b = -1
	elseif input.KeyCode == Enum.KeyCode.A then flyCtrl.l = -1
	elseif input.KeyCode == Enum.KeyCode.D then flyCtrl.r = 1
	elseif input.KeyCode == Enum.KeyCode.E then flyCtrl.u = 1
	elseif input.KeyCode == Enum.KeyCode.Q then flyCtrl.d = -1
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.W then flyCtrl.f = 0
	elseif input.KeyCode == Enum.KeyCode.S then flyCtrl.b = 0
	elseif input.KeyCode == Enum.KeyCode.A then flyCtrl.l = 0
	elseif input.KeyCode == Enum.KeyCode.D then flyCtrl.r = 0
	elseif input.KeyCode == Enum.KeyCode.E then flyCtrl.u = 0
	elseif input.KeyCode == Enum.KeyCode.Q then flyCtrl.d = 0
	end
end)

-- STREAMING_CHUNK: Основной цикл полета
RunService.RenderStepped:Connect(function()
	if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and bg and bv then
		local hrp = player.Character.HumanoidRootPart
		local camCFrame = camera.CFrame

		local moveDir = Vector3.new(0,0,0)
		moveDir = moveDir + (camCFrame.LookVector * (flyCtrl.f + flyCtrl.b))
		moveDir = moveDir + (camCFrame.RightVector * (flyCtrl.l + flyCtrl.r))
		moveDir = moveDir + (camCFrame.UpVector * (flyCtrl.u + flyCtrl.d))

		if moveDir.Magnitude > 0 then
			moveDir = moveDir.Unit
		end

		bv.Velocity = moveDir * flySpeed
		bg.CFrame = camCFrame
	end


end)

-- STREAMING_CHUNK: Обработчики кнопок меню (Тут же Wall Climb)
flyButton.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		flyButton.Text = "Fly [ON]"
		flyButton.TextColor3 = Color3.fromRGB(0, 255, 0)
		startFly()
	else
		flyButton.Text = "Fly [OFF]"
		flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		stopFly()
	end
end)

spinButton.MouseButton1Click:Connect(function()
	spinning = not spinning
	if spinning then
		spinButton.Text = "Spin [ON]"
		spinButton.TextColor3 = Color3.fromRGB(0, 255, 0)
		startSpin()
	else
		spinButton.Text = "Spin [OFF]"
		spinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		stopSpin()
	end
end)

noclipButton.MouseButton1Click:Connect(function()
	noclipping = not noclipping
	if noclipping then
		noclipButton.Text = "Noclip [ON]"
		noclipButton.TextColor3 = Color3.fromRGB(0, 255, 0)
	else
		noclipButton.Text = "Noclip [OFF]"
		noclipButton.TextColor3 = Color3.fromRGB(255, 50, 50)

		-- Моментальный возврат коллизии при выключении
		if player.Character then
			for _, part in pairs(player.Character:GetChildren()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
				end
			end
		end
	end


end)

wallHackButton.MouseButton1Click:Connect(function()
	wallHackOn = not wallHackOn
	if wallHackOn then
		wallHackButton.Text = "Wall Hack [ON]"
		wallHackButton.TextColor3 = Color3.fromRGB(0, 255, 0)
	else
		wallHackButton.Text = "Wall Hack [OFF]"
		wallHackButton.TextColor3 = Color3.fromRGB(255, 50, 50)

		-- Убираем подсветку ESP сразу при выключении
		for _, p in pairs(Players:GetPlayers()) do
			if p.Character then
				local hl = p.Character:FindFirstChild("ESP_Highlight")
				if hl then hl:Destroy() end

				local bgui = p.Character:FindFirstChild("ESP_Name")
				if bgui then bgui:Destroy() end
			end
		end
	end


end)

wallClimbButton.MouseButton1Click:Connect(function()
	wallClimbOn = not wallClimbOn
	if wallClimbOn then
		wallClimbButton.Text = "Wall Climb [ON]"
		wallClimbButton.TextColor3 = Color3.fromRGB(0, 255, 0)
	else
		wallClimbButton.Text = "Wall Climb [OFF]"
		wallClimbButton.TextColor3 = Color3.fromRGB(255, 50, 50)
		if wallClimbBV then
			wallClimbBV:Destroy()
			wallClimbBV = nil
		end
	end
end)

openKillMenuBtn.MouseButton1Click:Connect(function()
	killFrame.Visible = not killFrame.Visible
	if killFrame.Visible then
		openKillMenuBtn.Text = "Kill Menu [OPEN]"
		refreshKillList()
	else
		openKillMenuBtn.Text = "Kill Menu >"
	end
end)

-- STREAMING_CHUNK: Горячая клавиша и сброс состояния при возрождении
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
		mainFrame.Visible = not mainFrame.Visible
		if not mainFrame.Visible then
			killFrame.Visible = false
		end
	end
end)

player.CharacterAdded:Connect(function()
	if flying then
		flying = false
		flyButton.Text = "Fly [OFF]"
		flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		stopFly()
	end
	if spinning then
		spinning = false
		spinButton.Text = "Spin [OFF]"
		spinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		stopSpin()
	end
	if noclipping then
		noclipping = false
		noclipButton.Text = "Noclip [OFF]"
		noclipButton.TextColor3 = Color3.fromRGB(255, 50, 50)
	end
	if wallClimbOn then
		wallClimbOn = false
		wallClimbButton.Text = "Wall Climb [OFF]"
		wallClimbButton.TextColor3 = Color3.fromRGB(255, 50, 50)
		wallClimbBV = nil
	end
end)
