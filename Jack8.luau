--[[
    ═══════════════════════════════════════════════════════════════
    JackHub Library v5.0 (Ultimate Edition)
    الميزات: Boot احترافي / أشكال النافذة (Circle, Pro, Square) / 
             دعم الصور / إصلاح الأزرار / إشعارات متطورة / لوحة ألوان /
             نظام المفاتيح / دعم الجوال / الثيمات / تحسين الأداء
    ═══════════════════════════════════════════════════════════════
]]

local JackHub = {}
JackHub.__index = JackHub

-- ═══════════════════════════════════════════════════════════════
-- 1. الخدمات الأساسية
-- ═══════════════════════════════════════════════════════════════
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local TextService = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer
local IsMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local IsPC = not IsMobile

-- ═══════════════════════════════════════════════════════════════
-- 2. الثوابت والإعدادات العامة
-- ═══════════════════════════════════════════════════════════════
local LIB_NAME = "JackHub"
local CONFIG_FOLDER = LIB_NAME .. "/Configs"
local IS_MOBILE = IsMobile

-- أحجام تتكيف مع الجهاز
local SIZES = {
    WindowWidth = IS_MOBILE and 340 or 620,
    WindowHeight = IS_MOBILE and 380 or 440,
    TabBarWidth = IS_MOBILE and 110 or 160,
    TitleBarHeight = IS_MOBILE and 40 or 44,
    ElementHeight = IS_MOBILE and 42 or 36,
    ElementPadding = 6,
    CornerRadius = 10,
    NotificationWidth = IS_MOBILE and 260 or 320,
    NotificationHeight = 70,
}

-- ═══════════════════════════════════════════════════════════════
-- 3. الثيمات (Rayfield Style)
-- ═══════════════════════════════════════════════════════════════
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
    Blood = {
        Background = Color3.fromRGB(20, 10, 10),
        Header = Color3.fromRGB(15, 5, 5),
        TabBar = Color3.fromRGB(18, 8, 8),
        Element = Color3.fromRGB(35, 15, 15),
        ElementHover = Color3.fromRGB(50, 20, 20),
        Accent = Color3.fromRGB(227, 27, 27),
        Accent2 = Color3.fromRGB(255, 60, 60),
        Text = Color3.fromRGB(255, 220, 220),
        TextDim = Color3.fromRGB(200, 150, 150),
        Outline = Color3.fromRGB(80, 30, 30),
    },
    Ocean = {
        Background = Color3.fromRGB(15, 25, 35),
        Header = Color3.fromRGB(10, 18, 28),
        TabBar = Color3.fromRGB(12, 20, 30),
        Element = Color3.fromRGB(25, 40, 55),
        ElementHover = Color3.fromRGB(35, 55, 75),
        Accent = Color3.fromRGB(0, 180, 255),
        Accent2 = Color3.fromRGB(80, 210, 255),
        Text = Color3.fromRGB(200, 230, 255),
        TextDim = Color3.fromRGB(150, 180, 210),
        Outline = Color3.fromRGB(40, 70, 100),
    },
    Midnight = {
        Background = Color3.fromRGB(12, 12, 20),
        Header = Color3.fromRGB(8, 8, 15),
        TabBar = Color3.fromRGB(10, 10, 18),
        Element = Color3.fromRGB(22, 22, 35),
        ElementHover = Color3.fromRGB(32, 32, 50),
        Accent = Color3.fromRGB(100, 80, 200),
        Accent2 = Color3.fromRGB(140, 110, 240),
        Text = Color3.fromRGB(200, 200, 230),
        TextDim = Color3.fromRGB(140, 140, 170),
        Outline = Color3.fromRGB(45, 45, 70),
    },
    Matrix = {
        Background = Color3.fromRGB(10, 15, 10),
        Header = Color3.fromRGB(5, 10, 5),
        TabBar = Color3.fromRGB(8, 12, 8),
        Element = Color3.fromRGB(15, 25, 15),
        ElementHover = Color3.fromRGB(25, 40, 25),
        Accent = Color3.fromRGB(0, 220, 80),
        Accent2 = Color3.fromRGB(80, 255, 130),
        Text = Color3.fromRGB(200, 255, 200),
        TextDim = Color3.fromRGB(130, 180, 130),
        Outline = Color3.fromRGB(30, 60, 30),
    },
}

