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

local Pages = UI:CreatePage("Main 🏠")
local Section = Pages:CreateSection("Main (Toggles)")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local plot = workspace:WaitForChild("Plots"):WaitForChild(plr.Name)
local land = plot:FindFirstChild("Land")
local expand = plot:WaitForChild("Expand")


local autoFarmPlot = false

Section:CreateToggle({
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

