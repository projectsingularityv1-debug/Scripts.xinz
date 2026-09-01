-- UITest.lua
-- Script to test all available UI elements in ui.lua

local uiCode = ""
if isfile and isfile("ui.lua") then
    uiCode = readfile("ui.lua")
else
    uiCode = game:HttpGet("https://raw.githubusercontent.com/projectsingularityv1-debug/Scripts.xinz/refs/heads/main/ui.lua?t=" .. tostring(tick()))
end
local Library = loadstring(uiCode)()
local UIS = game:GetService("UserInputService")
local WindowSize = UIS.TouchEnabled and UDim2.fromOffset(550, 550) or UDim2.fromOffset(570, 450)


local KeyAvatarURL = getgenv().KeyAvatar
if not KeyAvatarURL then
    pcall(function()
        if isfile and isfile("SingularityKey.txt") then
            local savedKey = readfile("SingularityKey.txt")
            if savedKey and savedKey ~= "" then
                local req = (request or http_request or (syn and syn.request) or (http and http.request))
                local rbx_user = game:GetService("Players").LocalPlayer.Name
                local rbx_id = game:GetService("Players").LocalPlayer.UserId
                local url = "https://projectsingularity.online/raw/verify-key?k=" .. savedKey .. "&rbx_user=" .. rbx_user .. "&rbx_id=" .. tostring(rbx_id)
                if req then
                    local response = req({ Url = url, Method = "GET" })
                    if response and response.StatusCode == 200 then
                        local HttpService = game:GetService("HttpService")
                        local responseJson = HttpService:JSONDecode(response.Body)
                        if responseJson and responseJson.valid and responseJson.profile then
                            getgenv().KeyUsername = responseJson.profile.username
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
    KeyAvatarURL = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(game:GetService("Players").LocalPlayer.UserId) .. "&w=150&h=150"
end

local Window = Library:Window({

    Profile = {
        Username = getgenv().KeyUsername or "N/A",
        Email = "UID: " .. tostring(game:GetService("Players").LocalPlayer.UserId),
        AvatarUrl = KeyAvatarURL
    },

    Title = "Project XINZ X",
    Desc = "UI Library Test",
    Icon = "https://raw.githubusercontent.com/projectsingularityv1-debug/projectsingularity_HUP/main/1.png",
    Version = "2.0",
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.RightShift,
        Size = WindowSize
    },
    CloseUIButton = {
        Enabled = true,
        Text = "Close UI Test"
    }
})

-- ==========================================
-- 1. Buttons Tab
-- ==========================================
local BtnTab = Window:Tab({ Title = "Buttons", Icon = "mouse-pointer" })

BtnTab:Button({
    Title = "Standard Button",
    Callback = function() print("Standard Button clicked!") end
})

BtnTab:Button({
    Title = "Button with Description",
    Desc = "This button has a subtitle/description.",
    Callback = function() print("Button with Description clicked!") end
})

BtnTab:Button({
    Title = "Button with Image",
    Image = "star",
    Callback = function() print("Button with Image clicked!") end
})

BtnTab:Button({
    Title = "Fully Featured Button",
    Desc = "This button has a title, description, and an icon.",
    Image = "award",
    Callback = function() print("Fully Featured Button clicked!") end
})

-- ==========================================
-- 2. Toggles Tab
-- ==========================================
local ToggleTab = Window:Tab({ Title = "Toggles", Icon = "toggle-right" })

ToggleTab:Toggle({ 
    Title = "Standard Toggle", 
    Value = false, 
    Callback = function(val) print("Standard Toggle: ", val) end
})

ToggleTab:Toggle({ 
    Title = "Toggle with Description", 
    Desc = "Provides more details about what this setting does.",
    Value = false, 
    Callback = function(val) print("Toggle with Desc: ", val) end
})

ToggleTab:Toggle({ 
    Title = "Toggle with Image", 
    Image = "shield",
    Value = false, 
    Callback = function(val) print("Toggle with Image: ", val) end
})

ToggleTab:Toggle({ 
    Title = "Fully Featured Toggle", 
    Desc = "Title, description, and an icon all in one.",
    Image = "zap",
    Value = true, 
    Callback = function(val) print("Full Toggle: ", val) end
})

-- ==========================================
-- 3. Inputs & Sliders Tab
-- ==========================================
local InputTab = Window:Tab({ Title = "Inputs & Sliders", Icon = "sliders" })

InputTab:Slider({
    Title = "Standard Slider",
    Min = 0, Max = 100, Default = 50,
    Callback = function(val) print("Standard Slider: ", val) end
})

InputTab:Slider({
    Title = "Slider with Description & Image",
    Desc = "Adjust the speed here.",
    Image = "activity",
    Min = 10, Max = 200, Default = 100,
    Callback = function(val) print("Advanced Slider: ", val) end
})

InputTab:Textbox({
    Title = "Standard Textbox",
    Placeholder = "Enter text...",
    ClearText = true,
    Callback = function(text) print("Textbox input: ", text) end
})

InputTab:Textbox({
    Title = "Textbox with Info",
    Desc = "Type your API key here.",
    Image = "key",
    Placeholder = "API Key",
    ClearText = true,
    Callback = function(text) print("Advanced Textbox: ", text) end
})

-- ==========================================
-- 4. Dropdowns & Keybinds Tab
-- ==========================================
local DropTab = Window:Tab({ Title = "Dropdowns", Icon = "list" })

DropTab:Dropdown({
    Title = "Standard Dropdown",
    List = {"Apple", "Banana", "Orange"},
    Default = "Apple",
    Callback = function(val) print("Standard Dropdown: ", val) end
})

DropTab:Dropdown({
    Title = "Advanced Dropdown",
    Desc = "Select your preferred fruit",
    Image = "shopping-cart",
    List = {"Mango", "Grape", "Melon"},
    Default = "Mango",
    Callback = function(val) print("Advanced Dropdown: ", val) end
})

DropTab:Keybind({
    Title = "Standard Keybind",
    Default = Enum.KeyCode.E,
    Callback = function(key) print("Standard Keybind: ", key) end
})

DropTab:Keybind({
    Title = "Advanced Keybind",
    Desc = "Press to open menu",
    Image = "keyboard",
    Default = Enum.KeyCode.F,
    Callback = function(key) print("Advanced Keybind: ", key) end
})

-- ==========================================
-- 5. Advanced UI Tab
-- ==========================================
local AdvTab = Window:Tab({ Title = "Advanced UI", Icon = "settings" })

AdvTab:ColorPicker({
    Title = "Standard Color Picker",
    Default = Color3.fromRGB(255, 128, 0),
    Callback = function(color) print("Color: ", color) end
})

AdvTab:ColorPicker({
    Title = "Advanced Color Picker",
    Desc = "Pick a theme color",
    Image = "pen-tool",
    Default = Color3.fromRGB(0, 255, 255),
    Callback = function(color) print("Color: ", color) end
})

AdvTab:Label({
    Title = "Information Label",
    Desc = "This is a label with a description and image.",
    Image = "info"
})

AdvTab:Paragraph({
    Title = "Announcement",
    Desc = "This is a full paragraph block.\nIt supports multiple lines of text.\nVery useful for changelogs."
})

print("UITest.lua loaded successfully with ALL variants!")
