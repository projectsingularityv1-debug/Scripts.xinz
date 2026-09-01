local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local PlaceId = game.PlaceId
local LocalPlayer = Players.LocalPlayer

-- ════════════════════════════════════════════════════════════
-- // Configuration
-- ════════════════════════════════════════════════════════════
local Config = {
    LogoID = "rbxassetid://112209635962758",
    MainColor = Color3.fromRGB(220, 220, 220),      -- Sleek White/Grey
    AccentColor = Color3.fromRGB(255, 255, 255),    -- Bright White
    DarkBg = Color3.fromRGB(15, 15, 15),            -- Deep Obsidian
    CardBg = Color3.fromRGB(20, 20, 20),            -- UI Background
    SurfaceBg = Color3.fromRGB(18, 18, 18),         -- UI Page
    BorderColor = Color3.fromRGB(35, 35, 35),       -- Subtle Border

    -- Target scripts
    BFTargetScript = "https://raw.githubusercontent.com/kentatvv1-tech/Scripts/refs/heads/main/BF%20V1",
    MM2TargetScript = "https://raw.githubusercontent.com/kentatvv1-tech/Scripts/refs/heads/main/MM2%20DONE.lua",
    MineMountainTargetScript = "https://raw.githubusercontent.com/kentatvv1-tech/Scripts/refs/heads/main/fame%20222.lua",
    LaundrySimulatorTargetScript = "https://projectProjectXinz.online/raw/repos/191c9695-c9f9-4b5f-805f-d87e8e3b8fac/LaundrySimulator_AutoFarm.lua",
    TWDTargetScript = "https://raw.githubusercontent.com/kentatvv1-tech/Scripts/refs/heads/main/TWD%20V1.lua",
    FischTargetScript = "https://raw.githubusercontent.com/kentatvv1-tech/Scripts/refs/heads/main/LK%20AUTO.lua",
    CaliShootoutTargetScript = "https://projectProjectXinz.online/raw/repos/191c9695-c9f9-4b5f-805f-d87e8e3b8fac/gun%20auto.lua",

    -- Key System
    KeyVerifyURL = "https://projectProjectXinz.online/raw/verify-key",
    GetKeyURL = "https://projectProjectXinz.online/key.html",
}

local SupportedGames = {
    ["2753915549"] = "Blox Fruits",
    ["4442272183"] = "Blox Fruits",
    ["7449423635"] = "Blox Fruits",
    ["142823291"] = "Murder Mystery 2",
    ["125927821145949"] = "Mine a Mountain",
    ["6305942109"] = "Laundry Simulator",
    ["128039018996175"] = "The Walking Dead",
    ["16732694052"] = "Fisch",
    ["12077443856"] = "Cali Shootout"
}

-- ════════════════════════════════════════════════════════════
-- // Clean existing loader instances
-- ════════════════════════════════════════════════════════════
pcall(function()
    if CoreGui:FindFirstChild("ProjectXinzLoader") then
        CoreGui.ProjectXinzLoader:Destroy()
    end
    if Lighting:FindFirstChild("ProjectXinzBlur") then
        Lighting.ProjectXinzBlur:Destroy()
    end
end)

-- ════════════════════════════════════════════════════════════
-- // UI Container & Blur Setup
-- ════════════════════════════════════════════════════════════
local LoaderUI = Instance.new("ScreenGui")
LoaderUI.Name = "ProjectXinzLoader"
LoaderUI.ResetOnSpawn = false
LoaderUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if gethui then
    LoaderUI.Parent = gethui()
else
    local success = pcall(function() LoaderUI.Parent = CoreGui end)
    if not success and LocalPlayer then
        LoaderUI.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
end

local Blur = Instance.new("BlurEffect")
Blur.Name = "ProjectXinzBlur"
Blur.Size = 0
Blur.Parent = Lighting

-- Overlay Background
local Overlay = Instance.new("Frame")
Overlay.Name = "Overlay"
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
Overlay.BackgroundTransparency = 1
Overlay.BorderSizePixel = 0
Overlay.Parent = LoaderUI

-- ════════════════════════════════════════════════════════════
-- // Reusable UI Builder Helpers
-- ════════════════════════════════════════════════════════════
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = color or Config.BorderColor
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.Parent = parent
    return stroke
end

local function createGradient(parent, col1, col2, rotation)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, col1),
        ColorSequenceKeypoint.new(1, col2)
    })
    grad.Rotation = rotation or 0
    grad.Parent = parent
    return grad
end

-- ════════════════════════════════════════════════════════════
-- // KEY SYSTEM WINDOW
-- ════════════════════════════════════════════════════════════
local KeyWindow = Instance.new("Frame")
KeyWindow.Name = "KeyWindow"
KeyWindow.AnchorPoint = Vector2.new(0.5, 0.5)
KeyWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
KeyWindow.Size = UDim2.new(0, 420, 0, 340)
KeyWindow.BackgroundColor3 = Config.CardBg
KeyWindow.BackgroundTransparency = 1
KeyWindow.BorderSizePixel = 0
KeyWindow.ClipsDescendants = true
KeyWindow.Visible = false
KeyWindow.ZIndex = 5
KeyWindow.Parent = Overlay

