--[[
    ================================================
      SpeedSpin GUI — LocalScript для твоего плейса
      Место: StarterPlayerScripts
      
      Функции:
        [Speed]      — WalkSpeed 56 (350% от базовых 16)
        [Spin+Knock] — Вращение; тебя не откидывает,
                       других игроков отбрасывает
        
      RightShift — скрыть/показать GUI
    ================================================
]]

local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- ================================================
-- НАСТРОЙКИ (меняй здесь)
-- ================================================
local SPEED_VALUE  = 56    -- 350% от 16 (16 × 3.5 = 56). Хочешь другое — замени.
local SPIN_SPEED   = 300   -- Угловая скорость вращения
local KNOCK_FORCE  = 90    -- Горизонтальная сила отбрасывания
local KNOCK_UP     = 30    -- Вертикальная сила отбрасывания (подбрасывает вверх)
local KNOCK_CD     = 0.35  -- Кулдаун knockback на игрока (сек)

-- ================================================
-- ЦВЕТА
-- ================================================
local C_BG     = Color3.fromRGB(0, 0, 0)
local C_BORDER = Color3.fromRGB(200, 0, 0)
local C_TEXT   = Color3.fromRGB(255, 255, 255)
local C_ON     = Color3.fromRGB(0, 255, 0)

-- ================================================
-- GUI
-- ================================================
-- Удаляем старый если есть
local pgui = player:WaitForChild("PlayerGui")
if pgui:FindFirstChild("SpeedSpinGui") then
    pgui.SpeedSpinGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedSpinGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = pgui

-- Главное окно
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 210, 0, 170)
frame.Position = UDim2.new(0, 20, 0.5, -85)
frame.BackgroundColor3 = C_BG
frame.BorderSizePixel = 3
frame.BorderColor3 = C_BORDER
frame.Parent = screenGui

-- Заголовок
local titleCell = Instance.new("Frame")
titleCell.Size = UDim2.new(1, 0, 0, 42)
titleCell.BackgroundColor3 = C_BG
titleCell.BorderSizePixel = 1
titleCell.BorderColor3 = C_BORDER
titleCell.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "SpeedSpin"
titleLabel.TextColor3 = C_TEXT
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.Bodoni
titleLabel.Parent = titleCell

-- Перетаскивание окна
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging   = true
        dragStart  = input.Position
        startPos   = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or
       input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Создание кнопки-переключателя
local function makeToggleButton(labelText, yOffset)
    local cell = Instance.new("Frame")
    cell.Size = UDim2.new(1, 0, 0, 48)
    cell.Position = UDim2.new(0, 0, 0, yOffset)
    cell.BackgroundColor3 = C_BG
    cell.BorderSizePixel = 1
    cell.BorderColor3 = C_BORDER
    cell.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = labelText
    btn.TextColor3 = C_TEXT
    btn.TextSize = 17
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = cell

    local toggled = false
    return btn, function()
        return toggled
    end, function(newState)
        toggled = (newState ~= nil) and newState or (not toggled)
        btn.TextColor3 = toggled and C_ON or C_TEXT
        return toggled
    end
end

-- ================================================
-- ФУНКЦИЯ 1: SPEED (350%)
-- ================================================
local speedBtn, getSpeed, setSpeed = makeToggleButton("Speed  (350%)", 46)

local function applySpeed(char)
    local hum = char and char:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = getSpeed() and SPEED_VALUE or 16
    end
end

speedBtn.MouseButton1Click:Connect(function()
    local state = setSpeed()
    applySpeed(player.Character)
end)

-- ================================================
-- ФУНКЦИЯ 2: SPIN + KNOCKBACK (ФИКС «гаити»)
--
-- Проблема: BodyAngularVelocity не защищает от
--           линейного отлёта при столкновении.
-- Решение:
--   • SpinStabilizer (BodyVelocity, MaxForce XZ 9e9)
--     держит горизонтальную скорость = 0 → тебя
--     не откидывает.
--   • Touched → временный BodyVelocity на HRP
--     другого игрока → их отбрасывает.
-- ================================================
local spinObj         = nil
local spinStabilizer  = nil
local spinConnections = {}

local function cleanupSpin()
    for _, c in ipairs(spinConnections) do
        c:Disconnect()
    end
    spinConnections = {}

    if spinObj        and spinObj.Parent        then spinObj:Destroy()        end
    if spinStabilizer and spinStabilizer.Parent then spinStabilizer:Destroy() end
    spinObj        = nil
    spinStabilizer = nil
end

local function activateSpin(char)
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    cleanupSpin()

    -- Вращение
    spinObj = Instance.new("BodyAngularVelocity")
    spinObj.Name          = "SpinHacks"
    spinObj.MaxTorque     = Vector3.new(0, 9e9, 0)
    spinObj.AngularVelocity = Vector3.new(0, SPIN_SPEED, 0)
    spinObj.Parent        = hrp

    -- Стабилизатор: не даёт тебя откинуть по XZ
    spinStabilizer = Instance.new("BodyVelocity")
    spinStabilizer.Name      = "SpinStabilizer"
    spinStabilizer.MaxForce  = Vector3.new(9e9, 0, 9e9)
    spinStabilizer.Velocity  = Vector3.new(0, 0, 0)
    spinStabilizer.Parent    = hrp

    -- Knockback других игроков при касании
    local debounce = {}
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local conn = part.Touched:Connect(function(hit)
                if not hit or not hit.Parent then return end

                local hitChar   = hit.Parent
                local hitPlayer = Players:GetPlayerFromCharacter(hitChar)
                if not hitPlayer or hitPlayer == player then return end

                local hitHRP = hitChar:FindFirstChild("HumanoidRootPart")
                if not hitHRP then return end
                if debounce[hitPlayer] then return end

                debounce[hitPlayer] = true

                -- Направление отбрасывания: от спиннера к жертве
                local dir = hitHRP.Position - hrp.Position
                dir = Vector3.new(dir.X, 0, dir.Z)
                if dir.Magnitude > 0 then
                    dir = dir.Unit
                else
                    dir = hrp.CFrame.LookVector
                end

                -- Применяем кратковременный импульс
                local kBV = Instance.new("BodyVelocity")
                kBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                kBV.Velocity = dir * KNOCK_FORCE + Vector3.new(0, KNOCK_UP, 0)
                kBV.Parent   = hitHRP
                game:GetService("Debris"):AddItem(kBV, 0.18)

                task.wait(KNOCK_CD)
                debounce[hitPlayer] = nil
            end)
            table.insert(spinConnections, conn)
        end
    end
end

local spinBtn, getSpin, setSpin = makeToggleButton("Spin + Knock", 98)

spinBtn.MouseButton1Click:Connect(function()
    local state = setSpin()
    if state then
        activateSpin(player.Character)
    else
        cleanupSpin()
    end
end)

-- ================================================
-- Скрыть/показать  →  RightShift
-- ================================================
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        frame.Visible = not frame.Visible
    end
end)

-- ================================================
-- Автосброс при респавне
-- ================================================
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)

    -- Скорость
    if getSpeed() then
        applySpeed(char)
    end

    -- Спин
    if getSpin() then
        activateSpin(char)
    end
end)

print("[SpeedSpin] Загружен. RightShift — скрыть/показать.")
