--[[
    ============================================
    Library: RayLib (نسخة مخصصة)
    الوصف: مكتبة UI شبيهة بـ Rayfield مع تخصيصات متقدمة
    الميزات: Boot Screen, Key System, Tab مخصص, Color Picker,
             Settings Panel, Hide/Show UI, Minimize/Maximize
    ============================================
]]

local RayLib = {}
RayLib.__index = RayLib

-- ===== الخدمات الأساسية =====
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- ===== الثوابت =====
local LIBRARY_NAME = "RayLib"
local CONFIG_FOLDER = "RayLib/Configs"
local CONFIG_EXTENSION = ".json"

-- ===== الثيم الافتراضي =====
local DefaultTheme = {
    Background = Color3.fromRGB(25, 25, 30),
    Header = Color3.fromRGB(18, 18, 22),
    TabBar = Color3.fromRGB(20, 20, 25),
    Element = Color3.fromRGB(35, 35, 42),
    ElementHover = Color3.fromRGB(45, 45, 55),
    Accent = Color3.fromRGB(138, 43, 226),
    AccentHover = Color3.fromRGB(160, 70, 240),
    Text = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(150, 150, 160),
    Outline = Color3.fromRGB(60, 60, 70),
    ToggleOn = Color3.fromRGB(138, 43, 226),
    ToggleOff = Color3.fromRGB(50, 50, 60),
    SliderFill = Color3.fromRGB(138, 43, 226),
    SliderEmpty = Color3.fromRGB(50, 50, 60),
    KeySystemBG = Color3.fromRGB(20, 20, 25),
    BootBG = Color3.fromRGB(10, 10, 15),
}

-- ===== الثيمات الجاهزة =====
local Themes = {
    Default = DefaultTheme,
    Dark = {
        Background = Color3.fromRGB(15, 15, 18),
        Header = Color3.fromRGB(10, 10, 12),
        TabBar = Color3.fromRGB(12, 12, 15),
        Element = Color3.fromRGB(25, 25, 30),
        Accent = Color3.fromRGB(80, 80, 90),
        Text = Color3.fromRGB(220, 220, 220),
    },
    Blood = {
        Background = Color3.fromRGB(20, 10, 10),
        Header = Color3.fromRGB(15, 5, 5),
        TabBar = Color3.fromRGB(18, 8, 8),
        Element = Color3.fromRGB(35, 15, 15),
        Accent = Color3.fromRGB(227, 27, 27),
        Text = Color3.fromRGB(255, 220, 220),
    },
    Ocean = {
        Background = Color3.fromRGB(15, 25, 35),
        Header = Color3.fromRGB(10, 18, 28),
        TabBar = Color3.fromRGB(12, 20, 30),
        Element = Color3.fromRGB(25, 40, 55),
        Accent = Color3.fromRGB(0, 180, 255),
        Text = Color3.fromRGB(200, 230, 255),
    },
    Grape = {
        Background = Color3.fromRGB(30, 20, 40),
        Header = Color3.fromRGB(22, 14, 30),
        TabBar = Color3.fromRGB(25, 16, 35),
        Element = Color3.fromRGB(45, 30, 60),
        Accent = Color3.fromRGB(166, 71, 214),
        Text = Color3.fromRGB(230, 210, 255),
    },
    Midnight = {
        Background = Color3.fromRGB(12, 12, 20),
        Header = Color3.fromRGB(8, 8, 15),
        TabBar = Color3.fromRGB(10, 10, 18),
        Element = Color3.fromRGB(22, 22, 35),
        Accent = Color3.fromRGB(100, 80, 200),
        Text = Color3.fromRGB(200, 200, 230),
    },
}

-- ===== الحالة الداخلية =====
local State = {
    Theme = Themes.Default,
    Tabs = {},
    ActiveTab = nil,
    UIHidden = false,
    Minimized = false,
    SettingsOpen = false,
    BootComplete = false,
    KeyVerified = false,
    Window = nil,
    MainFrame = nil,
    TabContainer = nil,
    ContentFrame = nil,
    Notifications = {},
    Connections = {},
    ConfigData = {},
}

-- ===== دوال مساعدة =====

local function Create(className, props)
    local instance = Instance.new(className)
    for key, value in pairs(props) do
        instance[key] = value
    end
    return instance
end

local function Tween(instance, duration, props, style, direction)
    local info = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, info, props)
    tween:Play()
    return tween
end

local function Round(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = instance
    return corner
end

local function AddStroke(instance, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or State.Theme.Outline
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.5
    stroke.Parent = instance
    return stroke
end

local function AddGradient(instance, color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2),
    })
    gradient.Rotation = rotation or 0
    gradient.Parent = instance
    return gradient
end

