local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/discord"))()

local win = DiscordLib:Window("discord library")
local serv = win:Server("Preview", "")
local main = serv:Channel("Main")
local event = serv:Channel("Events")

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local plot = workspace:WaitForChild("Plots"):WaitForChild(plr.Name)

local land = plot:FindFirstChild("Land")
local expand = plot:WaitForChild("Expand")

-- UI Labels
main:Label("Collection.")
main:Seperator()

-- Auto-Farm Plot
local autoFarmPlot = false
main:Toggle("Auto-Farm Plot", false, function(state)
    autoFarmPlot = state
end)

task.spawn(function()
    while true do
        if autoFarmPlot then
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
        end
        task.wait(0.1)
    end
end)

-- Auto-Farm Rainbow Island
local autoFarmRainbow = false
event:Toggle("Auto-Farm Rainbow Island", false, function(state)
    autoFarmRainbow = state
end)

task.spawn(function()
    while true do
        if autoFarmRainbow then
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
        end
        task.wait(0.1)
    end
end)

-- Auto-Farm World Tree
local autoFarmWT = false
event:Toggle("Auto-Farm World Tree", false, function(state)
    autoFarmWT = state
end)

task.spawn(function()
    while true do
        if autoFarmWT then
            local worldtree = workspace:FindFirstChild("GlobalResources")
            if worldtree and worldtree:FindFirstChild("World Tree") then
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
        end
        task.wait(0.1)
    end
end)



-- Auto Hive Toggle
local autohive = false
main:Toggle("Auto-Hive", false, function(state)
    autohive = state
end)

task.spawn(function()
    while true do
        if autohive and land then
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
        end
        task.wait(0.5)
    end
end)

-- Auto Harvest Toggle
local autoharvest = false
main:Toggle("Auto-Harvest", false, function(state)
    autoharvest = state
end)

task.spawn(function()
    while true do
        if autoharvest then
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
        end
        task.wait(0.5)
    end
end)

-- Expansion Section
main:Label("Expansion.")
main:Seperator()

local autofarmExpand = false
main:Toggle("Auto-Contribute", false, function(state)
    autofarmExpand = state
end)

task.spawn(function()
    while true do
        if autofarmExpand then
            for _, exp in ipairs(expand:GetChildren()) do
                local top = exp:FindFirstChild("Top")
                if top then
                    local bGui = top:FindFirstChild("BillboardGui")
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
            end
        end
        task.wait(1)
    end
end)
