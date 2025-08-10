-- Main UI Script
local omni = loadstring(game:HttpGet("https://raw.githubusercontent.com/Billel-Game/RobloxS/refs/heads/main/uilib.lua"))()

local UI = omni.new({
    Name = "🔥 Fury Scripts 🔥";
    Credit = "Created by Billel";
    Color = Color3.fromRGB(122,28,187);
    Bind = "LeftControl";
    UseLoader = false;
    FullName = "";
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

local autoFire = false
Section:CreateToggle({
    Name = "Auto Fish";
    Flag = "Auto Fish";
    Default = false;
    Callback = function(state)
        autoFire = state
        if state then
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local remoteEvent = ReplicatedStorage:WaitForChild("\232\132\154\230\156\172")
                    :WaitForChild("RemoteEvent")
                    :WaitForChild("\228\186\139\228\187\182\232\167\166\229\143\145")

                local args = {
                    {
                        event = "\233\146\147\233\177\188"
                    }
                }

                while autoFire do
                    pcall(function()
                        remoteEvent:FireServer(unpack(args))
                    end)
                    task.wait(0.5) -- adjust delay as needed
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
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local sellRemote = ReplicatedStorage:WaitForChild("\232\132\154\230\156\172")
                    :WaitForChild("RemoteEvent")
                    :WaitForChild("\228\186\139\228\187\182\232\167\166\229\143\145")

                local args = {
                    {
                        event = "\229\133\168\233\131\168\229\135\186\229\148\174"
                    }
                }

                while autoSell do
                    pcall(function()
                        sellRemote:FireServer(unpack(args))
                    end)
                    task.wait(0.5) -- adjust delay if needed
                end
            end)
        end
    end;
})

local autoCollectBoats = false
Section:CreateToggle({
    Name = "🚤 Auto Collect Boats (Chinese support)";
    Flag = "AutoCollectBoats";
    Default = false,
    Callback = function(state)
        autoCollectBoats = state
        if state then
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local remoteEvent = ReplicatedStorage:WaitForChild("\232\132\154\230\156\172")
                    :WaitForChild("RemoteEvent")
                    :WaitForChild("\228\186\139\228\187\182\232\167\166\229\143\145")

                local workspaceRoot = workspace -- Change if boats are in a subfolder

                while autoCollectBoats do
                    local boatIds = {}

                    for _, obj in ipairs(workspaceRoot:GetDescendants()) do
                        -- Check for StringValue named "v"
                        if obj:IsA("StringValue") and obj.Name == "v" then
                            local val = obj.Value
                            -- Quick check: does val look like your boat ID? (numbers and dot)
                            if val:match("^%d+%.%d+$") then
                                table.insert(boatIds, val)
                            end
                        end
                    end

                    for _, boatId in ipairs(boatIds) do
                        local args = {
                            {
                                event = "\229\187\186\231\173\145\231\137\169_\230\148\182\233\155\134",
                                v = boatId
                            }
                        }
                        pcall(function()
                            remoteEvent:FireServer(unpack(args))
                        end)
                        task.wait(0.3)
                    end

                    task.wait(1)
                end
            end)
        end
    end;
})




