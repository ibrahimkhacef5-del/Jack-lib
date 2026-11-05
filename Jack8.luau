--[[
    ═══════════════════════════════════════════════════════════════
    JackHub Library v4.0 
 تم التحديث بواسطة :Ibrahimkhacef5-del 
    الميزات المضافة: أشكال (Circle, Pro, Square) / صور / Boot احترافي / إصلاح الأزرار
    ═══════════════════════════════════════════════════════════════
]]

local JackHub = {}
JackHub.__index = JackHub

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local IsMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local IsPC = not IsMobile

local LIB_NAME = "JackHub"
local IS_MOBILE = IsMobile
local SIZES = {
    WindowWidth = IS_MOBILE and 340 or 620,
    WindowHeight = IS_MOBILE and 380 or 440,
    TabBarWidth = IS_MOBILE and 110 or 160,
    TitleBarHeight = IS_MOBILE and 40 or 44,
    ElementHeight = IS_MOBILE and 42 or 36,
    ElementPadding = 6,
    CornerRadius = 10,
}

-- الثيم الافتراضي (معدل ليكون أرقى)
local DefaultTheme = {
    Background = Color3.fromRGB(18, 18, 20),
    Header = Color3.fromRGB(12, 12, 14),
    TabBar = Color3.fromRGB(15, 15, 18),
    Element = Color3.fromRGB(28, 28, 32),
    ElementHover = Color3.fromRGB(38, 38, 45),
    Accent = Color3.fromRGB(138, 43, 226), -- بنفسجي فاخر
    Accent2 = Color3.fromRGB(190, 80, 255),
    Text = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(150, 150, 165),
    Outline = Color3.fromRGB(45, 45, 55),
    ToggleOn = Color3.fromRGB(138, 43, 226),
    ToggleOff = Color3.fromRGB(40, 40, 45),
    SliderFill = Color3.fromRGB(138, 43, 226),
    SliderEmpty = Color3.fromRGB(40, 40, 45),
    Success = Color3.fromRGB(60, 200, 100),
    Danger = Color3.fromRGB(230, 60, 60),
    Warning = Color3.fromRGB(240, 180, 50),
    Info = Color3.fromRGB(70, 170, 250),
}

local Themes = {
    Default = DefaultTheme,
    Dark = {
        Background = Color3.fromRGB(10, 10, 12),
        Header = Color3.fromRGB(5, 5, 6),
        TabBar = Color3.fromRGB(8, 8, 10),
        Element = Color3.fromRGB(18, 18, 20),
        ElementHover = Color3.fromRGB(28, 28, 30),
        Accent = Color3.fromRGB(120, 120, 140),
        Accent2 = Color3.fromRGB(160, 160, 180),
        Text = Color3.fromRGB(220, 220, 220),
        TextDim = Color3.fromRGB(140, 140, 150),
        Outline = Color3.fromRGB(35, 35, 40),
    },
}

local State = {
    Theme = DefaultTheme,
    Tabs = {},
    ActiveTab = nil,
    Hidden = false,
    Minimized = false,
    Fullscreen = false,
    Flags = {},
    Window = nil,
    MainFrame = nil,
    ScreenGui = nil,
    ImageLabel = nil, -- لحفظ الصورة
}

-- ═══════════════════════════════════════════════════════════════
-- دوال مساعدة
-- ═══════════════════════════════════════════════════════════════

local function Create(className, props)
    local obj = Instance.new(className)
    for k, v in pairs(props) do
        if k ~= "Parent" then obj[k] = v end
    end
    if props.Parent then obj.Parent = props.Parent end
    return obj
end

