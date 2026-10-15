--[[
    ═══════════════════════════════════════════════════════════════
    JackHub Library v3.0
    مكتبة UI احترافية تدعم PC + Mobile
    الميزات: Boot / Key System / Tabs / Settings / Configs /
             Notifications / ColorPicker / Keybind / TextBox /
             Section / Label / Paragraph / Search / Tooltip
    ═══════════════════════════════════════════════════════════════
]]

local JackHub = {}
JackHub.__index = JackHub

-- ═══════════════════════════════════════════════════════════════
-- الخدمات
-- ═══════════════════════════════════════════════════════════════
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local IsMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local IsPC = not IsMobile

-- ═══════════════════════════════════════════════════════════════
-- الثوابت
-- ═══════════════════════════════════════════════════════════════
local LIB_NAME = "JackHub"
local CONFIG_FOLDER = "JackHub/Configs"
local IS_MOBILE = IsMobile

-- مقاسات تتكيف مع الجهاز
local SIZES = {
    WindowWidth = IS_MOBILE and 340 or 620,
    WindowHeight = IS_MOBILE and 380 or 440,
    TabBarWidth = IS_MOBILE and 110 or 160,
    TitleBarHeight = IS_MOBILE and 40 or 44,
    ElementHeight = IS_MOBILE and 42 or 36,
    ElementPadding = 6,
    CornerRadius = 10,
}

-- ═══════════════════════════════════════════════════════════════
-- الثيم الافتراضي
-- ═══════════════════════════════════════════════════════════════
local DefaultTheme = {
    Background = Color3.fromRGB(24, 24, 30),
    Header = Color3.fromRGB(18, 18, 22),
    TabBar = Color3.fromRGB(20, 20, 26),
    Element = Color3.fromRGB(34, 34, 42),
    ElementHover = Color3.fromRGB(44, 44, 54),
    Accent = Color3.fromRGB(138, 43, 226),
    Accent2 = Color3.fromRGB(190, 80, 255),
    Text = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(150, 150, 165),
    Outline = Color3.fromRGB(58, 58, 72),
    ToggleOn = Color3.fromRGB(138, 43, 226),
    ToggleOff = Color3.fromRGB(48, 48, 58),
    SliderFill = Color3.fromRGB(138, 43, 226),
    SliderEmpty = Color3.fromRGB(48, 48, 58),
    Success = Color3.fromRGB(60, 200, 100),
    Danger = Color3.fromRGB(230, 60, 60),
    Warning = Color3.fromRGB(240, 180, 50),
    Info = Color3.fromRGB(70, 170, 250),
}

