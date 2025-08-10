-- Key System
local correctKey = "k9X2vB7pQzLm4T1s"
local player = game.Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeyPrompt"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 210)
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

-- DiscordLib UI
local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/discord"))()
local win = DiscordLib:Window("discord library")
local serv = win:Server("Made by Billel", "")
local main = serv:Channel("Main")
local coll = serv:Channel("Collection")
local event = serv:Channel("Events")
local fish = serv:Channel("Fishing")
local shop = serv:Channel("Shop")

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local plot = workspace:WaitForChild("Plots"):WaitForChild(plr.Name)
local land = plot:FindFirstChild("Land")
local expand = plot:WaitForChild("Expand")

-- Generalized toggle pattern
local function createToggle(flagName, parent, label, loopFn, interval)
    local flag = false
    parent:Toggle(label, false, function(state)
        flag = state
        if state then
            task.spawn(function()
                while flag do
                    loopFn()
                    task.wait(interval or 5)
                end
            end)
        end
    end)
    return function() return flag end
end

-- Auto-Farm Plot
Section:createToggle("autoFarmPlot", coll, "Auto-Farm Plot", function()
    local plotResources = plot:FindFirstChild("Resources")
    if plotResources then
        for _, resource in ipairs(plotResources:GetChildren()) do
            pcall(function()
                game.ReplicatedStorage.Communication.HitResource:FireServer(resource)
            end)
        end
    end
end, 1)

-- Auto-Farm Rainbow Island
Section:createToggle("autoFarmRainbow", event, "Auto-Farm Rainbow Island", function()
    local rainbow = workspace:FindFirstChild("RainbowIsland")
    if rainbow and rainbow:FindFirstChild("Resources") then
        for _, resource in ipairs(rainbow.Resources:GetChildren()) do
            pcall(function()
                game.ReplicatedStorage.Communication.HitResource:FireServer(resource)
            end)
        end
    end
end, 1)

-- Auto-Farm World Tree
Section:createToggle("autoFarmWT", event, "Auto-Farm World Tree", function()
    local globalResources = workspace:FindFirstChild("GlobalResources")
    local worldTree = globalResources and globalResources:FindFirstChild("World Tree")
    if worldTree then
        pcall(function()
            game.ReplicatedStorage.Communication.HitResource:FireServer(worldTree)
        end)
    end
end, 2)

-- Auto-Hive
Section:createToggle("autohive", coll, "Auto-Hive", function()
    for _, spot in ipairs(land:GetDescendants()) do
        if spot:IsA("Model") and spot.Name:match("Spot") then
            pcall(function()
                game.ReplicatedStorage.Communication.Hive:FireServer(spot.Parent.Name, spot.Name, 2)
            end)
        end
    end
end, 5)

-- Auto-Harvest
Section:createToggle("autoharvest", coll, "Auto-Harvest", function()
    local plants = plot:FindFirstChild("Plants")
    if plants then
        for _, crop in ipairs(plants:GetChildren()) do
            pcall(function()
                game.ReplicatedStorage.Communication.Harvest:FireServer(crop.Name)
            end)
        end
    end
end, 2)

-- Auto-Contribute Expansion
Section:createToggle("autofarmExpand", main, "Auto-Contribute", function()
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
end, 5)

-- Teleport to Fishing Spot
fish:Button("Teleport to Fishing Spot", function()
    local char = plr.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(-553.862, -1.64, -95.602)
    end
end)

-- Auto-Fish
local autoFish = false
local fishConnection
local RunService = game:GetService("RunService")
local lastCast = 0
local cooldown = 0.01
fish:Toggle("Auto-Fish", false, function(state)
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
end)

-- Auto-Crafter
createToggle("autoCraft", main, "Auto Crafter", function()
    for _, c in pairs(plot:GetDescendants()) do
        if c.Name == "Crafter" then
            local attachment = c:FindFirstChildOfClass("Attachment")
            if attachment then
                pcall(function()
                    game.ReplicatedStorage.Communication.Craft:FireServer(attachment)
                end)
            end
        end
    end
end, 5)