createCorner(KeyWindow, 14)
local KeyWindowStroke = createStroke(KeyWindow, Config.BorderColor, 1.2, 0.2)
createGradient(KeyWindow, Color3.fromRGB(24, 24, 32), Color3.fromRGB(15, 15, 20), 45)

-- Window Topbar / Header
local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 40)
Topbar.BackgroundTransparency = 1
Topbar.ZIndex = 6
Topbar.Parent = KeyWindow

-- macOS Style Traffic Lights
local function makeDot(color, x)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 10, 0, 10)
    dot.Position = UDim2.new(0, x, 0.5, -5)
    dot.BackgroundColor3 = color
    dot.BorderSizePixel = 0
    dot.ZIndex = 7
    dot.Parent = Topbar
    createCorner(dot, 5)
    return dot
end

makeDot(Color3.fromRGB(255, 95, 87), 16)
makeDot(Color3.fromRGB(254, 188, 46), 32)
makeDot(Color3.fromRGB(40, 200, 64), 48)

-- Header Brand Title
local BrandTitle = Instance.new("TextLabel")
BrandTitle.Name = "BrandTitle"
BrandTitle.Size = UDim2.new(1, -120, 1, 0)
BrandTitle.Position = UDim2.new(0, 68, 0, 0)
BrandTitle.BackgroundTransparency = 1
BrandTitle.Font = Enum.Font.GothamBold
BrandTitle.Text = "PROJECT XINZ X"
BrandTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
BrandTitle.TextSize = 12
BrandTitle.TextXAlignment = Enum.TextXAlignment.Left
BrandTitle.ZIndex = 7
BrandTitle.Parent = Topbar

-- Version Pill Badge
local VersionBadge = Instance.new("Frame")
VersionBadge.Name = "VersionBadge"
VersionBadge.AnchorPoint = Vector2.new(1, 0.5)
VersionBadge.Position = UDim2.new(1, -14, 0.5, 0)
VersionBadge.Size = UDim2.new(0, 56, 0, 18)
VersionBadge.BackgroundColor3 = Color3.fromRGB(35, 35, 46)
VersionBadge.BorderSizePixel = 0
VersionBadge.ZIndex = 7
VersionBadge.Parent = Topbar
createCorner(VersionBadge, 9)
createStroke(VersionBadge, Color3.fromRGB(60, 60, 80), 1, 0.4)

local VersionText = Instance.new("TextLabel")
VersionText.Size = UDim2.new(1, 0, 1, 0)
VersionText.BackgroundTransparency = 1
VersionText.Font = Enum.Font.GothamBold
VersionText.Text = "v2.5"
VersionText.TextColor3 = Config.MainColor
VersionText.TextSize = 10
VersionText.ZIndex = 8
VersionText.Parent = VersionBadge

-- Separator line
local SepLine = Instance.new("Frame")
SepLine.Size = UDim2.new(1, 0, 0, 1)
SepLine.Position = UDim2.new(0, 0, 0, 40)
SepLine.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
SepLine.BorderSizePixel = 0
SepLine.ZIndex = 6
SepLine.Parent = KeyWindow

-- Center Brand Logo
local HeaderLogo = Instance.new("ImageLabel")
HeaderLogo.Name = "HeaderLogo"
HeaderLogo.AnchorPoint = Vector2.new(0.5, 0)
HeaderLogo.Position = UDim2.new(0.5, 0, 0, 54)
HeaderLogo.Size = UDim2.new(0, 42, 0, 42)
HeaderLogo.BackgroundTransparency = 1
HeaderLogo.Image = Config.LogoID
HeaderLogo.ZIndex = 6
HeaderLogo.Parent = KeyWindow
createCorner(HeaderLogo, 10)

-- Title & Subtitle
local KeyHeading = Instance.new("TextLabel")
KeyHeading.Name = "KeyHeading"
KeyHeading.AnchorPoint = Vector2.new(0.5, 0)
KeyHeading.Position = UDim2.new(0.5, 0, 0, 102)
KeyHeading.Size = UDim2.new(1, -40, 0, 20)
KeyHeading.BackgroundTransparency = 1
KeyHeading.Font = Enum.Font.GothamBold
KeyHeading.Text = "Authentication Required"
KeyHeading.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyHeading.TextSize = 15
KeyHeading.ZIndex = 6
KeyHeading.Parent = KeyWindow

local KeySubheading = Instance.new("TextLabel")
KeySubheading.Name = "KeySubheading"
KeySubheading.AnchorPoint = Vector2.new(0.5, 0)
KeySubheading.Position = UDim2.new(0.5, 0, 0, 124)
KeySubheading.Size = UDim2.new(1, -40, 0, 16)
KeySubheading.BackgroundTransparency = 1
KeySubheading.Font = Enum.Font.Gotham
KeySubheading.Text = "Enter your license key to verify and continue"
KeySubheading.TextColor3 = Color3.fromRGB(140, 140, 155)
KeySubheading.TextSize = 11
KeySubheading.ZIndex = 6
KeySubheading.Parent = KeyWindow

