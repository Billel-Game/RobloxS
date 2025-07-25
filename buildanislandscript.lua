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

-- Max hits per loop to reduce spam
local MAX_HITS_PER_LOOP = 3

-- Generalized toggle pattern with loopFn returning if it did work or not
local function createToggle(parent, label, loopFn)
    local flag = false
    parent:Toggle(label, false, function(state)
        flag = state
        if state then
            task.spawn(function()
                while flag do
                    local didWork = false
                    local ok, result = pcall(loopFn)
                    if ok then
                        didWork = result
                    else
                        warn("Error in "..label..":", result)
                    end
                    if didWork then
                        task.wait(0.5)
                    else
                        task.wait(2) -- wait longer if nothing done to reduce load
                    end
                end
            end)
        end
    end)
end

-- Auto-Farm Plot
createToggle(coll, "Auto-Farm Plot", function()
    local hits = 0
    local didFarm = false
    local plotResources = plot:FindFirstChild("Resources")
    if plotResources then
        for _, resource in ipairs(plotResources:GetChildren()) do
            if resource and resource.Parent then
                pcall(function()
                    game.ReplicatedStorage.Communication.HitResource:FireServer(resource)
                end)
                didFarm = true
                hits = hits + 1
                if hits >= MAX_HITS_PER_LOOP then break end
            end
        end
    end
    return didFarm
end)

-- Auto-Farm Rainbow Island
createToggle(event, "Auto-Farm Rainbow Island", function()
    local hits = 0
    local didFarm = false
    local rainbow = workspace:FindFirstChild("RainbowIsland")
    if rainbow and rainbow:FindFirstChild("Resources") then
        for _, resource in ipairs(rainbow.Resources:GetChildren()) do
            if resource and resource.Parent then
                pcall(function()
                    game.ReplicatedStorage.Communication.HitResource:FireServer(resource)
                end)
                didFarm = true
                hits = hits + 1
                if hits >= MAX_HITS_PER_LOOP then break end
            end
        end
    end
    return didFarm
end)

-- Auto-Farm World Tree
createToggle(event, "Auto-Farm World Tree", function()
    local didFarm = false
    local globalResources = workspace:FindFirstChild("GlobalResources")
    local worldTree = globalResources and globalResources:FindFirstChild("World Tree")
    if worldTree and worldTree.Parent then
        pcall(function()
            game.ReplicatedStorage.Communication.HitResource:FireServer(worldTree)
        end)
        didFarm = true
    end
    return didFarm
end)

-- Auto-Hive
createToggle(coll, "Auto-Hive", function()
    local hits = 0
    local didFarm = false
    if land then
        for _, spot in ipairs(land:GetDescendants()) do
            if spot:IsA("Model") and spot.Name:match("Spot") and spot.Parent then
                pcall(function()
                    game.ReplicatedStorage.Communication.Hive:FireServer(spot.Parent.Name, spot.Name, 2)
                end)
                didFarm = true
                hits = hits + 1
                if hits >= MAX_HITS_PER_LOOP then break end
            end
        end
    end
    return didFarm
end)

-- Auto-Harvest
createToggle(coll, "Auto-Harvest", function()
    local hits = 0
    local didFarm = false
    local plants = plot:FindFirstChild("Plants")
    if plants then
        for _, crop in ipairs(plants:GetChildren()) do
            if crop and crop.Parent then
                pcall(function()
                    game.ReplicatedStorage.Communication.Harvest:FireServer(crop.Name)
                end)
                didFarm = true
                hits = hits + 1
                if hits >= MAX_HITS_PER_LOOP then break end
            end
        end
    end
    return didFarm
end)

-- Auto-Contribute Expansion
createToggle(main, "Auto-Contribute", function()
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
                    end)
                    didFarm = true
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
local cooldown = 0.005 -- increase cooldown to reduce spam
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
createToggle(main, "Auto Crafter", function()
    local didCraft = false
    for _, c in pairs(plot:GetDescendants()) do
        if c.Name == "Crafter" then
            local attachment = c:FindFirstChildOfClass("Attachment")
            if attachment then
                pcall(function()
                    game.ReplicatedStorage.Communication.Craft:FireServer(attachment)
                end)
                didCraft = true
            end
        end
    end
    return didCraft
end)

-- Auto Gold Mine
createToggle(coll, "Auto Gold Mine", function()
    local hits = 0
    local didMine = false
    if land then
        for _, mine in pairs(land:GetDescendants()) do
            if mine:IsA("Model") and mine.Name == "GoldMineModel" and mine.Parent then
                pcall(function()
                    game.ReplicatedStorage.Communication.Goldmine:FireServer(mine.Parent.Name, 1)
                end)
                didMine = true
                hits = hits + 1
                if hits >= MAX_HITS_PER_LOOP then break end
            end
        end
    end
    return didMine
end)

-- Auto Collect Gold
createToggle(coll, "Auto Collect Gold", function()
    local hits = 0
    local didCollect = false
    if land then
        for _, mine in pairs(land:GetDescendants()) do
            if mine:IsA("Model") and mine.Name == "GoldMineModel" and mine.Parent then
                pcall(function()
                    game.ReplicatedStorage.Communication.Goldmine:FireServer(mine.Parent.Name, 2)
                end)
                didCollect = true
                hits = hits + 1
                if hits >= MAX_HITS_PER_LOOP then break end
            end
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
            for _, toggle in ipairs(categoryToggles[category]) do
                toggle:Destroy()
            end
            categoryToggles[category] = {}
        else
            for _, item in ipairs(items) do
                local toggle = shop:Toggle("Auto-Buy: " .. item, autoBuyItems[item] or false, function(state)
                    autoBuyItems[item] = state
                end)
                table.insert(categoryToggles[category], toggle)
            end
        end
    end)
end

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
