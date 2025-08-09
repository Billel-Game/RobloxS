-- Delta UI library minimal example
local UserInputService = game:GetService("UserInputService")

local Drawing = Drawing -- Delta exposes this

local mouseDown = false
local mouseX, mouseY = 0, 0

local function IsMouseInRect(x, y, w, h)
    return mouseX >= x and mouseX <= x + w and mouseY >= y and mouseY <= y + h
end

-- Track mouse position & button state
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        mouseX, mouseY = input.Position.X, input.Position.Y
    end
end)
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        mouseDown = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        mouseDown = false
    end
end)

-- Window variables
local windowX, windowY = 300, 200
local windowW, windowH = 300, 180
local dragging = false
local dragOffsetX, dragOffsetY = 0, 0

-- Toggle state
local toggleOn = false

-- Create window parts
local windowBackground = Drawing.new("Square")
windowBackground.Color = Color3.fromRGB(40, 40, 40)
windowBackground.Thickness = 0
windowBackground.Filled = true
windowBackground.Transparency = 0.9

local titleBar = Drawing.new("Square")
titleBar.Color = Color3.fromRGB(30, 30, 30)
titleBar.Thickness = 0
titleBar.Filled = true
titleBar.Transparency = 0.95

local titleText = Drawing.new("Text")
titleText.Text = "Delta UI Library"
titleText.Size = 18
titleText.Center = true
titleText.Color = Color3.fromRGB(255, 255, 255)
titleText.Position = Vector2.new(0, 0)

-- Toggle UI elements
local toggleBox = Drawing.new("Square")
toggleBox.Color = Color3.fromRGB(50, 50, 50)
toggleBox.Thickness = 1
toggleBox.Filled = true

local toggleMark = Drawing.new("Square")
toggleMark.Color = Color3.fromRGB(0, 170, 255)
toggleMark.Thickness = 0
toggleMark.Filled = true

local toggleLabel = Drawing.new("Text")
toggleLabel.Text = "Toggle me!"
toggleLabel.Size = 16
toggleLabel.Color = Color3.fromRGB(255, 255, 255)
toggleLabel.Position = Vector2.new(0, 0)

-- Button UI elements
local buttonBox = Drawing.new("Square")
buttonBox.Color = Color3.fromRGB(70, 70, 70)
buttonBox.Thickness = 0
buttonBox.Filled = true

local buttonText = Drawing.new("Text")
buttonText.Text = "Click me!"
buttonText.Size = 18
buttonText.Color = Color3.fromRGB(255, 255, 255)
buttonText.Center = true

-- Main loop for drawing and input handling
game:GetService("RunService").RenderStepped:Connect(function()
    -- Update mouse pos is handled by InputChanged

    -- Handle dragging window
    if dragging then
        windowX = mouseX - dragOffsetX
        windowY = mouseY - dragOffsetY
    end

    -- Window background and title bar
    windowBackground.Position = Vector2.new(windowX, windowY)
    windowBackground.Size = Vector2.new(windowW, windowH)
    windowBackground.Visible = true

    titleBar.Position = Vector2.new(windowX, windowY)
    titleBar.Size = Vector2.new(windowW, 30)
    titleBar.Visible = true

    titleText.Position = Vector2.new(windowX + windowW / 2, windowY + 15)
    titleText.Visible = true

    -- Dragging logic (on title bar)
    if mouseDown and IsMouseInRect(windowX, windowY, windowW, 30) and not dragging then
        dragging = true
        dragOffsetX = mouseX - windowX
        dragOffsetY = mouseY - windowY
    elseif not mouseDown then
        dragging = false
    end

    -- Toggle box
    local toggleX, toggleY = windowX + 20, windowY + 50
    toggleBox.Position = Vector2.new(toggleX, toggleY)
    toggleBox.Size = Vector2.new(20, 20)
    toggleBox.Visible = true

    -- Toggle mark shows only if toggled on
    toggleMark.Position = Vector2.new(toggleX + 4, toggleY + 4)
    toggleMark.Size = Vector2.new(12, 12)
    toggleMark.Visible = toggleOn

    -- Toggle label
    toggleLabel.Position = Vector2.new(toggleX + 30, toggleY - 2)
    toggleLabel.Visible = true

    -- Toggle click detection
    if mouseDown and IsMouseInRect(toggleX, toggleY, 20, 20) then
        toggleOn = not toggleOn
        wait(0.2) -- simple debounce
    end

    -- Button box
    local buttonX, buttonY = windowX + 20, windowY + 90
    buttonBox.Position = Vector2.new(buttonX, buttonY)
    buttonBox.Size = Vector2.new(windowW - 40, 40)
    buttonBox.Visible = true

    -- Button text
    buttonText.Position = Vector2.new(buttonX + (windowW - 40)/2, buttonY + 20)
    buttonText.Visible = true

    -- Button click detection
    if mouseDown and IsMouseInRect(buttonX, buttonY, windowW - 40, 40) then
        print("Button clicked!")
        wait(0.2) -- debounce
    end
end)