-- Key Input Container
local InputContainer = Instance.new("Frame")
InputContainer.Name = "InputContainer"
InputContainer.AnchorPoint = Vector2.new(0.5, 0)
InputContainer.Position = UDim2.new(0.5, 0, 0, 154)
InputContainer.Size = UDim2.new(1, -48, 0, 42)
InputContainer.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
InputContainer.BorderSizePixel = 0
InputContainer.ZIndex = 6
InputContainer.Parent = KeyWindow

createCorner(InputContainer, 8)
local InputStroke = createStroke(InputContainer, Color3.fromRGB(45, 45, 60), 1, 0.2)

-- Key Icon inside input
local KeyIcon = Instance.new("ImageLabel")
KeyIcon.AnchorPoint = Vector2.new(0, 0.5)
KeyIcon.Position = UDim2.new(0, 12, 0.5, 0)
KeyIcon.Size = UDim2.new(0, 16, 0, 16)
KeyIcon.BackgroundTransparency = 1
KeyIcon.Image = "rbxassetid://6031086178"
KeyIcon.ImageColor3 = Color3.fromRGB(150, 150, 170)
KeyIcon.ZIndex = 7
KeyIcon.Parent = InputContainer

-- Key Input TextBox
local KeyTextBox = Instance.new("TextBox")
KeyTextBox.Name = "KeyTextBox"
KeyTextBox.AnchorPoint = Vector2.new(0, 0.5)
KeyTextBox.Position = UDim2.new(0, 36, 0.5, 0)
KeyTextBox.Size = UDim2.new(1, -94, 1, 0)
KeyTextBox.BackgroundTransparency = 1
KeyTextBox.Font = Enum.Font.Code
KeyTextBox.PlaceholderText = "PASTE-KEY-HERE..."
KeyTextBox.PlaceholderColor3 = Color3.fromRGB(80, 80, 100)
KeyTextBox.TextColor3 = Color3.fromRGB(240, 240, 255)
KeyTextBox.TextSize = 12
KeyTextBox.TextXAlignment = Enum.TextXAlignment.Left
KeyTextBox.ClearTextOnFocus = false
KeyTextBox.ZIndex = 7
KeyTextBox.Parent = InputContainer

-- Saved Key Loader
local savedKey = ""
pcall(function()
    if isfile and isfile("ProjectXinzKey.txt") then
        savedKey = readfile("ProjectXinzKey.txt")
    end
end)
KeyTextBox.Text = savedKey

-- Paste Button (Small helper button inside input box)
local PasteBtn = Instance.new("TextButton")
PasteBtn.Name = "PasteBtn"
PasteBtn.AnchorPoint = Vector2.new(1, 0.5)
PasteBtn.Position = UDim2.new(1, -6, 0.5, 0)
PasteBtn.Size = UDim2.new(0, 48, 0, 26)
PasteBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
PasteBtn.BorderSizePixel = 0
PasteBtn.Font = Enum.Font.GothamMedium
PasteBtn.Text = "PASTE"
PasteBtn.TextColor3 = Color3.fromRGB(170, 170, 190)
PasteBtn.TextSize = 9
PasteBtn.ZIndex = 8
PasteBtn.Parent = InputContainer
createCorner(PasteBtn, 6)
createStroke(PasteBtn, Color3.fromRGB(50, 50, 70), 1, 0.5)

PasteBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if getclipboard then
            local clip = getclipboard()
            if clip and clip ~= "" then
                KeyTextBox.Text = clip:match("^%s*(.-)%s*$")
            end
        end
    end)
end)

-- Status / Feedback Message
local StatusMsg = Instance.new("TextLabel")
StatusMsg.Name = "StatusMsg"
StatusMsg.AnchorPoint = Vector2.new(0.5, 0)
StatusMsg.Position = UDim2.new(0.5, 0, 0, 202)
StatusMsg.Size = UDim2.new(1, -48, 0, 14)
StatusMsg.BackgroundTransparency = 1
StatusMsg.Font = Enum.Font.GothamMedium
StatusMsg.Text = ""
StatusMsg.TextColor3 = Color3.fromRGB(255, 90, 90)
StatusMsg.TextSize = 11
StatusMsg.ZIndex = 6
StatusMsg.Parent = KeyWindow

-- Verify / Submit Action Button
local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Name = "VerifyBtn"
VerifyBtn.AnchorPoint = Vector2.new(0.5, 0)
VerifyBtn.Position = UDim2.new(0.5, 0, 0, 224)
VerifyBtn.Size = UDim2.new(1, -48, 0, 40)
VerifyBtn.BackgroundColor3 = Config.MainColor
VerifyBtn.BorderSizePixel = 0
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.Text = "VERIFY & LOAD"
VerifyBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
VerifyBtn.TextSize = 13
VerifyBtn.AutoButtonColor = false
VerifyBtn.ZIndex = 7
VerifyBtn.Parent = KeyWindow

createCorner(VerifyBtn, 8)
local VerifyBtnGrad = createGradient(VerifyBtn, Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 200, 200), 0)

-- Secondary Actions Row ("Get Key" link & "Clear Saved")
local LinksRow = Instance.new("Frame")
LinksRow.Name = "LinksRow"
LinksRow.AnchorPoint = Vector2.new(0.5, 0)
LinksRow.Position = UDim2.new(0.5, 0, 0, 276)
LinksRow.Size = UDim2.new(1, -48, 0, 26)
LinksRow.BackgroundTransparency = 1
LinksRow.ZIndex = 6
LinksRow.Parent = KeyWindow

