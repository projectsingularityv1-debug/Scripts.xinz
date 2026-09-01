-- ==============================================================================
--  Project XINZ X / Singularity - UI Test & Demonstration Suite
--  Created by K2NTA ST | Project Singularity
--  Tests All UI Elements, Themes, Notifications, and Lucide/FontAwesome Icons
-- ==============================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- 1. Load UI Library (Local file first, then Web/GitHub Raw URL fallback)
local Library
local okLoad, resLoad = pcall(function()
    local code = ""
    local source = ""
    
    if typeof(isfile) == "function" and isfile("ui.lua") then
        code = readfile("ui.lua")
        source = "Local workspace/ui.lua"
    elseif typeof(isfile) == "function" and isfile("UI.main/ui.lua") then
        code = readfile("UI.main/ui.lua")
        source = "Local workspace/UI.main/ui.lua"
    else
        source = "GitHub Raw (ui_temp.lua)"
        local okHttp, httpBody = pcall(function()
            return game:HttpGet("https://raw.githubusercontent.com/projectsingularityv1-debug/Scripts.xinz/refs/heads/main/ui_temp.lua?t=" .. tostring(tick()))
        end)
        if okHttp and httpBody and #httpBody > 100 then
            code = httpBody
        else
            source = "projectsingularity.online"
            code = game:HttpGet("https://projectsingularity.online/raw/repos/191c9695-c9f9-4b5f-805f-d87e8e3b8fac/ui.lua?t=" .. tostring(tick()))
        end
    end
    
    local func, compileErr = loadstring(code)
    if not func then
        error("[" .. source .. " Compilation Error]: " .. tostring(compileErr))
    end
    
    local execOk, execRes = pcall(func)
    if not execOk then
        error("[" .. source .. " Execution Error]: " .. tostring(execRes))
    end
    
    return execRes
end)

if not okLoad or not resLoad then
    warn("Failed to load ui.lua: " .. tostring(resLoad))
    return
end

Library = resLoad

-- 2. Setup Dynamic Window Sizing
local WindowSize = UserInputService.TouchEnabled and UDim2.fromOffset(550, 550) or UDim2.fromOffset(570, 460)

-- 3. Resolve User Profile & Key System Data
local KeyUsername = getgenv().KeyUsername or LocalPlayer.DisplayName or LocalPlayer.Name
local KeyAvatarURL = getgenv().KeyAvatar

if not KeyAvatarURL then
    pcall(function()
        if typeof(isfile) == "function" and isfile("SingularityKey.txt") then
            local savedKey = readfile("SingularityKey.txt")
            if savedKey and savedKey ~= "" then
                local req = (request or http_request or (syn and syn.request) or (http and http.request))
                local rbx_user = LocalPlayer.Name
                local rbx_id = LocalPlayer.UserId
                local url = "https://projectsingularity.online/raw/verify-key?k=" .. savedKey .. "&rbx_user=" .. rbx_user .. "&rbx_id=" .. tostring(rbx_id)
                if req then
                    local response = req({ Url = url, Method = "GET" })
                    if response and response.StatusCode == 200 then
                        local responseJson = HttpService:JSONDecode(response.Body)
                        if responseJson and responseJson.valid and responseJson.profile then
                            KeyUsername = responseJson.profile.username or KeyUsername
                            local rawAvatar = responseJson.profile.avatar_url
                            if rawAvatar and rawAvatar ~= "" then
                                KeyAvatarURL = rawAvatar
                            end
                        end
                    end
                end
            end
        end
    end)
end

if not KeyAvatarURL or KeyAvatarURL == "" then
    KeyAvatarURL = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=150&h=150"
end

-- 4. Create Main Window
local Window = Library:Window({
    Title = "Project XINZ X",
    Desc = "UI Demonstration Suite",
    Icon = "https://raw.githubusercontent.com/projectsingularityv1-debug/projectsingularity_HUP/main/1.png",
    Version = "2.6",
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.RightControl,
        Size = WindowSize
    },
    Profile = {
        Username = KeyUsername,
        Email = "UID: " .. tostring(LocalPlayer.UserId),
        AvatarUrl = KeyAvatarURL
    },
    CloseUIButton = {
        Enabled = true
    }
})

-- Welcome Notification
pcall(function()
    Library:Notification({
        Title = "Singularity Loaded",
        Desc = "Welcome back, " .. KeyUsername .. "!",
        Icon = "star",
        Time = 4
    })
end)

-- ==============================================================================
-- 1. Buttons Tab
-- ==============================================================================
local BtnTab = Window:Tab({ Title = "Buttons", Icon = "mouse-pointer" })

BtnTab:Button({
    Title = "Standard Button",
    Callback = function()
        print("[Singularity] Standard Button clicked!")
        Library:Notification({ Title = "Button Clicked", Desc = "Standard Button Triggered", Icon = "mouse-pointer", Time = 2 })
    end
})

BtnTab:Button({
    Title = "Button with Description",
    Desc = "Displays detailed information below the title.",
    Callback = function()
        print("[Singularity] Button with Description clicked!")
    end
})

BtnTab:Button({
    Title = "Button with Lucide Icon",
    Image = "star",
    Callback = function()
        print("[Singularity] Star Icon Button clicked!")
    end
})

BtnTab:Button({
    Title = "Fully Featured Button",
    Desc = "Includes title, description, and individual Lucide award icon.",
    Image = "award",
    Callback = function()
        print("[Singularity] Award Button clicked!")
    end
})

