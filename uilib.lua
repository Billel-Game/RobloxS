local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Config
local CONFIG = {
    ToggleKey = Enum.KeyCode.RightShift,
    Width = 500,
    Height = 300,
    Theme = {
        Background = Color3.fromRGB(30,30,30),
        Panel = Color3.fromRGB(50,50,50),
        Text = Color3.fromRGB(220,220,220),
        Accent = Color3.fromRGB(100,150,255)
    }
}

-- Utility to create UI elements quickly
local function make(class, props)
    local obj = Instance.new(class)
    if props then
        for k,v in pairs(props) do
            if k == "Parent" then
                obj.Parent = v
            else
                pcall(function() obj[k] = v end)
            end
        end
    end
    return obj
end

-- Center position helper
local function center(width, height)
    return UDim2.new(0.5, -width/2, 0.5, -height/2)
end

-- Create main ScreenGui and frame
local screenGui = make("ScreenGui", {
    Parent = playerGui,
    Name = "SimpleUI",
    ResetOnSpawn = false,
})

local mainFrame = make("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, CONFIG.Width, 0, CONFIG.Height),
    Position = center(CONFIG.Width, CONFIG.Height),
    BackgroundColor3 = CONFIG.Theme.Background,
    Visible = true,
})

make("UICorner", {Parent = mainFrame, CornerRadius = UDim.new(0, 10)})

-- Tab Buttons container
local tabBar = make("Frame", {
    Parent = mainFrame,
    Size = UDim2.new(1, 0, 0, 40),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = CONFIG.Theme.Panel,
})

make("UICorner", {Parent = tabBar, CornerRadius = UDim.new(0, 10)})

-- Content container
local content = make("Frame", {
    Parent = mainFrame,
    Size = UDim2.new(1, -20, 1, -60),
    Position = UDim2.new(0, 10, 0, 50),
    BackgroundColor3 = CONFIG.Theme.Panel,
})

make("UICorner", {Parent = content, CornerRadius = UDim.new(0, 8)})

-- Tabs data
local tabs = {}
local activeTabIndex = nil

-- Helper: add tab button
local function addTab(name)
    local index = #tabs + 1
    local btn = make("TextButton", {
        Parent = tabBar,
        Size = UDim2.new(0, 100, 1, -8),
        Position = UDim2.new(0, (index - 1) * 110 + 10, 0, 4),
        Text = name,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        BackgroundColor3 = CONFIG.Theme.Panel,
        TextColor3 = CONFIG.Theme.Text,
    })
    make("UICorner", {Parent = btn, CornerRadius = UDim.new(0, 6)})

    local page = make("Frame", {
        Parent = content,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
    })

    tabs[index] = {Name = name, Button = btn, Page = page}

    btn.MouseButton1Click:Connect(function()
        for i, t in ipairs(tabs) do
            t.Page.Visible = false
            t.Button.BackgroundColor3 = CONFIG.Theme.Panel
        end
        tabs[index].Page.Visible = true
        tabs[index].Button.BackgroundColor3 = CONFIG.Theme.Accent
        activeTabIndex = index
    end)

    return page
end

-- Add tabs
local mainTab = addTab("Main")
local miscTab = addTab("Misc")

-- Activate first tab by default
tabs[1].Button:CaptureFocus()
tabs[1].Button.BackgroundColor3 = CONFIG.Theme.Accent
tabs[1].Page.Visible = true
activeTabIndex = 1

-- Helper: add a button to a tab page
local function addButton(parent, text, callback)
    local btn = make("TextButton", {
        Parent = parent,
        Size = UDim2.new(0, 150, 0, 36),
        Position = UDim2.new(0, 20, 0, #parent:GetChildren() * 46),
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        BackgroundColor3 = CONFIG.Theme.Background,
        TextColor3 = CONFIG.Theme.Text,
    })
    make("UICorner", {Parent = btn, CornerRadius = UDim.new(0, 6)})

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Helper: add a toggle to a tab page
local function addToggle(parent, text, default, callback)
    local frame = make("Frame", {
        Parent = parent,
        Size = UDim2.new(0, 200, 0, 36),
        Position = UDim2.new(0, 20, 0, #parent:GetChildren() * 46),
        BackgroundTransparency = 1,
    })

    local label = make("TextLabel", {
        Parent = frame,
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = CONFIG.Theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local toggleBtn = make("TextButton", {
        Parent = frame,
        Text = default and "ON" or "OFF",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = CONFIG.Theme.Text,
        BackgroundColor3 = default and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50),
        Size = UDim2.new(0, 50, 0, 26),
        Position = UDim2.new(0.75, 0, 0.15, 0),
    })
    make("UICorner", {Parent = toggleBtn, CornerRadius = UDim.new(0, 6)})

    local state = default

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        callback(state)
    end)

    return frame
end

-- Add sample controls to Main tab
addButton(mainTab, "Press me!", function()
    print("Button pressed!")
end)

addToggle(mainTab, "Enable feature", false, function(state)
    print("Toggle state:", state)
end)

-- Add sample controls to Misc tab
addButton(miscTab, "Misc Button", function()
    print("Misc Button clicked")
end)

addToggle(miscTab, "Misc Toggle", true, function(state)
    print("Misc Toggle state:", state)
end)

-- Simple dragging (click and drag main frame)
local dragging = false
local dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Toggle UI visibility with RightShift instantly (no tween)
local visible = true
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == CONFIG.ToggleKey then
        visible = not visible
        mainFrame.Visible = visible
        print("UI toggled, now visible:", visible)
    end
end)