-- Get Key Button with Icon
local GetKeyLink = Instance.new("TextButton")
GetKeyLink.Name = "GetKeyLink"
GetKeyLink.Size = UDim2.new(0.5, -4, 1, 0)
GetKeyLink.Position = UDim2.new(0, 0, 0, 0)
GetKeyLink.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
GetKeyLink.BorderSizePixel = 0
GetKeyLink.Font = Enum.Font.GothamMedium
GetKeyLink.Text = "  Get Key"
GetKeyLink.TextColor3 = Color3.fromRGB(170, 170, 190)
GetKeyLink.TextSize = 10
GetKeyLink.ZIndex = 7
GetKeyLink.Parent = LinksRow
createCorner(GetKeyLink, 6)
createStroke(GetKeyLink, Color3.fromRGB(45, 45, 60), 1, 0.4)

local LinkIcon = Instance.new("ImageLabel")
LinkIcon.Name = "LinkIcon"
LinkIcon.AnchorPoint = Vector2.new(0, 0.5)
LinkIcon.Position = UDim2.new(0, 10, 0.5, 0)
LinkIcon.Size = UDim2.new(0, 12, 0, 12)
LinkIcon.BackgroundTransparency = 1
LinkIcon.Image = "rbxassetid://6035047409"
LinkIcon.ImageColor3 = Color3.fromRGB(170, 170, 190)
LinkIcon.ZIndex = 8
LinkIcon.Parent = GetKeyLink

-- Clear Saved Button with Icon
local ClearKeyLink = Instance.new("TextButton")
ClearKeyLink.Name = "ClearKeyLink"
ClearKeyLink.Size = UDim2.new(0.5, -4, 1, 0)
ClearKeyLink.Position = UDim2.new(0.5, 4, 0, 0)
ClearKeyLink.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
ClearKeyLink.BorderSizePixel = 0
ClearKeyLink.Font = Enum.Font.GothamMedium
ClearKeyLink.Text = "  Clear Saved"
ClearKeyLink.TextColor3 = Color3.fromRGB(170, 170, 190)
ClearKeyLink.TextSize = 10
ClearKeyLink.ZIndex = 7
ClearKeyLink.Parent = LinksRow
createCorner(ClearKeyLink, 6)
createStroke(ClearKeyLink, Color3.fromRGB(45, 45, 60), 1, 0.4)

local TrashIcon = Instance.new("ImageLabel")
TrashIcon.Name = "TrashIcon"
TrashIcon.AnchorPoint = Vector2.new(0, 0.5)
TrashIcon.Position = UDim2.new(0, 10, 0.5, 0)
TrashIcon.Size = UDim2.new(0, 12, 0, 12)
TrashIcon.BackgroundTransparency = 1
TrashIcon.Image = "rbxassetid://6031075931"
TrashIcon.ImageColor3 = Color3.fromRGB(170, 170, 190)
TrashIcon.ZIndex = 8
TrashIcon.Parent = ClearKeyLink

-- ════════════════════════════════════════════════════════════
-- // MODERN LOADING SCREEN
-- ════════════════════════════════════════════════════════════
local LoadingCard = Instance.new("Frame")
LoadingCard.Name = "LoadingCard"
LoadingCard.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingCard.Position = UDim2.new(0.5, 0, 0.5, 0)
LoadingCard.Size = UDim2.new(0, 400, 0, 280)
LoadingCard.BackgroundColor3 = Config.CardBg
LoadingCard.BackgroundTransparency = 1
LoadingCard.BorderSizePixel = 0
LoadingCard.ClipsDescendants = true
LoadingCard.Visible = false
LoadingCard.ZIndex = 5
LoadingCard.Parent = Overlay

createCorner(LoadingCard, 14)
local LoadingCardStroke = createStroke(LoadingCard, Config.BorderColor, 1.2, 0.2)
createGradient(LoadingCard, Color3.fromRGB(24, 24, 32), Color3.fromRGB(15, 15, 20), 45)

-- Rotating Spinner Icon / Circular Loading Arc
local SpinnerRing = Instance.new("ImageLabel")
SpinnerRing.Name = "SpinnerRing"
SpinnerRing.AnchorPoint = Vector2.new(0.5, 0.5)
SpinnerRing.Position = UDim2.new(0.5, 0, 0, 72)
SpinnerRing.Size = UDim2.new(0, 76, 0, 76)
SpinnerRing.BackgroundTransparency = 1
SpinnerRing.Image = "rbxassetid://4977497258"
SpinnerRing.ImageColor3 = Config.MainColor
SpinnerRing.ZIndex = 8
SpinnerRing.Parent = LoadingCard

