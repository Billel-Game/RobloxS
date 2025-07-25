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

-- Anti AFK
local antiAfkConnection
main:Toggle("Anti AFK", false, function(state)
    if state then
        antiAfkConnection = plr.Idled:Connect(function()
            local vu = game:GetService("VirtualUser")
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end)
    else
        if antiAfkConnection then
            antiAfkConnection:Disconnect()
            antiAfkConnection = nil
        end
    end
end)

-- Generalized toggle pattern (returns true if loop did any action)
local function createToggle(flagName, parent, label, loopFn)
    local flag = false
    parent:Toggle(label, false, function(state)
        flag = state
        if state then
            task.spawn(function()
                while flag do
                    local didWork = loopFn()
                    if didWork == false then
                        task.wait(2) -- nothing done, wait longer
                    else
                        task.wait(0.5) -- did work, normal wait
                    end
                end
            end)
        end
    end)
    return function() return flag end
end

-- Auto-Farm Plot
createToggle("autoFarmPlot", coll, "Auto-Farm Plot", function()
    local didFarm = false
    local plotResources = plot:FindFirstChild("Resources")
    if plotResources then
        for _, resource in ipairs(plotResources:GetChildren()) do
            pcall(function()
                game.ReplicatedStorage.Communication.HitResource:FireServer(resource)
                didFarm = true
            end)
        end
    end
    return didFarm
end)

-- Auto-Farm Rainbow Island
createToggle("autoFarmRainbow", event, "Auto-Farm Rainbow Island", function()
    local didFarm = false
    local rainbow = workspace:FindFirstChild("RainbowIsland")
    if rainbow and rainbow:FindFirstChild("Resources") then
        for _, resource in ipairs(rainbow.Resources:GetChildren()) do
            pcall(function()
                game.ReplicatedStorage.Communication.HitResource:FireServer(resource)
                didFarm = true
            end)
        end
    end
    return didFarm
end)

-- Auto-Farm World Tree
createToggle("autoFarmWT", event, "Auto-Farm World Tree", function()
    local didFarm = false
    local globalResources = workspace:FindFirstChild("GlobalResources")
    local worldTree = globalResources and globalResources:FindFirstChild("World Tree")
    if worldTree then
        pcall(function()
            game.ReplicatedStorage.Communication.HitResource:FireServer(worldTree)
            didFarm = true
        end)
    end
    return didFarm
end)

-- Auto-Hive
createToggle("autohive", coll, "Auto-Hive", function()
    local didFarm = false
    for _, spot in ipairs(land:GetDescendants()) do
        if spot:IsA("Model") and spot.Name:match("Spot") then
            pcall(function()
                game.ReplicatedStorage.Communication.Hive:FireServer(spot.Parent.Name, spot.Name, 2)
                didFarm = true
            end)
        end
    end
    return didFarm
end)

-- Auto-Harvest
createToggle("autoharvest", coll, "Auto-Harvest", function()
    local didFarm = false
    local plants = plot:FindFirstChild("Plants")
    if plants then
        for _, crop in ipairs(plants:GetChildren()) do
            pcall(function()
                game.ReplicatedStorage.Communication.Harvest:FireServer(crop.Name)
                didFarm = true
            end)
        end
    end
    return didFarm
end)

-- Auto-Contribute Expansion
createToggle("autofarmExpand", main, "Auto-Contribute", function()
    local didFarm = false
    for _, exp in ipairs(expand:GetChildren()) do
        local top = exp:FindFirstChild("Top")
        local bGui = top and top:FindFirstChild("BillboardGui")
        if bGui then
            for _, contribute in ipairs(bGui:GetChildren()) do
                if contribute:IsA("Frame") and contribute.Name ~= "Example" then
                    local args = {exp.Name, contribute.Name, 1}
                    pcall(function()
                        game.ReplicatedStorage.Communication.ContributeToExpand:FireServer(unpack(args))
                        didFarm = true
                    end)
                end
            end
        end
    end
    return didFarm
end)

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
    local didCraft = false
    for _, c in pairs(plot:GetDescendants()) do
        if c.Name == "Crafter" then
            local attachment = c:FindFirstChildOfClass("Attachment")
            if attachment then
                pcall(function()
                    game.ReplicatedStorage.Communication.Craft:FireServer(attachment)
                    didCraft = true
                end)
            end
        end
    end
    return didCraft
end)

-- Auto Gold Mine
createToggle("autoGoldMine", coll, "Auto Gold Mine", function()
    local didMine = false
    for _, mine in pairs(land:GetDescendants()) do
        if mine:IsA("Model") and mine.Name == "GoldMineModel" then
            pcall(function()
                game.ReplicatedStorage.Communication.Goldmine:FireServer(mine.Parent.Name, 1)
                didMine = true
            end)
        end
    end
    return didMine
end)

-- Auto Collect Gold
createToggle("autoCollectGold", coll, "Auto Collect Gold", function()
    local didCollect = false
    for _, mine in pairs(land:GetDescendants()) do
        if mine:IsA("Model") and mine.Name == "GoldMineModel" then
            pcall(function()
                game.ReplicatedStorage.Communication.Goldmine:FireServer(mine.Parent.Name, 2)
                didCollect = true
            end)
        end
    end
    return didCollect
end)

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

-- Option 2: Category Buttons with Toggles
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
        end)
    end
end)