local function Tween(obj, dur, props, style, dir)
    local info = TweenInfo.new(dur or 0.25, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

-- إصلاح مشكلة الأزرار التي لا تستجيب
local function BindInput(obj, callback)
    local connection = obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 
           or input.UserInputType == Enum.UserInputType.Touch then
            -- إضافة تأثير ضغطة فوري
            local oldSize = obj.Size
            Tween(obj, 0.05, { Size = UDim2.new(oldSize.X.Scale, oldSize.X.Offset - 2, oldSize.Y.Scale, oldSize.Y.Offset - 2) })
            task.delay(0.05, function()
                Tween(obj, 0.05, { Size = oldSize })
                callback(input)
            end)
        end
    end)
    return connection
end

local function Round(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or SIZES.CornerRadius)
    c.Parent = obj
    return c
end

local function Stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or State.Theme.Outline
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

-- دالة لتحويل روابط الصور (يدعم Decals و Asset IDs)
local function ParseImageId(input)
    if type(input) == "number" then return "rbxassetid://" .. input end
    if type(input) == "string" then
        if input:find("rbxassetid://") then return input end
        if input:find("rbxthumb://") then return input end
        -- إذا كان رابط ديكال أو رقم فقط
        local numericId = input:match("%d+")
        if numericId then return "rbxassetid://" .. numericId end
    end
    return input
end

