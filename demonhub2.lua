--================================================== 
-- SERVIÇOS
--==================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
repeat task.wait() until LocalPlayer
repeat task.wait() until LocalPlayer:FindFirstChild("PlayerGui")
repeat task.wait() until LocalPlayer.Character

--==================================================
-- CORES
--==================================================
local BTN_NORMAL = Color3.fromRGB(35,35,35)
local BTN_ACTIVE = Color3.fromRGB(70,70,70)

--==================================================
-- GUI BASE
--==================================================
local gui = Instance.new("ScreenGui")
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Name = "HubUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- NOTIFICAÇÃO
--==================================================
local notify = Instance.new("TextLabel", gui)
notify.Size = UDim2.new(0,260,0,40)
notify.Position = UDim2.new(1,-310,1,-50)
notify.BackgroundColor3 = Color3.fromRGB(35,35,35)
notify.TextColor3 = Color3.new(1,1,1)
notify.Font = Enum.Font.GothamBold
notify.TextSize = 14
notify.Visible = false
notify.TextWrapped = true
Instance.new("UICorner", notify)

local function notifyMsg(text)
    notify.Text = text
    notify.Visible = true
    task.delay(2, function()
        notify.Visible = false
    end)
end

--==================================================
-- HUB
--==================================================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,500,0,350)
main.Position = UDim2.new(0.5,-250,0.5,-150)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.Visible = true
main.Active = true
main.Draggable = true
main.ZIndex = 10
Instance.new("UICorner", main)

local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,40)
top.BackgroundColor3 = Color3.fromRGB(25,25,25)
top.ZIndex = 11
--==================================================
-- TOPO
--==================================================

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,0,1,0)
title.Text = "Demon Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

--==================================================
-- CONTEÚDO
--==================================================
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-20,1,-55)
content.Position = UDim2.new(0,10,0,45)
content.BackgroundTransparency = 1

--==================================================
-- MENU LATERAL
--==================================================
local function sideButton(text,y)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.new(0,130,0,40)
    b.Position = UDim2.new(0,0,0,y)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 15
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = BTN_NORMAL
    Instance.new("UICorner", b)
    return b
end

local espBtn = sideButton("ESP",0)
local playerBtn = sideButton("PLAYER",50)
local tpBtn = sideButton("TELEPORT",100)
local aboutBtn = sideButton("ABOUT",150)
local othersBtn = sideButton("OTHERS",200)

local buttons = {espBtn, playerBtn, tpBtn, aboutBtn, othersBtn}

--==================================================
-- PAINÉIS (COM SCROLL AUTOMÁTICO)
--==================================================
local function panel()
    local p = Instance.new("ScrollingFrame", content)
    p.Size = UDim2.new(1, -150, 1, 0)
    p.Position = UDim2.new(0, 150, 0, 0)
    p.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    p.Visible = false

    p.ScrollBarThickness = 6
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.ScrollingDirection = Enum.ScrollingDirection.Y
    p.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

    Instance.new("UICorner", p)

    -- Layout
    local layout = Instance.new("UIListLayout", p)
    layout.Padding = UDim.new(0, 10)

    -- Padding interno
    local pad = Instance.new("UIPadding", p)
    pad.PaddingTop = UDim.new(0, 15)
    pad.PaddingLeft = UDim.new(0, 20)
    pad.PaddingRight = UDim.new(0, 20)

    return p
end

local espPanel = panel()
local playerPanel = panel()
local tpPanel = panel()
local aboutPanel = panel()
local othersPanel = panel()

--==================================================
-- FUNÇÃO SHOW PANEL
--==================================================
local function showPanel(panelToShow, activeBtn)
    espPanel.Visible = false
    playerPanel.Visible = false
    tpPanel.Visible = false
    aboutPanel.Visible = false
    othersPanel.Visible = false
    for _,b in ipairs(buttons) do
        b.BackgroundColor3 = BTN_NORMAL
    end
    panelToShow.Visible = true
    activeBtn.BackgroundColor3 = BTN_ACTIVE
end

--==================================================
-- ESP PLAYERS
--==================================================
local ESP_ON, ESP_NAME, ESP_DISTANCE, ESP_LINE = false, true, false, false
local lines = {}

local function espToggle(text, y, callback)
    local b = Instance.new("TextButton", espPanel)
    b.Size = UDim2.new(0,260,0,45)
    b.Size = UDim2.new(1, -40, 0, 45)
