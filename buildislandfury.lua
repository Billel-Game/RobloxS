local omni = loadstring(game:HttpGet("https://raw.githubusercontent.com/Billel-Game/RobloxS/refs/heads/main/libtest.lua"))()
omni:ShowKeyPrompt(
    "https://raw.githubusercontent.com/Billel-Game/RobloxS/main/broken",
    "https://link-target.net/1380127/e5ro3DcEbUkf"
)

local UI = omni.new({
    Name = "🔥 Build Island Script 🔥",
    Credit = "Created by Billel",
    Color = Color3.fromRGB(122, 28, 187),
    Discord = "Billel"
})

omni:CreateToggleButton(UI, 133641333781908)

-- UI Pages/Sections
local mainPage = UI:CreatePage("Main 🏠")
local mainSection = mainPage:CreateSection("Main")
local collSection = mainPage:CreateSection("Collection")
local eventSection = mainPage:CreateSection("Events")
local fishSection = mainPage:CreateSection("Fishing")
local shopSection = mainPage:CreateSection("Shop")

-- Services and Variables
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local plot = workspace:WaitForChild("Plots"):WaitForChild(plr.Name)
local land = plot:FindFirstChild("Land")
local expand = plot:WaitForChild("Expand")

-- Generalized toggle pattern
local function createToggle(section, name, loopFn)
    local flag = false
    section:CreateToggle({
        Name = name,
        Flag = name,
        Default = false,
        Callback = function(state)
            flag = state
            if state then
                task.spawn(function()
                    while flag do
                        loopFn()
                        task.wait(5)
                    end
                end)
            end
        end
    })
    return function() return flag end
end

-- Auto-Farm Plot
createToggle(collSection, "Auto-Farm Plot", function()
    local plotResources = plot:FindFirstChild("Resources")
    if plotResources then
        for _, resource in ipairs(plotResources:GetChildren()) do
            pcall(function()
                game.ReplicatedStorage.Communication.HitResource:FireServer(resource)
            end)
        end
    end
end)

-- Auto-Farm Rainbow Island
createToggle(eventSection, "Auto-Farm Rainbow Island", function()
    local rainbow = workspace:FindFirstChild("RainbowIsland")
    if rainbow and rainbow:FindFirstChild("Resources") then
        for _, resource in ipairs(rainbow.Resources:GetChildren()) do
            pcall(function()
                game.ReplicatedStorage.Communication.HitResource:FireServer(resource)
            end)
        end
    end
end)

-- Auto-Farm World Tree
createToggle(eventSection, "Auto-Farm World Tree", function()
    local globalResources = workspace:FindFirstChild("GlobalResources")
    local worldTree = globalResources and globalResources:FindFirstChild("World Tree")
    if worldTree then
        pcall(function()
            game.ReplicatedStorage.Communication.HitResource:FireServer(worldTree)
        end)
    end
end)

-- Auto-Hive
createToggle(collSection, "Auto-Hive", function()
    for _, spot in ipairs(land:GetDescendants()) do
        if spot:IsA("Model") and spot.Name:match("Spot") then
            pcall(function()
                game.ReplicatedStorage.Communication.Hive:FireServer(spot.Parent.Name, spot.Name, 2)
            end)
        end
    end
end)

-- Auto-Harvest
createToggle(collSection, "Auto-Harvest", function()
    local plants = plot:FindFirstChild("Plants")
    if plants then
        for _, crop in ipairs(plants:GetChildren()) do
            pcall(function()
                game.ReplicatedStorage.Communication.Harvest:FireServer(crop.Name)
            end)
        end
    end
end)

-- Auto-Contribute Expansion
createToggle(mainSection, "Auto-Contribute", function()
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
end)

-- Teleport to Fishing Spot
fishSection:CreateButton({
    Name = "Teleport to Fishing Spot",
    Callback = function()
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(-553.862, -1.64, -95.602)
        end
    end
})

-- Auto-Fish
local autoFish = false
local fishConnection
local RunService = game:GetService("RunService")
local lastCast = 0
local cooldown = 0.01
fishSection:CreateToggle({
    Name = "Auto-Fish",
    Flag = "AutoFish",
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

-- Auto-Crafter
createToggle(mainSection, "Auto Crafter", function()
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
end)

-- Auto Gold Mine
createToggle(collSection, "Auto Gold Mine", function()
    for _, mine in pairs(land:GetDescendants()) do
        if mine:IsA("Model") and mine.Name == "GoldMineModel" then
            pcall(function()
                game.ReplicatedStorage.Communication.Goldmine:FireServer(mine.Parent.Name, 1)
            end)
        end
    end
end)

-- Auto Collect Gold
createToggle(collSection, "Auto Collect Gold", function()
    for _, mine in pairs(land:GetDescendants()) do
        if mine:IsA("Model") and mine.Name == "GoldMineModel" then
            pcall(function()
                game.ReplicatedStorage.Communication.Goldmine:FireServer(mine.Parent.Name, 2)
            end)
        end
    end
end)

-- Timed Rewards Button
shopSection:CreateButton({
    Name = "Claim All Timed Rewards",
    Callback = function()
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
    end
})

-- Claim Shamrock Chest
shopSection:CreateButton({
    Name = "Claim Shamrock Chest",
    Callback = function()
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
    end
})

-- Buy Lightning Crate
shopSection:CreateButton({
    Name = "Buy Lightning Crate",
    Callback = function()
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
    end
})

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

    shopSection:CreateButton({
        Name = "Category: " .. category,
        Callback = function()
            if #categoryToggles[category] > 0 then
                -- Remove existing toggles
                for _, toggle in ipairs(categoryToggles[category]) do
                    toggle:Destroy()
                end
                categoryToggles[category] = {}
            else
                -- Add toggles
                for _, item in ipairs(items) do
                    local toggle = shopSection:CreateToggle({
                        Name = "Auto-Buy: " .. item,
                        Flag = "AutoBuy_" .. item,
                        Default = autoBuyItems[item] or false,
                        Callback = function(state)
                            autoBuyItems[item] = state
                        end
                    })
                    table.insert(categoryToggles[category], toggle)
                end
            end
        end
    })
end

-- Master Auto-Buy Toggle
shopSection:CreateToggle({
    Name = "Auto-Buy Selected Items",
    Flag = "AutoBuySelected",
    Default = false,
    Callback = function(state)
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
    end
})