local function Notify(title, message, duration)
    local notif = Create("Frame", {
        Name = "Notification",
        Size = UDim2.new(0, 300, 0, 80),
        Position = UDim2.new(1, -320, 0, 20 + (#State.Notifications * 90)),
        BackgroundColor3 = State.Theme.Element,
        BorderSizePixel = 0,
        ZIndex = 9999,
        Parent = State.Window and State.Window.ScreenGui or CoreGui,
    })
    Round(notif, 10)
    AddStroke(notif, State.Theme.Accent, 1, 0.3)
    
    local accentBar = Create("Frame", {
        Size = UDim2.new(0, 4, 1, -16),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = State.Theme.Accent,
        BorderSizePixel = 0,
        Parent = notif,
    })
    Round(accentBar, 2)
    
    local titleLabel = Create("TextLabel", {
        Size = UDim2.new(1, -40, 0, 24),
        Position = UDim2.new(0, 20, 0, 8),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = State.Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        Parent = notif,
    })
    
    local msgLabel = Create("TextLabel", {
        Size = UDim2.new(1, -40, 0, 36),
        Position = UDim2.new(0, 20, 0, 32),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = State.Theme.TextDim,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Font = Enum.Font.Gotham,
        Parent = notif,
    })
    
    table.insert(State.Notifications, notif)
    
    -- تأثير الدخول
    notif.Position = UDim2.new(1, 20, 0, 20 + (#State.Notifications - 1) * 90)
    Tween(notif, 0.4, { Position = UDim2.new(1, -320, 0, 20 + (#State.Notifications - 1) * 90) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    -- إزالة تلقائية
    task.delay(duration or 5, function()
        local idx = table.find(State.Notifications, notif)
        if idx then table.remove(State.Notifications, idx) end
        Tween(notif, 0.3, { Position = UDim2.new(1, 20, 0, notif.Position.Y.Offset) }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.wait(0.35)
        notif:Destroy()
    end)
end

local function SaveConfig(name, data)
    if not writefile then return end
    if not isfolder(CONFIG_FOLDER) then
        makefolder(CONFIG_FOLDER)
    end
    local success, err = pcall(function()
        writefile(CONFIG_FOLDER .. "/" .. name .. CONFIG_EXTENSION, HttpService:JSONEncode(data))
    end)
    if not success then
        warn("[RayLib] Failed to save config: " .. tostring(err))
    end
end

local function LoadConfig(name)
    if not readfile then return nil end
    local path = CONFIG_FOLDER .. "/" .. name .. CONFIG_EXTENSION
    if not isfile(path) then return nil end
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(path))
    end)
    if success then return data end
    return nil
end

-- ===== تطبيق الثيم على كل العناصر =====
local function ApplyTheme()
    local theme = State.Theme
    if not State.MainFrame then return end
    
    -- تحديث الإطارات الرئيسية
    for _, obj in ipairs(State.MainFrame:GetDescendants()) do
        if obj:GetAttribute("ThemeColor") then
            local colorKey = obj:GetAttribute("ThemeColor")
            if theme[colorKey] then
                if obj:IsA("Frame") or obj:IsA("TextButton") or obj:IsA("TextLabel") then
                    obj.BackgroundColor3 = theme[colorKey]
                end
            end
        end
        if obj:GetAttribute("ThemeText") then
            local colorKey = obj:GetAttribute("ThemeText")
            if theme[colorKey] then
                obj.TextColor3 = theme[colorKey]
            end
        end
        if obj:IsA("UIStroke") and obj:GetAttribute("ThemeStroke") then
            local colorKey = obj:GetAttribute("ThemeStroke")
            if theme[colorKey] then
                obj.Color = theme[colorKey]
            end
        end
    end
end

-- ===== إنشاء شاشة التحميل (Boot Screen) =====
local function CreateBootScreen(title, subtitle, bootType)
    local screenGui = Create("ScreenGui", {
        Name = "RayLib_Boot",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui,
    })
    
    local bg = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = State.Theme.BootBG,
        BorderSizePixel = 0,
        ZIndex = 1,
        Parent = screenGui,
    })
    
    -- تأثير تدرج الخلفية
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, State.Theme.BootBG),
        ColorSequenceKeypoint.new(0.5, State.Theme.Background),
        ColorSequenceKeypoint.new(1, State.Theme.BootBG),
    })
    gradient.Rotation = 45
    gradient.Parent = bg
    
    -- عنوان التحميل
    local titleLabel = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 60),
        Position = UDim2.new(0, 0, 0.4, -30),
        BackgroundTransparency = 1,
        Text = title or "RayLib",
        TextColor3 = State.Theme.Accent,
        TextSize = 42,
        Font = Enum.Font.GothamBold,
        TextScaled = false,
        ZIndex = 3,
        Parent = bg,
    })
    titleLabel.TextTransparency = 1
    
    local subtitleLabel = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0.4, 35),
        BackgroundTransparency = 1,
        Text = subtitle or "Loading...",
        TextColor3 = State.Theme.TextDim,
        TextSize = 16,
        Font = Enum.Font.Gotham,
        ZIndex = 3,
        Parent = bg,
    })
    subtitleLabel.TextTransparency = 1
    
    -- شريط التحميل
    local progressBg = Create("Frame", {
        Size = UDim2.new(0, 300, 0, 6),
        Position = UDim2.new(0.5, -150, 0.55, 0),
        BackgroundColor3 = State.Theme.Element,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = bg,
    })
    Round(progressBg, 3)
    
    local progressFill = Create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = State.Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 4,
        Parent = progressBg,
    })
    Round(progressFill, 3)
    
    -- تأثيرات Boot حسب النوع
    if bootType == "X" then
        -- تأثير X: خطوط متقاطعة
        local line1 = Create("Frame", {
            Size = UDim2.new(0, 80, 0, 3),
            Position = UDim2.new(0.5, -40, 0.35, 0),
            BackgroundColor3 = State.Theme.Accent,
            BorderSizePixel = 0,
            Rotation = 45,
            ZIndex = 5,
            Parent = bg,
        })
        local line2 = Create("Frame", {
            Size = UDim2.new(0, 80, 0, 3),
            Position = UDim2.new(0.5, -40, 0.35, 0),
            BackgroundColor3 = State.Theme.Accent,
            BorderSizePixel = 0,
            Rotation = -45,
            ZIndex = 5,
            Parent = bg,
        })
        line1.Size = UDim2.new(0, 0, 0, 3)
        line2.Size = UDim2.new(0, 0, 0, 3)
        Tween(line1, 0.6, { Size = UDim2.new(0, 80, 0, 3) })
        Tween(line2, 0.6, { Size = UDim2.new(0, 80, 0, 3) })
        
    elseif bootType == "XP" then
        -- تأثير XP: نبضات
        local pulse = Create("Frame", {
            Size = UDim2.new(0, 100, 0, 100),
            Position = UDim2.new(0.5, -50, 0.35, -50),
            BackgroundColor3 = State.Theme.Accent,
            BackgroundTransparency = 0.8,
            BorderSizePixel = 0,
            ZIndex = 2,
            Parent = bg,
        })
        Round(pulse, 50)
        Tween(pulse, 1, { Size = UDim2.new(0, 200, 0, 200), Position = UDim2.new(0.5, -100, 0.35, -100), BackgroundTransparency = 1 })
        
    elseif bootType == "XPRO" then
        -- تأثير XPRO: تدرج متحرك + خطوط
        local proGradient = Instance.new("UIGradient")
        proGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, State.Theme.Accent),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, State.Theme.Accent),
        })
        proGradient.Parent = progressFill
        
        local proLine = Create("Frame", {
            Size = UDim2.new(0, 0, 0, 2),
            Position = UDim2.new(0, 0, 0.3, 0),
            BackgroundColor3 = State.Theme.Accent,
            BorderSizePixel = 0,
            ZIndex = 5,
            Parent = bg,
        })
        Tween(proLine, 1.5, { Size = UDim2.new(1, 0, 0, 2) })
    end
    
    -- أنيميشن الظهور
    Tween(titleLabel, 0.8, { TextTransparency = 0 })
    Tween(subtitleLabel, 0.8, { TextTransparency = 0 })
    
    -- شريط التحميل
    local loadDuration = 3
    Tween(progressFill, loadDuration, { Size = UDim2.new(1, 0, 1, 0) }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    task.wait(loadDuration + 0.5)
    
    -- إغلاق شاشة التحميل
    Tween(bg, 0.5, { BackgroundTransparency = 1 })
    Tween(titleLabel, 0.3, { TextTransparency = 1 })
    Tween(subtitleLabel, 0.3, { TextTransparency = 1 })
    task.wait(0.6)
    screenGui:Destroy()
    State.BootComplete = true
end

-- ===== نظام المفاتيح (Key System) =====
local function CreateKeySystem(config)
    config = config or {}
    
    local title = config.Title or "Key System"
    local subtitle = config.Subtitle or "Enter your key to continue"
    local note = config.Note or "No key provided"
    local keys = config.Key or {"default"}
    local saveKey = config.SaveKey ~= false
    local keyFileName = config.FileName or "Key"
    local grabFromSite = config.GrabKeyFromSite or false
    local keyURL = config.KeyURL or ""
    
    -- إذا كانت المفاتيح موجودة ومحفوظة مسبقاً
    if saveKey and readfile and isfile then
        local savedKey = nil
        pcall(function()
            savedKey = readfile(LIBRARY_NAME .. "/" .. keyFileName .. ".key")
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
    
    -- جلب المفاتيح من موقع خارجي
    if grabFromSite and keyURL ~= "" then
        local success, fetched = pcall(function()
            return game:HttpGet(keyURL)
        end)
        if success and fetched then
            for line in fetched:gmatch("[^\r\n]+") do
                table.insert(keys, line)
            end
        end
    end
    
    -- إنشاء واجهة Key System
    local screenGui = Create("ScreenGui", {
        Name = "RayLib_KeySystem",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui,
    })
    
    local bg = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = 1,
        Parent = screenGui,
    })
    
    local main = Create("Frame", {
        Size = UDim2.new(0, 420, 0, 320),
        Position = UDim2.new(0.5, -210, 0.5, -160),
        BackgroundColor3 = State.Theme.KeySystemBG,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = bg,
    })
    Round(main, 14)
    AddStroke(main, State.Theme.Accent, 1, 0.3)
    
    -- شريط علوي
    local topBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = State.Theme.Header,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = main,
    })
    Round(topBar, 14)
    local topBarFix = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 1, -14),
        BackgroundColor3 = State.Theme.Header,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = topBar,
    })
    
    local keyTitle = Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 26),
        Position = UDim2.new(0, 14, 0, 5),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = State.Theme.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4,
        Parent = topBar,
    })
    
    local keySubtitle = Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 16),
        Position = UDim2.new(0, 14, 0, 28),
        BackgroundTransparency = 1,
        Text = subtitle,
        TextColor3 = State.Theme.TextDim,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4,
        Parent = topBar,
    })
    
    -- إضافة تبويبات (Tabs) في Key System
    local keyTabsContainer = Create("Frame", {
        Size = UDim2.new(1, -28, 0, 30),
        Position = UDim2.new(0, 14, 0, 60),
        BackgroundTransparency = 1,
        ZIndex = 4,
        Parent = main,
    })
    
    local keyTabsLayout = Instance.new("UIListLayout")
    keyTabsLayout.FillDirection = Enum.FillDirection.Horizontal
    keyTabsLayout.Padding = UDim.new(0, 8)
    keyTabsLayout.Parent = keyTabsContainer
    
    -- تبويب المفتاح الافتراضي
    local keyTab = Create("TextButton", {
        Size = UDim2.new(0, 100, 1, 0),
        BackgroundColor3 = State.Theme.Accent,
        BorderSizePixel = 0,
        Text = "المفتاح",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        ZIndex = 5,
        Parent = keyTabsContainer,
    })
    Round(keyTab, 6)
    
    -- إضافة تبويبات إضافية من الإعدادات
    local additionalTabs = config.AdditionalTabs or {}
    for _, tabData in ipairs(additionalTabs) do
        local tabBtn = Create("TextButton", {
            Size = UDim2.new(0, 100, 1, 0),
            BackgroundColor3 = State.Theme.Element,
            BorderSizePixel = 0,
            Text = tabData.Name or "Tab",
            TextColor3 = State.Theme.TextDim,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            ZIndex = 5,
            Parent = keyTabsContainer,
        })
        Round(tabBtn, 6)
        
        tabBtn.MouseButton1Click:Connect(function()
            -- إظهار محتوى التبويب الإضافي
            if tabData.Content then
                for _, child in ipairs(main:GetChildren()) do
                    if child:IsA("Frame") and child:GetAttribute("KeyContent") then
                        child.Visible = false
                    end
                end
                local content = Create("Frame", {
                    Size = UDim2.new(1, -28, 0, 180),
                    Position = UDim2.new(0, 14, 0, 100),
                    BackgroundTransparency = 1,
                    ZIndex = 4,
                    Parent = main,
                })
                content:SetAttribute("KeyContent", true)
                tabData.Content(content)
            end
        end)
    end
    
    -- حقل إدخال المفتاح
    local inputFrame = Create("Frame", {
        Size = UDim2.new(1, -28, 0, 44),
        Position = UDim2.new(0, 14, 0, 105),
        BackgroundColor3 = State.Theme.Element,
        BorderSizePixel = 0,
        ZIndex = 4,
        Parent = main,
    })
    Round(inputFrame, 8)
    AddStroke(inputFrame, State.Theme.Outline, 1, 0.5)
    
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
        ZIndex = 5,
        Parent = inputFrame,
    })
    
    -- زر التفعيل
    local submitBtn = Create("TextButton", {
        Size = UDim2.new(1, -28, 0, 40),
        Position = UDim2.new(0, 14, 0, 160),
        BackgroundColor3 = State.Theme.Accent,
        BorderSizePixel = 0,
        Text = "تفعيل",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        ZIndex = 4,
        Parent = main,
    })
    Round(submitBtn, 8)
    
    -- ملاحظة
    local noteLabel = Create("TextLabel", {
        Size = UDim2.new(1, -28, 0, 30),
        Position = UDim2.new(0, 14, 0, 210),
        BackgroundTransparency = 1,
        Text = note,
        TextColor3 = State.Theme.TextDim,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        ZIndex = 4,
        Parent = main,
    })
    
    -- حالة المفتاح
    local statusLabel = Create("TextLabel", {
        Size = UDim2.new(1, -28, 0, 20),
        Position = UDim2.new(0, 14, 0, 250),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Color3.fromRGB(255, 80, 80),
        TextSize = 12,
        Font = Enum.Font.Gotham,
        ZIndex = 4,
        Parent = main,
    })
    
    -- منطق التحقق
    local function verifyKey()
        local enteredKey = keyInput.Text
        if enteredKey == "" then
            statusLabel.Text = "الرجاء إدخال المفتاح"
            return
        end
        
        local valid = false
        for _, k in ipairs(keys) do
            if enteredKey == k then
                valid = true
                break
            end
        end
        
        if valid then
            statusLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
            statusLabel.Text = "تم التفعيل بنجاح!"
            State.KeyVerified = true
            
            if saveKey and writefile and isfolder then
                pcall(function()
                    if not isfolder(LIBRARY_NAME) then makefolder(LIBRARY_NAME) end
                    writefile(LIBRARY_NAME .. "/" .. keyFileName .. ".key", enteredKey)
                end)
            end
            
            task.wait(0.8)
            Tween(bg, 0.4, { BackgroundTransparency = 1 })
            Tween(main, 0.4, { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) })
            task.wait(0.5)
            screenGui:Destroy()
        else
            statusLabel.Text = "المفتاح غير صحيح!"
            keyInput.Text = ""
        end
    end
    
    submitBtn.MouseButton1Click:Connect(verifyKey)
    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then verifyKey() end
    end)
    
    -- انتظار التحقق
    while not State.KeyVerified do
        task.wait(0.1)
    end
    
    return true