b.LayoutOrder = y
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    Instance.new("UICorner", b)
    local function refresh()
        b.Text = text.." : "..(callback() and "ON" or "OFF")
    end
    refresh()
    b.MouseButton1Click:Connect(function()
        callback(true)
        refresh()
        notifyMsg(text.." "..(callback() and "ON" or "OFF"))
    end)
end

espToggle("ESP",20,function(t) if t then ESP_ON = not ESP_ON end return ESP_ON end)
espToggle("NOME",80,function(t) if t then ESP_NAME = not ESP_NAME end return ESP_NAME end)
espToggle("DISTÂNCIA",140,function(t) if t then ESP_DISTANCE = not ESP_DISTANCE end return ESP_DISTANCE end)
espToggle("LINHA",200,function(t)
    if t then
        ESP_LINE = not ESP_LINE
        if not ESP_LINE then
            for _,objs in pairs(lines) do for _,v in ipairs(objs) do v:Destroy() end end
            lines = {}
        end
    end
    return ESP_LINE
end)

RunService.RenderStepped:Connect(function()
    for p,objs in pairs(lines) do
        if not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then
            for _,v in ipairs(objs) do v:Destroy() end
            lines[p] = nil
        end
    end
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            local head = char:FindFirstChild("Head")
            local hrp = char.HumanoidRootPart
            -- HIGHLIGHT
            if ESP_ON then
                if not char:FindFirstChild("ESP_HL") then
                    local h = Instance.new("Highlight", char)
                    h.Name = "ESP_HL"
                    h.FillColor = Color3.fromRGB(255,0,0)
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
            else
                if char:FindFirstChild("ESP_HL") then char.ESP_HL:Destroy() end
            end
            -- NOME
            if ESP_ON and ESP_NAME and head then
                if not head:FindFirstChild("ESP_NAME") then
                    local bb = Instance.new("BillboardGui", head)
                    bb.Name = "ESP_NAME"
                    bb.Size = UDim2.new(0,200,0,25)
                    bb.StudsOffset = Vector3.new(0,2.5,0)
                    bb.AlwaysOnTop = true
                    local t = Instance.new("TextLabel", bb)
                    t.Size = UDim2.new(1,0,1,0)
                    t.BackgroundTransparency = 1
                    t.Font = Enum.Font.GothamBold
                    t.TextSize = 16
                    t.TextColor3 = Color3.new(1,1,1)
                    t.TextStrokeTransparency = 0.3
                end
                head.ESP_NAME.TextLabel.Text = p.Name
            else
                if head and head:FindFirstChild("ESP_NAME") then head.ESP_NAME:Destroy() end
            end
            -- DISTÂNCIA
            if ESP_ON and ESP_DISTANCE and head and LocalPlayer.Character then
                if not head:FindFirstChild("ESP_DIST") then
                    local bb = Instance.new("BillboardGui", head)
                    bb.Name = "ESP_DIST"
                    bb.Size = UDim2.new(0,200,0,22)
                    bb.StudsOffset = Vector3.new(0,1.8,0)
                    bb.AlwaysOnTop = true
                    local t = Instance.new("TextLabel", bb)
                    t.Size = UDim2.new(1,0,1,0)
                    t.BackgroundTransparency = 1
                    t.Font = Enum.Font.Gotham
                    t.TextSize = 14
                    t.TextColor3 = Color3.new(1,1,1)
                    t.TextStrokeTransparency = 0.3
                end
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                head.ESP_DIST.TextLabel.Text = math.floor(dist).."m"
            else
                if head and head:FindFirstChild("ESP_DIST") then head.ESP_DIST:Destroy() end
            end
            -- LINHA
            if ESP_ON and ESP_LINE and LocalPlayer.Character then
                if not lines[p] then
                    local a0 = Instance.new("Attachment", LocalPlayer.Character.HumanoidRootPart)
                    local a1 = Instance.new("Attachment", hrp)
                    local beam = Instance.new("Beam")
                    beam.Attachment0 = a0
                    beam.Attachment1 = a1
                    beam.Width0 = 0.05
                    beam.Width1 = 0.05
                    beam.FaceCamera = true
                    beam.Color = ColorSequence.new(Color3.new(1,1,1))
                    beam.Parent = a0
                    lines[p] = {beam, a0, a1}
                end
            elseif lines[p] then
                for _,v in ipairs(lines[p]) do v:Destroy() end
                lines[p] = nil
            end
        end
    end
end)

