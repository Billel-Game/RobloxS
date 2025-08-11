local keyUrl = "https://raw.githubusercontent.com/Billel-Game/RobloxS/main/broken"
local success, correctKey = pcall(function()
    return game:HttpGet(keyUrl)
end)
if not success then
    warn("Failed to fetch key:", correctKey)
    return
end
print("Fetched key:", correctKey)
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

local omni = loadstring(game:HttpGet("https://raw.githubusercontent.com/Billel-Game/RobloxS/refs/heads/main/uilib.lua"))()

--// UI Setup
local UI = omni.new({
    Name = "🔥 Fury Scripts 🔥",
    Credit = "Created by Billel",
    Color = Color3.fromRGB(122, 28, 187),
    Discord = "Billel"
})

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FuryScreenGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "FuryUIToggle"
toggleButton.Image = "rbxassetid://133641333781908"
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(122, 28, 187)
toggleButton.BackgroundTransparency = 0.2
toggleButton.ZIndex = 999
toggleButton.BorderSizePixel = 3
toggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.Parent = screenGui

toggleButton.MouseButton1Click:Connect(function()
    UI.container.Main.Visible = not UI.container.Main.Visible
end)

local mainPage = UI:CreatePage("Main 🏠")
local mainSection = mainPage:CreateSection("Main (Toggles)")

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Remote Paths
local remoteFolder = ReplicatedStorage:WaitForChild("\232\132\154\230\156\172")
local remoteEvent = remoteFolder:WaitForChild("RemoteEvent")
local fishingRemote = remoteEvent:WaitForChild("\228\186\139\228\187\182\232\167\166\229\143\145")

--// Auto Fish Toggle
local autoFishEnabled = false

mainSection:CreateToggle({
    Name = "🎣 Auto Fish",
    Flag = "AutoFish",
    Default = false,
    Callback = function(state)
        autoFishEnabled = state
        if state then
            task.spawn(function()
                local args = { { event = "\233\146\147\233\177\188" } }
                while autoFishEnabled do
                    pcall(function()
                        fishingRemote:FireServer(unpack(args))
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

--// Auto Sell Toggle
local autoSellEnabled = false

mainSection:CreateToggle({
    Name = "💰 Auto Sell Inventory",
    Flag = "AutoSellInventory",
    Default = false,
    Callback = function(state)
        autoSellEnabled = state
        if state then
            task.spawn(function()
                local args = { { event = "\229\133\168\233\131\168\229\135\186\229\148\174" } }
                while autoSellEnabled do
                    pcall(function()
                        fishingRemote:FireServer(unpack(args))
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end
})

--// Optional: Add a hotkey to toggle UI visibility
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.LeftControl and not gpe then
        UI.Visible = not UI.Visible
    end
end)