-- Central Brand Logo Container with Clean Rounded Badge
local LogoBadge = Instance.new("Frame")
LogoBadge.Name = "LogoBadge"
LogoBadge.AnchorPoint = Vector2.new(0.5, 0.5)
LogoBadge.Position = UDim2.new(0.5, 0, 0, 72)
LogoBadge.Size = UDim2.new(0, 48, 0, 48)
LogoBadge.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
LogoBadge.BorderSizePixel = 0
LogoBadge.ClipsDescendants = true
LogoBadge.ZIndex = 6
LogoBadge.Parent = LoadingCard
createCorner(LogoBadge, 24)
createStroke(LogoBadge, Color3.fromRGB(50, 50, 68), 1, 0.3)

local LoadingLogo = Instance.new("ImageLabel")
LoadingLogo.Name = "LoadingLogo"
LoadingLogo.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
LoadingLogo.Size = UDim2.new(1.1, 0, 1.1, 0)
LoadingLogo.BackgroundTransparency = 1
LoadingLogo.Image = Config.LogoID
LoadingLogo.ZIndex = 7
LoadingLogo.Parent = LogoBadge

-- Loading Main Title
local LoadTitle = Instance.new("TextLabel")
LoadTitle.Name = "LoadTitle"
LoadTitle.AnchorPoint = Vector2.new(0.5, 0)
LoadTitle.Position = UDim2.new(0.5, 0, 0, 126)
LoadTitle.Size = UDim2.new(1, -40, 0, 22)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Font = Enum.Font.GothamBold
LoadTitle.Text = "INITIALIZING HUB"
LoadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadTitle.TextSize = 16
LoadTitle.ZIndex = 6
LoadTitle.Parent = LoadingCard

-- Dynamic Status Message
local LoadStatus = Instance.new("TextLabel")
LoadStatus.Name = "LoadStatus"
LoadStatus.AnchorPoint = Vector2.new(0.5, 0)
LoadStatus.Position = UDim2.new(0.5, 0, 0, 150)
LoadStatus.Size = UDim2.new(1, -40, 0, 16)
LoadStatus.BackgroundTransparency = 1
LoadStatus.Font = Enum.Font.GothamMedium
LoadStatus.Text = "Connecting to Project XINZ X..."
LoadStatus.TextColor3 = Color3.fromRGB(150, 150, 170)
LoadStatus.TextSize = 12
LoadStatus.ZIndex = 6
LoadStatus.Parent = LoadingCard

-- Game Pill Badge (Display target detected game)
local GameBadge = Instance.new("Frame")
GameBadge.Name = "GameBadge"
GameBadge.AnchorPoint = Vector2.new(0.5, 0)
GameBadge.Position = UDim2.new(0.5, 0, 0, 176)
GameBadge.Size = UDim2.new(0, 180, 0, 22)
GameBadge.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
GameBadge.BorderSizePixel = 0
GameBadge.ZIndex = 6
GameBadge.Parent = LoadingCard
createCorner(GameBadge, 11)
createStroke(GameBadge, Color3.fromRGB(50, 50, 70), 1, 0.4)

local GameBadgeDot = Instance.new("Frame")
GameBadgeDot.AnchorPoint = Vector2.new(0, 0.5)
GameBadgeDot.Position = UDim2.new(0, 8, 0.5, 0)
GameBadgeDot.Size = UDim2.new(0, 6, 0, 6)
GameBadgeDot.BackgroundColor3 = Color3.fromRGB(0, 230, 140)
GameBadgeDot.BorderSizePixel = 0
GameBadgeDot.ZIndex = 7
GameBadgeDot.Parent = GameBadge
createCorner(GameBadgeDot, 3)

local GameBadgeText = Instance.new("TextLabel")
GameBadgeText.Size = UDim2.new(1, -22, 1, 0)
GameBadgeText.Position = UDim2.new(0, 18, 0, 0)
GameBadgeText.BackgroundTransparency = 1
GameBadgeText.Font = Enum.Font.GothamBold
GameBadgeText.Text = "Detecting Game..."
GameBadgeText.TextColor3 = Color3.fromRGB(220, 220, 235)
GameBadgeText.TextSize = 10
GameBadgeText.TextXAlignment = Enum.TextXAlignment.Left
GameBadgeText.ZIndex = 7
GameBadgeText.Parent = GameBadge

-- Percentage Label & Progress Bar Container
local ProgressSection = Instance.new("Frame")
ProgressSection.Name = "ProgressSection"
ProgressSection.AnchorPoint = Vector2.new(0.5, 0)
ProgressSection.Position = UDim2.new(0.5, 0, 0, 214)
ProgressSection.Size = UDim2.new(1, -56, 0, 28)
ProgressSection.BackgroundTransparency = 1
ProgressSection.ZIndex = 6
ProgressSection.Parent = LoadingCard

local PercentLabel = Instance.new("TextLabel")
PercentLabel.Name = "PercentLabel"
PercentLabel.AnchorPoint = Vector2.new(1, 0)
PercentLabel.Position = UDim2.new(1, 0, 0, -16)
PercentLabel.Size = UDim2.new(0, 60, 0, 14)
PercentLabel.BackgroundTransparency = 1
PercentLabel.Font = Enum.Font.Code
PercentLabel.Text = "0%"
PercentLabel.TextColor3 = Config.MainColor
PercentLabel.TextSize = 11
PercentLabel.TextXAlignment = Enum.TextXAlignment.Right
PercentLabel.ZIndex = 7
PercentLabel.Parent = ProgressSection

