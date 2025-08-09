-- Simple Delta UI Library inspired by Discord UI style

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local UI = {}
UI.__index = UI

-- Helpers
local function createDrawing(type, props)
    local d = Drawing.new(type)
    for k,v in pairs(props or {}) do
        d[k] = v
    end
    return d
end

-- Mouse tracking
local mouse = {
    X = 0,
    Y = 0,
    Down = false,
}
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        mouse.X, mouse.Y = input.Position.X, input.Position.Y
    end
end)
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        mouse.Down = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        mouse.Down = false
    end
end)

local function mouseInRect(x,y,w,h)
    return mouse.X >= x and mouse.X <= x+w and mouse.Y >= y and mouse.Y <= y+h
end

-- Window constructor
function UI.newWindow(title, width, height)
    local self = setmetatable({}, UI)
    self.Title = title or "Window"
    self.Width = width or 500
    self.Height = height or 350
    self.X = 200
    self.Y = 150
    self.Dragging = false
    self.DragOffset = Vector2.new(0,0)
    self.Controls = {}

    -- Drawing objects
    self.Background = createDrawing("Square", {
        Color = Color3.fromRGB(32, 34, 37),
        Filled = true,
        Transparency = 0.9,
        Thickness = 0,
    })
    self.TitleBar = createDrawing("Square", {
        Color = Color3.fromRGB(44, 47, 51),
        Filled = true,
        Transparency = 0.95,
        Thickness = 0,
    })
    self.TitleText = createDrawing("Text", {
        Text = self.Title,
        Size = 20,
        Center = true,
        Outline = true,
        Color = Color3.fromRGB(220, 221, 222),
        Font = 3,
    })

    -- Start update loop
    RunService.RenderStepped:Connect(function()
        self:Render()
    end)

    return self
end

function UI:AddToggle(name, callback)
    local toggle = {
        Type = "Toggle",
        Name = name,
        Callback = callback,
        State = false,
        Size = Vector2.new(self.Width - 40, 30),
    }
    table.insert(self.Controls, toggle)
    return toggle
end

function UI:AddButton(name, callback)
    local button = {
        Type = "Button",
        Name = name,
        Callback = callback,
        Size = Vector2.new(self.Width - 40, 30),
    }
    table.insert(self.Controls, button)
    return button
end

function UI:Render()
    -- Dragging logic
    if self.Dragging then
        self.X = mouse.X - self.DragOffset.X
        self.Y = mouse.Y - self.DragOffset.Y
    elseif mouse.Down and mouseInRect(self.X, self.Y, self.Width, 30) and not self.Dragging then
        -- Start dragging
        if not self._dragLock then
            self.Dragging = true
            self.DragOffset = Vector2.new(mouse.X - self.X, mouse.Y - self.Y)
            self._dragLock = true
        end
    elseif not mouse.Down then
        self.Dragging = false
        self._dragLock = false
    end

    -- Draw window bg and title bar
    self.Background.Position = Vector2.new(self.X, self.Y)
    self.Background.Size = Vector2.new(self.Width, self.Height)
    self.Background.Visible = true

    self.TitleBar.Position = Vector2.new(self.X, self.Y)
    self.TitleBar.Size = Vector2.new(self.Width, 30)
    self.TitleBar.Visible = true

    self.TitleText.Position = Vector2.new(self.X + self.Width/2, self.Y + 15)
    self.TitleText.Visible = true

    -- Controls render & input
    local yOffset = 50
    for _, ctrl in ipairs(self.Controls) do
        if ctrl.Type == "Toggle" then
            -- Draw toggle box
            if not ctrl.ToggleBox then
                ctrl.ToggleBox = createDrawing("Square", {
                    Color = Color3.fromRGB(114, 137, 218),
                    Thickness = 0,
                    Filled = true,
                })
                ctrl.ToggleMark = createDrawing("Square", {
                    Color = Color3.fromRGB(67, 181, 129),
                    Thickness = 0,
                    Filled = true,
                })
                ctrl.Label = createDrawing("Text", {
                    Text = ctrl.Name,
                    Size = 18,
                    Color = Color3.fromRGB(220, 221, 222),
                    Outline = true,
                    Font = 3,
                })
            end

            local boxX, boxY = self.X + 20, self.Y + yOffset
            local boxSize = 20
            ctrl.ToggleBox.Position = Vector2.new(boxX, boxY)
            ctrl.ToggleBox.Size = Vector2.new(boxSize, boxSize)
            ctrl.ToggleBox.Visible = true

            ctrl.Label.Position = Vector2.new(boxX + boxSize + 10, boxY + boxSize/2)
            ctrl.Label.Visible = true

            if ctrl.State then
                ctrl.ToggleMark.Position = Vector2.new(boxX + 4, boxY + 4)
                ctrl.ToggleMark.Size = Vector2.new(boxSize - 8, boxSize - 8)
                ctrl.ToggleMark.Visible = true
            else
                ctrl.ToggleMark.Visible = false
            end

            -- Click detection
            if mouse.Down and mouseInRect(boxX, boxY, boxSize, boxSize) and not self._lastToggleClick then
                ctrl.State = not ctrl.State
                if ctrl.Callback then
                    ctrl.Callback(ctrl.State)
                end
                self._lastToggleClick = true
                task.delay(0.2, function()
                    self._lastToggleClick = false
                end)
            end

            yOffset = yOffset + 40

        elseif ctrl.Type == "Button" then
            if not ctrl.Box then
                ctrl.Box = createDrawing("Square", {
                    Color = Color3.fromRGB(114, 137, 218),
                    Thickness = 0,
                    Filled = true,
                })
                ctrl.Label = createDrawing("Text", {
                    Text = ctrl.Name,
                    Size = 18,
                    Color = Color3.fromRGB(220, 221, 222),
                    Outline = true,
                    Center = true,
                    Font = 3,
                })
            end

            local boxX, boxY = self.X + 20, self.Y + yOffset
            local boxW, boxH = self.Width - 40, 30
            ctrl.Box.Position = Vector2.new(boxX, boxY)
            ctrl.Box.Size = Vector2.new(boxW, boxH)
            ctrl.Box.Visible = true

            ctrl.Label.Position = Vector2.new(boxX + boxW/2, boxY + boxH/2)
            ctrl.Label.Visible = true

            if mouse.Down and mouseInRect(boxX, boxY, boxW, boxH) and not self._lastButtonClick then
                if ctrl.Callback then
                    ctrl.Callback()
                end
                self._lastButtonClick = true
                task.delay(0.2, function()
                    self._lastButtonClick = false
                end)
            end

            yOffset = yOffset + 50
        end
    end
end

return UI
