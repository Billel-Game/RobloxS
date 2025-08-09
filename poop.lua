-- Key Prompt UI
local correctKey = "123" -- Change this to your desired key
local player = game.Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeyPrompt"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 120)
frame.Position = UDim2.new(0.5, -150, 0.5, -60)
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

local entered = false

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
    Discord = "IDI NAHUY";
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

local autoPoop = false
Section:CreateToggle({
    Name = "💩 Auto Poop";
    Flag = "AutoPoop";
    Default = false;
    Callback = function(state)
        autoPoop = state
        if state then
            task.spawn(function()
                while autoPoop do
                    local char = game.Players.LocalPlayer.Character
                    if char then
                        for _, part in ipairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                    game:GetService("ReplicatedStorage"):WaitForChild("PoopChargeStart"):FireServer()
                    local args = { 1 }
                    game:GetService("ReplicatedStorage"):WaitForChild("PoopEvent"):FireServer(unpack(args))
                    task.wait(1)
                end
            end)
        end
    end;
})

local autoSell = false
Section:CreateToggle({
    Name = "💰 Auto Sell Inventory";
    Flag = "AutoSellInventory";
    Default = false;
    Callback = function(state)
        autoSell = state
        if state then
            task.spawn(function()
                while autoSell do
                    game:GetService("ReplicatedStorage"):WaitForChild("Sell_Inventory"):FireServer()
                    task.wait(5)
                end
            end)
        end
    end;
})

local autoQuest = false
Section:CreateToggle({
    Name = "Auto Monkey Quest 🦧";
    Flag = "AutoQuest";
    Default = false;
    Callback = function(state)
        autoQuest = state
        if state then
            task.spawn(function()
                while autoQuest do
                    local args = {
                        "MonkeyKing",
                        {
                            Read_Only = true,
                            Proxy_Package = {}
                        }
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("Quest_Fetch_Status"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end;
})

local Pages2 = UI:CreatePage("Shop 💲")
local Section2 = Pages2:CreateSection("Gear Shop (Auto Buy)")

local autoLaxative = false
Section2:CreateToggle({
    Name = "💰 Auto Buy Laxative";
    Flag = "AutoLaxative";
    Default = false;
    Callback = function(state)
        autoLaxative = state
        if state then
            task.spawn(function()
                while autoLaxative do
                    local args = { "Laxative" }
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("GearShop: RequestPurchase"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end;
})

local autoPills = false
Section2:CreateToggle({
    Name = "💰 Auto Buy Pills";
    Flag = "AutoPills";
    Default = false;
    Callback = function(state)
        autoPills = state
        if state then
            task.spawn(function()
                while autoPills do
                    local args = { "Pills" }
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("GearShop: RequestPurchase"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end;
})

local autoToxic = false
Section2:CreateToggle({
    Name = "💰 Auto Buy Toxic Potion";
    Flag = "autoToxic";
    Default = false;
    Callback = function(state)
        autoToxic = state
        if state then
            task.spawn(function()
                while autoToxic do
                    local args = { "ToxicPotion" }
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("GearShop: RequestPurchase"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end;
})

local autoWaiste = false
Section2:CreateToggle({
    Name = "💰 Auto Buy Nuclear Waiste";
    Flag = "autoWaiste";
    Default = false;
    Callback = function(state)
        autoWaiste = state
        if state then
            task.spawn(function()
                while autoWaiste do
                    local args = { "NuclearWaiste" }
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("GearShop: RequestPurchase"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end;
})

local Section3 = Pages2:CreateSection("Egg Shop (Auto Buy)")
local autoLegendaryEgg = false
Section3:CreateToggle({
    Name = "🥚 Auto Buy Legendary Egg";
    Flag = "AutoLegendaryEgg";
    Default = false;
    Callback = function(state)
        autoLegendaryEgg = state
        if state then
            task.spawn(function()
                while autoLegendaryEgg do
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("PetEggShop:RequestPurchase"):InvokeServer("Legendary Egg")
                    task.wait(5)
                end
            end)
        end
    end;
})
local autoCommonEgg = false
Section3:CreateToggle({
    Name = "🥚 Auto Buy Common Egg";
    Flag = "AutoCommonEgg";
    Default = false;
    Callback = function(state)
        autoCommonEgg = state
        if state then
            task.spawn(function()
                while autoCommonEgg do
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("PetEggShop:RequestPurchase"):InvokeServer("Common Egg")
                    task.wait(5)
                end
            end)
        end
    end;
})