-- ==============================================================================
-- 2. Toggles Tab
-- ==============================================================================
local ToggleTab = Window:Tab({ Title = "Toggles", Icon = "toggle-right" })

ToggleTab:Toggle({ 
    Title = "Standard Toggle", 
    Value = false, 
    Callback = function(val)
        print("[Singularity] Standard Toggle: ", val)
    end
})

ToggleTab:Toggle({ 
    Title = "Toggle with Description", 
    Desc = "Enables automatic resource gathering in the background.",
    Value = false, 
    Callback = function(val)
        print("[Singularity] Toggle with Desc: ", val)
    end
})

ToggleTab:Toggle({ 
    Title = "Toggle with Shield Icon", 
    Image = "shield",
    Value = false, 
    Callback = function(val)
        print("[Singularity] Shield Toggle: ", val)
    end
})

ToggleTab:Toggle({ 
    Title = "Fast Mode (Full Toggle)", 
    Desc = "Turbocharge your task execution with zero delay.",
    Image = "zap",
    Value = true, 
    Callback = function(val)
        print("[Singularity] Fast Mode: ", val)
    end
})

-- ==============================================================================
-- 3. Inputs & Sliders Tab
-- ==============================================================================
local InputTab = Window:Tab({ Title = "Inputs & Sliders", Icon = "sliders" })

InputTab:Slider({
    Title = "WalkSpeed Multiplier",
    Min = 16,
    Max = 250,
    Default = 16,
    Callback = function(val)
        print("[Singularity] WalkSpeed: ", val)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = val
        end
    end
})

InputTab:Slider({
    Title = "JumpPower Adjustment",
    Desc = "Modify humanoid jump power dynamically.",
    Image = "activity",
    Min = 50,
    Max = 300,
    Default = 50,
    Callback = function(val)
        print("[Singularity] JumpPower: ", val)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = val
        end
    end
})

InputTab:Textbox({
    Title = "Quick Command Input",
    Placeholder = "Enter command...",
    ClearText = true,
    Callback = function(text)
        print("[Singularity] Command entered: ", text)
    end
})

InputTab:Textbox({
    Title = "Webhook / Key Input",
    Desc = "Paste custom Discord Webhook or API Key here.",
    Image = "key",
    Placeholder = "https://discord.com/api/webhooks/...",
    ClearText = false,
    Callback = function(text)
        print("[Singularity] Key/Webhook set: ", text)
    end
})

-- ==============================================================================
-- 4. Dropdowns & Keybinds Tab
-- ==============================================================================
local DropTab = Window:Tab({ Title = "Dropdowns", Icon = "list" })

DropTab:Dropdown({
    Title = "Select Target Mob",
    List = {"Bandit [Lv. 5]", "Monkey [Lv. 15]", "Pirate [Lv. 35]", "Boss [Lv. 100]"},
    Default = "Bandit [Lv. 5]",
    Callback = function(val)
        print("[Singularity] Selected Target: ", val)
    end
})

DropTab:Dropdown({
    Title = "Shopping / Item Selector",
    Desc = "Choose an item to purchase automatically.",
    Image = "shopping-cart",
    List = {"Health Potion", "Energy Drink", "Mystic Sword", "Dragon Shield"},
    Default = "Health Potion",
    Callback = function(val)
        print("[Singularity] Item Selected: ", val)
    end
})

DropTab:Keybind({
    Title = "Auto-Farm Toggle Keybind",
    Default = Enum.KeyCode.E,
    Callback = function(key)
        print("[Singularity] Auto-Farm Keybind Triggered: ", key)
    end
})

DropTab:Keybind({
    Title = "Quick Teleport Keybind",
    Desc = "Instant shortcut to escape danger.",
    Image = "keyboard",
    Default = Enum.KeyCode.F,
    Callback = function(key)
        print("[Singularity] Quick Teleport Triggered: ", key)
    end
})

-- ==============================================================================
-- 5. Themes & Advanced UI Tab
-- ==============================================================================
local AdvTab = Window:Tab({ Title = "Themes & Settings", Icon = "settings" })

AdvTab:Dropdown({
    Title = "Theme Selector",
    Desc = "Switch UI appearance in real-time.",
    Image = "palette",
    List = {"Dark", "Light", "Liquid Glass", "Amethyst", "Rose", "Ocean", "Neon", "Gold"},
    Default = "Dark",
    Callback = function(themeName)
        Library:setTheme(themeName)
        print("[Singularity] Theme switched to: ", themeName)
    end
})

AdvTab:ColorPicker({
    Title = "Custom Accent Color",
    Default = Color3.fromRGB(0, 225, 255),
    Callback = function(color)
        print("[Singularity] Accent Color: ", color)
    end
})

AdvTab:ColorPicker({
    Title = "Highlight Color Picker",
    Desc = "Select custom UI highlight color.",
    Image = "pen-tool",
    Default = Color3.fromRGB(255, 185, 0),
    Callback = function(color)
        print("[Singularity] Highlight Color: ", color)
    end
})

AdvTab:Label({
    Title = "System Information",
    Desc = "Project XINZ X | Compkiller 2.6 Icon Engine | 100% Anti-Detection",
    Image = "info"
})

AdvTab:Paragraph({
    Title = "Changelog v2.6",
    Desc = "• Upgraded to Compkiller 2.6 standalone icon engine\n• Added Async Custom Asset Cache (XINZ_Cache)\n• Real-time Theme Switching & Smooth Animations\n• Fixed Image clipping and offline fallback stability"
})

print("[Singularity] UITest.lua loaded successfully with all components!")
