local correctKey = "k9X2vB7pQzLm4T1s"
local player = game.Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeyPrompt"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 210) -- Wider and taller for spacing
frame.Position = UDim2.new(0.5, -160, 0.5, -105)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0, 40)
label.Position = UDim2.new(0, 0, 0, 0)
label.BackgroundTransparency = 1
label.Text = "Enter Key:"
label.TextColor3 = Color3.new(1,1,1)
label.Font = Enum.Font.SourceSansBold
label.TextSize = 24
label.Parent = frame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -20, 0, 40)
textBox.Position = UDim2.new(0, 10, 0, 50)
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textBox.TextColor3 = Color3.new(1,1,1)
textBox.Font = Enum.Font.SourceSans
textBox.TextSize = 22
textBox.PlaceholderText = "Paste your key here"
textBox.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 22
closeButton.Text = "X"
closeButton.Parent = frame

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    error("Closed by user.")
end)

local checkButton = Instance.new("TextButton")
checkButton.Size = UDim2.new(1, -20, 0, 30)
checkButton.Position = UDim2.new(0, 10, 0, 100)
checkButton.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
checkButton.TextColor3 = Color3.new(1,1,1)
checkButton.Font = Enum.Font.SourceSansBold
checkButton.TextSize = 20
checkButton.Text = "Check Key"
checkButton.Parent = frame

local linkButton = Instance.new("TextButton")
linkButton.Size = UDim2.new(1, -20, 0, 30)
linkButton.Position = UDim2.new(0, 10, 0, 140)
linkButton.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
linkButton.TextColor3 = Color3.new(1,1,1)
linkButton.Font = Enum.Font.SourceSansBold
linkButton.TextSize = 20
linkButton.Text = "Get Key (Linkvertise)"
linkButton.Parent = frame

local entered = false

checkButton.MouseButton1Click:Connect(function()
    if textBox.Text == correctKey then
        entered = true
        screenGui:Destroy()
    else
        textBox.Text = ""
        label.Text = "Wrong Key! Try again:"
    end
end)

linkButton.MouseButton1Click:Connect(function()
    setclipboard("https://link-target.net/1380127/e5ro3DcEbUkf")
    label.Text = "Link copied! Paste in browser."
end)

textBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and textBox.Text == correctKey then
        entered = true
        screenGui:Destroy()
    elseif enterPressed then
        textBox.Text = ""
        label.Text = "Wrong Key! Try again:"
    end
end)

while not entered do
    task.wait()
end
-- Main script starts here (keep only ONE copy of your UI code below this line)
local omni = loadstring(game:HttpGet("https://raw.githubusercontent.com/Billel-Game/RobloxS/refs/heads/main/uilib.lua"))()

local UI = omni.new({
    Name = "🔥 Fury Scripts 🔥";
    Credit = "Created by Billel";
    Color = Color3.fromRGB(122,28,187);
    Bind = "LeftControl";
    UseLoader = false;
    FullName = "";
    -- You can remove CheckKey now, the prompt handles it
    Discord = "Billel";
})

local notifSound = Instance.new("Sound",workspace)
notifSound.PlaybackSpeed = 1
notifSound.Volume = 0.35
notifSound.SoundId = "rbxassetid://5829559206"
notifSound.PlayOnRemove = true
notifSound:Destroy()

UI:Notify({
    Title = "Welcome!";
    Content = "Toggle Hub 'LeftControl'";
})


local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local plot = workspace:WaitForChild("Plots"):WaitForChild(plr.Name)
local land = plot:FindFirstChild("Land")
local expand = plot:WaitForChild("Expand")