local ProgressBarTrack = Instance.new("Frame")
ProgressBarTrack.Name = "ProgressBarTrack"
ProgressBarTrack.Size = UDim2.new(1, 0, 0, 6)
ProgressBarTrack.Position = UDim2.new(0, 0, 0, 4)
ProgressBarTrack.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
ProgressBarTrack.BorderSizePixel = 0
ProgressBarTrack.ZIndex = 6
ProgressBarTrack.Parent = ProgressSection
createCorner(ProgressBarTrack, 3)

local ProgressBarFill = Instance.new("Frame")
ProgressBarFill.Name = "ProgressBarFill"
ProgressBarFill.Size = UDim2.new(0, 0, 1, 0)
ProgressBarFill.BackgroundColor3 = Config.MainColor
ProgressBarFill.BorderSizePixel = 0
ProgressBarFill.ZIndex = 7
ProgressBarFill.Parent = ProgressBarTrack
createCorner(ProgressBarFill, 3)
createGradient(ProgressBarFill, Color3.fromRGB(255, 255, 255), Color3.fromRGB(180, 180, 180), 0)

-- ════════════════════════════════════════════════════════════
-- // Interactive Animations & Micro-interactions
-- ════════════════════════════════════════════════════════════

-- TextBox Focus Highlight
KeyTextBox.Focused:Connect(function()
    TweenService:Create(InputStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
        Color = Config.MainColor,
        Transparency = 0
    }):Play()
    TweenService:Create(InputContainer, TweenInfo.new(0.25), {
        BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    }):Play()
end)

KeyTextBox.FocusLost:Connect(function()
    TweenService:Create(InputStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
        Color = Color3.fromRGB(45, 45, 60),
        Transparency = 0.2
    }):Play()
    TweenService:Create(InputContainer, TweenInfo.new(0.25), {
        BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    }):Play()
end)

-- Button Hover Animations
local function setupHover(btn, normalColor, hoverColor)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
    end)
end

setupHover(VerifyBtn, Config.MainColor, Color3.fromRGB(255, 255, 255))
setupHover(GetKeyLink, Color3.fromRGB(22, 22, 30), Color3.fromRGB(32, 32, 44))
setupHover(ClearKeyLink, Color3.fromRGB(22, 22, 30), Color3.fromRGB(38, 24, 28))
setupHover(PasteBtn, Color3.fromRGB(28, 28, 38), Color3.fromRGB(40, 40, 56))

-- Get Key Link Action
GetKeyLink.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(Config.GetKeyURL)
        StatusMsg.TextColor3 = Color3.fromRGB(0, 220, 140)
        StatusMsg.Text = "Key URL copied to clipboard"
        task.delay(3, function()
            if StatusMsg and StatusMsg.Text:find("copied") then
                StatusMsg.Text = ""
            end
        end)
    end
end)

-- Clear Key Action
ClearKeyLink.MouseButton1Click:Connect(function()
    pcall(function()
        if delfile then delfile("ProjectXinzKey.txt") end
    end)
    KeyTextBox.Text = ""
    StatusMsg.TextColor3 = Color3.fromRGB(255, 180, 60)
    StatusMsg.Text = "Saved key cleared"
    task.delay(2, function()
        if StatusMsg and StatusMsg.Text == "Saved key cleared" then
            StatusMsg.Text = ""
        end
    end)
end)

-- ════════════════════════════════════════════════════════════
-- // Entrance Sequence
-- ════════════════════════════════════════════════════════════
TweenService:Create(Blur, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 26}):Play()
TweenService:Create(Overlay, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.35}):Play()

task.wait(0.2)
KeyWindow.Visible = true
KeyWindow.Size = UDim2.new(0, 420, 0, 20)
KeyWindow.BackgroundTransparency = 1

TweenService:Create(KeyWindow, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 420, 0, 320),
    BackgroundTransparency = 0.35
}):Play()

-- Pulse Logo Ambient Loop
task.spawn(function()
    while KeyWindow and KeyWindow.Parent do
        TweenService:Create(HeaderLogo, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 45, 0, 45)
        }):Play()
        task.wait(1.8)
        TweenService:Create(HeaderLogo, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 40, 0, 40)
        }):Play()
        task.wait(1.8)
    end
end)

-- ════════════════════════════════════════════════════════════
-- // Custom Profile Image Loader
-- ════════════════════════════════════════════════════════════
local function LoadCustomImage(url, fileName)
    if not url or url == "" then return "" end
    if not isfile or not writefile or not getcustomasset then return url end

    local success, imageData = pcall(function()
        return game:HttpGet(url)
    end)
    if not success or not imageData then return url end

    pcall(function() writefile(fileName, imageData) end)
    local assetOk, assetId = pcall(function() return getcustomasset(fileName) end)
    if assetOk and assetId then return assetId end
    return url
end