-- ═══════════════════════════════════════════════════════════════
-- الثيمات الجاهزة
-- ═══════════════════════════════════════════════════════════════
local Themes = {
    Default = DefaultTheme,
    Dark = {
        Background = Color3.fromRGB(15, 15, 18),
        Header = Color3.fromRGB(10, 10, 12),
        TabBar = Color3.fromRGB(12, 12, 15),
        Element = Color3.fromRGB(25, 25, 30),
        ElementHover = Color3.fromRGB(35, 35, 42),
        Accent = Color3.fromRGB(120, 120, 140),
        Accent2 = Color3.fromRGB(160, 160, 180),
        Text = Color3.fromRGB(220, 220, 220),
        TextDim = Color3.fromRGB(140, 140, 150),
        Outline = Color3.fromRGB(45, 45, 55),
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
    Grape = {
        Background = Color3.fromRGB(30, 20, 40),
        Header = Color3.fromRGB(22, 14, 30),
        TabBar = Color3.fromRGB(25, 16, 35),
        Element = Color3.fromRGB(45, 30, 60),
        ElementHover = Color3.fromRGB(60, 40, 80),
        Accent = Color3.fromRGB(166, 71, 214),
        Accent2 = Color3.fromRGB(200, 110, 240),
        Text = Color3.fromRGB(230, 210, 255),
        TextDim = Color3.fromRGB(180, 160, 210),
        Outline = Color3.fromRGB(80, 55, 100),
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
-- الحالة الداخلية
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
    KeyVerified = false,
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

-- دالة ربط شاملة للـ PC + Mobile
local function BindInput(obj, callback, inputType)
    inputType = inputType or "Click"
    local connection
    
    if inputType == "Click" then
        connection = obj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 
               or input.UserInputType == Enum.UserInputType.Touch then
                callback(input)
            end
        end)
    elseif inputType == "Enter" then
        connection = obj.MouseEnter:Connect(callback)
        obj.TouchLongPress = connection
    elseif inputType == "Leave" then
        connection = obj.MouseLeave:Connect(callback)
    elseif inputType == "Changed" then
        connection = obj.InputChanged:Connect(callback)
    end
    
    return connection
end

-- ═══════════════════════════════════════════════════════════════
-- الإشعارات (Notifications)
-- ═══════════════════════════════════════════════════════════════
local NotifGui = nil
local function GetNotifGui()
    if NotifGui and NotifGui.Parent then return NotifGui end
    if State.ScreenGui then return State.ScreenGui end
    NotifGui = Create("ScreenGui", {
        Name = "JackHub_Notifications",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
        Parent = CoreGui,
    })
    return NotifGui
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
    
    local notifWidth = IS_MOBILE and 260 or 320
    local notifHeight = 70
    
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
    local stroke = Stroke(notif, accentColor, 1.5, 0.3)
    
    -- شريط جانبي
    local bar = Create("Frame", {
        Size = UDim2.new(0, 4, 1, -14),
        Position = UDim2.new(0, 6, 0, 7),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        ZIndex = 1000,
        Parent = notif,
    })
    Round(bar, 2)
    
    -- أيقونة
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
    
    -- العنوان
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
    
    -- الرسالة
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
    
    -- أنيميشن دخول
    Tween(notif, 0.4, {
        Position = UDim2.new(1, -(notifWidth + 20), 0, 20 + ((existingCount) * (notifHeight + 8)))
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    -- حذف تلقائي
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
-- الحفظ والتحميل
-- ═══════════════════════════════════════════════════════════════
local function SaveConfig(name, data)
    if not (writefile and isfolder and makefolder) then return end
    pcall(function()
        if not isfolder(LIB_NAME) then makefolder(LIB_NAME) end
        if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
        writefile(CONFIG_FOLDER .. "/" .. name .. ".json", HttpService:JSONEncode(data))
    end)
end

local function LoadConfig(name)
    if not (readfile and isfile) then return nil end
    local path = CONFIG_FOLDER .. "/" .. name .. ".json"
    if not isfile(path) then return nil end
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(path))
    end)
    if success then return data end
    return nil
end

-- ═══════════════════════════════════════════════════════════════
-- تطبيق الثيم
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
            -- دمج مع الافتراضي لملء المفاتيح الناقصة
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
-- Boot Screen
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
            Image = bgImage,
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
    
    -- العنوان
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
    
    -- شريط التقدم
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
    
    local grad2 = Instance.new("UIGradient")
    grad2.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, State.Theme.Accent),
        ColorSequenceKeypoint.new(0.5, State.Theme.Accent2),
        ColorSequenceKeypoint.new(1, State.Theme.Accent),
    })
    grad2.Parent = progressFill
    
    -- تأثيرات حسب النوع
    if bootType == "X" then
        for _, rot in ipairs({45, -45}) do
            local line = Create("Frame", {
                Size = UDim2.new(0, 0, 0, 3),
                Position = UDim2.new(0.5, -40, 0.35, 0),
                BackgroundColor3 = State.Theme.Accent,
                BorderSizePixel = 0,
                Rotation = rot,
                Parent = bg,
            })
            Tween(line, 0.6, { Size = UDim2.new(0, 80, 0, 3) })
        end
    elseif bootType == "XP" then
        for i = 1, 4 do
            task.delay((i-1) * 0.25, function()
                local p = Create("Frame", {
                    Size = UDim2.new(0, 40, 0, 40),
                    Position = UDim2.new(0.5, -20, 0.35, -20),
                    BackgroundColor3 = State.Theme.Accent,
                    BackgroundTransparency = 0.7,
                    BorderSizePixel = 0,
                    Parent = bg,
                })
                Round(p, 20)
                Tween(p, 1.2, {
                    Size = UDim2.new(0, 180, 0, 180),
                    Position = UDim2.new(0.5, -90, 0.35, -90),
                    BackgroundTransparency = 1,
                })
                task.wait(1.5)
                p:Destroy()
            end)
        end
    elseif bootType == "XPRO" then
        local ring = Create("Frame", {
            Size = UDim2.new(0, 90, 0, 90),
            Position = UDim2.new(0.5, -45, 0.35, -45),
            BackgroundTransparency = 1,
            Parent = bg,
        })
        local rs = Instance.new("UIStroke")
        rs.Color = State.Theme.Accent
        rs.Thickness = 3
        rs.Parent = ring
        local rc = Instance.new("UICorner")
        rc.CornerRadius = UDim.new(1, 0)
        rc.Parent = ring
        
        task.spawn(function()
            for i = 1, 40 do
                rs.Transparency = 0.5 - (i / 80)
                ring.Rotation = i * 9
                task.wait(0.04)
            end
        end)
    end
    
    -- أنيميشن الظهور
    Tween(titleLabel, 0.7, { TextTransparency = 0 })
    Tween(subtitleLabel, 0.9, { TextTransparency = 0 })
    
    -- شريط التقدم
    local loadDuration = 2.5
    Tween(progressFill, loadDuration, { Size = UDim2.new(1, 0, 1, 0) }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    task.wait(loadDuration + 0.3)
    
    -- إغلاق
    Tween(bg, 0.4, { BackgroundTransparency = 1 })
    Tween(titleLabel, 0.3, { TextTransparency = 1 })
    Tween(subtitleLabel, 0.3, { TextTransparency = 1 })
    task.wait(0.5)
    gui:Destroy()
end

-- ═══════════════════════════════════════════════════════════════
-- Key System
-- ═══════════════════════════════════════════════════════════════
local function CreateKeySystem(config)
    config = config or {}
    
    local title = config.Title or "Key System"
    local subtitle = config.Subtitle or "أدخل المفتاح للمتابعة"
    local note = config.Note or ""
    local keys = config.Key or {"default"}
    local saveKey = config.SaveKey ~= false
    local keyFileName = config.FileName or "Key"
    local grabFromSite = config.GrabKeyFromSite or false
    local keyURL = config.KeyURL or ""
    local additionalTabs = config.AdditionalTabs or {}
    
    -- التحقق من مفتاح محفوظ
    if saveKey and readfile and isfile then
        local savedKey
        pcall(function()
            savedKey = readfile(LIB_NAME .. "/" .. keyFileName .. ".key")
        end)
        if savedKey then
            for _, k in ipairs(keys) do
                if savedKey == k then
                    State.KeyVerified = true
                    return true
                end
            end
        end
    end
    
    if grabFromSite and keyURL ~= "" then
        local ok, fetched = pcall(function() return game:HttpGet(keyURL) end)
        if ok and fetched then
            for line in fetched:gmatch("[^\r\n]+") do
                table.insert(keys, line)
            end
        end
    end
    
    local screenGui = Create("ScreenGui", {
        Name = "JackHub_KeySystem",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
        Parent = CoreGui,
    })
    
    local bg = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = screenGui,
    })
    
    local panelWidth = IS_MOBILE and 300 or 420
    local panelHeight = IS_MOBILE and 300 or 320
    
    local main = Create("Frame", {
        Size = UDim2.new(0, panelWidth, 0, panelHeight),
        Position = UDim2.new(0.5, -panelWidth/2, 0.5, -panelHeight/2),
        BackgroundColor3 = State.Theme.Background,
        BorderSizePixel = 0,
        Parent = bg,
    })
    Round(main, 14)
    Stroke(main, State.Theme.Accent, 1.5, 0.3)
    
    -- شريط علوي
    local topBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = State.Theme.Header,
        BorderSizePixel = 0,
        Parent = main,
    })
    Round(topBar, 14)
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 1, -14),
        BackgroundColor3 = State.Theme.Header,
        BorderSizePixel = 0,
        Parent = topBar,
    })
    
    Create("TextLabel", {
        Size = UDim2.new(1, -28, 0, 26),
        Position = UDim2.new(0, 14, 0, 5),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = State.Theme.Text,
        TextSize = 17,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar,
    })
    
    Create("TextLabel", {
        Size = UDim2.new(1, -28, 0, 16),
        Position = UDim2.new(0, 14, 0, 28),
        BackgroundTransparency = 1,
        Text = subtitle,
        TextColor3 = State.Theme.TextDim,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar,
    })
    
    -- منطقة التبويبات
    local tabsHolder = Create("Frame", {
        Size = UDim2.new(1, -28, 0, 30),
        Position = UDim2.new(0, 14, 0, 60),
        BackgroundTransparency = 1,
        Parent = main,
    })
    local tl = Instance.new("UIListLayout")
    tl.FillDirection = Enum.FillDirection.Horizontal
    tl.Padding = UDim.new(0, 6)
    tl.Parent = tabsHolder
    
    local function createKeyTab(name, isActive)
        local btn = Create("TextButton", {
            Size = UDim2.new(0, IS_MOBILE and 90 or 100, 1, 0),
            BackgroundColor3 = isActive and State.Theme.Accent or State.Theme.Element,
            BorderSizePixel = 0,
            Text = name,
            TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or State.Theme.TextDim,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            Parent = tabsHolder,
        })
        Round(btn, 6)
        return btn
    end
    
    createKeyTab("المفتاح", true)
    
    -- محتوى افتراضي
    local contentHolder = Create("Frame", {
        Size = UDim2.new(1, -28, 1, -170),
        Position = UDim2.new(0, 14, 0, 100),
        BackgroundTransparency = 1,
        Parent = main,
    })
    
    -- حقل إدخال
    local inputFrame = Create("Frame", {
        Size = UDim2.new(1, -28, 0, 44),
        Position = UDim2.new(0, 14, 0, 160),
        BackgroundColor3 = State.Theme.Element,
        BorderSizePixel = 0,
        Parent = main,
    })
    Round(inputFrame, 8)
    Stroke(inputFrame, State.Theme.Outline, 1, 0.5)
    
    local keyInput = Create("TextBox", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = "أدخل المفتاح هنا...",
        TextColor3 = State.Theme.Text,
        PlaceholderColor3 = State.Theme.TextDim,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = inputFrame,
    })
    
    -- زر التفعيل
    local submitBtn = Create("TextButton", {
        Size = UDim2.new(1, -28, 0, 40),
        Position = UDim2.new(0, 14, 0, 215),
        BackgroundColor3 = State.Theme.Accent,
        BorderSizePixel = 0,
        Text = "تفعيل",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        Parent = main,
    })
    Round(submitBtn, 8)
    
    -- الحالة
    local statusLabel = Create("TextLabel", {
        Size = UDim2.new(1, -28, 0, 20),
        Position = UDim2.new(0, 14, 1, -32),
        BackgroundTransparency = 1,
        Text = note,
        TextColor3 = State.Theme.TextDim,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        Parent = main,
    })
    
    -- تبويبات إضافية
    for _, tab in ipairs(additionalTabs) do
        local tabBtn = createKeyTab(tab.Name or "Tab", false)
        tabBtn.MouseButton1Click:Connect(function()
            -- إخفاء المحتوى الأساسي
            inputFrame.Visible = false
            submitBtn.Visible = false
            contentHolder:ClearAllChildren()
            statusLabel.Text = ""
            
            if tab.Content then
                tab.Content(contentHolder)
            end
        end)
    end
    
    -- التحقق
    local function verify()
        local entered = keyInput.Text
        if entered == "" then
            statusLabel.TextColor3 = State.Theme.Warning
            statusLabel.Text = "الرجاء إدخال المفتاح"
            return
        end
        
        local valid = false
        for _, k in ipairs(keys) do
            if entered == k then valid = true break end
        end
        
        if valid then
            statusLabel.TextColor3 = State.Theme.Success
            statusLabel.Text = "✓ تم التفعيل بنجاح!"
            State.KeyVerified = true
            
            if saveKey and writefile then
                pcall(function()
                    if not isfolder(LIB_NAME) then makefolder(LIB_NAME) end
                    writefile(LIB_NAME .. "/" .. keyFileName .. ".key", entered)
                end)
            end
            
            task.wait(0.7)
            Tween(bg, 0.4, { BackgroundTransparency = 1 })
            Tween(main, 0.4, { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) })
            task.wait(0.5)
            screenGui:Destroy()
        else
            statusLabel.TextColor3 = State.Theme.Danger
            statusLabel.Text = "✕ المفتاح غير صحيح!"
            keyInput.Text = ""
        end
    end
    
    BindInput(submitBtn, verify)
    keyInput.FocusLost:Connect(function(enter) if enter then verify() end end)
    
    -- انتظار بدون حجب
    while not State.KeyVerified do
        task.wait(0.1)
        if not screenGui.Parent then break end
    end
    
    return true
