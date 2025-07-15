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

local antiAfkConnection

main:Toggle("Anti AFK", false, function(state)
    if state then
        antiAfkConnection = plr.Idled:Connect(function()
            local vu = game:GetService("VirtualUser")
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end)
        print("Anti AFK enabled")
    else
        if antiAfkConnection then
            antiAfkConnection:Disconnect()
            antiAfkConnection = nil
        end
        print("Anti AFK disabled")
    end
end)


-- Auto-Farm Plot
local autoFarmPlot = false
local farmPlotConnection

coll:Toggle("Auto-Farm Plot", false, function(state)
    autoFarmPlot = state

    if state then
        farmPlotConnection = task.spawn(function()
            while autoFarmPlot do
                local plotResources = plot:FindFirstChild("Resources")
                if plotResources then
                    for _, resource in ipairs(plotResources:GetChildren()) do
                        local success, err = pcall(function()
                            game.ReplicatedStorage.Communication.HitResource:FireServer(resource)
                        end)
                        if not success then
                            warn("Plot HitResource failed:", err)
                        end
                        task.wait(0.01)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

-- Auto-Farm Rainbow Island
local autoFarmRainbow = false
local rainbowConnection

event:Toggle("Auto-Farm Rainbow Island", false, function(state)
    autoFarmRainbow = state

    if state then
        rainbowConnection = task.spawn(function()
            while autoFarmRainbow do
                local rainbow = workspace:FindFirstChild("RainbowIsland")
                if rainbow and rainbow:FindFirstChild("Resources") then
                    for _, resource in ipairs(rainbow.Resources:GetChildren()) do
                        local success, err = pcall(function()
                            game.ReplicatedStorage.Communication.HitResource:FireServer(resource)
                        end)
                        if not success then
                            warn("Rainbow HitResource failed:", err)
                        end
                        task.wait(0.01)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

-- Auto-Farm World Tree
local autoFarmWT = false
local worldTreeConnection

event:Toggle("Auto-Farm World Tree", false, function(state)
    autoFarmWT = state

    if state then
        worldTreeConnection = task.spawn(function()
            while autoFarmWT do
                local globalResources = workspace:FindFirstChild("GlobalResources")
                local worldTree = globalResources and globalResources:FindFirstChild("World Tree")

                if worldTree then
                    local success, err = pcall(function()
                        game.ReplicatedStorage.Communication.HitResource:FireServer(worldTree)
                    end)
                    if not success then
                        warn("World Tree HitResource failed:", err)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

-- Auto Hive Toggle
local autohive = false
local hiveConnection

coll:Toggle("Auto-Hive", false, function(state)
    autohive = state

    if state then
        hiveConnection = task.spawn(function()
            while autohive and land do
                for _, spot in ipairs(land:GetDescendants()) do
                    if spot:IsA("Model") and spot.Name:match("Spot") then
                        local success, err = pcall(function()
                            game.ReplicatedStorage.Communication.Hive:FireServer(spot.Parent.Name, spot.Name, 2)
                        end)
                        if not success then
                            warn("Hive FireServer failed:", err)
                        end
                        task.wait(0.01)
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

-- Auto Harvest Toggle
local autoharvest = false
local harvestConnection

coll:Toggle("Auto-Harvest", false, function(state)
    autoharvest = state

    if state then
        harvestConnection = task.spawn(function()
            while autoharvest do
                local plants = plot:FindFirstChild("Plants")
                if plants then
                    for _, crop in ipairs(plants:GetChildren()) do
                        local success, err = pcall(function()
                            game.ReplicatedStorage.Communication.Harvest:FireServer(crop.Name)
                        end)
                        if not success then
                            warn("Harvest FireServer failed:", err)
                        end
                        task.wait(0.01)
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

-- Expansion Section
main:Label("Expansion.")
main:Seperator()

local autofarmExpand = false
local expandConnection

main:Toggle("Auto-Contribute", false, function(state)
    autofarmExpand = state

    if state then
        expandConnection = task.spawn(function()
            while autofarmExpand do
                for _, exp in ipairs(expand:GetChildren()) do
                    local top = exp:FindFirstChild("Top")
                    local bGui = top and top:FindFirstChild("BillboardGui")
                    if bGui then
                        for _, contribute in ipairs(bGui:GetChildren()) do
                            if contribute:IsA("Frame") and contribute.Name ~= "Example" then
                                local args = {exp.Name, contribute.Name, 1}
                                local success, err = pcall(function()
                                    game.ReplicatedStorage.Communication.ContributeToExpand:FireServer(unpack(args))
                                end)
                                if not success then
                                    warn("ContributeToExpand FireServer failed:", err)
                                end
                                task.wait(0.05)
                            end
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
end)

-- Shop Buttons

shop:Button("Claim All Timed Rewards", function()
    local rewardNames = {
        "rewardOne", "rewardTwo", "rewardThree", "rewardFour",
        "rewardFive", "rewardSix", "rewardSeven", "rewardEight",
        "rewardNine", "rewardTen", "rewardEleven", "rewardTwelve"
    }

    for _, reward in ipairs(rewardNames) do
        local success, err = pcall(function()
            game:GetService("ReplicatedStorage")
                :WaitForChild("Communication")
                :WaitForChild("ClaimTimedReward")
                :InvokeServer(reward)
        end)

        if success then
            print("Claimed:", reward)
        else
            warn("Failed to claim:", reward, err)
        end

        task.wait(0.1) -- slight delay for stability
    end
end)

shop:Button("Buy Lightning Crate", function()
    local args = {
        "Lightning Crate",
        1
    }
    local success, err = pcall(function()
        game:GetService("ReplicatedStorage")
            :WaitForChild("Communication")
            :WaitForChild("PurchaseCrateRequest")
            :FireServer(unpack(args))
    end)

    if success then
        print("Successfully purchased Lightning Crate")
    else
        warn("Crate purchase failed:", err)
    end
end)


shop:Button("Claim Shamrock Chest", function()
    local args = {
        "RainbowIslandShamrockChest"
    }

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


-- Fishing Section

fish:Button("Teleport to Fishing Spot", function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(-553.862060546875, -1.6463816165924072, -95.60205078125)
        print("Teleported to fishing spot.")
    else
        warn("Teleport failed: Character or HumanoidRootPart missing.")
    end
end)

local autoFish = false
local fishConnection
local RunService = game:GetService("RunService")
local lastCast = 0
local cooldown = 0.001 -- adjust as needed

fish:Toggle("Auto-Fish", false, function(state)
    autoFish = state

    if state then
        if not fishConnection then
            fishConnection = RunService.Heartbeat:Connect(function()
                if (tick() - lastCast) >= cooldown then
                    lastCast = tick()

                    local args = {
                        Vector3.new(-553.862060546875, -1.6463816165924072, -95.60205078125),
                        0.42542959961479954
                    }

                    local success, err = pcall(function()
                        game:GetService("ReplicatedStorage")
                            :WaitForChild("Communication")
                            :WaitForChild("Fish")
                            :InvokeServer(unpack(args))
                    end)

                    if not success then
                        warn("Auto-Fish failed:", err)
                    end
                end
            end)
        end
    else
        if fishConnection then
            fishConnection:Disconnect()
            fishConnection = nil
        end
    end
end)

local craft_delay = 0.5

local autoCraft = false
main:Toggle("Auto Crafter", false, function(state)
    autoCraft = state

    if state then
        task.spawn(function()
            while autoCraft do
                for _, c in pairs(plot:GetDescendants()) do
                    if c.Name == "Crafter" then
                        local attachment = c:FindFirstChildOfClass("Attachment")
                        if attachment then
                            local success, err = pcall(function()
                                game:GetService("ReplicatedStorage")
                                    :WaitForChild("Communication")
                                    :WaitForChild("Craft")
                                    :FireServer(attachment)
                            end)
                            if not success then
                                warn("Auto Crafter failed:", err)
                            end
                        end
                    end
                end
                task.wait(craft_delay)
            end
        end)
    end
end)

local autoGoldMine = false
coll:Toggle("Auto Gold Mine", false, function(state)
    autoGoldMine = state

    if state then
        task.spawn(function()
            while autoGoldMine do
                for _, mine in pairs(land:GetDescendants()) do
                    if mine:IsA("Model") and mine.Name == "GoldMineModel" then
                        local success, err = pcall(function()
                            game:GetService("ReplicatedStorage")
                                :WaitForChild("Communication")
                                :WaitForChild("Goldmine")
                                :FireServer(mine.Parent.Name, 1)
                        end)
                        if not success then
                            warn("Auto Gold Mine failed:", err)
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
end)

local autoCollectGold = false
coll:Toggle("Auto Collect Gold", false, function(state)
    autoCollectGold = state

    if state then
        task.spawn(function()
            while autoCollectGold do
                for _, mine in pairs(land:GetDescendants()) do
                    if mine:IsA("Model") and mine.Name == "GoldMineModel" then
                        local success, err = pcall(function()
                            game:GetService("ReplicatedStorage")
                                :WaitForChild("Communication")
                                :WaitForChild("Goldmine")
                                :FireServer(mine.Parent.Name, 2)
                        end)
                        if not success then
                            warn("Auto Collect Gold failed:", err)
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
end)

local selectedItem = "Coal Crate" -- default item
local autoBuy = false

local autoBuyItems = {}
local autoBuyMerchant = false

-- Toggles for each item
local itemList = {
    "Corn Seed",
    "Coal Crate",
    "Honey Bee",
    "Busy Bee Potion",
    "Growth Potion",
    "Strawberry Seeds",
    "Autochopper Mk 1",
    "Autominer Mk1",
    "Tomato Seeds",
    "Blueberry Seeds",
    "Apple Seeds",
    "Watermelon Seeds",
    "Strength Potion",
    "Resource Potion",
    "Multicast Potion",
    "Magic Durian Seeds",
    "Magma Bee",
    "Galaxy Potion",
    "Peach Seeds",
    "Pumpkin Seeds",
    "Cherry Seeds",
    "Starfruit Seeds",
    "Mango Seeds",
    "Goji Berry Seeds",
    "Dragonfruit Seeds"
}

for _, itemName in ipairs(itemList) do
    autoBuyItems[itemName] = false
    shop:Toggle("Buy " .. itemName, false, function(state)
        autoBuyItems[itemName] = state
    end)
end

-- Master auto-buy toggle
shop:Toggle("Auto-Buy Selected Items", false, function(state)
    autoBuyMerchant = state

    if state then
        task.spawn(function()
            while autoBuyMerchant do
                for itemName, shouldBuy in pairs(autoBuyItems) do
                    if shouldBuy then
                        local args = { itemName, false }

                        local success, err = pcall(function()
                            game:GetService("ReplicatedStorage")
                                :WaitForChild("Communication")
                                :WaitForChild("BuyFromMerchant")
                                :FireServer(unpack(args))
                        end)

                        if not success then
                            warn("Failed to buy", itemName, ":", err)
                        else
                            print("Bought:", itemName)
                        end

                        task.wait(0.5) -- Delay between each item
                    end
                end

                task.wait(2) -- Delay before repeating the whole loop
            end
        end)
    end
end)