-- ════════════════════════════════════════════════════════════
-- // Key Verification Network Function
-- ════════════════════════════════════════════════════════════
local function verifyKey(key)
    local rbx_user = "Unknown"
    local rbx_id = 0
    pcall(function()
        if LocalPlayer then
            rbx_user = LocalPlayer.Name
            rbx_id = LocalPlayer.UserId
        end
    end)

    local success, result = pcall(function()
        local response = game:HttpGet(
            Config.KeyVerifyURL .. "?k=" .. key .. "&rbx_user=" .. rbx_user .. "&rbx_id=" .. tostring(rbx_id),
            true
        )
        return HttpService:JSONDecode(response)
    end)

    if not success then
        local ok2, result2 = pcall(function()
            local body = HttpService:JSONEncode({ key = key, rbx_user = rbx_user, rbx_id = rbx_id })
            local resp = HttpService:PostAsync(Config.KeyVerifyURL, body, Enum.HttpContentType.ApplicationJson)
            return HttpService:JSONDecode(resp)
        end)
        if ok2 and result2 then return result2 end
    end

    if success and result then return result end
    return { valid = false, message = "Connection failed. Please check network." }
end

-- ════════════════════════════════════════════════════════════
-- // Smooth Progress Update Helper
-- ════════════════════════════════════════════════════════════
local function setProgress(percent, duration, statusText)
    if statusText then LoadStatus.Text = statusText end
    local tween = TweenService:Create(ProgressBarFill, TweenInfo.new(duration or 0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(math.clamp(percent, 0, 1), 0, 1, 0)
    })
    tween:Play()
    
    -- Animate percentage number smoothly
    task.spawn(function()
        local startTime = tick()
        local cur = tonumber(PercentLabel.Text:match("%d+")) or 0
        local target = math.floor(percent * 100)
        while tick() - startTime < (duration or 0.6) do
            local alpha = (tick() - startTime) / (duration or 0.6)
            local val = math.floor(cur + (target - cur) * alpha)
            PercentLabel.Text = tostring(val) .. "%"
            RunService.RenderStepped:Wait()
        end
        PercentLabel.Text = tostring(target) .. "%"
    end)
    return tween
end

-- ════════════════════════════════════════════════════════════
-- // Verification & Loading Execution
-- ════════════════════════════════════════════════════════════
local keyVerified = false