end

-- ═══════════════════════════════════════════════════════════════
-- إنشاء النافذة
-- ═══════════════════════════════════════════════════════════════
function JackHub:CreateWindow(config)
    config = config or {}
    
    local windowName = config.Name or "JackHub"
    local bootType = config.BootType or "XPRO"
    local themeName = config.Theme or "Default"
    local toggleKey = config.ToggleUIKeybind or "K"
    local keyEnabled = config.KeySystem or false
    local keySettings = config.KeySettings or {}
    local bgImage = config.BackgroundImage
    local author = config.Author or ""
    local version = config.Version or "v1.0"
    
    -- الثيم
    JackHub:SetTheme(themeName)
    
    -- Boot
    if config.BootScreen ~= false then
        CreateBootScreen({
            Title = config.LoadingTitle or windowName,
            Subtitle = config.LoadingSubtitle or "Loading...",
            Type = bootType,
            Background = config.BootBackground,
        })
    end
    
    -- Key
    if keyEnabled then
        CreateKeySystem(keySettings)
    end
    
    -- ═══ الواجهة الرئيسية ═══
    local screenGui = Create("ScreenGui", {
        Name = "JackHub_UI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100,
        Parent = CoreGui,
    })
    
    State.ScreenGui = screenGui
    
    -- الخلفية الشفافة
    local backdrop = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 5,
        Parent = screenGui,
    })
    
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
    Round(mainFrame, 12)
    Stroke(mainFrame, State.Theme.Outline, 1.5, 0.4)
    mainFrame:SetAttribute("ThemeColor", "Background")
    
    State.MainFrame = mainFrame
    State.Window = { ScreenGui = screenGui, MainFrame = mainFrame }
    
    -- خلفية مخصصة
    if bgImage then
        local img = Create("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = bgImage,
            ImageTransparency = 0.85,
            ScaleType = Enum.ScaleType.Crop,
            ZIndex = 1,
            Parent = mainFrame,
        })
        Round(img, 12)
    end
    
    -- ═══ شريط العنوان ═══
    local titleBar = Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, SIZES.TitleBarHeight),
        BackgroundColor3 = State.Theme.Header,
        BorderSizePixel = 0,
        ZIndex = 20,
        Parent = mainFrame,
    })
    titleBar:SetAttribute("ThemeColor", "Header")
    Round(titleBar, 12)
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = State.Theme.Header,
        BorderSizePixel = 0,
        ZIndex = 20,
        Parent = titleBar,
    })
    
    -- شريط تقدم افتراضي (لكن مخفي)
    -- العنوان + الشعار
    local titleIcon = Create("TextLabel", {
        Size = UDim2.new(0, 24, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = "◆",
        TextColor3 = State.Theme.Accent,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        ZIndex = 22,
        Parent = titleBar,
    })
    
    Create("TextLabel", {
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 42, 0, 0),
        BackgroundTransparency = 1,
        Text = windowName,
        TextColor3 = State.Theme.Text,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 22,
        Parent = titleBar,
    }).Name = "TitleLabel"
    
    if author ~= "" then
        Create("TextLabel", {
            Size = UDim2.new(0, 200, 1, 0),
            Position = UDim2.new(0, 42, 0, 0),
            BackgroundTransparency = 1,
            Text = "  by " .. author,
            TextColor3 = State.Theme.TextDim,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 22,
            Parent = titleBar,
        })
    end
    
    -- ═══ أزرار الشريط العلوي ═══
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
        btn:SetAttribute("ThemeColor", "Element")
        btn:SetAttribute("ThemeText", "Text")
        Round(btn, 6)
        
        -- Tooltip بسيط
        btn.MouseEnter:Connect(function()
            Tween(btn, 0.15, { BackgroundColor3 = isClose and State.Theme.Danger or State.Theme.Accent })
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, 0.15, { BackgroundColor3 = State.Theme.Element })
        end)
        BindInput(btn, callback)
        return btn
    end
    
    -- زر Settings
    createTitleBtn("⚙", "الإعدادات", function()
        JackHub:ToggleSettings()
    end)
    
    -- زر Hide/Show
    createTitleBtn("◉", "إخفاء/إظهار", function()
        JackHub:ToggleUI()
    end)
    
    -- زر Minimize
    createTitleBtn("─", "تصغير", function()
        JackHub:ToggleMinimize()
    end)
    
    -- زر Fullscreen
    createTitleBtn("⛶", "ملء الشاشة", function()
        JackHub:ToggleFullscreen()
    end)
    
    -- زر Close
    createTitleBtn("✕", "إغلاق", function()
        JackHub:Destroy()
    end, true)
    
    -- ═══ شريط البحث ═══
    local searchBar = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 32),
        Position = UDim2.new(0, 10, 0, SIZES.TitleBarHeight + 6),
        BackgroundColor3 = State.Theme.TabBar,
        BorderSizePixel = 0,
        Visible = false, -- يظهر عند البحث
        ZIndex = 19,
        Parent = mainFrame,
    })
    Round(searchBar, 8)
    Stroke(searchBar, State.Theme.Outline, 1, 0.6)
    
    local searchInput = Create("TextBox", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 24, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = "🔍 ابحث...",
        TextColor3 = State.Theme.Text,
        PlaceholderColor3 = State.Theme.TextDim,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        ZIndex = 20,
        Parent = searchBar,
    })
    
    -- ═══ منطقة التبويبات ═══
    local tabBar = Create("Frame", {
        Name = "TabBar",
        Size = UDim2.new(0, SIZES.TabBarWidth, 1, -(SIZES.TitleBarHeight)),
        Position = UDim2.new(0, 0, 0, SIZES.TitleBarHeight),
        BackgroundColor3 = State.Theme.TabBar,
        BorderSizePixel = 0,
        ZIndex = 15,
        Parent = mainFrame,
    })
    tabBar:SetAttribute("ThemeColor", "TabBar")
    
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
    
    -- ═══ منطقة المحتوى ═══
    local contentFrame = Create("Frame", {
        Name = "ContentFrame",
        Size = UDim2.new(1, -SIZES.TabBarWidth, 1, -SIZES.TitleBarHeight),
        Position = UDim2.new(0, SIZES.TabBarWidth, 0, SIZES.TitleBarHeight),
        BackgroundTransparency = 1,
        ZIndex = 15,
        Parent = mainFrame,
    })
    
    State.ContentFrame = contentFrame
    
    -- ═══════════════════════════════════════════════════════════════
    -- إنشاء التبويبات
    -- ═══════════════════════════════════════════════════════════════
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
        tabBtn:SetAttribute("ThemeColor", "Element")
        tabBtn:SetAttribute("ThemeText", "TextDim")
        
        -- إطار محتوى التبويب
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
            ContentLayout = cLayout,
            Name = tabName,
            Icon = tabIcon,
        }
        
        table.insert(State.Tabs, tabData)
        
        -- أحداث
        tabBtn.MouseEnter:Connect(function()
            if State.ActiveTab ~= tabData then
                Tween(tabBtn, 0.15, { BackgroundColor3 = State.Theme.ElementHover })
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if State.ActiveTab ~= tabData then
                Tween(tabBtn, 0.15, { BackgroundColor3 = State.Theme.Element })
            end
        end)
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
                tab.Content.Position = UDim2.new(0, 16, 0, 8)
                Tween(tab.Content, 0.25, { Position = UDim2.new(0, 8, 0, 8) })
            else
                Tween(tab.Button, 0.2, { BackgroundColor3 = State.Theme.Element })
                tab.Button.TextColor3 = State.Theme.TextDim
                tab.Content.Visible = false
            end
        end
    end
    
    -- ═══════════════════════════════════════════════════════════════
    -- عناصر UI
    -- ═══════════════════════════════════════════════════════════════
    
    -- زر
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
        Stroke(btn, State.Theme.Outline, 1, 0.7)
        btn:SetAttribute("ThemeColor", "Element")
        btn:SetAttribute("ThemeText", "Text")
        
        btn.MouseEnter:Connect(function()
            Tween(btn, 0.15, { BackgroundColor3 = State.Theme.ElementHover })
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, 0.15, { BackgroundColor3 = State.Theme.Element })
        end)
        BindInput(btn, function()
            Tween(btn, 0.08, { Size = UDim2.new(0.97, -8, 0, SIZES.ElementHeight - 2) })
            task.wait(0.08)
            Tween(btn, 0.08, { Size = UDim2.new(1, -8, 0, SIZES.ElementHeight) })
            if cfg.Callback then cfg.Callback() end
        end)
        return btn
    end
    
    -- Toggle
    function JackHub:AddToggle(tab, cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Toggle"
        local default = cfg.Default or false
        local flag = cfg.Flag or name
        local isOn = default
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, -8, 0, SIZES.ElementHeight),
            BackgroundColor3 = State.Theme.Element,
            BorderSizePixel = 0,
            ZIndex = 18,
            Parent = tab.ContentScroll,
        })
        Round(frame, 8)
        frame:SetAttribute("ThemeColor", "Element")
        
        Create("TextLabel", {
            Size = UDim2.new(1, -70, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = State.Theme.Text,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 19,
            Parent = frame,
        }):SetAttribute("ThemeText", "Text")
        
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
        
        local function setState(v, fireCallback)
            isOn = v
            State.Flags[flag] = v
            Tween(knob, 0.2, {
                Position = isOn and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            })
            Tween(swBg, 0.2, {
                BackgroundColor3 = isOn and State.Theme.ToggleOn or State.Theme.ToggleOff
            })
            if fireCallback ~= false and cfg.Callback then
                cfg.Callback(isOn)
            end
        end
        
        if default then State.Flags[flag] = true end
        
        BindInput(frame, function()
            setState(not isOn)
        end)
        
        return {
            Set = function(v) setState(v) end,
            Get = function() return isOn end,
            Frame = frame,
        }
    end
    
    -- Slider
    function JackHub:AddSlider(tab, cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Slider"
        local min = cfg.Min or 0
        local max = cfg.Max or 100
        local def = cfg.Default or min
        local suffix = cfg.Suffix or ""
        local flag = cfg.Flag or name
        local current = math.clamp(def, min, max)
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, -8, 0, 54),
            BackgroundColor3 = State.Theme.Element,
            BorderSizePixel = 0,
            ZIndex = 18,
            Parent = tab.ContentScroll,
        })
        Round(frame, 8)
        frame:SetAttribute("ThemeColor", "Element")
        
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
            State.Flags[flag] = current
            if cfg.Callback then cfg.Callback(current) end
        end
        
        -- PC + Mobile: نستخدم Position.X الموحّد
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
        
        State.Flags[flag] = current
        
        return {
            Set = function(v)
                current = math.clamp(v, min, max)
                local rel = (current - min) / (max - min)
                valLabel.Text = tostring(current) .. suffix
                fill.Size = UDim2.new(rel, 0, 1, 0)
                knob.Position = UDim2.new(rel, -7, 0.5, -7)
                State.Flags[flag] = current
                if cfg.Callback then cfg.Callback(current) end
            end,
            Get = function() return current end,
        }
    end
    
    -- Dropdown
    function JackHub:AddDropdown(tab, cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Dropdown"
        local options = cfg.Options or {}
        local flag = cfg.Flag or name
        local multi = cfg.Multi or false
        local selected = multi and {} or nil
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, -8, 0, SIZES.ElementHeight),
            BackgroundColor3 = State.Theme.Element,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 18,
            Parent = tab.ContentScroll,
        })
        Round(frame, 8)
        frame:SetAttribute("ThemeColor", "Element")
        
        local nameLabel = Create("TextLabel", {
            Size = UDim2.new(1, -60, 0, SIZES.ElementHeight),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = State.Theme.Text,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 19,
            Parent = frame,
        })
        
        local arrow = Create("TextLabel", {
            Size = UDim2.new(0, 20, 0, SIZES.ElementHeight),
            Position = UDim2.new(1, -26, 0, 0),
            BackgroundTransparency = 1,
            Text = "▼",
            TextColor3 = State.Theme.TextDim,
            TextSize = 11,
            ZIndex = 19,
            Parent = frame,
        })
        
        local optionList = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = State.Theme.Element,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 19,
            Parent = frame,
        })
        
        local optLayout = Instance.new("UIListLayout")
        optLayout.Padding = UDim.new(0, 2)
        optLayout.Parent = optionList
        Padding(optionList, 4)
        
        local isOpen = false
        
        local function refreshList()
            optionList:ClearAllChildren()
            local lyt = Instance.new("UIListLayout")
            lyt.Padding = UDim.new(0, 2)
            lyt.Parent = optionList
            Padding(optionList, 4)
            
            for _, option in ipairs(options) do
                local isSelected = multi and table.find(selected, option) or selected == option
                local ob = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 28),
                    BackgroundColor3 = isSelected and State.Theme.Accent or State.Theme.Element,
                    BorderSizePixel = 0,
                    Text = (isSelected and "✓ " or "") .. tostring(option),
                    TextColor3 = isSelected and Color3.fromRGB(255,255,255) or State.Theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 20,
                    Parent = optionList,
                })
                Round(ob, 4)
                Padding(ob, 6, nil, nil, 8, nil)
                
                BindInput(ob, function()
                    if multi then
                        local idx = table.find(selected, option)
                        if idx then table.remove(selected, idx) else table.insert(selected, option) end
                        nameLabel.Text = name .. " (" .. #selected .. ")"
                        State.Flags[flag] = selected
                        if cfg.Callback then cfg.Callback(selected) end
                        refreshList()
                    else
                        selected = option
                        nameLabel.Text = name .. ": " .. tostring(option)
                        State.Flags[flag] = option
                        isOpen = false
                        Tween(optionList, 0.2, { Size = UDim2.new(1, 0, 0, 0) })
                        Tween(frame, 0.2, { Size = UDim2.new(1, -8, 0, SIZES.ElementHeight) })
                        arrow.Text = "▼"
                        if cfg.Callback then cfg.Callback(option) end
                    end
                end)
            end
        end
        
        BindInput(frame, function()
            isOpen = not isOpen
            if isOpen then
                refreshList()
                local h = math.min(#options * 30 + 8, 180)
                Tween(optionList, 0.2, { Size = UDim2.new(1, 0, 0, h) })
                Tween(frame, 0.2, { Size = UDim2.new(1, -8, 0, SIZES.ElementHeight + h) })
                arrow.Text = "▲"
            else
                Tween(optionList, 0.2, { Size = UDim2.new(1, 0, 0, 0) })
                Tween(frame, 0.2, { Size = UDim2.new(1, -8, 0, SIZES.ElementHeight) })
                arrow.Text = "▼"
            end
        end)
        
        return {
            Set = function(v) selected = v; State.Flags[flag] = v; nameLabel.Text = name .. ": " .. tostring(v); if cfg.Callback then cfg.Callback(v) end end,
            Get = function() return selected end,
        }
    end
    
    -- TextBox
    function JackHub:AddTextBox(tab, cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Input"
        local placeholder = cfg.Placeholder or "..."
        local def = cfg.Default or ""
        local flag = cfg.Flag or name
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, -8, 0, SIZES.ElementHeight),
            BackgroundColor3 = State.Theme.Element,
            BorderSizePixel = 0,
            ZIndex = 18,
            Parent = tab.ContentScroll,
        })
        Round(frame, 8)
        frame:SetAttribute("ThemeColor", "Element")
        
        Create("TextLabel", {
            Size = UDim2.new(0, 90, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = State.Theme.Text,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 19,
            Parent = frame,
        })
        
        local box = Create("TextBox", {
            Size = UDim2.new(1, -110, 1, 0),
            Position = UDim2.new(0, 102, 0, 0),
            BackgroundTransparency = 1,
            Text = def,
            PlaceholderText = placeholder,
            TextColor3 = State.Theme.Text,
            PlaceholderColor3 = State.Theme.TextDim,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Right,
            ClearTextOnFocus = false,
            ZIndex = 19,
            Parent = frame,
        })
        
        State.Flags[flag] = def
        
        box.FocusLost:Connect(function()
            State.Flags[flag] = box.Text
            if cfg.Callback then cfg.Callback(box.Text) end
        end)
        
        return {
            Set = function(v) box.Text = v; State.Flags[flag] = v; if cfg.Callback then cfg.Callback(v) end end,
            Get = function() return box.Text end,
        }
    end
    
    -- Keybind
    function JackHub:AddKeybind(tab, cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Keybind"
        local def = cfg.Default or "E"
        local flag = cfg.Flag or name
        local current = def
        local listening = false
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, -8, 0, SIZES.ElementHeight),
            BackgroundColor3 = State.Theme.Element,
            BorderSizePixel = 0,
            ZIndex = 18,
            Parent = tab.ContentScroll,
        })
        Round(frame, 8)
        frame:SetAttribute("ThemeColor", "Element")
        
        Create("TextLabel", {
            Size = UDim2.new(1, -80, 1, 0),
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
        
        local keyBtn = Create("TextButton", {
            Size = UDim2.new(0, 60, 0, 24),
            Position = UDim2.new(1, -72, 0.5, -12),
            BackgroundColor3 = State.Theme.TabBar,
            BorderSizePixel = 0,
            Text = def,
            TextColor3 = State.Theme.Accent,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            ZIndex = 19,
            Parent = frame,
        })
        Round(keyBtn, 6)
        
        local conn
        local function startListening()
            listening = true
            keyBtn.Text = "..."
            conn = UserInputService.InputBegan:Connect(function(input, gp)
                if gp then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    current = input.KeyCode.Name
                    State.Flags[flag] = current
                    keyBtn.Text = current
                    listening = false
                    if conn then conn:Disconnect() end
                    if cfg.Callback then cfg.Callback(current) end
                    if cfg.OnPressed then
                        -- Bind callback
                        UserInputService.InputBegan:Connect(function(i, g)
                            if not g and i.KeyCode == input.KeyCode then cfg.OnPressed() end
                        end)
                    end
                end
            end)
        end
        
        BindInput(keyBtn, startListening)
        State.Flags[flag] = def
        
        return {
            Set = function(v) current = v; keyBtn.Text = v; State.Flags[flag] = v end,
            Get = function() return current end,
        }
    end
    
    -- Section
    function JackHub:AddSection(tab, cfg)
        cfg = cfg or {}
        local section = Create("TextLabel", {
            Size = UDim2.new(1, -8, 0, 28),
            BackgroundTransparency = 1,
            Text = cfg.Name or "Section",
            TextColor3 = State.Theme.Accent,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 18,
            Parent = tab.ContentScroll,
        })
        Padding(section, 0, 4, 0, 4, 0)
        return section
    end
    
    -- Label / Paragraph
    function JackHub:AddLabel(tab, cfg)
        cfg = cfg or {}
        local label = Create("TextLabel", {
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
        return label
    end
    
    -- ColorPicker (HSV)
    function JackHub:AddColorPicker(tab, cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Color"
        local def = cfg.Default or Color3.fromRGB(138, 43, 226)
        local flag = cfg.Flag or name
        local current = def
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, -8, 0, SIZES.ElementHeight),
            BackgroundColor3 = State.Theme.Element,
            BorderSizePixel = 0,
            ZIndex = 18,
            Parent = tab.ContentScroll,
        })
        Round(frame, 8)
        frame:SetAttribute("ThemeColor", "Element")
        
        Create("TextLabel", {
            Size = UDim2.new(1, -60, 1, 0),
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
        
        local preview = Create("Frame", {
            Size = UDim2.new(0, 30, 0, 22),
            Position = UDim2.new(1, -42, 0.5, -11),
            BackgroundColor3 = def,
            BorderSizePixel = 0,
            ZIndex = 19,
            Parent = frame,
        })
        Round(preview, 6)
        Stroke(preview, State.Theme.Outline, 1, 0.3)
        
        -- لوحة اختيار الألوان المنبثقة
        local picker = Create("Frame", {
            Size = UDim2.new(1, -8, 0, 0),
            BackgroundColor3 = State.Theme.TabBar,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 19,
            Parent = tab.ContentScroll,
        })
        Round(picker, 8)
        
        local isOpen = false
        
        -- HSV Picker
        local hueBar = Create("Frame", {
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundColor3 = Color3.new(1, 0, 0),
            BorderSizePixel = 0,
            ZIndex = 20,
            Parent = picker,
        })
        Round(hueBar, 4)
        local hueGrad = Instance.new("UIGradient")
        hueGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1,0,0)),
            ColorSequenceKeypoint.new(0.17, Color3.new(1,1,0)),
            ColorSequenceKeypoint.new(0.33, Color3.new(0,1,0)),
            ColorSequenceKeypoint.new(0.5, Color3.new(0,1,1)),
            ColorSequenceKeypoint.new(0.67, Color3.new(0,0,1)),
            ColorSequenceKeypoint.new(0.83, Color3.new(1,0,1)),
            ColorSequenceKeypoint.new(1, Color3.new(1,0,0)),
        })
        hueGrad.Parent = hueBar
        
        local hueKnob = Create("Frame", {
            Size = UDim2.new(0, 6, 1.4, 0),
            Position = UDim2.new(0, 0, -0.2, 0),
            BackgroundColor3 = Color3.new(1,1,1),
            BorderSizePixel = 0,
            ZIndex = 21,
            Parent = hueBar,
        })
        Round(hueKnob, 3)
        
        -- HSV value = Hue * Sat * Val
        local function hsvToRGB(h, s, v)
            return Color3.fromHSV(h, s, v)
        end
        
        local h, s, v = Color3.toHSV(def)
        
        local function updateFromHSV()
            current = hsvToRGB(h, s, v)
            preview.BackgroundColor3 = current
            State.Flags[flag] = current
            if cfg.Callback then cfg.Callback(current) end
        end
        
        -- شريط Hue
        local hueDrag = false
        BindInput(hueBar, function(input)
            hueDrag = true
            local rel = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
            h = rel
            hueKnob.Position = UDim2.new(rel, -3, -0.2, 0)
            updateFromHSV()
        end)
        UserInputService.InputChanged:Connect(function(input)
            if hueDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local rel = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                h = rel
                hueKnob.Position = UDim2.new(rel, -3, -0.2, 0)
                updateFromHSV()
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                hueDrag = false
            end
        end)
        
        -- Saturation bar
        local satBar = Create("Frame", {
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 10, 0, 38),
            BackgroundColor3 = Color3.new(1,1,1),
            BorderSizePixel = 0,
            ZIndex = 20,
            Parent = picker,
        })
        Round(satBar, 4)
        local satGrad = Instance.new("UIGradient")
        satGrad.Color = ColorSequence.new(Color3.new(1,1,1), hsvToRGB(h, 1, 1))
        satGrad.Parent = satBar
        
        local satKnob = Create("Frame", {
            Size = UDim2.new(0, 6, 1.4, 0),
            Position = UDim2.new(s, -3, -0.2, 0),
            BackgroundColor3 = Color3.new(1,1,1),
            BorderSizePixel = 0,
            ZIndex = 21,
            Parent = satBar,
        })
        Round(satKnob, 3)
        
        local satDrag = false
        BindInput(satBar, function(input)
            satDrag = true
            local rel = math.clamp((input.Position.X - satBar.AbsolutePosition.X) / satBar.AbsoluteSize.X, 0, 1)
            s = rel
            satKnob.Position = UDim2.new(rel, -3, -0.2, 0)
            updateFromHSV()
        end)
        UserInputService.InputChanged:Connect(function(input)
            if satDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local rel = math.clamp((input.Position.X - satBar.AbsolutePosition.X) / satBar.AbsoluteSize.X, 0, 1)
                s = rel
                satKnob.Position = UDim2.new(rel, -3, -0.2, 0)
                updateFromHSV()
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                satDrag = false
            end
        end)
        
        -- Brightness
        local briBar = Create("Frame", {
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 10, 0, 66),
            BackgroundColor3 = Color3.new(0,0,0),
            BorderSizePixel = 0,
            ZIndex = 20,
            Parent = picker,
        })
        Round(briBar, 4)
        local briGrad = Instance.new("UIGradient")
        briGrad.Color = ColorSequence.new(Color3.new(0,0,0), Color3.new(1,1,1))
        briGrad.Parent = briBar
        
        local briKnob = Create("Frame", {
            Size = UDim2.new(0, 6, 1.4, 0),
            Position = UDim2.new(v, -3, -0.2, 0),
            BackgroundColor3 = Color3.new(1,1,1),
            BorderSizePixel = 0,
            ZIndex = 21,
            Parent = briBar,
        })
        Round(briKnob, 3)
        
        local briDrag = false
        BindInput(briBar, function(input)
            briDrag = true
            local rel = math.clamp((input.Position.X - briBar.AbsolutePosition.X) / briBar.AbsoluteSize.X, 0, 1)
            v = rel
            briKnob.Position = UDim2.new(rel, -3, -0.2, 0)
            updateFromHSV()
        end)
        UserInputService.InputChanged:Connect(function(input)
            if briDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local rel = math.clamp((input.Position.X - briBar.AbsolutePosition.X) / briBar.AbsoluteSize.X, 0, 1)
                v = rel
                briKnob.Position = UDim2.new(rel, -3, -0.2, 0)
                updateFromHSV()
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                briDrag = false
            end
        end)
        
        -- Hex input
        local hexBox = Create("TextBox", {
            Size = UDim2.new(1, -20, 0, 28),
            Position = UDim2.new(0, 10, 0, 94),
            BackgroundColor3 = State.Theme.Element,
            BorderSizePixel = 0,
            Text = "#8A2BE2",
            TextColor3 = State.Theme.Text,
            TextSize = 12,
            Font = Enum.Font.Code,
            ZIndex = 20,
            Parent = picker,
        })
        Round(hexBox, 6)
        
        hexBox.FocusLost:Connect(function()
            local hex = hexBox.Text:gsub("#", "")
            local ok, color = pcall(function()
                local r = tonumber(hex:sub(1,2), 16)/255
                local g = tonumber(hex:sub(3,4), 16)/255
                local b = tonumber(hex:sub(5,6), 16)/255
                return Color3.new(r, g, b)
            end)
            if ok and color then
                h, s, v = Color3.toHSV(color)
                updateFromHSV()
                hexBox.Text = "#" .. hex:upper()
            end
        end)
        
        -- تحديث hex عند التغيير
        local function updateHex()
            local r = math.floor(current.R * 255)
            local g = math.floor(current.G * 255)
            local b = math.floor(current.B * 255)
            hexBox.Text = string.format("#%02X%02X%02X", r, g, b)
        end
        -- نطبقها كل إطار
        RunService.RenderStepped:Connect(function()
            if isOpen then updateHex() end
        end)
        
        -- فتح/إغلاق
        BindInput(preview, function()
            isOpen = not isOpen
            Tween(picker, 0.25, { Size = UDim2.new(1, -8, 0, isOpen and 132 or 0) })
        end)
        
        State.Flags[flag] = def
        
        return {
            Set = function(c)
                current = c
                h, s, v = Color3.toHSV(c)
                preview.BackgroundColor3 = c
                satKnob.Position = UDim2.new(s, -3, -0.2, 0)
                briKnob.Position = UDim2.new(v, -3, -0.2, 0)
                hueKnob.Position = UDim2.new(h, -3, -0.2, 0)
                updateHex()
                State.Flags[flag] = c
                if cfg.Callback then cfg.Callback(c) end
            end,
            Get = function() return current end,
        }
    end
    
    -- ═══════════════════════════════════════════════════════════════
    -- Settings Panel
    -- ═══════════════════════════════════════════════════════════════
    function JackHub:ToggleSettings()
        State.SettingsOpen = not State.SettingsOpen
        
        if not State.SettingsPanel then
            local panel = Create("Frame", {
                Name = "SettingsPanel",
                Size = UDim2.new(1, -20, 1, -20),
                Position = UDim2.new(0, 10, 0, SIZES.TitleBarHeight + 10),
                BackgroundColor3 = State.Theme.Background,
                BorderSizePixel = 0,
                Visible = false,
                ZIndex = 50,
                Parent = mainFrame,
            })
            Round(panel, 12)
            Stroke(panel, State.Theme.Accent, 2, 0.3)
            panel:SetAttribute("ThemeColor", "Background")
            
            -- Header
            local header = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = State.Theme.Header,
                BorderSizePixel = 0,
                ZIndex = 51,
                Parent = panel,
            })
            Round(header, 12)
            Create("Frame", {
                Size = UDim2.new(1, 0, 0, 12),
                Position = UDim2.new(0, 0, 1, -12),
                BackgroundColor3 = State.Theme.Header,
                BorderSizePixel = 0,
                ZIndex = 51,
                Parent = header,
            })
            
            Create("TextLabel", {
                Size = UDim2.new(1, -50, 1, 0),
                Position = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Text = "⚙  الإعدادات",
                TextColor3 = State.Theme.Text,
                TextSize = 15,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 52,
                Parent = header,
            })
            
            local closeBtn = Create("TextButton", {
                Size = UDim2.new(0, 28, 0, 28),
                Position = UDim2.new(1, -36, 0.5, -14),
                BackgroundColor3 = State.Theme.Element,
                BorderSizePixel = 0,
                Text = "✕",
                TextColor3 = State.Theme.Text,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                ZIndex = 52,
                Parent = header,
            })
            Round(closeBtn, 6)
            BindInput(closeBtn, function()
                JackHub:ToggleSettings()
            end)
            
            -- Scroll للمحتوى
            local content = Create("ScrollingFrame", {
                Size = UDim2.new(1, -16, 1, -60),
                Position = UDim2.new(0, 8, 0, 52),
                BackgroundTransparency = 1,
                ScrollBarThickness = 4,
                ScrollBarImageColor3 = State.Theme.Accent,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ZIndex = 52,
                Parent = panel,
            })
            local cLayout = Instance.new("UIListLayout")
            cLayout.Padding = UDim.new(0, 8)
            cLayout.Parent = content
            Padding(content, 4)
            
            -- قسم: الثيمات
            local function settingsLabel(text)
                return Create("TextLabel", {
                    Size = UDim2.new(1, -8, 0, 22),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = State.Theme.Accent,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 53,
                    Parent = content,
                })
            end
            
            settingsLabel("🎨  الثيمات الجاهزة")
            
            local themeRow = Create("Frame", {
                Size = UDim2.new(1, -8, 0, 44),
                BackgroundTransparency = 1,
                ZIndex = 53,
                Parent = content,
            })
            local tLayout = Instance.new("UIListLayout")
            tLayout.FillDirection = Enum.FillDirection.Horizontal
            tLayout.Padding = UDim.new(0, 6)
            tLayout.Parent = themeRow
            
            for themeName, _ in pairs(Themes) do
                local tb = Create("TextButton", {
                    Size = UDim2.new(0, 78, 1, 0),
                    BackgroundColor3 = State.Theme.Element,
                    BorderSizePixel = 0,
                    Text = themeName,
                    TextColor3 = State.Theme.Text,
                    TextSize = 11,
                    Font = Enum.Font.Gotham,
                    ZIndex = 54,
                    Parent = themeRow,
                })
                Round(tb, 6)
                Stroke(tb, State.Theme.Outline, 1, 0.5)
                
                BindInput(tb, function()
                    JackHub:SetTheme(themeName)
                    JackHub:Notify("الثيم", "تم التغيير إلى: " .. themeName, 2, "Success")
                end)
            end
            
            settingsLabel("🎯  اللون الرئيسي")
            
            -- أزرار ألوان سريعة
            local colorRow = Create("Frame", {
                Size = UDim2.new(1, -8, 0, 36),
                BackgroundTransparency = 1,
                ZIndex = 53,
                Parent = content,
            })
            local colLayout = Instance.new("UIListLayout")
            colLayout.FillDirection = Enum.FillDirection.Horizontal
            colLayout.Padding = UDim.new(0, 6)
            colLayout.Parent = colorRow
            
            local quickColors = {
                Color3.fromRGB(138, 43, 226),
                Color3.fromRGB(230, 60, 60),
                Color3.fromRGB(0, 180, 255),
                Color3.fromRGB(60, 200, 100),
                Color3.fromRGB(240, 180, 50),
                Color3.fromRGB(255, 105, 180),
                Color3.fromRGB(120, 200, 255),
                Color3.fromRGB(255, 255, 255),
            }
            
            for _, c in ipairs(quickColors) do
                local cb = Create("TextButton", {
                    Size = UDim2.new(0, 30, 1, 0),
                    BackgroundColor3 = c,
                    BorderSizePixel = 0,
                    Text = "",
                    ZIndex = 54,
                    Parent = colorRow,
                })
                Round(cb, 15)
                BindInput(cb, function()
                    JackHub:SetAccentColor(c)
                end)
            end
            
            settingsLabel("🖼  الخلفية")
            
            -- Toggle إخفاء الخلفية
            local bgToggleFrame = Create("Frame", {
                Size = UDim2.new(1, -8, 0, 36),
                BackgroundColor3 = State.Theme.Element,
                BorderSizePixel = 0,
                ZIndex = 53,
                Parent = content,
            })
            Round(bgToggleFrame, 8)
            
            Create("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = "إظهار الخلفية الداكنة",
                TextColor3 = State.Theme.Text,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 54,
                Parent = bgToggleFrame,
            })
            
            local bgState = true
            local bgSw = Create("Frame", {
                Size = UDim2.new(0, 36, 0, 18),
                Position = UDim2.new(1, -46, 0.5, -9),
                BackgroundColor3 = State.Theme.ToggleOn,
                BorderSizePixel = 0,
                ZIndex = 54,
                Parent = bgToggleFrame,
            })
            Round(bgSw, 9)
            local bgKnob = Create("Frame", {
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(1, -16, 0.5, -7),
                BackgroundColor3 = Color3.new(1,1,1),
                BorderSizePixel = 0,
                ZIndex = 55,
                Parent = bgSw,
            })
            Round(bgKnob, 7)
            
            BindInput(bgToggleFrame, function()
                bgState = not bgState
                Tween(bgKnob, 0.15, { Position = bgState and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7) })
                Tween(bgSw, 0.15, { BackgroundColor3 = bgState and State.Theme.ToggleOn or State.Theme.ToggleOff })
                -- تطبيق على الخلفية
                if mainFrame:FindFirstChildOfClass("ImageLabel") then
                    mainFrame:FindFirstChildOfClass("ImageLabel").Visible = bgState
                end
            end)
            
            settingsLabel("⌨  اختصارات")
            
            Create("TextLabel", {
                Size = UDim2.new(1, -8, 0, 60),
                BackgroundColor3 = State.Theme.Element,
                Text = "  K  ←  إخفاء/إظهار الواجهة\n  M  ←  تصغير الواجهة\n  F  ←  ملء الشاشة",
                TextColor3 = State.Theme.Text,
                TextSize = 12,
                Font = Enum.Font.Code,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                ZIndex = 53,
                Parent = content,
            }).Name = "ShortcutsLabel"
            Round(content.ShortcutsLabel, 8)
            Padding(content.ShortcutsLabel, 8, 6, 6, 8, 8)
            
            settingsLabel("📁  الإعدادات المحفوظة")
            
            local configRow = Create("Frame", {
                Size = UDim2.new(1, -8, 0, 36),
                BackgroundTransparency = 1,
                ZIndex = 53,
                Parent = content,
            })
            local cfLayout = Instance.new("UIListLayout")
            cfLayout.FillDirection = Enum.FillDirection.Horizontal
            cfLayout.Padding = UDim.new(0, 6)
            cfLayout.Parent = configRow
            
            local saveBtn = Create("TextButton", {
                Size = UDim2.new(0.5, -3, 1, 0),
                BackgroundColor3 = State.Theme.Success,
                BorderSizePixel = 0,
                Text = "💾  حفظ",
                TextColor3 = Color3.new(1,1,1),
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                ZIndex = 54,
                Parent = configRow,
            })
            Round(saveBtn, 6)
            BindInput(saveBtn, function()
                SaveConfig(State.ConfigName, State.Flags)
                JackHub:Notify("حفظ", "تم حفظ الإعدادات!", 2, "Success")
            end)
            
            local loadBtn = Create("TextButton", {
                Size = UDim2.new(0.5, -3, 1, 0),
                BackgroundColor3 = State.Theme.Info,
                BorderSizePixel = 0,
                Text = "📂  تحميل",
                TextColor3 = Color3.new(1,1,1),
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                ZIndex = 54,
                Parent = configRow,
            })
            Round(loadBtn, 6)
            BindInput(loadBtn, function()
                local data = LoadConfig(State.ConfigName)
                if data then
                    for k, v in pairs(data) do
                        State.Flags[k] = v
                    end
                    JackHub:Notify("تحميل", "تم تحميل الإعدادات!", 2, "Success")
                else
                    JackHub:Notify("خطأ", "لا يوجد ملف محفوظ", 2, "Danger")
                end
            end)
            
            settingsLabel("⚠  منطقة الخطر")
            
            local dangerBtn = Create("TextButton", {
                Size = UDim2.new(1, -8, 0, 36),
                BackgroundColor3 = State.Theme.Danger,
                BorderSizePixel = 0,
                Text = "🗑  حذف الإعدادات المحفوظة",
                TextColor3 = Color3.new(1,1,1),
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                ZIndex = 54,
                Parent = content,
            })
            Round(dangerBtn, 6)
            BindInput(dangerBtn, function()
                pcall(function()
                    if delfile then
                        delfile(CONFIG_FOLDER .. "/" .. State.ConfigName .. ".json")
                    end
                end)
                JackHub:Notify("حذف", "تم حذف الإعدادات", 2, "Warning")
            end)
            
            State.SettingsPanel = panel
        end
        
        State.SettingsPanel.Visible = State.SettingsOpen
        if State.SettingsOpen then
            State.SettingsPanel.Size = UDim2.new(1, -20, 0, 10)
            Tween(State.SettingsPanel, 0.3, { Size = UDim2.new(1, -20, 1, -20) })
        end
    end
    
    -- ═══════════════════════════════════════════════════════════════
    -- Hide/Show/Minimize/Fullscreen
    -- ═══════════════════════════════════════════════════════════════
    function JackHub:ToggleUI()
        State.Hidden = not State.Hidden
        if State.Hidden then
            Tween(mainFrame, 0.3, { Position = UDim2.new(-1, -50, mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset) })
        else
            Tween(mainFrame, 0.3, { Position = UDim2.new(0.5, -SIZES.WindowWidth/2, 0.5, -SIZES.WindowHeight/2) })
        end
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
            Tween(mainFrame, 0.3, {
                Size = UDim2.new(0, workspace.CurrentCamera.ViewportSize.X - 40, 0, workspace.CurrentCamera.ViewportSize.Y - 40),
                Position = UDim2.new(0, 20, 0, 20),
            })
        else
            Tween(mainFrame, 0.3, {
                Size = UDim2.new(0, SIZES.WindowWidth, 0, SIZES.WindowHeight),
                Position = UDim2.new(0.5, -SIZES.WindowWidth/2, 0.5, -SIZES.WindowHeight/2),
            })
        end
    end
    
    function JackHub:Destroy()
        Tween(mainFrame, 0.3, { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.35)
        screenGui:Destroy()
    end
    
    -- ═══════════════════════════════════════════════════════════════
    -- اختصارات الكيبورد
    -- ═══════════════════════════════════════════════════════════════
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if input.KeyCode == Enum.KeyCode[toggleKey] then JackHub:ToggleUI()
        elseif input.KeyCode == Enum.KeyCode.M then JackHub:ToggleMinimize()
        elseif input.KeyCode == Enum.KeyCode.F then JackHub:ToggleFullscreen()
        end
    end)
    
    -- ═══════════════════════════════════════════════════════════════
    -- السحب (PC + Mobile)
    -- ═══════════════════════════════════════════════════════════════
    do
        local dragging = false
        local dragStart, startPos
        
        local function startDrag(input)
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
        
        local function updateDrag(input)
            if not dragging then return end
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
        
        local function endDrag()
            dragging = false
        end
        
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 
                or input.UserInputType == Enum.UserInputType.Touch then
                startDrag(input)
            end
        end)
        
        titleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement 
                or input.UserInputType == Enum.UserInputType.Touch then
                updateDrag(input)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement 
                or input.UserInputType == Enum.UserInputType.Touch) then
                updateDrag(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 
                or input.UserInputType == Enum.UserInputType.Touch then
                endDrag()
            end
        end)
    end
    
    -- ═══════════════════════════════════════════════════════════════
    -- إشعار بدء التشغيل
    -- ═══════════════════════════════════════════════════════════════
    task.wait(0.3)
    JackHub:Notify("JackHub", "تم تحميل المكتبة بنجاح! اضغط K للإخفاء", 4, "Success")
    
    return JackHub
end

-- ═══════════════════════════════════════════════════════════════
-- إرجاع المكتبة
-- ═══════════════════════════════════════════════════════════════
return JackHub