local Pages = UI:CreatePage("Main 🏠")
local mainSection = Pages:CreateSection("Main (Toggles)")
local eventSection = Pages:CreateSection("Events")         -- <--- Add this line!
local collectionSection = Pages:CreateSection("Collection")
local ShopSection = Shop:CreateSection("Shop (Toggles)")
local fishingSection = Fish:CreateSection("Fishing")
-- Auto-Farm Plot
mainSection:CreateToggle({
    Name = "Auto-Farm Plot",
    Flag = "autoFarmPlot",
    Default = false,
    Callback = function(state)
        autoFarmPlot = state
        if state then
            task.spawn(function()
                while autoFarmPlot do
                    local plotResources = plot:FindFirstChild("Resources")
                    if plotResources then
                        for _, resource in ipairs(plotResources:GetChildren()) do
                            pcall(function()
                                game.ReplicatedStorage.Communication.HitResource:FireServer(resource)
                            end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

-- Auto-Farm Rainbow Island
mainSection:CreateToggle({
    Name = "Auto-Farm Rainbow Island",
    Flag = "autoFarmRainbow",
    Default = false,
    Callback = function(state)
        local running = state
        if state then
            task.spawn(function()
                while running and eventSection.Flags.autoFarmRainbow do
                    local rainbow = workspace:FindFirstChild("RainbowIsland")
                    if rainbow and rainbow:FindFirstChild("Resources") then
                        for _, resource in ipairs(rainbow.Resources:GetChildren()) do
                            pcall(function()
                                game.ReplicatedStorage.Communication.HitResource:FireServer(resource)
                            end)
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

-- Auto-Farm World Tree
mainSection:CreateToggle({
    Name = "Auto-Farm World Tree",
    Flag = "autoFarmWT",
    Default = false,
    Callback = function(state)
        local running = state
        if state then
            task.spawn(function()
                while running and eventSection.Flags.autoFarmWT do
                    local globalResources = workspace:FindFirstChild("GlobalResources")
                    local worldTree = globalResources and globalResources:FindFirstChild("World Tree")
                    if worldTree then
                        pcall(function()
                            game.ReplicatedStorage.Communication.HitResource:FireServer(worldTree)
                        end)
                    end
                    task.wait(2)
                end
            end)
        end
    end
})

-- Auto-Hive
mainSection:CreateToggle({
    Name = "Auto-Hive",
    Flag = "autohive",
    Default = false,
    Callback = function(state)
        local running = state
        if state then
            task.spawn(function()
                while running and collectionSection.Flags.autohive do
                    for _, spot in ipairs(land:GetDescendants()) do
                        if spot:IsA("Model") and spot.Name:match("Spot") then
                            pcall(function()
                                game.ReplicatedStorage.Communication.Hive:FireServer(spot.Parent.Name, spot.Name, 2)
                            end)
                        end
                    end
                    task.wait(5)
                end
            end)
        end
    end
})

-- Auto-Harvest
mainSection:CreateToggle({
    Name = "Auto-Harvest",
    Flag = "autoharvest",
    Default = false,
    Callback = function(state)
        local running = state
        if state then
            task.spawn(function()
                while running and collectionSection.Flags.autoharvest do
                    local plants = plot:FindFirstChild("Plants")
                    if plants then
                        for _, crop in ipairs(plants:GetChildren()) do
                            pcall(function()
                                game.ReplicatedStorage.Communication.Harvest:FireServer(crop.Name)
                            end)
                        end
                    end
                    task.wait(2)
                end
            end)
        end
    end
})

-- Auto-Contribute Expansion
mainSection:CreateToggle({
    Name = "Auto-Contribute",
    Flag = "autofarmExpand",
    Default = false,
    Callback = function(state)
        local running = state
        if state then
            task.spawn(function()
                while running and mainSection.Flags.autofarmExpand do
                    for _, exp in ipairs(expand:GetChildren()) do
                        local top = exp:FindFirstChild("Top")
                        local bGui = top and top:FindFirstChild("BillboardGui")
                        if bGui then
                            for _, contribute in ipairs(bGui:GetChildren()) do
                                if contribute:IsA("Frame") and contribute.Name ~= "Example" then
                                    local args = {exp.Name, contribute.Name, 1}
                                    pcall(function()
                                        game.ReplicatedStorage.Communication.ContributeToExpand:FireServer(unpack(args))
                                    end)
                                end
                            end
                        end
                    end
                    task.wait(5)
                end
            end)
        end
    end
})


-- Teleport to Fishing Spot
fishingSection:CreateButton({
    Name = "Teleport to Fishing Spot",
    Callback = function()
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(-553.862, -1.64, -95.602)
        end
    end
})

-- Auto-Fish Toggle
local autoFish = false
local fishConnection
local RunService = game:GetService("RunService")
local lastCast = 0
local cooldown = 0.01

fishingSection:CreateToggle({
    Name = "Auto-Fish",
    Flag = "autoFish",
    Default = false,
    Callback = function(state)
        autoFish = state
        if state then
            fishConnection = RunService.Heartbeat:Connect(function()
                if (tick() - lastCast) >= cooldown then
                    lastCast = tick()
                    pcall(function()
                        game:GetService("ReplicatedStorage").Communication.Fish:InvokeServer(
                            Vector3.new(-553.862, -1.64, -95.602), 0.42
                        )
                    end)
                end
            end)
        else
            if fishConnection then
                fishConnection:Disconnect()
                fishConnection = nil
            end
        end
    end
})