--==================================================
-- ESP MOEDAS (LEVEMENTE)
--==================================================
local tokenBtn = Instance.new("TextButton", espPanel)
tokenBtn.Size = UDim2.new(0,260,0,45)
tokenBtn.Position = UDim2.new(0,20,0,260)
tokenBtn.Font = Enum.Font.GothamBold
tokenBtn.TextSize = 16
tokenBtn.TextColor3 = Color3.new(1,1,1)
tokenBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
Instance.new("UICorner", tokenBtn)

local ESP_TOKEN_ON = false
local tokenHighlights = {}

local function createTokenHighlight(obj)
    if tokenHighlights[obj] then return end
    local h = Instance.new("Highlight")
    h.FillColor = Color3.fromRGB(255,255,0)
    h.OutlineColor = Color3.fromRGB(255,255,0)
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = obj
    tokenHighlights[obj] = h
end

local function removeTokenHighlight(obj)
    if tokenHighlights[obj] then
        tokenHighlights[obj]:Destroy()
        tokenHighlights[obj] = nil
    end
end

workspace.DescendantAdded:Connect(function(obj)
    if ESP_TOKEN_ON and obj:IsA("BasePart") and obj.Name:match("Coin") then
        createTokenHighlight(obj)
    end
end)

workspace.DescendantRemoving:Connect(function(obj)
    if obj:IsA("BasePart") and obj.Name:match("Coin") then
        removeTokenHighlight(obj)
    end
end)

tokenBtn.MouseButton1Click:Connect(function()
    ESP_TOKEN_ON = not ESP_TOKEN_ON
    tokenBtn.Text = "ESP MOEDAS : "..(ESP_TOKEN_ON and "ON" or "OFF")
    notifyMsg("ESP MOEDAS "..(ESP_TOKEN_ON and "ON" or "OFF"))

    if ESP_TOKEN_ON then
        for _, token in ipairs(workspace:GetDescendants()) do
            if token:IsA("BasePart") and token.Name:match("Coin") then
                createTokenHighlight(token)
            end
        end
    else
        for obj,_ in pairs(tokenHighlights) do
            removeTokenHighlight(obj)
        end
    end
end)

--==================================================
-- PLAYER PANEL COMPLETO (GODMODE + NOCLIP + SPEED + SUPERJUMP + FLY)
--==================================================

-- Configurações iniciais
local GOD_ON, NOCLIP_ON, isFlying = false, false, false
local speedValue = 16
local superJumpPower = 50
local flySpeed = 50
local FlyControl = {Forward=0, Backward=0, Left=0, Right=0, Up=0, Down=0}
local bodyVelocity = nil

-- Funções utilitárias
local function getChar() return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() end
local function getHumanoid() return getChar():WaitForChild("Humanoid") end
local function getRootPart() return getChar():WaitForChild("HumanoidRootPart") end

--==================================================
-- CRIAÇÃO DE BOTÕES
--==================================================
local function createPlayerButton(parent, text, y)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0,260,0,40)
    b.Size = UDim2.new(1, -40, 0, 45)
b.LayoutOrder = y
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    Instance.new("UICorner", b)
    b.Text = text
    return b
end

local godBtn = createPlayerButton(playerPanel, "GODMODE : OFF", 10)
local noclipBtn = createPlayerButton(playerPanel, "NOCLIP : OFF", 60)
local flyBtn = createPlayerButton(playerPanel, "FLY : OFF", 110)

--==================================================
-- ATUALIZA TEXTOS DOS BOTÕES
--==================================================
local function updatePlayerTexts()
    godBtn.Text = "GODMODE : "..(GOD_ON and "ON" or "OFF")
    noclipBtn.Text = "NOCLIP : "..(NOCLIP_ON and "ON" or "OFF")
    flyBtn.Text = "FLY : "..(isFlying and "ON" or "OFF")
end
updatePlayerTexts()

--==================================================
-- FUNÇÕES
--==================================================

-- GODMODE
local function applyGod()
    local hum = getHumanoid()
    hum.MaxHealth = math.huge
    hum.Health = math.huge
    hum.HealthChanged:Connect(function()
        if GOD_ON then hum.Health = hum.MaxHealth end
    end)
end