-- ═══════════════════════════════════════════════════════════════
-- Boot Screen (احترافي مثل Rayfield)
-- ═══════════════════════════════════════════════════════════════
local function CreateBootScreen(config)
    local title = config.Title or "JackHub"
    local subtitle = config.Subtitle or "Premium Loading..."
    local bgImage = config.Background
    
    local gui = Create("ScreenGui", {
        Name = "JackHub_Boot", ResetOnSpawn = false, IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999, Parent = CoreGui,
    })

    local bg = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(10, 10, 12),
        BorderSizePixel = 0, Parent = gui,
    })

    if bgImage then
        Create("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Image = ParseImageId(bgImage), ImageTransparency = 0.6,
            ScaleType = Enum.ScaleType.Crop, Parent = bg,
        })
    end

    local titleLabel = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 60), Position = UDim2.new(0, 0, 0.4, -40),
        BackgroundTransparency = 1, Text = title, TextColor3 = State.Theme.Accent,
        TextSize = IS_MOBILE and 32 or 42, Font = Enum.Font.GothamBold,
        TextTransparency = 1, Parent = bg,
    })

    local subtitleLabel = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 26), Position = UDim2.new(0, 0, 0.4, 25),
        BackgroundTransparency = 1, Text = subtitle, TextColor3 = State.Theme.TextDim,
        TextSize = 14, Font = Enum.Font.Gotham, TextTransparency = 1, Parent = bg,
    })

    local progressWidth = IS_MOBILE and 240 or 320
    local progressBg = Create("Frame", {
        Size = UDim2.new(0, progressWidth, 0, 4), Position = UDim2.new(0.5, -progressWidth/2, 0.55, 0),
        BackgroundColor3 = State.Theme.Element, BorderSizePixel = 0, Parent = bg,
    })
    Round(progressBg, 2)

    local progressFill = Create("Frame", {
        Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = State.Theme.Accent,
        BorderSizePixel = 0, Parent = progressBg,
    })
    Round(progressFill, 2)

    Tween(titleLabel, 0.8, { TextTransparency = 0 })
    Tween(subtitleLabel, 1.0, { TextTransparency = 0 })
    
    Tween(progressFill, 2.5, { Size = UDim2.new(1, 0, 1, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    
    task.wait(2.8)

    Tween(bg, 0.4, { BackgroundTransparency = 1 })
    Tween(titleLabel, 0.3, { TextTransparency = 1 })
    Tween(subtitleLabel, 0.3, { TextTransparency = 1 })
    task.wait(0.5)
    gui:Destroy()
end

-- ═══════════════════════════════════════════════════════════════
-- إنشاء النافذة
-- ═══════════════════════════════════════════════════════════════
function JackHub:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "JackHub"
    local themeName = config.Theme or "Default"
    local shape = config.Shape or "Pro" -- "Pro", "Square", "Circle"
    local bgImage = config.BackgroundImage
    local toggleKey = config.ToggleUIKeybind or "RightShift"

    if Themes[themeName] then State.Theme = Themes[themeName] end

    if config.BootScreen ~= false then
        CreateBootScreen({
            Title = config.LoadingTitle or windowName,
            Subtitle = config.LoadingSubtitle or "Preparing Interface...",
            Background = config.BootBackground,
        })
    end

    -- تحديد حجم وزوايا النافذة بناءً على الشكل
    local cornerRadius = 10
    if shape == "Pro" then cornerRadius = 8
    elseif shape == "Square" then cornerRadius = 0
    elseif shape == "Circle" then cornerRadius = 20 end

    local screenGui = Create("ScreenGui", {
        Name = "JackHub_UI", ResetOnSpawn = false, IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100, Parent = CoreGui,
    })
    State.ScreenGui = screenGui

    -- الحاوية الرئيسية
    local mainFrame = Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, SIZES.WindowWidth, 0, SIZES.WindowHeight),
        Position = UDim2.new(0.5, -SIZES.WindowWidth/2, 0.5, -SIZES.WindowHeight/2),
        BackgroundColor3 = State.Theme.Background, BorderSizePixel = 0,
        ClipsDescendants = true, ZIndex = 10, Parent = screenGui,
    })
    Round(mainFrame, cornerRadius)
    Stroke(mainFrame, State.Theme.Outline, 1.5, 0.4)
    State.MainFrame = mainFrame

    -- إضافة الصورة في الخلفية (مع شفافية)
    if bgImage then
        local img = Create("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Image = ParseImageId(bgImage), ImageTransparency = 0.8,
            ScaleType = Enum.ScaleType.Crop, ZIndex = 1, Parent = mainFrame,
        })
        Round(img, cornerRadius)
        State.ImageLabel = img
    end

    -- شريط العنوان
    local titleBar = Create("Frame", {
        Name = "TitleBar", Size = UDim2.new(1, 0, 0, SIZES.TitleBarHeight),
        BackgroundColor3 = State.Theme.Header, BorderSizePixel = 0, ZIndex = 20, Parent = mainFrame,
    })
    Round(titleBar, cornerRadius)

    Create("TextLabel", {
        Size = UDim2.new(0, 200, 1, 0), Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1, Text = windowName, TextColor3 = State.Theme.Text,
        TextSize = 15, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 22, Parent = titleBar,
    })

    -- منطقة التبويبات
    local tabBar = Create("Frame", {
        Name = "TabBar", Size = UDim2.new(0, SIZES.TabBarWidth, 1, -(SIZES.TitleBarHeight)),
        Position = UDim2.new(0, 0, 0, SIZES.TitleBarHeight), BackgroundColor3 = State.Theme.TabBar,
        BorderSizePixel = 0, ZIndex = 15, Parent = mainFrame,
    })
    local tabScroll = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 16, Parent = tabBar,
    })
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 4); tabLayout.Parent = tabScroll
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 6); tabPadding.PaddingLeft = UDim.new(0, 6); tabPadding.PaddingRight = UDim.new(0, 6)
    tabPadding.Parent = tabScroll

    -- منطقة المحتوى
    local contentFrame = Create("Frame", {
        Name = "ContentFrame", Size = UDim2.new(1, -SIZES.TabBarWidth, 1, -SIZES.TitleBarHeight),
        Position = UDim2.new(0, SIZES.TabBarWidth, 0, SIZES.TitleBarHeight),
        BackgroundTransparency = 1, ZIndex = 15, Parent = mainFrame,
    })

    -- دالة إغلاق
    function JackHub:Destroy()
        if State.ScreenGui then State.ScreenGui:Destroy() end
    end

    -- زر الإغلاق
    local closeBtn = Create("TextButton", {
        Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(1, -34, 0.5, -13),
        BackgroundColor3 = State.Theme.Danger, Text = "✕", TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.GothamBold, TextSize = 14, ZIndex = 22, Parent = titleBar,
    })
    Round(closeBtn, 6)
    BindInput(closeBtn, function() JackHub:Destroy() end)

    -- دالة إنشاء تبويب
    function JackHub:CreateTab(tabConfig)
        local tabName = tabConfig.Name or "Tab"
        local tabIcon = tabConfig.Icon or "●"

        local tabBtn = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, SIZES.ElementHeight),
            BackgroundColor3 = State.Theme.Element, Text = "  " .. tabIcon .. "  " .. tabName,
            TextColor3 = State.Theme.TextDim, TextSize = 13, Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 17, Parent = tabScroll,
        })
        Round(tabBtn, 8)

        local tabContent = Create("Frame", {
            Size = UDim2.new(1, -16, 1, -16), Position = UDim2.new(0, 8, 0, 8),
            BackgroundTransparency = 1, Visible = false, ZIndex = 16, Parent = contentFrame,
        })
        local contentScroll = Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 4,
            ScrollBarImageColor3 = State.Theme.Accent, CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 17, Parent = tabContent,
        })
        local cLayout = Instance.new("UIListLayout")
        cLayout.Padding = UDim.new(0, SIZES.ElementPadding); cLayout.Parent = contentScroll

        local tabData = { Button = tabBtn, Content = tabContent, ContentScroll = contentScroll, Name = tabName }
        table.insert(State.Tabs, tabData)

        BindInput(tabBtn, function()
            JackHub:SelectTab(tabData)
        end)

        if #State.Tabs == 1 then JackHub:SelectTab(tabData) end
        return tabData
    end

    function JackHub:SelectTab(tabData)
        State.ActiveTab = tabData
        for _, tab in ipairs(State.Tabs) do
            if tab == tabData then
                Tween(tab.Button, 0.2, { BackgroundColor3 = State.Theme.Accent })
                tab.Button.TextColor3 = Color3.new(1,1,1)
                tab.Content.Visible = true
            else
                Tween(tab.Button, 0.2, { BackgroundColor3 = State.Theme.Element })
                tab.Button.TextColor3 = State.Theme.TextDim
                tab.Content.Visible = false
            end
        end
    end

    -- ═══════════════════════════════════════════════════════════════
    -- عناصر الواجهة (مع إصلاح الأزرار)
    -- ═══════════════════════════════════════════════════════════════

    function JackHub:AddButton(tab, cfg)
        local btn = Create("TextButton", {
            Size = UDim2.new(1, -8, 0, SIZES.ElementHeight),
            BackgroundColor3 = State.Theme.Element, Text = (cfg.Icon and cfg.Icon .. "  " or "") .. (cfg.Name or "Button"),
            TextColor3 = State.Theme.Text, TextSize = 13, Font = Enum.Font.Gotham, ZIndex = 18, Parent = tab.ContentScroll,
        })
        Round(btn, cornerRadius)
        BindInput(btn, function()
            if cfg.Callback then cfg.Callback() end
        end)
        return btn
    end

    function JackHub:AddToggle(tab, cfg)
        local isOn = cfg.Default or false
        local frame = Create("Frame", {
            Size = UDim2.new(1, -8, 0, SIZES.ElementHeight),
            BackgroundColor3 = State.Theme.Element, ZIndex = 18, Parent = tab.ContentScroll,
        })
        Round(frame, cornerRadius)

        Create("TextLabel", {
            Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1, Text = cfg.Name or "Toggle", TextColor3 = State.Theme.Text,
            TextSize = 13, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 19, Parent = frame,
        })

        local swBg = Create("Frame", {
            Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -52, 0.5, -10),
            BackgroundColor3 = isOn and State.Theme.ToggleOn or State.Theme.ToggleOff,
            BorderSizePixel = 0, ZIndex = 19, Parent = frame,
        })
        Round(swBg, 10)

        local knob = Create("Frame", {
            Size = UDim2.new(0, 16, 0, 16), Position = isOn and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, ZIndex = 20, Parent = swBg,
        })
        Round(knob, 8)

        BindInput(frame, function()
            isOn = not isOn
            Tween(knob, 0.2, { Position = isOn and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8) })
            Tween(swBg, 0.2, { BackgroundColor3 = isOn and State.Theme.ToggleOn or State.Theme.ToggleOff })
            if cfg.Callback then cfg.Callback(isOn) end
        end)
    end

    function JackHub:AddSlider(tab, cfg)
        local min, max, current = cfg.Min or 0, cfg.Max or 100, cfg.Default or 0
        local frame = Create("Frame", {
            Size = UDim2.new(1, -8, 0, 54), BackgroundColor3 = State.Theme.Element, ZIndex = 18, Parent = tab.ContentScroll,
        })
        Round(frame, cornerRadius)

        Create("TextLabel", {
            Size = UDim2.new(1, -80, 0, 18), Position = UDim2.new(0, 12, 0, 6),
            BackgroundTransparency = 1, Text = cfg.Name or "Slider", TextColor3 = State.Theme.Text,
            TextSize = 13, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 19, Parent = frame,
        })
        local valLabel = Create("TextLabel", {
            Size = UDim2.new(0, 60, 0, 18), Position = UDim2.new(1, -72, 0, 6),
            BackgroundTransparency = 1, Text = tostring(current) .. (cfg.Suffix or ""), TextColor3 = State.Theme.Accent,
            TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 19, Parent = frame,
        })
        local trackBg = Create("Frame", {
            Size = UDim2.new(1, -24, 0, 6), Position = UDim2.new(0, 12, 0, 36),
            BackgroundColor3 = State.Theme.SliderEmpty, BorderSizePixel = 0, ZIndex = 19, Parent = frame,
        })
        Round(trackBg, 3)
        local fill = Create("Frame", {
            Size = UDim2.new((current-min)/(max-min), 0, 1, 0), BackgroundColor3 = State.Theme.Accent,
            BorderSizePixel = 0, ZIndex = 20, Parent = trackBg,
        })
        Round(fill, 3)

        local dragging = false
        local function update(input)
            local rel = math.clamp((input.Position.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X, 0, 1)
            current = math.floor(min + (max-min) * rel)
            valLabel.Text = tostring(current) .. (cfg.Suffix or "")
            fill.Size = UDim2.new(rel, 0, 1, 0)
            if cfg.Callback then cfg.Callback(current) end
        end

        trackBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                update(input)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end)
    end

    function JackHub:AddSection(tab, cfg)
        Create("TextLabel", {
            Size = UDim2.new(1, -8, 0, 28), BackgroundTransparency = 1,
            Text = cfg.Name or "Section", TextColor3 = State.Theme.Accent, TextSize = 13,
            Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 18, Parent = tab.ContentScroll,
        })
    end

    return State.Window
end

function JackHub:Notify(title, message, duration, notifType)
    -- إشعارات بسيطة
    local gui = State.ScreenGui or CoreGui
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 250, 0, 50)
    notif.Position = UDim2.new(1, -260, 1, -60)
    notif.BackgroundColor3 = State.Theme.Element
    notif.Parent = gui
    Round(notif, 8)
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, -20, 1, -20)
    txt.Position = UDim2.new(0, 10, 0, 10)
    txt.BackgroundTransparency = 1
    txt.Text = title .. "\n" .. message
    txt.TextColor3 = State.Theme.Text
    txt.Font = Enum.Font.Gotham
    txt.TextSize = 12
    txt.TextWrapped = true
    txt.Parent = notif

    task.delay(duration or 3, function()
        Tween(notif, 0.3, { Position = UDim2.new(1, -260, 1, 0) })
        task.wait(0.4)
        notif:Destroy()
    end)
end

return JackHub
