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