-- NOCLIP
local function toggleNoclip()
    NOCLIP_ON = not NOCLIP_ON
    updatePlayerTexts()
    notifyMsg("NOCLIP "..(NOCLIP_ON and "ON" or "OFF"))
end

-- FLY
local function startFly()
    if isFlying then return end
    isFlying = true
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.Parent = getRootPart()
    updatePlayerTexts()
end
local function stopFly()
    isFlying = false
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    updatePlayerTexts()
end
--==================================================
-- CRIAÇÃO DE SLIDERS (ALINHADOS + SCROLL)
--==================================================
local function createSlider(name, minVal, maxVal, initial, callback)
    local holder = Instance.new("Frame", playerPanel)
    holder.Size = UDim2.new(1, -40, 0, 70)
    holder.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", holder)
    label.Size = UDim2.new(1, -70, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Text = name..": "..initial

    local box = Instance.new("TextBox", holder)
    box.Size = UDim2.new(0, 60, 0, 20)
    box.Position = UDim2.new(1, -60, 0, 0)
    box.Text = tostring(initial)
    box.ClearTextOnFocus = false
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.TextColor3 = Color3.new(1,1,1)
    box.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Instance.new("UICorner", box)

    local bar = Instance.new("Frame", holder)
    bar.Size = UDim2.new(1, 0, 0, 18)
    bar.Position = UDim2.new(0, 0, 0, 30)
    bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
    Instance.new("UICorner", bar)

    local fill = Instance.new("Frame", bar)
    fill.BackgroundColor3 = Color3.fromRGB(90,160,255)
    fill.Size = UDim2.new((initial-minVal)/(maxVal-minVal), 0, 1, 0)
    Instance.new("UICorner", fill)

    local function update(val)
        val = math.clamp(val, minVal, maxVal)
        fill.Size = UDim2.new((val-minVal)/(maxVal-minVal),0,1,0)
        label.Text = name..": "..math.floor(val)
        box.Text = tostring(math.floor(val))
        callback(val)
    end

    local dragging = false
    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    bar.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local percent = math.clamp(
                (UIS:GetMouseLocation().X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
                0, 1
            )
            update(minVal + percent * (maxVal - minVal))
        end
    end)

    box.FocusLost:Connect(function()
        local v = tonumber(box.Text)
        if v then update(v) end
    end)

    update(initial)
end

createSlider("SPEED", 16, 200, speedValue, function(v)
    speedValue = v
    getHumanoid().WalkSpeed = v
end)

createSlider("SUPERJUMP", 50, 200, superJumpPower, function(v)
    superJumpPower = v
    getHumanoid().JumpPower = v
end)

createSlider("FLY SPEED", 10, 500, flySpeed, function(v)
    flySpeed = v
end)


--==================================================
-- CONTROLE DO FLY / NOCLIP
--==================================================
RunService.RenderStepped:Connect(function()
    -- Noclip
if NOCLIP_ON then
    local char = LocalPlayer.Character
    if char then
        for _,v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end
    -- Fly
    if isFlying and bodyVelocity then
        local camCFrame = workspace.CurrentCamera.CFrame
        local move = (camCFrame.LookVector*(FlyControl.Forward-FlyControl.Backward) +
                      camCFrame.RightVector*(FlyControl.Right-FlyControl.Left) +
                      Vector3.new(0,FlyControl.Up-FlyControl.Down,0))
        if move.Magnitude>0 then move=move.Unit end
        bodyVelocity.Velocity = move*flySpeed
    end
end)

UIS.InputBegan:Connect(function(input,gp)
    if gp then return end
    if input.KeyCode==Enum.KeyCode.W then FlyControl.Forward=1 end
    if input.KeyCode==Enum.KeyCode.S then FlyControl.Backward=1 end
    if input.KeyCode==Enum.KeyCode.A then FlyControl.Left=1 end
    if input.KeyCode==Enum.KeyCode.D then FlyControl.Right=1 end
    if input.KeyCode==Enum.KeyCode.Space then FlyControl.Up=1 end
    if input.KeyCode==Enum.KeyCode.LeftShift then FlyControl.Down=1 end
end)
UIS.InputEnded:Connect(function(input)
    if input.KeyCode==Enum.KeyCode.W then FlyControl.Forward=0 end
    if input.KeyCode==Enum.KeyCode.S then FlyControl.Backward=0 end
    if input.KeyCode==Enum.KeyCode.A then FlyControl.Left=0 end
    if input.KeyCode==Enum.KeyCode.D then FlyControl.Right=0 end
    if input.KeyCode==Enum.KeyCode.Space then FlyControl.Up=0 end
    if input.KeyCode==Enum.KeyCode.LeftShift then FlyControl.Down=0 end
end)

--==================================================
-- CONEXÕES DOS BOTÕES
--==================================================
godBtn.MouseButton1Click:Connect(function()
    GOD_ON = not GOD_ON
    updatePlayerTexts()
    if GOD_ON then applyGod() end
    notifyMsg("GODMODE "..(GOD_ON and "ON" or "OFF"))
end)
noclipBtn.MouseButton1Click:Connect(toggleNoclip)
flyBtn.MouseButton1Click:Connect(function()
    if isFlying then stopFly() else startFly() end
    notifyMsg("FLY "..(isFlying and "ON" or "OFF"))
end)

-- GODMODE NO SPAWN
LocalPlayer.CharacterAdded:Connect(function(char)
    if GOD_ON then applyGod() end
end)

--==================================================
-- TELEPORT + OTHERS COM LISTA CLICÁVEL
--==================================================
local function createPlayerList(panel, textBox)
    local listFrame = Instance.new("ScrollingFrame", panel)
    listFrame.Size = UDim2.new(0,260,0,150)
    listFrame.Position = UDim2.new(0,20,0,130)
    listFrame.CanvasSize = UDim2.new(0,0,0,0)
    listFrame.ScrollBarThickness = 6
    listFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
    Instance.new("UICorner", listFrame)

    local listLayout = Instance.new("UIListLayout", listFrame)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0,5)

    local function refreshList()
        for _, child in pairs(listFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1,0,0,30)
                btn.Text = p.Name
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 14
                btn.TextColor3 = Color3.new(1,1,1)
                btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
                Instance.new("UICorner", btn)
                btn.Parent = listFrame
                btn.MouseButton1Click:Connect(function()
                    textBox.Text = p.Name
                    notifyMsg("Selecionado: "..p.Name)
                end)
            end
        end

        listFrame.CanvasSize = UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y + 5)
    end

    Players.PlayerAdded:Connect(refreshList)
    Players.PlayerRemoving:Connect(refreshList)
    refreshList()
