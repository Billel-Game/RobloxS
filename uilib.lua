local library = {}

function library:CreateWindow(title)
    local window = {
        Title = title,
        X, Y = 100, 100,
        Width, Height = 400, 300,
        Dragging = false,
        Controls = {},
        ActiveTab = 1,
    }

    function window:Draw()
        -- Draw window background
        Drawing.new("Rectangle", window.X, window.Y, window.Width, window.Height)
        -- Draw title bar
        Drawing.new("Text", window.X + 10, window.Y + 10, window.Title)
        -- Draw tabs and controls
        -- Handle hover, clicks, input...
    end

    function window:Update()
        -- Check mouse input to drag window or click buttons
    end

    function window:AddTab(name)
        table.insert(self.Controls, {Name = name, Controls = {}})
    end

    function window:AddButton(tabIndex, buttonName, callback)
        table.insert(self.Controls[tabIndex].Controls, {Type="Button", Name=buttonName, Callback=callback})
    end

    return window
end

return library
