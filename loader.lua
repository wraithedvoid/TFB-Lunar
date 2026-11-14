local API_BASE = "https://tfb-script.wraithedvoid.workers.dev"
local SCRIPT_URL = "https://raw.githubusercontent.com/wraithedvoid/TFB-Lunar/refs/heads/main/lunar_studio_obfed.lua"
local DISCORD = "https://discord.gg/Qtsayh6ast"
local WEBSITE = "https://wraithedvoid.github.io/lunar-web/"
local TITLE = "Lunar Hub"
local KEY_FILE = "LunarKey.txt"

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

if CoreGui:FindFirstChild("LunarKeyUI") then CoreGui.LunarKeyUI:Destroy() end
if Lighting:FindFirstChild("LunarBlur") then Lighting.LunarBlur:Destroy() end

local function httpGet(url)
    local ok, res = pcall(function() return game:HttpGet(url, true) end)
    return ok and res or nil
end

local function notify(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = TITLE, Text = msg, Duration = 4,
        })
    end)
end

local function runScript()
    local src = httpGet(SCRIPT_URL)
    if not src then notify("Failed to download script.") return end
    local fn, err = loadstring(src)
    if not fn then notify("Script error: " .. tostring(err)) return end
    pcall(fn)
end

local blur = Instance.new("BlurEffect")
blur.Name = "LunarBlur"
blur.Size = 0
blur.Parent = Lighting
TweenService:Create(blur, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = 15}):Play()

local gui = Instance.new("ScreenGui")
gui.Name = "LunarKeyUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999 
gui.Parent = CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 380, 0, 270)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(18, 15, 25) 
main.BackgroundTransparency = 1
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 45)
title.Position = UDim2.new(0, 20, 0, 0)
title.BackgroundTransparency = 1
title.Text = "LUNAR | KEY SYSTEM"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextTransparency = 1
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.AutoButtonColor = false
closeBtn.Parent = main
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local inputContainer = Instance.new("Frame")
inputContainer.Size = UDim2.new(1, -40, 0, 45)
inputContainer.Position = UDim2.new(0, 20, 0, 60)
inputContainer.BackgroundColor3 = Color3.fromRGB(10, 8, 15)
inputContainer.BackgroundTransparency = 1
inputContainer.Parent = main
Instance.new("UICorner", inputContainer).CornerRadius = UDim.new(0, 8)

local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -20, 1, 0)
input.Position = UDim2.new(0, 10, 0, 0)
input.BackgroundTransparency = 1
input.Text = ""
input.TextTransparency = 1
input.TextColor3 = Color3.fromRGB(255, 255, 255)
input.PlaceholderText = "Enter Key..."
input.PlaceholderColor3 = Color3.fromRGB(100, 90, 120)
input.Font = Enum.Font.GothamMedium
input.TextSize = 14
input.ClearTextOnFocus = false
input.Parent = inputContainer

local btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(1, -40, 0, 40)
btnContainer.Position = UDim2.new(0, 20, 0, 120)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = main

local function createAirflowBtn(text, pos, size, baseColor)
    local btn = Instance.new("TextButton")
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = baseColor
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextTransparency = 1
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.AutoButtonColor = false
    btn.Parent = btnContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 0, BackgroundColor3 = baseColor:Lerp(Color3.new(1,1,1), 0.15)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.2, BackgroundColor3 = baseColor}):Play()
    end)
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(size.X.Scale, size.X.Offset - 4, size.Y.Scale, size.Y.Offset - 4), Position = UDim2.new(pos.X.Scale, pos.X.Offset + 2, pos.Y.Scale, pos.Y.Offset + 2)}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = size, Position = pos}):Play()
    end)
    return btn
end

local getBtn = createAirflowBtn("Get Key", UDim2.new(0, 0, 0, 0), UDim2.new(0, 165, 1, 0), Color3.fromRGB(124, 58, 237))
local checkBtn = createAirflowBtn("Check Key", UDim2.new(1, -165, 0, 0), UDim2.new(0, 165, 1, 0), Color3.fromRGB(91, 33, 182))