-- Auto Gold Mine
createToggle("autoGoldMine", coll, "Auto Gold Mine", function()
    for _, mine in pairs(land:GetDescendants()) do
        if mine:IsA("Model") and mine.Name == "GoldMineModel" then
            pcall(function()
                game.ReplicatedStorage.Communication.Goldmine:FireServer(mine.Parent.Name, 1)
            end)
        end
    end
end, 5)

-- Auto Collect Gold
createToggle("autoCollectGold", coll, "Auto Collect Gold", function()
    for _, mine in pairs(land:GetDescendants()) do
        if mine:IsA("Model") and mine.Name == "GoldMineModel" then
            pcall(function()
                game.ReplicatedStorage.Communication.Goldmine:FireServer(mine.Parent.Name, 2)
            end)
        end
    end
end, 5)

-- Timed Rewards Button
shop:Button("Claim All Timed Rewards", function()
    local rewardNames = {
        "rewardOne", "rewardTwo", "rewardThree", "rewardFour",
        "rewardFive", "rewardSix", "rewardSeven", "rewardEight",
        "rewardNine", "rewardTen", "rewardEleven", "rewardTwelve"
    }
    for _, reward in ipairs(rewardNames) do
        pcall(function()
            game:GetService("ReplicatedStorage").Communication.ClaimTimedReward:InvokeServer(reward)
        end)
        task.wait(0.1)
    end
end)

-- Claim Shamrock Chest
shop:Button("Claim Shamrock Chest", function()
    local args = { "RainbowIslandShamrockChest" }
    local success, err = pcall(function()
        game:GetService("ReplicatedStorage")
            :WaitForChild("Communication")
            :WaitForChild("RewardChestClaimRequest")
            :FireServer(unpack(args))
    end)
    if success then
        print("Successfully claimed Shamrock Chest!")
    else
        warn("Failed to claim Shamrock Chest:", err)
    end
end)

-- Buy Lightning Crate
shop:Button("Buy Lightning Crate", function()
    local args = { "Lightning Crate", 1 }
    local success, err = pcall(function()
        game:GetService("ReplicatedStorage")
            :WaitForChild("Communication")
            :WaitForChild("PurchaseCrateRequest")
            :FireServer(unpack(args))
    end)
    if success then
        print("Successfully purchased Lightning Crate!")
    else
        warn("Failed to purchase Lightning Crate:", err)
    end
end)

-- Shop Auto-Buy
local autoBuyItems = {}
local autoBuyMerchant = false

local categories = {
    Seeds = {"Corn Seed", "Strawberry Seeds", "Tomato Seeds", "Apple Seeds", "Blueberry Seeds", "Watermelon Seeds", "Peach Seeds", "Pumpkin Seeds", "Cherry Seeds", "Starfruit Seeds", "Mango Seeds", "Goji Berry Seeds", "Dragonfruit Seeds", "Magic Durian Seeds"},
    Potions = {"Busy Bee Potion", "Growth Potion", "Strength Potion", "Resource Potion", "Multicast Potion", "Galaxy Potion"},
    Machines = {"Autochopper Mk 1", "Autominer Mk1"},
    Special = {"Coal Crate", "Honey Bee", "Magma Bee"}
}
local categoryToggles = {}

for category, items in pairs(categories) do
    categoryToggles[category] = {}

    shop:Button("Category: " .. category, function()
        if #categoryToggles[category] > 0 then
            -- Remove existing toggles
            for _, toggle in ipairs(categoryToggles[category]) do
                toggle:Destroy()
            end
            categoryToggles[category] = {}
        else
            -- Add toggles
            for _, item in ipairs(items) do
                local toggle = shop:Toggle("Auto-Buy: " .. item, autoBuyItems[item] or false, function(state)
                    autoBuyItems[item] = state
                end)
                table.insert(categoryToggles[category], toggle)
            end
        end
    end)
end

-- Master Auto-Buy Toggle
shop:Toggle("Auto-Buy Selected Items", false, function(state)
    autoBuyMerchant = state
    if state then
        task.spawn(function()
            while autoBuyMerchant do
                for itemName, shouldBuy in pairs(autoBuyItems) do
                    if shouldBuy then
                        pcall(function()
                            game.ReplicatedStorage.Communication.BuyFromMerchant:FireServer(itemName, false)
                        end)
                        task.wait(0.5)
                    end
                end
                task.wait(2)
            end