end

-- TELEPORT
local tpBox = Instance.new("TextBox", tpPanel)
tpBox.Size = UDim2.new(0,260,0,45)
tpBox.LayoutOrder = 1
tpBox.Position = UDim2.new(0,20,0,20)
tpBox.PlaceholderText = "Nome do player"
tpBox.Font = Enum.Font.Gotham
tpBox.TextSize = 16
tpBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
tpBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", tpBox)

local tpGo = Instance.new("TextButton", tpPanel)
tpGo.Size = UDim2.new(0,260,0,45)
tpGo.Position = UDim2.new(0,20,0,75)
tpGo.LayoutOrder = 2
tpGo.Text = "TELEPORTAR"
tpGo.Font = Enum.Font.GothamBold
tpGo.TextSize = 16
tpGo.TextColor3 = Color3.new(1,1,1)
tpGo.BackgroundColor3 = Color3.fromRGB(70,120,255)
Instance.new("UICorner", tpGo)

tpGo.MouseButton1Click:Connect(function()
    local t = Players:FindFirstChild(tpBox.Text)
    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)
        notifyMsg("TELEPORT OK")
    else
        notifyMsg("PLAYER NÃO ENCONTRADO")
    end
end)

createPlayerList(tpPanel, tpBox)

-- OTHERS (Spectate)
local otherBox = Instance.new("TextBox", othersPanel)
otherBox.LayoutOrder = 1

otherBox.Size = UDim2.new(0,260,0,45)
otherBox.Position = UDim2.new(0,20,0,20)
otherBox.PlaceholderText = "Nome do player"
otherBox.Font = Enum.Font.Gotham
otherBox.TextSize = 16
otherBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
otherBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", otherBox)

local spectateBtn = Instance.new("TextButton", othersPanel)
spectateBtn.LayoutOrder = 2


spectateBtn.Size = UDim2.new(0,260,0,45)
spectateBtn.Position = UDim2.new(0,20,0,75)
spectateBtn.Text = "ESPECTAR"
spectateBtn.Font = Enum.Font.GothamBold
spectateBtn.TextSize = 16
spectateBtn.TextColor3 = Color3.new(1,1,1)
spectateBtn.BackgroundColor3 = Color3.fromRGB(70,120,255)
Instance.new("UICorner", spectateBtn)

