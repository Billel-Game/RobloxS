local omni = loadstring(game:HttpGet("https://raw.githubusercontent.com/Billel-Game/RobloxS/refs/heads/main/libtest.lua"))()
omni:ShowKeyPrompt(
    "https://raw.githubusercontent.com/Billel-Game/RobloxS/main/broken",
    "https://link-target.net/1380127/e5ro3DcEbUkf"
)
--// UI Setup
local UI = omni.new({
    Name = "🔥 Fury Scripts 🔥",
    Credit = "Created by Billel",
    Color = Color3.fromRGB(122, 28, 187),
    Discord = "Billel"
})

local toggleButton = omni:CreateToggleButton(UI, 133641333781908)

local mainPage = UI:CreatePage("Main 🏠")
local mainSection = mainPage:CreateSection("Main (Toggles)")

--// Services & Remotes
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local net = ReplicatedStorage:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

local EquipToolFromHotbar = net:WaitForChild("RE/EquipToolFromHotbar")
local ChargeFishingRod = net:WaitForChild("RF/ChargeFishingRod")
local RequestFishingMinigameStarted = net:WaitForChild("RF/RequestFishingMinigameStarted")
local FishingCompleted = net:WaitForChild("RE/FishingCompleted")
local SellAllItems = net:WaitForChild("RF/SellAllItems")
local RedeemCode = net:WaitForChild("RF/RedeemCode")

local autoFishEnabled = false

mainSection:CreateToggle({
    Name = "🎣 Auto Fish",
    Flag = "AutoFish",
    Default = false,
    Callback = function(state)
        autoFishEnabled = state
        if state then
            -- Equip fishing rod/tool ONCE before starting the loop
            pcall(function()
                EquipToolFromHotbar:FireServer(1)
            end)
            task.spawn(function()
                while autoFishEnabled do
                    -- 1. Charge fishing rod
                    pcall(function()
                        ChargeFishingRod:InvokeServer(1754880829.878927)
                    end)
                    task.wait(0.2)
                    -- 2. Start minigame
                    pcall(function()
                        RequestFishingMinigameStarted:InvokeServer(-1.2379989624023438, 0.9989980268601486)
                    end)
                    task.wait(0.2)
                    -- 3. Complete fishing
                    pcall(function()
                        FishingCompleted:FireServer()
                    end)
                    task.wait(1) -- Adjust as needed for game timing
                end
            end)
        end
    end
})

local autoSellEnabled = false

mainSection:CreateToggle({
    Name = "💰 Auto Sell All Items",
    Flag = "AutoSellAll",
    Default = false,
    Callback = function(state)
        autoSellEnabled = state
        if state then
            task.spawn(function()
                while autoSellEnabled do
                    pcall(function()
                        SellAllItems:InvokeServer()
                    end)
                    task.wait(5)
                end
            end)
        end
    end
})

local teleportLocations = {
    ["Sisyphus Statue"] = {-3743, -136, -1017},
    ["Treasure Room"]   = {-3606, -267, -1580}
}

mainSection:CreateDropdown({
    Name = "Teleport Location",
    Flag = "TeleportDropdown",
    Options = {"Sisyphus Statue", "Angler rod", "Treasure Room"}, -- Use Options, not List
    Callback = function(selected)
        local pos = teleportLocations[selected]
        if pos then
            local player = game.Players.LocalPlayer
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(table.unpack(pos))
            end
        end
    end
})

local teleportShops = {
    ["Angler rod"]      = {-3789, -148, -1345},
}

mainSection:CreateDropdown({
    Name = "Teleport Shops",
    Flag = "TeleportDropdown",
    Options = {"Sisyphus Statue", "Angler rod", "Treasure Room"}, -- Use Options, not List
    Callback = function(selected)
        local pos = teleportShops[selected]
        if pos then
            local player = game.Players.LocalPlayer
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(table.unpack(pos))
            end
        end
    end
})