-- ═══════════════════════════════════════════════════════════════
-- 4. الحالة الداخلية للمكتبة
-- ═══════════════════════════════════════════════════════════════
local State = {
    Theme = DefaultTheme,
    CurrentThemeName = "Default",
    Tabs = {},
    ActiveTab = nil,
    Hidden = false,
    Minimized = false,
    Fullscreen = false,
    SettingsOpen = false,
    Notifications = {},
    Connections = {},
    Flags = {},
    ConfigName = "default",
    Window = nil,
    MainFrame = nil,
    ScreenGui = nil,
    SettingsPanel = nil,
    SearchActive = false,
    SearchText = "",
}

-- ═══════════════════════════════════════════════════════════════
-- 5. دوال مساعدة أساسية
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

-- دالة لتحويل روابط الصور (يدعم Decals و Asset IDs)
local function ParseImageId(input)
    if type(input) == "number" then return "rbxassetid://" .. input end
    if type(input) == "string" then
        if input:find("rbxassetid://") then return input end
        if input:find("rbxthumb://") then return input end
        local numericId = input:match("%d+")
        if numericId then return "rbxassetid://" .. numericId end
    end
    return input
end

-- دالة ربط الأزرار (إصلاح مشكلة عدم الاستجابة)
local function BindInput(obj, callback, inputType)
    inputType = inputType or "Click"
    local connection

    if inputType == "Click" then
        connection = obj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 
               or input.UserInputType == Enum.UserInputType.Touch then
                
                -- تأثير بصري للضغطة
                if obj:IsA("GuiButton") then
                    local oldSize = obj.Size
                    Tween(obj, 0.05, { Size = UDim2.new(oldSize.X.Scale, oldSize.X.Offset - 2, oldSize.Y.Scale, oldSize.Y.Offset - 2) })
                    task.delay(0.05, function()
                        Tween(obj, 0.05, { Size = oldSize })
                    end)
                end
                
                callback(input)
            end
        end)
    elseif inputType == "Enter" then
        connection = obj.MouseEnter:Connect(callback)
    elseif inputType == "Leave" then
        connection = obj.MouseLeave:Connect(callback)
    end
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

local function Padding(obj, all, top, bottom, left, right)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, top or all or 0)
    p.PaddingBottom = UDim.new(0, bottom or all or 0)
    p.PaddingLeft = UDim.new(0, left or all or 0)
    p.PaddingRight = UDim.new(0, right or all or 0)
    p.Parent = obj
    return p
end

-- ═══════════════════════════════════════════════════════════════
-- 6. إدارة الإشعارات (Notifications)
-- ═══════════════════════════════════════════════════════════════
local function GetNotifGui()
    if State.ScreenGui and State.ScreenGui.Parent then return State.ScreenGui end
    local gui = Create("ScreenGui", {
        Name = "JackHub_Notifications",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
        Parent = CoreGui,
    })
    return gui
end