local isSpectating = false
local targetPlayer = nil
local cam = workspace.CurrentCamera
local originalCameraType = cam.CameraType
local originalCameraSubject = cam.CameraSubject

spectateBtn.MouseButton1Click:Connect(function()
    if not isSpectating then
        targetPlayer = Players:FindFirstChild(otherBox.Text)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            isSpectating = true
            spectateBtn.Text = "PARAR ESPECTAR"
            notifyMsg("ESPECTANDO: "..targetPlayer.Name)
            cam.CameraType = Enum.CameraType.Scriptable
        else
            notifyMsg("PLAYER NÃO ENCONTRADO")
        end
    else
        isSpectating = false
        spectateBtn.Text = "ESPECTAR"
        cam.CameraType = originalCameraType
        cam.CameraSubject = originalCameraSubject
        notifyMsg("ESPECTAR DESATIVADO")
    end
end)

createPlayerList(othersPanel, otherBox)

RunService.RenderStepped:Connect(function()
    if isSpectating and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = targetPlayer.Character.HumanoidRootPart
        cam.CFrame = hrp.CFrame * CFrame.new(0,5,10) * CFrame.Angles(math.rad(-15),0,0)
    end
end)

--==================================================
-- ABOUT
--==================================================
local aboutTitle = Instance.new("TextLabel", aboutPanel)
aboutTitle.Size = UDim2.new(1,-40,0,30)
aboutTitle.Position = UDim2.new(0,20,0,15)
aboutTitle.BackgroundTransparency = 1
aboutTitle.Text = "SOBRE"
aboutTitle.Font = Enum.Font.GothamBold
aboutTitle.TextSize = 18
aboutTitle.TextColor3 = Color3.new(1,1,1)
aboutTitle.TextXAlignment = Enum.TextXAlignment.Left

local creators = Instance.new("TextLabel", aboutPanel)
creators.Size = UDim2.new(1,-40,0,60)
creators.Position = UDim2.new(0,20,0,55)
creators.BackgroundTransparency = 1
creators.TextWrapped = true
creators.TextYAlignment = Enum.TextYAlignment.Top
creators.Font = Enum.Font.Gotham
creators.TextSize = 15
creators.TextColor3 = Color3.new(1,1,1)
creators.Text = "CRIADORES:\n• B4_LORD\n• SZ RICK"

local donateBtn = Instance.new("TextButton", aboutPanel)
donateBtn.Size = UDim2.new(0,260,0,45)
donateBtn.Position = UDim2.new(0,20,0,130)
donateBtn.Text = "DONATE"
donateBtn.Font = Enum.Font.GothamBold
donateBtn.TextSize = 16
donateBtn.TextColor3 = Color3.new(1,1,1)
donateBtn.BackgroundColor3 = Color3.fromRGB(60,160,90)
Instance.new("UICorner", donateBtn)

donateBtn.MouseButton1Click:Connect(function()
    local link = "https://www.youtube.com/"
    if syn and syn.openurl then
        syn.openurl(link)
        notifyMsg("ABRINDO YOUTUBE ❤️")
    elseif openurl then
        openurl(link)
        notifyMsg("ABRINDO YOUTUBE ❤️")
    elseif setclipboard then
        setclipboard(link)
        notifyMsg("LINK COPIADO ❤️")
    else
        notifyMsg("COPIE O LINK MANUALMENTE")
    end
end)

--==================================================
-- CONTROLES DOS BOTÕES LATERAIS
--==================================================
espBtn.MouseButton1Click:Connect(function() showPanel(espPanel, espBtn) end)
playerBtn.MouseButton1Click:Connect(function() showPanel(playerPanel, playerBtn) end)
tpBtn.MouseButton1Click:Connect(function() showPanel(tpPanel, tpBtn) end)
aboutBtn.MouseButton1Click:Connect(function() showPanel(aboutPanel, aboutBtn) end)
othersBtn.MouseButton1Click:Connect(function() showPanel(othersPanel, othersBtn) end)

showPanel(espPanel, espBtn)

--==================================================
-- TECLA Z (ABRIR HUB)
--==================================================
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.Z then
        main.Visible = not main.Visible
    end
end)
