    local omni = loadstring(game:HttpGet("https://raw.githubusercontent.com/Billel-Game/RobloxS/refs/heads/main/uilib.lua"))()

    local UI = omni.new({
        Name = "🔥 Fury Scripts 🔥";
        Credit = "Created by Billel";
        Color = Color3.fromRGB(122,28,187);
        Bind = "LeftControl";
        UseLoader = false;
        FullName = "";
        CheckKey = function(inputtedKey)
            return inputtedKey=="123"
        end;
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
  local autoPoop = false

Section:CreateToggle({
    Name = "💩 Auto Poop";
    Flag = "AutoPoop";
    Default = false;
    Callback = function(state)
        autoPoop = state
        if state then
            task.spawn(function()
                while autoPoop do
                    -- Noclip: set CanCollide false for all character parts
                    local char = game.Players.LocalPlayer.Character
                    if char then
                        for _, part in ipairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                    -- First remote
                    game:GetService("ReplicatedStorage"):WaitForChild("PoopChargeStart"):FireServer()
                    -- Second remote with args
                    local args = { 1 }
                    game:GetService("ReplicatedStorage"):WaitForChild("PoopEvent"):FireServer(unpack(args))
                    task.wait(1) -- adjust delay if needed
                end
            end)
        end
    end;
})

    Section:CreateButton({
        Name = "💰 Sell Inventory";
        Callback = function()
            game:GetService("ReplicatedStorage"):WaitForChild("Sell_Inventory"):FireServer()
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
                    while autoSell do
                        game:GetService("ReplicatedStorage"):WaitForChild("Sell_Inventory"):FireServer()
                        task.wait(5)
                    end
                end)
            end
        end;
    })

local autoQuest = false

Section:CreateToggle({
    Name = "Auto Monkey Quest 🦧";
    Flag = "AutoQuest";
    Default = false;
    Callback = function(state)
        autoQuest = state
        if state then
            task.spawn(function()
                while autoQuest do
                    local args = {
                        "MonkeyKing",
                        {
                            Read_Only = true,
                            Proxy_Package = {}
                        }
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("Quest_Fetch_Status"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end;
})
    local Pages2 = UI:CreatePage("Shop 💲")

    local Section = Pages2:CreateSection("Gear Shop (Auto Buy)")

local autoLaxative = false
Section:CreateToggle({
    Name = "⚙️ Auto Buy Laxative";
    Flag = "AutoLaxative";
    Default = false;
    Callback = function(state)
        autoLaxative = state
        if state then
            task.spawn(function()
                while autoLaxative do
                    local args = { "Laxative" }
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("GearShop: RequestPurchase"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end;
})

local autoPills = false
Section:CreateToggle({
    Name = "⚙️ Auto Buy Pills";
    Flag = "AutoPills";
    Default = false;
    Callback = function(state)
        autoPills = state
        if state then
            task.spawn(function()
                while autoPills do
                    local args = { "Pills" }
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("GearShop: RequestPurchase"):InvokeServer(unpack(args))
                    task.wait(5)
                end
            end)
        end
    end;
})
   local Section = Pages2:CreateSection("Egg Shop (Auto Buy)")

    local autoCommonEgg = false
Section:CreateToggle({
    Name = "🥚 Auto Open Common Egg";
    Flag = "AutoCommonEgg";
    Default = false;
    Callback = function(state)
        autoCommonEgg = state
        if state then
            task.spawn(function()
                while autoCommonEgg do
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("PetEggShop:RequestPurchase"):InvokeServer("Common Egg")
                    task.wait(5)
                end
            end)
        end
    end;
})

local autoLegendaryEgg = false
Section:CreateToggle({
    Name = "🌟 Auto Open Legendary Egg";
    Flag = "AutoLegendaryEgg";
    Default = false;
    Callback = function(state)
        autoLegendaryEgg = state
        if state then
            task.spawn(function()
                while autoLegendaryEgg do
                    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("PetEggShop:RequestPurchase"):InvokeServer("Legendary Egg")
                    task.wait(5)
                end
            end)
        end
    end;
})