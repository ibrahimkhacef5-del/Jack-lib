# Jack-lib
```
https//:Instagram.com/uzcawe
```

# 📖 JackHub Library v3.0

> مكتبة UI احترافية لـ Roblox — تدعم **PC** و **Mobile** تلقائياً

![Version](https://img.shields.io/badge/version-3.0-blue)
![Platform](https://img.shields.io/badge/platform-Roblox-red)
![Status](https://img.shields.io/badge/status-stable-green)

---

## 📥 التثبيت

```lua
local JackHub = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/ibrahimkhacef5-del/Jack-lib/refs/heads/main/Jack6.luau"
))()
```

---

## 🚀 البداية السريعة

```lua
-- 1. تحميل المكتبة
local JackHub = loadstring(game:HttpGet("رابط المكتبة"))()

-- 2. إنشاء النافذة
local Window = JackHub:CreateWindow({
    Name = "سكربتي",
})

-- 3. إنشاء تبويب
local Tab = Window:CreateTab({ Name = "الرئيسية", Icon = "🏠" })

-- 4. إضافة زر
Window:AddButton(Tab, {
    Name = "زر تجريبي",
    Callback = function()
        JackHub:Notify("نجح", "الزر يعمل!", 2, "Success")
    end,
})
```

---

## 🪟 إنشاء النافذة

```lua
local Window = JackHub:CreateWindow({
    Name = "Jack Hub",              -- اسم السكربت
    Author = "Jack",                -- اسم المطور (اختياري)
    Version = "v1.0",               -- الإصدار (اختياري)
    
    BootType = "XPRO",              -- نوع شاشة التحميل: "X" / "XP" / "XPRO"
    BootScreen = true,              -- تفعيل شاشة التحميل
    LoadingTitle = "Jack Hub",      -- عنوان شاشة التحميل
    LoadingSubtitle = "Loading...", -- نص فرعي
    
    Theme = "Default",              -- الثيم
    ToggleUIKeybind = "K",          -- زر إخفاء الواجهة
    
    BackgroundImage = nil,          -- خلفية مخصصة: "rbxassetid://ID"
    BootBackground = nil,           -- خلفية شاشة التحميل
    
    KeySystem = false,              -- نظام المفاتيح
    KeySettings = {
        Title = "نظام المفاتيح",
        Subtitle = "أدخل المفتاح",
        Note = "المفتاح الافتراضي: default",
        Key = {"default"},
        SaveKey = true,
        FileName = "Key",
        GrabKeyFromSite = false,
        KeyURL = "",
    },
})
```

---

## 📑 التبويبات

```lua
local MainTab = Window:CreateTab({
    Name = "الرئيسية",
    Icon = "🏠",
})
```

---

## 🧩 العناصر المتاحة

### 🔘 زر (Button)

```lua
Window:AddButton(Tab, {
    Name = "اضغط هنا",
    Icon = "🔥",
    Callback = function()
        print("تم الضغط!")
    end,
})
```

### 🔀 تبديل (Toggle)

```lua
Window:AddToggle(Tab, {
    Name = "تفعيل الميزة",
    Default = false,
    Flag = "my_toggle",
    Callback = function(value)
        print("الحالة:", value)
    end,
})
```

### 🎚️ شريط تمرير (Slider)

```lua
Window:AddSlider(Tab, {
    Name = "السرعة",
    Min = 0,
    Max = 100,
    Default = 50,
    Suffix = "%",
    Flag = "my_slider",
    Callback = function(value)
        print("القيمة:", value)
    end,
})
```

### 📋 قائمة منسدلة (Dropdown)

```lua
Window:AddDropdown(Tab, {
    Name = "اختر الوضع",
    Options = {"عادي", "سريع", "بطيء"},
    Flag = "my_dropdown",
    Callback = function(value)
        print("اخترت:", value)
    end,
})

-- قائمة متعددة الاختيار
Window:AddDropdown(Tab, {
    Name = "اختر متعدد",
    Options = {"A", "B", "C"},
    Multi = true,
    Callback = function(selected)
        print("المختارة:", table.concat(selected, ", "))
    end,
})
```

### ✏️ حقل نص (TextBox)

```lua
Window:AddTextBox(Tab, {
    Name = "الاسم",
    Placeholder = "اكتب هنا...",
    Default = "",
    Flag = "my_text",
    Callback = function(text)
        print("النص:", text)
    end,
})
```

### ⌨️ ربط مفتاح (Keybind)

```lua
Window:AddKeybind(Tab, {
    Name = "مفتاح سريع",
    Default = "E",
    Flag = "my_key",
    OnPressed = function()
        print("ضغطت المفتاح!")
    end,
})
```

### 🎨 منتقي لون (ColorPicker)

```lua
Window:AddColorPicker(Tab, {
    Name = "اللون",
    Default = Color3.fromRGB(138, 43, 226),
    Flag = "my_color",
    Callback = function(color)
        print("اللون:", color)
    end,
})
```

### 📌 عنوان قسم (Section)

```lua
Window:AddSection(Tab, {
    Name = "قسم جديد",
})
```

### 📝 نص توضيحي (Label)

```lua
Window:AddLabel(Tab, {
    Text = "هذا نص توضيحي",
    Height = 30,
})
```

---

## 🔔 الإشعارات

```lua
JackHub:Notify("العنوان", "الرسالة", 3, "Success")
```

**الأنواع المتاحة:**

| النوع | اللون | الاستخدام |
|-------|------|-----------|
| `"Info"` | أزرق | معلومات عامة |
| `"Success"` | أخضر | عملية ناجحة |
| `"Warning"` | أصفر | تحذير |
| `"Danger"` | أحمر | خطأ |

---

## 🎨 التحكم في الثيم

### تغيير الثيم الجاهز

```lua
JackHub:SetTheme("Blood")
```

**الثيمات المتاحة:** `Default` / `Dark` / `Blood` / `Ocean` / `Grape` / `Midnight` / `Matrix`

### تغيير اللون الرئيسي

```lua
JackHub:SetAccentColor(Color3.fromRGB(255, 100, 50))
```

### ثيم مخصص

```lua
JackHub:SetTheme({
    Accent = Color3.fromRGB(0, 255, 200),
    Background = Color3.fromRGB(20, 20, 25),
    Text = Color3.fromRGB(255, 255, 255),
})
```

---

## 🎛️ التحكم في الواجهة

```lua
JackHub:ToggleUI()          -- إخفاء / إظهار
JackHub:ToggleMinimize()    -- تصغير / تكبير
JackHub:ToggleFullscreen()  -- ملء الشاشة
JackHub:ToggleSettings()    -- فتح / إغلاق الإعدادات
JackHub:Destroy()           -- إغلاق الواجهة
```

---

## ⌨️ الاختصارات الافتراضية

| المفتاح | الوظيفة |
|---------|---------|
| **K** | إخفاء / إظهار الواجهة |
| **M** | تصغير / تكبير |
| **F** | ملء الشاشة |

---

## 📏 تعديل حجم النافذة

```lua
task.wait(0.2)
local sg = game:GetService("CoreGui"):FindFirstChild("JackHub_UI")
if sg then
    local mf = sg:FindFirstChild("MainFrame")
    if mf then
        mf.Size = UDim2.new(0, 800, 0, 600)
        mf.Position = UDim2.new(0.5, -400, 0.5, -300)
    end
end
```

---

## 💾 حفظ وتحميل الإعدادات

كل عنصر يحتوي على `Flag` تُحفظ قيمته تلقائياً في `State.Flags`.

- اضغط زر 💾 في الإعدادات → **حفظ**
- اضغط زر 📂 في الإعدادات → **تحميل**

---

## 📱 دعم الجوال

المكتبة **تكتشف تلقائياً** إذا كنت على جوال أو كمبيوتر:

- **على PC:** نافذة 620×440 مع عناصر 36px
- **على Mobile:** نافذة 340×380 مع عناصر 42px (أكبر لللمس)

كل الأزرار والسلايدرات والدروب داونز تعمل باللمس والماوس **بدون أي إعداد إضافي**.

---

## 🎯 مثال كامل

```lua
local JackHub = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/ibrahimkhacef5-del/Jack-lib/refs/heads/main/Jack6.luau"
))()

local Window = JackHub:CreateWindow({
    Name = "My Script",
    Author = "You",
    Theme = "Default",
    BootType = "XPRO",
})

-- تبويب الرئيسية
local MainTab = Window:CreateTab({ Name = "الرئيسية", Icon = "🏠" })

Window:AddSection(MainTab, { Name = "أزرار" })

Window:AddButton(MainTab, {
    Name = "زر تجريبي",
    Icon = "🔥",
    Callback = function()
        JackHub:Notify("نجح", "الزر يعمل!", 2, "Success")
    end,
})

Window:AddToggle(MainTab, {
    Name = "تفعيل الميزة",
    Default = false,
    Callback = function(v) print(v) end,
})

Window:AddSlider(MainTab, {
    Name = "القيمة",
    Min = 0, Max = 100, Default = 50,
    Callback = function(v) print(v) end,
})

JackHub:Notify("مرحباً", "تم تحميل السكربت!", 4, "Success")
```

---

## ❓ الأسئلة الشائعة

### كيف أغيّر حجم النافذة؟
راجع قسم **📏 تعديل حجم النافذة** أعلاه.

### كيف أضيف نظام المفاتيح؟
```lua
KeySystem = true,
KeySettings = {
    Key = {"مفتاحك"},
}
```

### هل يعمل على الجوال؟
نعم، تلقائياً.

### كيف أحفظ إعداداتي؟
استخدم زر 💾 في لوحة الإعدادات.

### الحروف العربية تظهر بشكل صحيح؟
نعم، المكتبة تدعم العربية.

---

## 📌 ملاحظات مهمة

1. جميع العناصر تدعم **اللمس** و **الماوس** بدون كود إضافي
2. استخدم `Flag` في كل عنصر تريد حفظه
3. يمكنك تعديل الحجم والألوان من سكربتك بدون فتح ملف المكتبة
4. المكتبة معزولة عن أي مكتبة أخرى (لا تعارض)

---

## 📄 الترخيص

مجاني للاستخدام الشخصي والتجاري.

---

## 👤 المطور

**Jack** — [GitHub](https://github.com/ibrahimkhacef5-del)

---

**⭐ إذا أعجبتك المكتبة، لا تنسَ النجمة على GitHub!**
