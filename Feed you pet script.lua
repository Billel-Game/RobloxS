local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/discord"))()

local win = DiscordLib:Window("discord library")
local serv = win:Server("Made by Billel", "")
local main = serv:Channel("Main")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = Players.LocalPlayer

-- Anti AFK
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

-- Helper: Get player’s plot
local function getMyPlot()
    local plots = workspace:WaitForChild("Gameplay"):WaitForChild("Plots")
    for _, plot in pairs(plots:GetChildren()) do
        local owner = plot:FindFirstChild("Owner")
        if owner and owner.Value == plr then
            return plot
        end
    end
    return nil
end

-- Auto-Click Food Pump
local autoClickPump = false
local foodPumpConnection

main:Toggle("Auto-Click Food Pump", false, function(state)
    autoClickPump = state

    if state then
        foodPumpConnection = task.spawn(function()
            while autoClickPump do
                local success, err = pcall(function()
                    local myPlot = getMyPlot()
                    if not myPlot then
                        warn("Could not find your plot.")
                        return
                    end

                    local args = { myPlot }
                    ReplicatedStorage:WaitForChild("Events")
                        :WaitForChild("Gameplay")
                        :WaitForChild("ClickFoodPump")
                        :FireServer(unpack(args))
                end)

                if not success then
                    warn("ClickFoodPump failed:", err)
                end

                task.wait(0.1) -- Adjust as needed
            end
        end)
    else
        autoClickPump = false
        foodPumpConnection = nil
    end
end)

-- Auto Change Friends Online
local autoChangeFriends = false
local friendsConnection

main:Toggle("Auto Change Friends Online", false, function(state)
    autoChangeFriends = state

    if state then
        friendsConnection = task.spawn(function()
            while autoChangeFriends do
                local args = { 10000 }

                local success, err = pcall(function()
                    ReplicatedStorage:WaitForChild("Events")
                        :WaitForChild("Other")
                        :WaitForChild("ChangeFriendsOnline")
                        :FireServer(unpack(args))
                end)

                if not success then
                    warn("ChangeFriendsOnline failed:", err)
                end

                task.wait(5) -- Adjust how often it fires
            end
        end)
    else
        autoChangeFriends = false
        friendsConnection = nil
    end
end)

-- Auto Grow Passive Food
local autoGrowFood = false
local growFoodConnection

main:Toggle("Auto Grow Passive Food", false, function(state)
    autoGrowFood = state

    if state then
        growFoodConnection = task.spawn(function()
            while autoGrowFood do
                local success, err = pcall(function()
                    ReplicatedStorage:WaitForChild("Events")
                        :WaitForChild("Gameplay")
                        :WaitForChild("GrowPassiveFood")
                        :FireServer()
                end)

                if not success then
                    warn("GrowPassiveFood failed:", err)
                end

                task.wait(0.1) -- Adjust delay as needed (e.g., 1-10 seconds)
            end
        end)
    else
        autoGrowFood = false
        growFoodConnection = nil
    end
end)