local discordBtn = createAirflowBtn("Join Discord Server", UDim2.new(0, 20, 0, 175), UDim2.new(1, -40, 0, 36), Color3.fromRGB(88, 101, 242))
discordBtn.Parent = main

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -40, 0, 20)
status.Position = UDim2.new(0, 20, 0, 230)
status.BackgroundTransparency = 1
status.Text = ""
status.TextColor3 = Color3.fromRGB(167, 139, 250)
status.TextTransparency = 1
status.Font = Enum.Font.GothamMedium
status.TextSize = 12
status.Parent = main

local function playEntrance()
    local openTween = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(main, openTween, {BackgroundTransparency = 0.05, Size = UDim2.new(0, 380, 0, 270)}):Play()
    TweenService:Create(blur, openTween, {Size = 15}):Play()
    TweenService:Create(title, openTween, {TextTransparency = 0}):Play()
    TweenService:Create(closeBtn, openTween, {BackgroundTransparency = 0.8, TextTransparency = 0}):Play()
    TweenService:Create(inputContainer, openTween, {BackgroundTransparency = 0}):Play()
    TweenService:Create(input, openTween, {TextTransparency = 0}):Play()
    for _, obj in pairs(btnContainer:GetChildren()) do
        if obj:IsA("TextButton") then
            TweenService:Create(obj, openTween, {BackgroundTransparency = 0.2, TextTransparency = 0}):Play()
        end
    end
    TweenService:Create(discordBtn, openTween, {BackgroundTransparency = 0.2, TextTransparency = 0}):Play()
    TweenService:Create(status, openTween, {TextTransparency = 0}):Play()
end

task.spawn(function()
    task.wait(0.1) 
    playEntrance()
end)

local function hideUI()
    TweenService:Create(main, TweenInfo.new(0.3), {BackgroundTransparency = 1, Size = UDim2.new(0, 350, 0, 250)}):Play()
    TweenService:Create(blur, TweenInfo.new(0.3), {Size = 0}):Play()
    for _, obj in pairs(main:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            TweenService:Create(obj, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        end
    end
    task.wait(0.3)
    main.Visible = false
end

closeBtn.MouseButton1Click:Connect(hideUI)

discordBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(DISCORD) elseif toclipboard then toclipboard(DISCORD) end
    notify("Discord link copied!")
end)

getBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(WEBSITE) elseif toclipboard then toclipboard(WEBSITE) end
    notify("Website link copied!")
end)

local function attemptCheck(keyToCheck)
    if keyToCheck == "" then status.Text = "Enter a key first." return end
    status.Text = "Checking..."
    
    local res = httpGet(API_BASE .. "/check?key=" .. HttpService:UrlEncode(keyToCheck))
    if not res then status.Text = "Network error." return end
    
    local ok, data = pcall(function() return HttpService:JSONDecode(res) end)
    if not ok or not data then status.Text = "Bad response." return end
    
    if data.valid then
        status.Text = "Valid! Saving & Loading..."
        if writefile then
            pcall(function() writefile(KEY_FILE, keyToCheck) end)
        end
        
        task.wait(0.5)
        if Lighting:FindFirstChild("LunarBlur") then Lighting.LunarBlur:Destroy() end
        gui:Destroy()
        runScript()
    else
        status.Text = "Invalid or expired key."
        if isfile and isfile(KEY_FILE) then
            pcall(function() delfile(KEY_FILE) end)
        end
    end
end

checkBtn.MouseButton1Click:Connect(function()
    attemptCheck(input.Text:gsub("%s+", ""))
end)

task.spawn(function()
    if isfile and isfile(KEY_FILE) then
        local savedKey = readfile(KEY_FILE)
        if savedKey and savedKey ~= "" then
            input.Text = savedKey
            status.Text = "Found saved key. Auto-checking..."
            task.wait(1) 
            attemptCheck(savedKey)
        end
    end
end)

UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.RightControl then
        if main.Visible then
            hideUI()
        else
            main.Visible = true
            main.BackgroundTransparency = 1
            main.Size = UDim2.new(0, 350, 0, 250)
            blur.Size = 0
            task.spawn(playEntrance)
        end
    end
end)