local function onConfirm()
    if keyVerified then return end

    local key = KeyTextBox.Text:match("^%s*(.-)%s*$")
    if key == "" then
        StatusMsg.TextColor3 = Color3.fromRGB(255, 80, 80)
        StatusMsg.Text = "Please enter a license key"
        return
    end

    -- Visual loading state
    VerifyBtn.Text = "VERIFYING KEY..."
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    VerifyBtn.Active = false
    KeyTextBox.TextEditable = false
    StatusMsg.TextColor3 = Color3.fromRGB(200, 200, 220)
    StatusMsg.Text = "Checking key with authorization server..."

    local result = verifyKey(key)

    if result and result.valid then
        keyVerified = true
        
        -- Cache valid key locally
        pcall(function()
            if writefile then writefile("ProjectXinzKey.txt", key) end
        end)

        if result.profile then
            getgenv().KeyUsername = result.profile.username
            getgenv().KeyEmail = result.profile.email
            getgenv().KeyAvatar = result.profile.avatar_url
            
            if getgenv().KeyAvatar and getgenv().KeyAvatar ~= "" then
                local userId = (LocalPlayer and LocalPlayer.UserId) or 0
                local fileName = "ProjectXinz_Profile_" .. tostring(userId) .. ".png"
                getgenv().KeyAvatarAsset = LoadCustomImage(getgenv().KeyAvatar, fileName)
            end
        end

        StatusMsg.TextColor3 = Color3.fromRGB(0, 230, 140)
        StatusMsg.Text = result.message or "Key verified successfully"
        VerifyBtn.Text = "ACCESS GRANTED"
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 190, 110)

        task.wait(0.6)

        -- Transition Out Key Window
        TweenService:Create(KeyWindow, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 420, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.4)
        KeyWindow.Visible = false

        -- ════════════════════════════════════════════════════════
        -- // Show Premium Loading Card
        -- ════════════════════════════════════════════════════════
        LoadingCard.Visible = true
        LoadingCard.Size = UDim2.new(0, 400, 0, 0)
        LoadingCard.BackgroundTransparency = 1

        TweenService:Create(LoadingCard, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 400, 0, 280),
            BackgroundTransparency = 0.35
        }):Play()

        -- Fast Smooth Spinner Rotation Loop (Active loader spinning)
        task.spawn(function()
            while LoadingCard and LoadingCard.Parent and LoadingCard.Visible do
                SpinnerRing.Rotation = (SpinnerRing.Rotation + 4.5) % 360
                RunService.RenderStepped:Wait()
            end
        end)

        -- Step 1: Initialize System
        setProgress(0.20, 0.6, "Validating Client Authorization...")
        task.wait(0.7)

        -- Step 2: Detect Target Game
        local GameName = SupportedGames[tostring(PlaceId)]

        -- Fallback detection
        if not GameName then
            local rs = game:GetService("ReplicatedStorage")
            if rs:FindFirstChild("Remotes") and rs.Remotes:FindFirstChild("CommF_") then
                GameName = "Blox Fruits"
            elseif workspace:FindFirstChild("Normal") and workspace:FindFirstChild("Lobby") and rs:FindFirstChild("Trade") then
                GameName = "Murder Mystery 2"
            end
        end

        if GameName then
            GameBadgeText.Text = GameName
            GameBadgeDot.BackgroundColor3 = Color3.fromRGB(0, 230, 140)
            
            setProgress(0.50, 0.8, "Game Profile Linked: " .. GameName)
            task.wait(0.9)

            -- Step 3: Fetch Scripts
            setProgress(0.85, 0.9, "Downloading Engine Payload...")
            task.wait(1.0)

            -- Step 4: Finalize
            setProgress(1.0, 0.5, "Execution Ready")
            LoadTitle.Text = "ProjectXinz LOADED"
            LoadTitle.TextColor3 = Config.MainColor

            task.wait(0.8)

            -- Fade Out UI Smoothly
            TweenService:Create(Blur, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Size = 0}):Play()
            TweenService:Create(Overlay, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
            TweenService:Create(LoadingCard, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 360, 0, 0),
                BackgroundTransparency = 1
            }):Play()

            task.wait(0.6)
            LoaderUI:Destroy()
            Blur:Destroy()

            -- ════════════════════════════════════════════════════
            -- // Execute Game Payload
            -- ════════════════════════════════════════════════════
            if GameName == "Blox Fruits" then
                local ok, err = pcall(function()
                    loadstring(game:HttpGet(Config.BFTargetScript))()
                end)
                if not ok then warn("[ProjectXinz Loader] Blox Fruits Script Error: " .. tostring(err)) end
            elseif GameName == "Murder Mystery 2" then
                local ok, err = pcall(function()
                    loadstring(game:HttpGet(Config.MM2TargetScript))()
                end)
                if not ok then warn("[ProjectXinz Loader] MM2 Script Error: " .. tostring(err)) end
            elseif GameName == "Mine a Mountain" then
                local success, err = pcall(function()
                    loadstring(game:HttpGet(Config.MineMountainTargetScript))()
                end)
                if not success then warn("[ProjectXinz Loader] Mine a Mountain Script Error: " .. tostring(err)) end
            elseif GameName == "Laundry Simulator" then
                local success, err = pcall(function()
                    loadstring(game:HttpGet(Config.LaundrySimulatorTargetScript))()
                end)
                if not success then warn("[ProjectXinz Loader] Laundry Simulator Script Error: " .. tostring(err)) end
            elseif GameName == "The Walking Dead" then
                local success, err = pcall(function()
                    loadstring(game:HttpGet(Config.TWDTargetScript))()
                end)
                if not success then warn("[ProjectXinz Loader] The Walking Dead Script Error: " .. tostring(err)) end
            elseif GameName == "Fisch" then
                local success, err = pcall(function()
                    loadstring(game:HttpGet(Config.FischTargetScript))()
                end)
                if not success then warn("[ProjectXinz Loader] Fisch Script Error: " .. tostring(err)) end
            elseif GameName == "Cali Shootout" then
                local success, err = pcall(function()
                    loadstring(game:HttpGet(Config.CaliShootoutTargetScript))()
                end)
                if not success then warn("[ProjectXinz Loader] Cali Shootout Script Error: " .. tostring(err)) end
            end
        else
            -- Game not supported
            GameBadgeText.Text = "Unsupported Game"
            GameBadgeDot.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
            LoadTitle.Text = "GAME NOT SUPPORTED"
            LoadTitle.TextColor3 = Color3.fromRGB(255, 70, 70)
            
            setProgress(1.0, 0.4, "PlaceId " .. tostring(PlaceId) .. " is not registered")
            ProgressBarFill.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
            
            task.wait(2.5)
            
            TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 0}):Play()
            TweenService:Create(Overlay, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
            TweenService:Create(LoadingCard, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
            
            task.wait(0.5)
            LoaderUI:Destroy()
            Blur:Destroy()
        end
    else
        -- Key Error handling with shake effect
        VerifyBtn.Text = "VERIFY & LOAD"
        VerifyBtn.BackgroundColor3 = Config.MainColor
        VerifyBtn.Active = true
        KeyTextBox.TextEditable = true

        local msg = (result and result.message) or "Invalid license key"
        StatusMsg.TextColor3 = Color3.fromRGB(255, 75, 75)
        StatusMsg.Text = msg

        -- Horizontal Shake Animation
        local origPos = KeyWindow.Position
        for i = 1, 4 do
            TweenService:Create(KeyWindow, TweenInfo.new(0.05), {
                Position = UDim2.new(0.5, (i % 2 == 0 and 10 or -10), 0.5, 0)
            }):Play()
            task.wait(0.06)
        end
        TweenService:Create(KeyWindow, TweenInfo.new(0.1), {Position = origPos}):Play()

        -- Glow red border briefly
        TweenService:Create(KeyWindowStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(255, 70, 70),
            Transparency = 0
        }):Play()

        task.delay(1.5, function()
            if KeyWindowStroke then
                TweenService:Create(KeyWindowStroke, TweenInfo.new(0.4), {
                    Color = Config.BorderColor,
                    Transparency = 0.2
                }):Play()
            end
        end)
    end
end

VerifyBtn.MouseButton1Click:Connect(onConfirm)

KeyTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        onConfirm()
    end
end)
