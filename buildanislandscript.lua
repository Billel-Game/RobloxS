local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/discord"))()

local win = DiscordLib:Window("discord library")
local serv = win:Server("Preview", "")
local main = serv:Channel("Main")

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local plot = game:GetService("Workspace"):WaitForChild("Plots"):WaitForChild(plr.Name)

local land = plot:FindFirstChild("Land")
local expand = plot:WaitForChild("Expand")

main:Label("Collection.")
main:Seperator()

local autofarm = false
main:Toggle("Auto-Farm", false, function(bool)
    autofarm = bool
end)

task.spawn(function()
    while true do
        if autofarm then
            local allResources = {}

            local plotResources = plot:FindFirstChild("Resources")
            if plotResources then
                for _, r in ipairs(plotResources:GetChildren()) do
                    table.insert(allResources, r)
                end
            end

            local rainbow = workspace:FindFirstChild("RainbowIsland")
            if rainbow and rainbow:FindFirstChild("Resources") then
                for _, r in ipairs(rainbow.Resources:GetChildren()) do
                    table.insert(allResources, r)
                end
            end

            for _, r in ipairs(allResources) do
                local success, err = pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("HitResource"):FireServer(r)
                end)
                if not success then
                    warn("HitResource FireServer failed:", err)
                end
                task.wait(0.01)
            end
        end
        task.wait(0.1)
    end
end)

local autohive = false
main:Toggle("Auto-Hive", false, function(bool)
    autohive = bool
end)

task.spawn(function()
    while true do
        if autohive then
            for _, spot in ipairs(land:GetDescendants()) do
                if spot:IsA("Model") and spot.Name:match("Spot") then
                    local success, err = pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("Hive"):FireServer(spot.Parent.Name, spot.Name, 2)
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


local autoharvest = false
main:Toggle("Auto-Harvest", false, function(bool)
    autoharvest = bool
end)

task.spawn(function()
    while true do
        if autoharvest then
            local plants = plot:FindFirstChild("Plants")
            if plants then
                for _, crop in pairs(plants:GetChildren()) do
                    local success, err = pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("Harvest"):FireServer(crop.Name)
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

main:Label("Expansion.")
main:Seperator()

local autofarmExpand = false
main:Toggle("Auto-Contribute", false, function(bool)
    autofarmExpand = bool
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
                                    game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("ContributeToExpand"):FireServer(unpack(args))
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
