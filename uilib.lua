-- SpeedHubUI ModuleScript
-- Put this ModuleScript somewhere like ReplicatedStorage or ServerStorage or inside your UI folder

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CONFIG
local CONFIG = {
    ToggleKey = Enum.KeyCode.RightShift, -- change if you want another hotkey
    UIName = "SpeedHubStyleUI",
    Width = 560,
    Height = 360,
    Theme = {
        Background = Color3.fromRGB(18,18,20),
        Accent = Color3.fromRGB(98, 160, 255),
        Panel = Color3.fromRGB(28,28,30),
        Text = Color3.fromRGB(230,230,230),
        MutedText = Color3.fromRGB(170,170,170)
    },
    TweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

-- Utility functions
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

local function center(rect)
    return UDim2.new(0.5, -rect.X.Offset/2, 0.5, -rect.Y.Offset/2)
end

-- Root UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = CONFIG.UIName
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = make("Frame", {
    Parent = screenGui,
    Name = "MainFrame",
    Size = UDim2.new(0, CONFIG.Width, 0, CONFIG.Height),
    Position = center(UDim2.new(0, CONFIG.Width, 0, CONFIG.Height)),
    BackgroundColor3 = CONFIG.Theme.Background,
    BorderSizePixel = 0,
    AnchorPoint = Vector2.new(0.5,0.5),
    Visible = true
})
make("UICorner", {Parent = mainFrame, CornerRadius = UDim.new(0, 12)})

-- Shadow (simple outer stroke)
local shadow = make("Frame", {
    Parent = screenGui,
    Name = "Shadow",
    Size = UDim2.new(0, CONFIG.Width+12, 0, CONFIG.Height+12),
    Position = center(UDim2.new(0, CONFIG.Width+12, 0, CONFIG.Height+12)),
    BackgroundTransparency = 1,
    ZIndex = 0,
    AnchorPoint = Vector2.new(0.5,0.5)
})
local shadowImg = make("ImageLabel", {
    Parent = shadow,
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    Image = "rbxassetid://319258791", -- soft shadow image built-in-ish (replace if desired)
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(10,10,118,118),
})
shadowImg.AnchorPoint = Vector2.new(0.5,0.5)
shadowImg.Position = UDim2.new(0.5,0.5,0.5,0.5)

-- Top bar (title + tabs)
local topBar = make("Frame", {Parent = mainFrame, Name = "TopBar", Size = UDim2.new(1,0,0,48), Position = UDim2.new(0,0,0,0), BackgroundColor3 = CONFIG.Theme.Panel, BorderSizePixel = 0})
make("UICorner", {Parent = topBar, CornerRadius = UDim.new(0, 12)})

local title = make("TextLabel", {Parent = topBar, Name = "Title", Size = UDim2.new(0, 240, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = "SpeedHub", TextColor3 = CONFIG.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left})

-- Tab container
local tabBar = make("Frame", {Parent = topBar, Name = "TabBar", Size = UDim2.new(1, -260, 1, 0), Position = UDim2.new(0, 260, 0, 0), BackgroundTransparency = 1})

local rightControls = make("Frame", {Parent = topBar, Name = "RightControls", Size = UDim2.new(0, 240, 1, 0), Position = UDim2.new(1, -240, 0, 0), BackgroundTransparency = 1})

-- Close/minimize buttons
local closeBtn = make("TextButton", {Parent = rightControls, Name = "Close", Size = UDim2.new(0,36,0,28), Position = UDim2.new(1, -48, 0.5, -14), BackgroundTransparency = 1, Text = "✕", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = CONFIG.Theme.MutedText})
local minimizeBtn = make("TextButton", {Parent = rightControls, Name = "Minimize", Size = UDim2.new(0,36,0,28), Position = UDim2.new(1, -96, 0.5, -14), BackgroundTransparency = 1, Text = "—", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = CONFIG.Theme.MutedText})

-- Content area
local content = make("Frame", {Parent = mainFrame, Name = "Content", Size = UDim2.new(1, -24, 1, -68), Position = UDim2.new(0, 12, 0, 56), BackgroundTransparency = 1})

-- Left column for controls (optional)
local leftColumn = make("Frame", {Parent = content, Name = "LeftColumn", Size = UDim2.new(0, 220, 1, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = CONFIG.Theme.Panel, BorderSizePixel = 0})
make("UICorner", {Parent = leftColumn, CornerRadius = UDim.new(0,8)})

local pagesContainer = make("Frame", {Parent = content, Name = "Pages", Size = UDim2.new(1, -236, 1, 0), Position = UDim2.new(0, 236, 0, 0), BackgroundTransparency = 1})

-- Basic API containers
local Window = {}
Window.__index = Window

local function makeNotification(text, title)
    title = title or "Notification"
    local notif = make("Frame", {Parent = screenGui, Name = "Notif", Size = UDim2.new(0, 260, 0, 72), Position = UDim2.new(1, -280, 0, 24), BackgroundColor3 = CONFIG.Theme.Panel, BorderSizePixel = 0})
    make("UICorner", {Parent = notif, CornerRadius = UDim.new(0,8)})
    local h = make("TextLabel", {Parent = notif, Size = UDim2.new(1, -16, 0, 28), Position = UDim2.new(0, 8, 0, 8), BackgroundTransparency = 1, Text = title, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = CONFIG.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left})
    local b = make("TextLabel", {Parent = notif, Size = UDim2.new(1, -16, 0, 36), Position = UDim2.new(0, 8, 0, 30), BackgroundTransparency = 1, Text = text, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = CONFIG.Theme.MutedText, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left})

    notif.Size = UDim2.new(0, 0, 0, 72)
    local t = TweenService:Create(notif, CONFIG.TweenInfo, {Size = UDim2.new(0, 260, 0, 72)})
    t:Play()

    delay(3, function()
        local t2 = TweenService:Create(notif, CONFIG.TweenInfo, {Size = UDim2.new(0, 0, 0, 72)})
        t2:Play()
        t2.Completed:Connect(function() notif:Destroy() end)
    end)
end

-- API: CreateWindow
function Window.new(titleText)
    local self = setmetatable({}, Window)
    self.Title = titleText or "SpeedHub"
    self.Tabs = {}
    self.ActiveTab = nil
    return self
end

function Window:Build()
    title.Text = self.Title
    -- make tab buttons
    local x = 0
    for i,tab in ipairs(self.Tabs) do
        local btn = make("TextButton", {Parent = tabBar, Name = tab.Name.."Btn", Size = UDim2.new(0, 84, 1, -10), Position = UDim2.new(0, x, 0, 5), BackgroundTransparency = 1, Text = tab.Icon or tab.Name, Font = Enum.Font.GothamBold, TextColor3 = CONFIG.Theme.MutedText, TextSize = 14})
        btn.MouseButton1Click:Connect(function()
            self:SwitchTo(i)
        end)
        tab._Button = btn
        x = x + 86
    end

    -- tabs content
    for i,tab in ipairs(self.Tabs) do
        tab.Frame.Parent = pagesContainer
        tab.Frame.Visible = false
        tab.Frame.Size = UDim2.new(1,0,1,0)
        make("UICorner", {Parent = tab.Frame, CornerRadius = UDim.new(0,8)})
    end

    if #self.Tabs > 0 then
        self:SwitchTo(1)
    end
end

function Window:AddTab(name, icon)
    local tab = {Name = name, Icon = icon}
    tab.Frame = make("Frame", {Name = name.."Page", BackgroundTransparency = 1})
    tab._Elements = {}

    -- helper to create a section in the tab
    function tab:AddLabel(text)
        local lbl = make("TextLabel", {Parent = tab.Frame, Size = UDim2.new(1, -16, 0, 28), Position = UDim2.new(0, 8, 0, (#tab._Elements)*34 + 8), BackgroundTransparency = 1, Text = text, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = CONFIG.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left})
        table.insert(tab._Elements, lbl)
        return lbl
    end

    function tab:AddButton(text, callback)
        local i = #tab._Elements
        local btn = make("TextButton", {Parent = tab.Frame, Size = UDim2.new(0, 220, 0, 36), Position = UDim2.new(0, 8, 0, i*44 + 40), BackgroundColor3 = CONFIG.Theme.Panel, Text = text, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = CONFIG.Theme.Text})
        make("UICorner", {Parent = btn, CornerRadius = UDim.new(0,8)})
        btn.MouseButton1Click:Connect(function() pcall(callback) end)
        table.insert(tab._Elements, btn)
        return btn
    end

    function tab:AddToggle(text, default, callback)
        local i = #tab._Elements
        local container = make("Frame", {Parent = tab.Frame, Size = UDim2.new(0, 220, 0, 36), Position = UDim2.new(0, 8, 0, i*44 + 40), BackgroundTransparency = 1})
        local lbl = make("TextLabel", {Parent = container, Size = UDim2.new(1, -48, 1, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1, Text = text, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = CONFIG.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left})
        local toggle = make("TextButton", {Parent = container, Size = UDim2.new(0, 32, 0, 20), Position = UDim2.new(1, -36, 0.5, -10), BackgroundColor3 = CONFIG.Theme.Panel, Text = default and "ON" or "OFF", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = CONFIG.Theme.Text})
        make("UICorner", {Parent = toggle, CornerRadius = UDim.new(0,6)})
        local state = default
        toggle.MouseButton1Click:Connect(function()
            state = not state
            toggle.Text = state and "ON" or "OFF"
            pcall(callback, state)
        end)
        table.insert(tab._Elements, container)
        return {Label = lbl, Toggle = toggle, GetState = function() return state end}
    end

    function tab:AddSlider(text, min, max, default, callback)
        local i = #tab._Elements
        local cont = make("Frame", {Parent = tab.Frame, Size = UDim2.new(0, 320, 0, 44), Position = UDim2.new(0, 8, 0, i*50 + 40), BackgroundTransparency = 1})
        local lbl = make("TextLabel", {Parent = cont, Size = UDim2.new(1, -16, 0, 18), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1, Text = text.." — "..tostring(default), Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = CONFIG.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left})
        local bar = make("Frame", {Parent = cont, Size = UDim2.new(1, -16, 0, 10), Position = UDim2.new(0, 8, 0, 24), BackgroundColor3 = CONFIG.Theme.Panel})
        make("UICorner", {Parent = bar, CornerRadius = UDim.new(0, 6)})
        local knob = make("Frame", {Parent = bar, Size = UDim2.new((default-min)/(max-min), 0, 1, 0), Position = UDim2.new(0,0,0,0), BackgroundColor3 = CONFIG.Theme.Accent})
        make("UICorner", {Parent = knob, CornerRadius = UDim.new(0,6)})
        local dragging = false
        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        bar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        RunService.RenderStepped:Connect(function()
            if dragging then
                local mouse = UserInputService:GetMouseLocation()
                local relative = math.clamp((mouse.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                knob.Size = UDim2.new(relative, 0, 1, 0)
                local value = min + (max-min)*relative
                lbl.Text = text.." — "..string.format("%.2f", value)
                pcall(callback, value)
            end
        end)
        table.insert(tab._Elements, cont)
        return {Label = lbl, Bar = bar, Knob = knob}
    end

    function tab:AddTextbox(placeholder, clearOnEnter, callback)
        local i = #tab._Elements
        local box = make("TextBox", {Parent = tab.Frame, Size = UDim2.new(0, 220, 0, 28), Position = UDim2.new(0, 8, 0, i*44 + 40), BackgroundColor3 = CONFIG.Theme.Panel, Text = "", PlaceholderText = placeholder or "...", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = CONFIG.Theme.Text})
        make("UICorner", {Parent = box, CornerRadius = UDim.new(0,6)})
        box.FocusLost:Connect(function(enter)
            if enter then
                pcall(callback, box.Text)
                if clearOnEnter then box.Text = "" end
            end
        end)
        table.insert(tab._Elements, box)
        return box
    end

    function tab:AddDropdown(text, options, callback)
        local i = #tab._Elements
        local cont = make("Frame", {Parent = tab.Frame, Size = UDim2.new(0, 220, 0, 36), Position = UDim2.new(0, 8, 0, i*44 + 40), BackgroundTransparency = 1})
        local lbl = make("TextLabel", {Parent = cont, Size = UDim2.new(1, -48, 1, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1, Text = text, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = CONFIG.Theme.Text, TextXAlignment = Enum.TextXAlignment.Left})
        local btn = make("TextButton", {Parent = cont, Size = UDim2.new(0, 32, 0, 20), Position = UDim2.new(1, -36, 0.5, -10), BackgroundColor3 = CONFIG.Theme.Panel, Text = "v", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = CONFIG.Theme.Text})
        make("UICorner", {Parent = btn, CornerRadius = UDim.new(0,6)})
        local menu = make("Frame", {Parent = cont, Size = UDim2.new(0, 220, 0, 0), Position = UDim2.new(0, 0, 1, 4), BackgroundColor3 = CONFIG.Theme.Panel, ClipsDescendants = true})
        make("UICorner", {Parent = menu, CornerRadius = UDim.new(0,8)})

        local selectedIndex = nil

        local function closeMenu()
            local tween = TweenService:Create(menu, CONFIG.TweenInfo, {Size = UDim2.new(0, 220, 0, 0)})
            tween:Play()
        end
        local function openMenu()
            local tween = TweenService:Create(menu, CONFIG.TweenInfo, {Size = UDim2.new(0, 220, 0, math.min(#options * 28, 112))})
            tween:Play()
        end

        btn.MouseButton1Click:Connect(function()
            if menu.Size.Y.Offset > 0 then
                closeMenu()
            else
                openMenu()
            end
        end)

        for idx,opt in ipairs(options) do
            local optBtn = make("TextButton", {Parent = menu, Size = UDim2.new(1, 0, 0, 28), Position = UDim2.new(0, 0, 0, (idx-1)*28), BackgroundTransparency = 1, Text = opt, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = CONFIG.Theme.Text})
            optBtn.MouseButton1Click:Connect(function()
                selectedIndex = idx
                lbl.Text = text .. ": " .. opt
                closeMenu()
                pcall(callback, opt, idx)
            end)
        end

        table.insert(tab._Elements, cont)
        return {Label = lbl, Button = btn, Menu = menu, GetSelection = function() return selectedIndex end}
    end

    table.insert(self.Tabs, tab)
    return tab
end

function Window:SwitchTo(index)
    if self.ActiveTab then
        self.ActiveTab.Frame.Visible = false
        if self.ActiveTab._Button then
            self.ActiveTab._Button.TextColor3 = CONFIG.Theme.MutedText
        end
    end
    local tab = self.Tabs[index]
    if tab then
        tab.Frame.Visible = true
        if tab._Button then
            tab._Button.TextColor3 = CONFIG.Theme.Accent
        end
        self.ActiveTab = tab
    end
end

function Window:Notify(text, title)
    makeNotification(text, title)
end

-- Dragging for main frame
do
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        shadow.Position = UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset + 6, mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset + 6)
    end

    topBar.InputBegan:Connect(function(input)
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

    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Close and minimize button functionality
closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)
minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    shadow.Visible = mainFrame.Visible
end)

-- Toggle hotkey to show/hide UI
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == CONFIG.ToggleKey then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

return Window