function JackHub:Notify(title, message, duration, notifType)
    duration = duration or 4
    notifType = notifType or "Info"

    local typeColors = {
        Info = State.Theme.Info,
        Success = State.Theme.Success,
        Warning = State.Theme.Warning,
        Danger = State.Theme.Danger,
    }
    local typeIcons = {
        Info = "ℹ",
        Success = "✓",
        Warning = "⚠",
        Danger = "✕",
    }
    local accentColor = typeColors[notifType] or State.Theme.Accent
    local icon = typeIcons[notifType] or "ℹ"

    local notifWidth = SIZES.NotificationWidth
    local notifHeight = SIZES.NotificationHeight
    local parent = GetNotifGui()
    local existingCount = #State.Notifications

    local notif = Create("Frame", {
        Name = "Notification_" .. tostring(existingCount),
        Size = UDim2.new(0, notifWidth, 0, notifHeight),
        Position = UDim2.new(1, 20, 0, 20 + (existingCount * (notifHeight + 8))),
        BackgroundColor3 = State.Theme.Element,
        BorderSizePixel = 0,
        ZIndex = 999,
        Parent = parent,
    })
    Round(notif, 10)
    Stroke(notif, accentColor, 1.5, 0.3)

    Create("Frame", {
        Size = UDim2.new(0, 4, 1, -14),
        Position = UDim2.new(0, 6, 0, 7),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        ZIndex = 1000,
        Parent = notif,
    })

    Create("TextLabel", {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(0, 16, 0, 8),
        BackgroundTransparency = 1,
        Text = icon,
        TextColor3 = accentColor,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        ZIndex = 1001,
        Parent = notif,
    })

    Create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 22),
        Position = UDim2.new(0, 48, 0, 8),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = State.Theme.Text,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 1001,
        Parent = notif,
    })

    Create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 32),
        Position = UDim2.new(0, 48, 0, 30),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = State.Theme.TextDim,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        ZIndex = 1001,
        Parent = notif,
    })

    table.insert(State.Notifications, notif)

    Tween(notif, 0.4, {
        Position = UDim2.new(1, -(notifWidth + 20), 0, 20 + ((existingCount) * (notifHeight + 8)))
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    task.delay(duration, function()
        local idx = table.find(State.Notifications, notif)
        if idx then table.remove(State.Notifications, idx) end
        Tween(notif, 0.3, { Position = UDim2.new(1, 20, 0, notif.Position.Y.Offset) })
        task.wait(0.35)
        if notif then notif:Destroy() end
    end)

    return notif
end

-- ═══════════════════════════════════════════════════════════════
-- 7. تطبيق الثيمات
-- ═══════════════════════════════════════════════════════════════
function JackHub:ApplyTheme()
    local t = State.Theme
    if not State.MainFrame then return end

    for _, obj in ipairs(State.MainFrame:GetDescendants()) do
        local bgKey = obj:GetAttribute("ThemeColor")
        local txtKey = obj:GetAttribute("ThemeText")
        local strKey = obj:GetAttribute("ThemeStroke")

        if bgKey and t[bgKey] then
            pcall(function() obj.BackgroundColor3 = t[bgKey] end)
        end
        if txtKey and t[txtKey] then
            pcall(function() obj.TextColor3 = t[txtKey] end)
        end
        if strKey and t[strKey] and obj:IsA("UIStroke") then
            obj.Color = t[strKey]
        end
    end
end

function JackHub:SetTheme(themeOrName)
    if type(themeOrName) == "string" then
        if Themes[themeOrName] then
            for k, v in pairs(DefaultTheme) do
                State.Theme[k] = Themes[themeOrName][k] or v
            end
            State.CurrentThemeName = themeOrName
        end
    elseif type(themeOrName) == "table" then
        for k, v in pairs(themeOrName) do
            State.Theme[k] = v
        end
        State.CurrentThemeName = "Custom"
    end
    JackHub:ApplyTheme()
end

function JackHub:SetAccentColor(color)
    State.Theme.Accent = color
    State.Theme.ToggleOn = color
    State.Theme.SliderFill = color
    State.Theme.Accent2 = Color3.new(
        math.min(color.R * 1.3, 1),
        math.min(color.G * 1.3, 1),
        math.min(color.B * 1.3, 1)
    )
    JackHub:ApplyTheme()
end

-- ═══════════════════════════════════════════════════════════════
-- 8. شاشة البداية (Boot Screen) - تصميم احترافي
-- ═══════════════════════════════════════════════════════════════
local function CreateBootScreen(config)
    local title = config.Title or "JackHub"
    local subtitle = config.Subtitle or "Loading..."
    local bootType = config.Type or "XPRO"
    local bgImage = config.Background

    local gui = Create("ScreenGui", {
        Name = "JackHub_Boot",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
        Parent = CoreGui,
    })

    local bg = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = State.Theme.Background,
        BorderSizePixel = 0,
        Parent = gui,
    })

    if bgImage then
        Create("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = ParseImageId(bgImage),
            ImageTransparency = 0.5,
            ScaleType = Enum.ScaleType.Crop,
            Parent = bg,
        })
    end

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, State.Theme.Background),
        ColorSequenceKeypoint.new(0.5, State.Theme.Header),
        ColorSequenceKeypoint.new(1, State.Theme.Background),
    })
    grad.Rotation = 45
    grad.Parent = bg

    local titleLabel = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 60),
        Position = UDim2.new(0, 0, 0.4, -40),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = State.Theme.Accent,
        TextSize = IS_MOBILE and 32 or 42,
        Font = Enum.Font.GothamBold,
        TextTransparency = 1,
        Parent = bg,
    })

    local subtitleLabel = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 26),
        Position = UDim2.new(0, 0, 0.4, 25),
        BackgroundTransparency = 1,
        Text = subtitle,
        TextColor3 = State.Theme.TextDim,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextTransparency = 1,
        Parent = bg,
    })

    local progressWidth = IS_MOBILE and 240 or 320
    local progressBg = Create("Frame", {
        Size = UDim2.new(0, progressWidth, 0, 6),
        Position = UDim2.new(0.5, -progressWidth/2, 0.55, 0),
        BackgroundColor3 = State.Theme.Element,
        BorderSizePixel = 0,
        Parent = bg,
    })
    Round(progressBg, 3)

    local progressFill = Create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = State.Theme.Accent,
        BorderSizePixel = 0,
        Parent = progressBg,
    })
    Round(progressFill, 3)

    Tween(titleLabel, 0.7, { TextTransparency = 0 })
    Tween(subtitleLabel, 0.9, { TextTransparency = 0 })
    Tween(progressFill, 2.5, { Size = UDim2.new(1, 0, 1, 0) }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    task.wait(2.8)

    Tween(bg, 0.4, { BackgroundTransparency = 1 })
    Tween(titleLabel, 0.3, { TextTransparency = 1 })
    Tween(subtitleLabel, 0.3, { TextTransparency = 1 })
    task.wait(0.5)
    gui:Destroy()
end

-- ═══════════════════════════════════════════════════════════════
-- 9. إنشاء النافذة الرئيسية (مع دعم الأشكال والصور)
-- ═══════════════════════════════════════════════════════════════
function JackHub:CreateWindow(config)
    config = config or {}

    local windowName = config.Name or "JackHub"
    local themeName = config.Theme or "Default"
    local shape = config.Shape or "Pro" -- "Pro", "Square", "Circle"
    local bgImage = config.BackgroundImage
    local toggleKey = config.ToggleUIKeybind or "RightShift"

    if Themes[themeName] then
        JackHub:SetTheme(themeName)
    end

    if config.BootScreen ~= false then
        CreateBootScreen({
            Title = config.LoadingTitle or windowName,
            Subtitle = config.LoadingSubtitle or "Loading...",
            Background = config.BootBackground,
        })
    end

    -- تحديد الزوايا بناءً على الشكل المختار
    local cornerRadius = 10
    if shape == "Pro" then cornerRadius = 8
    elseif shape == "Square" then cornerRadius = 0
    elseif shape == "Circle" then cornerRadius = 20 end

    local screenGui = Create("ScreenGui", {
        Name = "JackHub_UI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100,
        Parent = CoreGui,
    })

    State.ScreenGui = screenGui

    local mainFrame = Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, SIZES.WindowWidth, 0, SIZES.WindowHeight),
        Position = UDim2.new(0.5, -SIZES.WindowWidth/2, 0.5, -SIZES.WindowHeight/2),
        BackgroundColor3 = State.Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 10,
        Parent = screenGui,
    })
    Round(mainFrame, cornerRadius)
    Stroke(mainFrame, State.Theme.Outline, 1.5, 0.4)

    if bgImage then
        local img = Create("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = ParseImageId(bgImage),
            ImageTransparency = 0.8,
            ScaleType = Enum.ScaleType.Crop,
            ZIndex = 1,
            Parent = mainFrame,
        })
        Round(img, cornerRadius)
    end

    State.MainFrame = mainFrame
    State.Window = { ScreenGui = screenGui, MainFrame = mainFrame }

    local titleBar = Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, SIZES.TitleBarHeight),
        BackgroundColor3 = State.Theme.Header,
        BorderSizePixel = 0,
        ZIndex = 20,
        Parent = mainFrame,
    })
    Round(titleBar, cornerRadius)

    Create("TextLabel", {
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        Text = windowName,
        TextColor3 = State.Theme.Text,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 22,
        Parent = titleBar,
    })

    local btnContainer = Create("Frame", {
        Size = UDim2.new(0, 130, 1, 0),
        Position = UDim2.new(1, -130, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = 22,
        Parent = titleBar,
    })
    local bLayout = Instance.new("UIListLayout")
    bLayout.FillDirection = Enum.FillDirection.Horizontal
    bLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    bLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    bLayout.Padding = UDim.new(0, 4)
    bLayout.Parent = btnContainer

    local function createTitleBtn(icon, tooltip, callback, isClose)
        local btn = Create("TextButton", {
            Size = UDim2.new(0, 26, 0, 26),
            BackgroundColor3 = State.Theme.Element,
            BorderSizePixel = 0,
            Text = icon,
            TextColor3 = State.Theme.Text,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            ZIndex = 23,
            Parent = btnContainer,
        })
        Round(btn, 6)
        BindInput(btn, callback)
        return btn
    end

    createTitleBtn("⚙", "الإعدادات", function() JackHub:ToggleSettings() end)
    createTitleBtn("◉", "إخفاء/إظهار", function() JackHub:ToggleUI() end)
    createTitleBtn("─", "تصغير", function() JackHub:ToggleMinimize() end)
    createTitleBtn("⛶", "ملء الشاشة", function() JackHub:ToggleFullscreen() end)
    createTitleBtn("✕", "إغلاق", function() JackHub:Destroy() end, true)

    local tabBar = Create("Frame", {
        Name = "TabBar",
        Size = UDim2.new(0, SIZES.TabBarWidth, 1, -(SIZES.TitleBarHeight)),
        Position = UDim2.new(0, 0, 0, SIZES.TitleBarHeight),
        BackgroundColor3 = State.Theme.TabBar,
        BorderSizePixel = 0,
        ZIndex = 15,
        Parent = mainFrame,
    })

    local tabScroll = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = State.Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 16,
        Parent = tabBar,
    })
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.Parent = tabScroll
    Padding(tabScroll, 6)

    local contentFrame = Create("Frame", {
        Name = "ContentFrame",
        Size = UDim2.new(1, -SIZES.TabBarWidth, 1, -SIZES.TitleBarHeight),
        Position = UDim2.new(0, SIZES.TabBarWidth, 0, SIZES.TitleBarHeight),
        BackgroundTransparency = 1,
        ZIndex = 15,
        Parent = mainFrame,
    })

    function JackHub:Destroy()
        if State.ScreenGui then State.ScreenGui:Destroy() end
    end

    function JackHub:ToggleUI()
        State.Hidden = not State.Hidden
        mainFrame.Visible = not State.Hidden
    end

    function JackHub:ToggleMinimize()
        State.Minimized = not State.Minimized
        if State.Minimized then
            Tween(mainFrame, 0.3, { Size = UDim2.new(0, SIZES.WindowWidth, 0, SIZES.TitleBarHeight) })
        else
            Tween(mainFrame, 0.3, { Size = UDim2.new(0, SIZES.WindowWidth, 0, SIZES.WindowHeight) })
        end
    end

    function JackHub:ToggleFullscreen()
        State.Fullscreen = not State.Fullscreen
        if State.Fullscreen then
            Tween(mainFrame, 0.3, { Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0) })
        else
            Tween(mainFrame, 0.3, { 
                Size = UDim2.new(0, SIZES.WindowWidth, 0, SIZES.WindowHeight),
                Position = UDim2.new(0.5, -SIZES.WindowWidth/2, 0.5, -SIZES.WindowHeight/2)
            })
        end
    end

    function JackHub:ToggleSettings()
        -- دالة الإعدادات (مكان مخصص للتوسع)
        JackHub:Notify("Settings", "قائمة الإعدادات قيد التطوير", 2, "Info")
    end

    function JackHub:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"
        local tabIcon = tabConfig.Icon or "●"

        local displayText = "  " .. tabIcon .. "  " .. tabName

        local tabBtn = Create("TextButton", {
            Size = UDim2.new(1, -8, 0, SIZES.ElementHeight),
            BackgroundColor3 = State.Theme.Element,
            BorderSizePixel = 0,
            Text = displayText,
            TextColor3 = State.Theme.TextDim,
            TextSize = IS_MOBILE and 12 or 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 17,
            Parent = tabScroll,
        })
        Round(tabBtn, 8)

        local tabContent = Create("Frame", {
            Size = UDim2.new(1, -16, 1, -16),
            Position = UDim2.new(0, 8, 0, 8),
            BackgroundTransparency = 1,
            Visible = false,
            ZIndex = 16,
            Parent = contentFrame,
        })

        local contentScroll = Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = State.Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ZIndex = 17,
            Parent = tabContent,
        })

        local cLayout = Instance.new("UIListLayout")
        cLayout.Padding = UDim.new(0, SIZES.ElementPadding)
        cLayout.Parent = contentScroll
        Padding(contentScroll, 4)

        local tabData = {
            Button = tabBtn,
            Content = tabContent,
            ContentScroll = contentScroll,
            Name = tabName,
        }

        table.insert(State.Tabs, tabData)

        BindInput(tabBtn, function()
            JackHub:SelectTab(tabData)
        end)

        if #State.Tabs == 1 then
            JackHub:SelectTab(tabData)
        end

        return tabData
    end

    function JackHub:SelectTab(tabData)
        State.ActiveTab = tabData
        for _, tab in ipairs(State.Tabs) do
            if tab == tabData then
                Tween(tab.Button, 0.2, { BackgroundColor3 = State.Theme.Accent })
                tab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                tab.Content.Visible = true
            else
                Tween(tab.Button, 0.2, { BackgroundColor3 = State.Theme.Element })
                tab.Button.TextColor3 = State.Theme.TextDim
                tab.Content.Visible = false
            end
        end
    end

    -- ═══════════════════════════════════════════════════════════════
    -- عناصر الواجهة (Buttons, Toggles, Sliders, Dropdowns, etc.)
    -- ═══════════════════════════════════════════════════════════════

    function JackHub:AddButton(tab, cfg)
        cfg = cfg or {}
        local btn = Create("TextButton", {
            Size = UDim2.new(1, -8, 0, SIZES.ElementHeight),
            BackgroundColor3 = State.Theme.Element,
            BorderSizePixel = 0,
            Text = (cfg.Icon and cfg.Icon .. "  " or "") .. (cfg.Name or "Button"),
            TextColor3 = State.Theme.Text,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            ZIndex = 18,
            Parent = tab.ContentScroll,
        })
        Round(btn, 8)
        BindInput(btn, function()
            if cfg.Callback then cfg.Callback() end
        end)
        return btn
    end

    function JackHub:AddToggle(tab, cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Toggle"
        local default = cfg.Default or false
        local isOn = default

        local frame = Create("Frame", {
            Size = UDim2.new(1, -8, 0, SIZES.ElementHeight),
            BackgroundColor3 = State.Theme.Element,
            BorderSizePixel = 0,
            ZIndex = 18,
            Parent = tab.ContentScroll,
        })
        Round(frame, 8)

        Create("TextLabel", {
            Size = UDim2.new(1, -70, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = State.Theme.Text,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 19,
            Parent = frame,
        })

        local swBg = Create("Frame", {
            Size = UDim2.new(0, 40, 0, 20),
            Position = UDim2.new(1, -52, 0.5, -10),
            BackgroundColor3 = isOn and State.Theme.ToggleOn or State.Theme.ToggleOff,
            BorderSizePixel = 0,
            ZIndex = 19,
            Parent = frame,
        })
        Round(swBg, 10)

        local knob = Create("Frame", {
            Size = UDim2.new(0, 16, 0, 16),
            Position = isOn and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            ZIndex = 20,
            Parent = swBg,
        })
        Round(knob, 8)

        BindInput(frame, function()
            isOn = not isOn
            Tween(knob, 0.2, {
                Position = isOn and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            })
            Tween(swBg, 0.2, {
                BackgroundColor3 = isOn and State.Theme.ToggleOn or State.Theme.ToggleOff
            })
            if cfg.Callback then cfg.Callback(isOn) end
        end)
    end

    function JackHub:AddSlider(tab, cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Slider"
        local min = cfg.Min or 0
        local max = cfg.Max or 100
        local def = cfg.Default or min
        local suffix = cfg.Suffix or ""
        local current = math.clamp(def, min, max)

        local frame = Create("Frame", {
            Size = UDim2.new(1, -8, 0, 54),
            BackgroundColor3 = State.Theme.Element,
            BorderSizePixel = 0,
            ZIndex = 18,
            Parent = tab.ContentScroll,
        })
        Round(frame, 8)

        Create("TextLabel", {
            Size = UDim2.new(1, -80, 0, 18),
            Position = UDim2.new(0, 12, 0, 6),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = State.Theme.Text,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 19,
            Parent = frame,
        })

        local valLabel = Create("TextLabel", {
            Size = UDim2.new(0, 60, 0, 18),
            Position = UDim2.new(1, -72, 0, 6),
            BackgroundTransparency = 1,
            Text = tostring(current) .. suffix,
            TextColor3 = State.Theme.Accent,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 19,
            Parent = frame,
        })

        local trackBg = Create("Frame", {
            Size = UDim2.new(1, -24, 0, 6),
            Position = UDim2.new(0, 12, 0, 36),
            BackgroundColor3 = State.Theme.SliderEmpty,
            BorderSizePixel = 0,
            ZIndex = 19,
            Parent = frame,
        })
        Round(trackBg, 3)

        local fill = Create("Frame", {
            Size = UDim2.new((current - min) / (max - min), 0, 1, 0),
            BackgroundColor3 = State.Theme.SliderFill,
            BorderSizePixel = 0,
            ZIndex = 20,
            Parent = trackBg,
        })
        Round(fill, 3)

        local knob = Create("Frame", {
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new((current - min) / (max - min), -7, 0.5, -7),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            ZIndex = 21,
            Parent = trackBg,
        })
        Round(knob, 7)

        local dragging = false
        local function update(inputPos)
            local absPos = trackBg.AbsolutePosition.X
            local absW = trackBg.AbsoluteSize.X
            local rel = math.clamp((inputPos - absPos) / absW, 0, 1)
            current = math.floor(min + (max - min) * rel)
            valLabel.Text = tostring(current) .. suffix
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, -7, 0.5, -7)
            if cfg.Callback then cfg.Callback(current) end
        end

        BindInput(trackBg, function(input)
            dragging = true
            update(input.Position.X)
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement 
                or input.UserInputType == Enum.UserInputType.Touch) then
                update(input.Position.X)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    function JackHub:AddSection(tab, cfg)
        cfg = cfg or {}
        Create("TextLabel", {
            Size = UDim2.new(1, -8, 0, 28),
            BackgroundTransparency = 1,
            Text = cfg.Name or "Section",
            TextColor3 = State.Theme.Accent,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 18,
            Parent = tab.ContentScroll,
        })
    end

    function JackHub:AddLabel(tab, cfg)
        cfg = cfg or {}
        Create("TextLabel", {
            Size = UDim2.new(1, -8, 0, cfg.Height or 24),
            BackgroundTransparency = 1,
            Text = cfg.Text or "Label",
            TextColor3 = State.Theme.TextDim,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            ZIndex = 18,
            Parent = tab.ContentScroll,
        })
    end

    -- إرجاع النافذة
    return State.Window
end

-- ═══════════════════════════════════════════════════════════════
-- 10. إرجاع المكتبة
-- ═══════════════════════════════════════════════════════════════
return JackHub