end

-- ===== إنشاء النافذة الرئيسية =====
function RayLib:CreateWindow(config)
    config = config or {}
    
    local windowName = config.Name or "RayLib Window"
    local loadingTitle = config.LoadingTitle or windowName
    local loadingSubtitle = config.LoadingSubtitle or "Loading..."
    local bootType = config.BootType or "XPRO" -- "X", "XP", "XPRO"
    local themeName = config.Theme or "Default"
    local toggleKey = config.ToggleUIKeybind or "K"
    local keySystem = config.KeySystem or false
    local keySettings = config.KeySettings or {}
    local minimizeButton = config.MinimizeButton ~= false
    local hideButton = config.HideButton ~= false
    local settingsButton = config.SettingsButton ~= false
    local backgroundImage = config.BackgroundImage or nil
    local bootBackground = config.BootBackground or nil
    
    -- تعيين الثيم
    if Themes[themeName] then
        State.Theme = Themes[themeName]
    else
        for k, v in pairs(themeName) do
            if type(v) == "Color3" then
                State.Theme[k] = v
            end
        end
    end
    
    -- شاشة التحميل
    if config.BootScreen ~= false then
        CreateBootScreen(loadingTitle, loadingSubtitle, bootType)
    end
    
    -- نظام المفاتيح
    if keySystem then
        CreateKeySystem(keySettings)
    end
    
    -- إنشاء واجهة المستخدم
    local screenGui = Create("ScreenGui", {
        Name = "RayLib_UI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui,
    })
    
    -- إطار رئيسي
    local mainFrame = Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 600, 0, 420),
        Position = UDim2.new(0.5, -300, 0.5, -210),
        BackgroundColor3 = State.Theme.Background,
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = screenGui,
    })
    Round(mainFrame, 12)
    AddStroke(mainFrame, State.Theme.Outline, 1, 0.6)
    
    State.MainFrame = mainFrame
    State.Window = { ScreenGui = screenGui, MainFrame = mainFrame }
    
    -- خلفية مخصصة
    if backgroundImage then
        local bgImage = Create("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = backgroundImage,
            ImageTransparency = 0.85,
            ZIndex = 1,
            Parent = mainFrame,
        })
        Round(bgImage, 12)
    end
    
    -- شريط العنوان
    local titleBar = Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = State.Theme.Header,
        BorderSizePixel = 0,
        ZIndex = 11,
        Parent = mainFrame,
    })
    Round(titleBar, 12)
    local titleBarFix = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = State.Theme.Header,
        BorderSizePixel = 0,
        ZIndex = 11,
        Parent = titleBar,
    })
    
    -- اسم السكربت
    local titleLabel = Create("TextLabel", {
        Size = UDim2.new(1, -200, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        Text = windowName,
        TextColor3 = State.Theme.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 12,
        Parent = titleBar,
    })
    
    -- أزرار الشريط العلوي
    local buttonContainer = Create("Frame", {
        Size = UDim2.new(0, 120, 1, 0),
        Position = UDim2.new(1, -120, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = 12,
        Parent = titleBar,
    })
    
    local btnLayout = Instance.new("UIListLayout")
    btnLayout.FillDirection = Enum.FillDirection.Horizontal
    btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    btnLayout.Padding = UDim.new(0, 4)
    btnLayout.Parent = buttonContainer
    
    -- دالة مساعدة لإنشاء أزرار الشريط
    local function createTitleButton(text, callback, isClose)
        local btn = Create("TextButton", {
            Size = UDim2.new(0, 28, 0, 28),
            BackgroundColor3 = State.Theme.Element,
            BorderSizePixel = 0,
            Text = text,
            TextColor3 = State.Theme.Text,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            ZIndex = 13,
            Parent = buttonContainer,
        })
        Round(btn, 6)
        
        btn.MouseEnter:Connect(function()
            Tween(btn, 0.15, { BackgroundColor3 = isClose and Color3.fromRGB(220, 50, 50) or State.Theme.Accent })
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, 0.15, { BackgroundColor3 = State.Theme.Element })
        end)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end
    
    -- زر التصغير
    if minimizeButton then
        createTitleButton("─", function()
            State.Minimized = not State.Minimized
            if State.Minimized then
                Tween(mainFrame, 0.3, { Size = UDim2.new(0, 600, 0, 44) }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            else
                Tween(mainFrame, 0.3, { Size = UDim2.new(0, 600, 0, 420) }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            end
        end)
    end
    
    -- زر الإخفاء/الإظهار
    if hideButton then
        local hideBtn = createTitleButton("◉", function()
            State.UIHidden = not State.UIHidden
            Tween(mainFrame, 0.3, { BackgroundTransparency = State.UIHidden and 1 or 0 }, Enum.EasingStyle.Quad)
            for _, child in ipairs(mainFrame:GetChildren()) do
                if child:IsA("GuiObject") and child.Name ~= "TitleBar" then
                    Tween(child, 0.3, { BackgroundTransparency = State.UIHidden and 1 or child:GetAttribute("OrigTransparency") or 0 })
                end
            end
        end)
    end
    
    -- زر الإعدادات
    if settingsButton then
        createTitleButton("⚙", function()
            State.SettingsOpen = not State.SettingsOpen
            -- سيتم تنفيذ منطق الإعدادات لاحقاً
            Notify("الإعدادات", State.SettingsOpen and "تم فتح الإعدادات" or "تم إغلاق الإعدادات", 2)
        end)
    end
    
    -- زر الإغلاق
    createTitleButton("✕", function()
        Tween(mainFrame, 0.3, { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.35)
        screenGui:Destroy()
    end, true)
    
    -- منطقة التبويبات
    local tabBar = Create("Frame", {
        Name = "TabBar",
        Size = UDim2.new(0, 150, 1, -44),
        Position = UDim2.new(0, 0, 0, 44),
        BackgroundColor3 = State.Theme.TabBar,
        BorderSizePixel = 0,
        ZIndex = 11,
        Parent = mainFrame,
    })
    
    local tabScroll = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = State.Theme.Accent,
        ZIndex = 12,
        Parent = tabBar,
    })
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.Parent = tabScroll
    
    -- منطقة المحتوى
    local contentFrame = Create("Frame", {
        Name = "ContentFrame",
        Size = UDim2.new(1, -150, 1, -44),
        Position = UDim2.new(0, 150, 0, 44),
        BackgroundTransparency = 1,
        ZIndex = 11,
        Parent = mainFrame,
    })
    
    State.ContentFrame = contentFrame
    State.TabContainer = tabScroll
    
    -- دالة إنشاء التبويبات
    function RayLib:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"
        local tabIcon = tabConfig.Icon or nil
        local tabPosition = tabConfig.Position or "Top" -- "Top" أو "Side"
        
        -- زر التبويب
        local tabBtn = Create("TextButton", {
            Size = UDim2.new(1, -8, 0, 36),
            BackgroundColor3 = State.Theme.Element,
            BorderSizePixel = 0,
            Text = "  " .. (tabIcon and tabIcon .. "  " or "") .. tabName,
            TextColor3 = State.Theme.TextDim,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 13,
            Parent = tabScroll,
        })
        Round(tabBtn, 6)
        tabBtn:SetAttribute("ThemeColor", "Element")
        tabBtn:SetAttribute("ThemeText", "TextDim")
        
        -- إطار المحتوى
        local tabContent = Create("Frame", {
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            Visible = false,
            ZIndex = 12,
            Parent = contentFrame,
        })
        
        local contentScroll = Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = State.Theme.Accent,
            ZIndex = 13,
            Parent = tabContent,
        })
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 6)
        contentLayout.Parent = contentScroll
        
        local tabData = {
            Button = tabBtn,
            Content = tabContent,
            ContentScroll = contentScroll,
            ContentLayout = contentLayout,
            Name = tabName,
            Position = tabPosition,
        }
        
        table.insert(State.Tabs, tabData)
        
        -- أحداث التبويب
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
        tabBtn.MouseButton1Click:Connect(function()
            RayLib:SelectTab(tabData)
        end)
        
        -- إذا كان أول تبويب، يتم تحديده
        if #State.Tabs == 1 then
            RayLib:SelectTab(tabData)
        end
        
        return tabData
    end
    
    -- دالة تحديد التبويب
    function RayLib:SelectTab(tabData)
        State.ActiveTab = tabData
        
        for _, tab in ipairs(State.Tabs) do
            if tab == tabData then
                Tween(tab.Button, 0.2, { BackgroundColor3 = State.Theme.Accent })
                tab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                tab.Content.Visible = true
                -- أنيميشن الدخول
                tab.Content.Position = UDim2.new(0, 10, 0, 10)
                Tween(tab.Content, 0.25, { Position = UDim2.new(0, 0, 0, 0) })
            else
                Tween(tab.Button, 0.2, { BackgroundColor3 = State.Theme.Element })
                tab.Button.TextColor3 = State.Theme.TextDim
                tab.Content.Visible = false
            end
        end
    end
    
    -- ===== عناصر UI =====
    
    -- زر عادي
    function RayLib:AddButton(tabData, buttonConfig)
        buttonConfig = buttonConfig or {}
        local btnName = buttonConfig.Name or "Button"
        local callback = buttonConfig.Callback or function() end
        
        local btn = Create("TextButton", {
            Size = UDim2.new(1, -8, 0, 36),
            BackgroundColor3 = State.Theme.Element,
            BorderSizePixel = 0,
            Text = btnName,
            TextColor3 = State.Theme.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            ZIndex = 14,
            Parent = tabData.ContentScroll,
        })
        Round(btn, 6)
        AddStroke(btn, State.Theme.Outline, 1, 0.6)
        btn:SetAttribute("ThemeColor", "Element")
        btn:SetAttribute("ThemeText", "Text")
        
        btn.MouseEnter:Connect(function()
            Tween(btn, 0.15, { BackgroundColor3 = State.Theme.ElementHover })
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, 0.15, { BackgroundColor3 = State.Theme.Element })
        end)
        btn.MouseButton1Click:Connect(function()
            -- تأثير الضغط
            Tween(btn, 0.1, { Size = UDim2.new(0.98, -8, 0, 34) })
            task.wait(0.1)
            Tween(btn, 0.1, { Size = UDim2.new(1, -8, 0, 36) })
            callback()
        end)
        
        return btn
    end
    
    -- Toggle مع قائمة ألوان
    function RayLib:AddToggle(tabData, toggleConfig)
        toggleConfig = toggleConfig or {}
        local toggleName = toggleConfig.Name or "Toggle"
        local default = toggleConfig.Default or false
        local callback = toggleConfig.Callback or function() end
        local enableColorPicker = toggleConfig.ColorPicker or false
        
        local toggleFrame = Create("Frame", {
            Size = UDim2.new(1, -8, 0, 36),
            BackgroundColor3 = State.Theme.Element,
            BorderSizePixel = 0,
            ZIndex = 14,
            Parent = tabData.ContentScroll,
        })
        Round(toggleFrame, 6)
        toggleFrame:SetAttribute("ThemeColor", "Element")
        
        local nameLabel = Create("TextLabel", {
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = toggleName,
            TextColor3 = State.Theme.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 15,
            Parent = toggleFrame,
        })
        nameLabel:SetAttribute("ThemeText", "Text")
        
        -- مؤشر Toggle
        local toggleBg = Create("Frame", {
            Size = UDim2.new(0, 40, 0, 20),
            Position = UDim2.new(1, -50, 0.5, -10),
            BackgroundColor3 = default and State.Theme.ToggleOn or State.Theme.ToggleOff,
            BorderSizePixel = 0,
            ZIndex = 15,
            Parent = toggleFrame,
        })
        Round(toggleBg, 10)
        
        local toggleKnob = Create("Frame", {
            Size = UDim2.new(0, 16, 0, 16),
            Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            ZIndex = 16,
            Parent = toggleBg,
        })
        Round(toggleKnob, 8)
        
        local isOn = default
        local colorPickerFrame = nil
        
        -- إنشاء Color Picker إذا كان مطلوباً
        if enableColorPicker then
            colorPickerFrame = Create("Frame", {
                Size = UDim2.new(1, -8, 0, 60),
                BackgroundColor3 = State.Theme.Element,
                BorderSizePixel = 0,
                Visible = false,
                ZIndex = 14,
                Parent = tabData.ContentScroll,
            })
            Round(colorPickerFrame, 6)
            
            -- أزرار الألوان
            local colors = {
                {Color3.fromRGB(138, 43, 226), "بنفسجي"},
                {Color3.fromRGB(227, 27, 27), "أحمر"},
                {Color3.fromRGB(0, 180, 255), "أزرق"},
                {Color3.fromRGB(50, 205, 50), "أخضر"},
                {Color3.fromRGB(255, 165, 0), "برتقالي"},
                {Color3.fromRGB(255, 105, 180), "وردي"},
            }
            
            local colorLayout = Instance.new("UIListLayout")
            colorLayout.FillDirection = Enum.FillDirection.Horizontal
            colorLayout.Padding = UDim.new(0, 6)
            colorLayout.Parent = colorPickerFrame
            
            for _, colorData in ipairs(colors) do
                local colorBtn = Create("TextButton", {
                    Size = UDim2.new(0, 30, 0, 30),
                    BackgroundColor3 = colorData[1],
                    BorderSizePixel = 0,
                    Text = "",
                    ZIndex = 15,
                    Parent = colorPickerFrame,
                })
                Round(colorBtn, 15)
                
                colorBtn.MouseButton1Click:Connect(function()
                    State.Theme.Accent = colorData[1]
                    State.Theme.ToggleOn = colorData[1]
                    State.Theme.SliderFill = colorData[1]
                    ApplyTheme()
                end)
            end
        end
        
        -- منطق Toggle
        local function setToggle(value)
            isOn = value
            local targetPos = isOn and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            local targetColor = isOn and State.Theme.ToggleOn or State.Theme.ToggleOff
            
            Tween(toggleKnob, 0.2, { Position = targetPos }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            Tween(toggleBg, 0.2, { BackgroundColor3 = targetColor })
            
            if colorPickerFrame then
                colorPickerFrame.Visible = isOn
            end
            
            callback(isOn)
        end
        
        toggleFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                setToggle(not isOn)
            end
        end)
        
        return {
            Set = setToggle,
            Get = function() return isOn end,
        }
    end
    
    -- Slider
    function RayLib:AddSlider(tabData, sliderConfig)
        sliderConfig = sliderConfig or {}
        local sliderName = sliderConfig.Name or "Slider"
        local min = sliderConfig.Min or 0
        local max = sliderConfig.Max or 100
        local default = sliderConfig.Default or min
        local callback = sliderConfig.Callback or function() end
        
        local sliderFrame = Create("Frame", {
            Size = UDim2.new(1, -8, 0, 56),
            BackgroundColor3 = State.Theme.Element,
            BorderSizePixel = 0,
            ZIndex = 14,
            Parent = tabData.ContentScroll,
        })
        Round(sliderFrame, 6)
        sliderFrame:SetAttribute("ThemeColor", "Element")
        
        local nameLabel = Create("TextLabel", {
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 10, 0, 4),
            BackgroundTransparency = 1,
            Text = sliderName,
            TextColor3 = State.Theme.Text,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 15,
            Parent = sliderFrame,
        })
        
        local valueLabel = Create("TextLabel", {
            Size = UDim2.new(0, 40, 0, 20),
            Position = UDim2.new(1, -50, 0, 4),
            BackgroundTransparency = 1,
            Text = tostring(default),
            TextColor3 = State.Theme.Accent,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            ZIndex = 15,
            Parent = sliderFrame,
        })
        
        local sliderBg = Create("Frame", {
            Size = UDim2.new(1, -20, 0, 6),
            Position = UDim2.new(0, 10, 0, 32),
            BackgroundColor3 = State.Theme.SliderEmpty,
            BorderSizePixel = 0,
            ZIndex = 15,
            Parent = sliderFrame,
        })
        Round(sliderBg, 3)
        
        local sliderFill = Create("Frame", {
            Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
            BackgroundColor3 = State.Theme.SliderFill,
            BorderSizePixel = 0,
            ZIndex = 16,
            Parent = sliderBg,
        })
        Round(sliderFill, 3)
        
        local sliderKnob = Create("Frame", {
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            ZIndex = 17,
            Parent = sliderBg,
        })
        Round(sliderKnob, 7)
        
        local currentValue = default
        local dragging = false
        
        local function updateSlider(input)
            local mouseX = input.Position.X
            local sliderAbsPos = sliderBg.AbsolutePosition.X
            local sliderWidth = sliderBg.AbsoluteSize.X
            local relativeX = math.clamp((mouseX - sliderAbsPos) / sliderWidth, 0, 1)
            currentValue = math.floor(min + (max - min) * relativeX)
            valueLabel.Text = tostring(currentValue)
            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            sliderKnob.Position = UDim2.new(relativeX, -7, 0.5, -7)
            callback(currentValue)
        end
        
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateSlider(input)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        return {
            Set = function(value)
                currentValue = math.clamp(value, min, max)
                local relativeX = (currentValue - min) / (max - min)
                valueLabel.Text = tostring(currentValue)
                sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                sliderKnob.Position = UDim2.new(relativeX, -7, 0.5, -7)
                callback(currentValue)
            end,
            Get = function() return currentValue end,
        }
    end
    
    -- Dropdown
    function RayLib:AddDropdown(tabData, dropdownConfig)
        dropdownConfig = dropdownConfig or {}
        local dropdownName = dropdownConfig.Name or "Dropdown"
        local options = dropdownConfig.Options or {}
        local callback = dropdownConfig.Callback or function() end
        
        local dropdownFrame = Create("Frame", {
            Size = UDim2.new(1, -8, 0, 36),
            BackgroundColor3 = State.Theme.Element,
            BorderSizePixel = 0,
            ZIndex = 14,
            Parent = tabData.ContentScroll,
        })
        Round(dropdownFrame, 6)
        
        local nameLabel = Create("TextLabel", {
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = dropdownName,
            TextColor3 = State.Theme.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 15,
            Parent = dropdownFrame,
        })
        
        local arrow = Create("TextLabel", {
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(1, -30, 0, 0),
            BackgroundTransparency = 1,
            Text = "▼",
            TextColor3 = State.Theme.TextDim,
            TextSize = 10,
            ZIndex = 15,
            Parent = dropdownFrame,
        })
        
        local optionList = Create("Frame", {
            Size = UDim2.new(1, -8, 0, 0),
            Position = UDim2.new(0, 0, 1, 4),
            BackgroundColor3 = State.Theme.Element,
            BorderSizePixel = 0,
            Visible = false,
            ClipsDescendants = true,
            ZIndex = 20,
            Parent = dropdownFrame,
        })
        Round(optionList, 6)
        
        local optionLayout = Instance.new("UIListLayout")
        optionLayout.Padding = UDim.new(0, 2)
        optionLayout.Parent = optionList
        
        local isOpen = false
        local selectedValue = nil
        
        local function toggleDropdown()
            isOpen = not isOpen
            optionList.Visible = isOpen
            local targetHeight = isOpen and (#options * 32) or 0
            Tween(optionList, 0.2, { Size = UDim2.new(1, -8, 0, targetHeight) })
            arrow.Text = isOpen and "▲" or "▼"
        end
        
        for _, option in ipairs(options) do
            local optBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = State.Theme.Element,
                BorderSizePixel = 0,
                Text = tostring(option),
                TextColor3 = State.Theme.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                ZIndex = 21,
                Parent = optionList,
            })
            
            optBtn.MouseEnter:Connect(function()
                optBtn.BackgroundColor3 = State.Theme.ElementHover
            end)
            optBtn.MouseLeave:Connect(function()
                optBtn.BackgroundColor3 = State.Theme.Element
            end)
            optBtn.MouseButton1Click:Connect(function()
                selectedValue = option
                nameLabel.Text = dropdownName .. ": " .. tostring(option)
                toggleDropdown()
                callback(option)
            end)
        end
        
        dropdownFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                toggleDropdown()
            end
        end)
        
        return {
            Set = function(value)
                selectedValue = value
                nameLabel.Text = dropdownName .. ": " .. tostring(value)
                callback(value)
            end,
            Get = function() return selectedValue end,
        }
    end
    
    -- دالة تحديث الثيم
    function RayLib:SetTheme(themeNameOrTable)
        if type(themeNameOrTable) == "string" and Themes[themeNameOrTable] then
            State.Theme = Themes[themeNameOrTable]
        elseif type(themeNameOrTable) == "table" then
            for k, v in pairs(themeNameOrTable) do
                State.Theme[k] = v
            end
        end
        ApplyTheme()
    end
    
    -- دالة إخفاء/إظهار الواجهة
    function RayLib:ToggleUI()
        State.UIHidden = not State.UIHidden
        if State.UIHidden then
            Tween(mainFrame, 0.3, { BackgroundTransparency = 1 })
            for _, child in ipairs(mainFrame:GetChildren()) do
                if child:IsA("GuiObject") and child.Name ~= "TitleBar" then
                    Tween(child, 0.3, { BackgroundTransparency = 1 })
                end
            end
        else
            Tween(mainFrame, 0.3, { BackgroundTransparency = 0 })
            for _, child in ipairs(mainFrame:GetChildren()) do
                if child:IsA("GuiObject") and child.Name ~= "TitleBar" then
                    Tween(child, 0.3, { BackgroundTransparency = child:GetAttribute("OrigTransparency") or 0 })
                end
            end
        end
    end
    
    -- دالة التصغير/التكبير
    function RayLib:ToggleMinimize()
        State.Minimized = not State.Minimized
        if State.Minimized then
            Tween(mainFrame, 0.3, { Size = UDim2.new(0, 600, 0, 44) }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        else
            Tween(mainFrame, 0.3, { Size = UDim2.new(0, 600, 0, 420) }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end
    end
    
    -- دالة إغلاق الواجهة
    function RayLib:Destroy()
        if State.Window and State.Window.ScreenGui then
            State.Window.ScreenGui:Destroy()
        end
    end
    
    -- ربط مفتاح التبديل
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode[toggleKey] then
            RayLib:ToggleUI()
        end
    end)
    
    -- سحب النافذة
    local dragging = false
    local dragInput, dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
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
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    return RayLib
end

return RayLib
