-- ==============================================================================
--  Project XINZ X - Basketball Hub (Native Standalone Clean UI Edition)
--  Clean Modern UI (No Emojis, Standardized Typography)
--  Created by K2NTA ST | Project Singularity
-- ==============================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = (pcall(function() return game:GetService("VirtualInputManager") end) and game:GetService("VirtualInputManager")) or nil

local LocalPlayer = Players.LocalPlayer

-- Prevent multiple script executions (Anti-Overlap)
local env = (getgenv and getgenv()) or _G
local runId = tick()
env.BasketballXINZ_RunID = runId

if env.BasketballXINZ_Cleanup then
    pcall(env.BasketballXINZ_Cleanup)
end

pcall(function()
    for _, v in ipairs(CoreGui:GetChildren()) do
        if v.Name == "SingularityHoopsHub" then v:Destroy() end
    end
    if LocalPlayer:FindFirstChild("PlayerGui") then
        for _, v in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
            if v.Name == "SingularityHoopsHub" then v:Destroy() end
        end
    end
end)

-- 1. Safely retrieve game controllers with dynamic reload support (Dynamic Safe Loader) --
local Knit = nil
local function initKnit()
    if not Knit then
        pcall(function()
            if ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Knit") then
                local kClient = ReplicatedStorage.Packages.Knit:FindFirstChild("KnitClient") or ReplicatedStorage.Packages.Knit
                Knit = require(kClient)
            end
        end)
    end
    return Knit
end
initKnit()

local function getSafeController(name)
    local ctrl = nil
    initKnit()
    if Knit and Knit.GetController then
        pcall(function() ctrl = Knit.GetController(name) end)
    end
    if not ctrl and ReplicatedStorage:FindFirstChild("Controllers") then
        local mod = ReplicatedStorage.Controllers:FindFirstChild(name)
        if mod and mod:IsA("ModuleScript") then
            pcall(function() ctrl = require(mod) end)
        end
    end
    return ctrl
end

local BallController      = getSafeController("BallController")
local DefenseController   = getSafeController("DefenseController")
local AbilityController   = getSafeController("AbilityController")
local AwakeningController = getSafeController("AwakeningController")
local MovementController  = getSafeController("MovementController")
local MatchController     = getSafeController("MatchController")
local CourtController     = getSafeController("CourtController")

-- 
local Config = {
    AutoGetBall = false,
    GetBallMode = "TP",        -- "TP" (Instant Teleport) or "Fly" (Fly Mode)
    FlySpeed = 55,
            Config.BallESP = false
    InstantShoot = true,       -- Instant Shoot (Simulate click + 100% hoop score teleport)
            Config.AutoShoot = false
    AutoPerfectShoot = true,   -- 100% score from anywhere (Teleport above rim and drop)
    DoubleClickShoot = true,   -- Simulate double-click for shooting
    InstantShootKey = "E",     -- Instant shoot hotkey [E] or [F]
    ShootMode = "Instant",     -- "Instant" (Teleport above hoop and drop)
    ClickHoldTime = 0.12,      -- Click charge duration in seconds
    TeleportHeight = 9.0,      -- Height above hoop rim in studs
    AutoFaceNet = false,       -- Automatically face the hoop when shooting
    AutoBlock = false,
    AutoBlockRange = 14,
    AutoSteal = false,
    AutoStealRange = 15,
    StealCooldown = 0.25,
    BlockCooldown = 0.6,
    SpeedEnabled = false,
    CustomSpeed = 28,
    SpeedMethod = "Hybrid",    -- "Hybrid", "CFrame", "Velocity", "WalkSpeed"
    InfJump = false,
    Noclip = false,
    AntiAFK = true
}

-- 2. Team Check System -----------------------------------------
local function isTeammate(player)
    if not player or player == LocalPlayer then return true end
    if LocalPlayer.Team and player.Team then return LocalPlayer.Team == player.Team end
    if LocalPlayer.TeamColor and player.TeamColor then return LocalPlayer.TeamColor == player.TeamColor end
    if LocalPlayer.Character and player.Character then
        local myTeam = LocalPlayer.Character:GetAttribute("Team") or LocalPlayer:GetAttribute("Team")
        local targetTeam = player.Character:GetAttribute("Team") or player:GetAttribute("Team")
        if myTeam and targetTeam and myTeam == targetTeam then return true end
    end
    return false
end

-- 3. Prevent game WalkSpeed reset (Metamethod Hook) ------------
pcall(function()
    if hookmetamethod and checkcaller and newcclosure then
        local oldNewIndex
        oldNewIndex = hookmetamethod(game, "__newindex", newcclosure(function(self, prop, val)
            if not checkcaller() and Config.SpeedEnabled and tostring(prop) == "WalkSpeed" and self:IsA("Humanoid") then
                local char = LocalPlayer.Character
                if char and self:IsDescendantOf(char) then
                    return oldNewIndex(self, prop, Config.CustomSpeed)
                end
            end
            return oldNewIndex(self, prop, val)
        end))
    end
end)

-- 4. Game Loops & Multi-Layer Speed ----------------------------

-- Movement Tab
local renderConn = RunService.RenderStepped:Connect(function(dt)
    if env.BasketballXINZ_RunID ~= runId then return end
    local char = LocalPlayer.Character
    if not char then return end

    if Config.SpeedEnabled then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")

        if hum and hrp then
            hum.WalkSpeed = Config.CustomSpeed

            if hum.MoveDirection.Magnitude > 0 then
                local moveDir = hum.MoveDirection
                local extraSpeed = math.max(0, Config.CustomSpeed - 16)

                if Config.SpeedMethod == "CFrame" then
                    hrp.CFrame = hrp.CFrame + (moveDir * (extraSpeed * dt))
                elseif Config.SpeedMethod == "Velocity" then
                    local curY = (hrp.AssemblyLinearVelocity and hrp.AssemblyLinearVelocity.Y) or hrp.Velocity.Y
                    local targetVel = Vector3.new(moveDir.X * Config.CustomSpeed, curY, moveDir.Z * Config.CustomSpeed)
                    if hrp.AssemblyLinearVelocity then
                        hrp.AssemblyLinearVelocity = targetVel
                    else
                        hrp.Velocity = targetVel
                    end
                elseif Config.SpeedMethod == "Hybrid" then
                    hrp.CFrame = hrp.CFrame + (moveDir * (extraSpeed * dt * 0.4))
                    local curY = (hrp.AssemblyLinearVelocity and hrp.AssemblyLinearVelocity.Y) or hrp.Velocity.Y
                    local targetVel = Vector3.new(moveDir.X * (Config.CustomSpeed * 0.8), curY, moveDir.Z * (Config.CustomSpeed * 0.8))
                    if hrp.AssemblyLinearVelocity then
                        hrp.AssemblyLinearVelocity = targetVel
                    else
                        hrp.Velocity = targetVel
                    end
                end
            end
        end

        if MovementController then
            pcall(function()
                if MovementController.SetSpeed then MovementController:SetSpeed(Config.CustomSpeed) end
                if MovementController.Speed then MovementController.Speed = Config.CustomSpeed end
                if MovementController.SprintSpeed then MovementController.SprintSpeed = Config.CustomSpeed end
                if MovementController.BaseSpeed then MovementController.BaseSpeed = Config.CustomSpeed end
            end)
        end
    end
end)

-- 4.2 Noclip (Stepped)
local steppedConn = RunService.Stepped:Connect(function()
    if env.BasketballXINZ_RunID ~= runId then return end
    local char = LocalPlayer.Character
    if not char then return end

    if Config.Noclip then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end

    if Config.SpeedEnabled then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= Config.CustomSpeed then
            hum.WalkSpeed = Config.CustomSpeed
        end
    end
end)

-- 4.3 Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Config.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- 5. PERFECT SHOOT & BALL TRAJECTORY (100% Swish Score) --------
local function isAttachedToPlayer(item)
    if not item or not item.Parent then return true end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and item:IsDescendantOf(p.Character) then
            return true
        end
    end
    return false
end

-- Valid ball filter (excludes map decorations, ball racks, anchored parts)
local function isValidGameBall(part)
    if not part or not part:IsA("BasePart") or not part.Parent then return false end
    if isAttachedToPlayer(part) then return false end
    if part.Anchored then return false end -- Active basketball must not be anchored

    local name = part.Name:lower()
    local pName = part.Parent.Name:lower()

    -- 
    if name:find("spawn") or name:find("rack") or name:find("stand") or name:find("holder") or name:find("gui") or name:find("decal") or name:find("light") or name:find("shop") or name:find("display") or name:find("particle") or name:find("icon") or name:find("ring") or name:find("net") or name:find("rim") or name:find("hoop") or name:find("board") or name:find("post") or name:find("pole") or name:find("court") or name:find("floor") or name:find("ground") then
        return false
    end
    if pName:find("rack") or pName:find("stand") or pName:find("shop") or pName:find("display") or pName:find("hoop") or pName:find("court") then
        return false
    end

    -- Valid basketball dimensions (0.8 to 4.5 studs)
    local sz = part.Size
    if sz.X < 0.5 or sz.X > 5.0 or sz.Y < 0.5 or sz.Y > 5.0 or sz.Z < 0.5 or sz.Z > 5.0 then
        return false
    end

    return true
end

local function findFreeBasketball()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local myPos = myRoot and myRoot.Position

    -- 1.  BallController  ( 100%)
    if BallController then
        local b = BallController.Ball or BallController.CurrentBall or BallController._ball or BallController.BallInstance
        if b and typeof(b) == "Instance" and b.Parent then
            local p = b:IsA("BasePart") and b or b:FindFirstChildWhichIsA("BasePart")
            if p and isValidGameBall(p) then return p end
        end
        if BallController.GetBall then
            local success, b2 = pcall(function() return BallController:GetBall() end)
            if success and b2 and typeof(b2) == "Instance" and b2.Parent then
                local p2 = b2:IsA("BasePart") and b2 or b2:FindFirstChildWhichIsA("BasePart")
                if p2 and isValidGameBall(p2) then return p2 end
            end
        end
    end

    -- 2.  Workspace  ( 35 studs)
    local candidateBall = nil
    local minDistance = 35

    for _, folderName in ipairs({"Balls", "GameBalls", "Gameplay", "Court", "Visuals", "Debris"}) do
        local folder = workspace:FindFirstChild(folderName)
        if folder then
            for _, item in ipairs(folder:GetChildren()) do
                if isValidGameBall(item) and item.Name:lower():find("ball") then
                    if myPos then
                        local dist = (myPos - item.Position).Magnitude
                        if dist < minDistance then
                            minDistance = dist
                            candidateBall = item
                        end
                    else
                        return item
                    end
                end
            end
        end
    end

    if candidateBall then return candidateBall end

    -- 3.  Workspace 
    for _, item in ipairs(workspace:GetChildren()) do
        if isValidGameBall(item) and item.Name:lower():find("ball") then
            if myPos then
                local dist = (myPos - item.Position).Magnitude
                if dist < minDistance then
                    minDistance = dist
                    candidateBall = item
                end
            else
                return item
            end
        end
    end

    if candidateBall then return candidateBall end

    -- 4.  Descendants ()
    for _, item in ipairs(workspace:GetDescendants()) do
        if isValidGameBall(item) then
            local n = item.Name:lower()
            local pn = item.Parent.Name:lower()
            if (n:find("ball") or pn:find("ball")) then
                if myPos then
                    local dist = (myPos - item.Position).Magnitude
                    if dist < minDistance then
                        minDistance = dist
                        candidateBall = item
                    end
                else
                    return item
                end
            end
        end
    end

    return candidateBall
end

local function findBasketball()
    -- Find ball including possessed/held by players
    local char = LocalPlayer.Character
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("BasePart") and item.Name:lower():find("ball") then return item end
            if item:IsA("Tool") or item:IsA("Model") then
                local p = item:FindFirstChild("Handle") or item:FindFirstChildWhichIsA("BasePart")
                if p and (item.Name:lower():find("ball") or p.Name:lower():find("ball")) then return p end
            end
        end
    end
    return findFreeBasketball()
end

local hookedShoots = {}
local guideBallToHoop
local getNearestHoop

local function refreshAndHookControllers()
    BallController      = getSafeController("BallController") or BallController
    DefenseController   = getSafeController("DefenseController") or DefenseController
    AbilityController   = getSafeController("AbilityController") or AbilityController
    AwakeningController = getSafeController("AwakeningController") or AwakeningController
    MovementController  = getSafeController("MovementController") or MovementController
    MatchController     = getSafeController("MatchController") or MatchController
    CourtController     = getSafeController("CourtController") or CourtController
end

local function getExactHoopCenter(targetHoop)
    if not targetHoop or not targetHoop.Parent then return nil end
    local p = targetHoop.Parent
    if p and (p:IsA("Model") or p:IsA("Folder")) then
        for _, exactName in ipairs({"Swish", "swish", "Score", "score", "Trigger", "trigger", "Net", "net", "Rim", "rim", "Ring", "ring"}) do
            local found = p:FindFirstChild(exactName, true)
            if found and found:IsA("BasePart") then
                return found.Position
            end
        end
    end
    return targetHoop.Position
end

getNearestHoop = function()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    refreshAndHookControllers()

-- 1. Safely retrieve game controllers with dynamic reload support (Dynamic Safe Loader) --
    if BallController then
        if BallController.GetGoal then
            local success, g = pcall(function() return BallController:GetGoal() end)
            if success and g and g.Parent then
                local part = g:FindFirstChild("Swish", true) or g:FindFirstChild("Score", true) or g:FindFirstChild("Trigger", true) or g:FindFirstChild("Net", true) or g:FindFirstChild("Rim", true) or g:FindFirstChild("Ring", true) or (g:IsA("BasePart") and g) or g:FindFirstChildWhichIsA("BasePart")
                if part then return part end
            end
        end
        if BallController.Goal and typeof(BallController.Goal) == "Instance" and BallController.Goal.Parent then
            local part = BallController.Goal:FindFirstChild("Swish", true) or BallController.Goal:FindFirstChild("Score", true) or BallController.Goal:FindFirstChild("Trigger", true) or BallController.Goal:FindFirstChild("Net", true) or BallController.Goal:FindFirstChild("Rim", true) or BallController.Goal:FindFirstChild("Ring", true) or (BallController.Goal:IsA("BasePart") and BallController.Goal) or BallController.Goal:FindFirstChildWhichIsA("BasePart")
            if part then return part end
        end
    end

    if MatchController and MatchController.GetAttackingGoal then
        local success, g = pcall(function() return MatchController:GetAttackingGoal() end)
        if success and g and g.Parent then
            local part = g:FindFirstChild("Swish", true) or g:FindFirstChild("Score", true) or g:FindFirstChild("Trigger", true) or g:FindFirstChild("Net", true) or g:FindFirstChild("Rim", true) or g:FindFirstChild("Ring", true) or (g:IsA("BasePart") and g) or g:FindFirstChildWhichIsA("BasePart")
            if part then return part end
        end
    end

-- Exclude backboard, poles, or support structures
    local closestHoop = nil
    local minDistance = math.huge

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Parent then
            local name = obj.Name:lower()
-- Exclude backboard, poles, or support structures
            if not name:find("backboard") and not name:find("board") and not name:find("pole") and not name:find("stand") and not name:find("support") and not name:find("post") and not name:find("glass") then
                if name:find("swish") or name:find("score") or name:find("trigger") or name == "rim" or name:find("rim") or name == "net" or name:find("net") or name == "ring" or name:find("ring") then
                    if obj.Position.Y > 4 then
                        local dist = (myRoot.Position - obj.Position).Magnitude
                        if dist < minDistance then
                            minDistance = dist
                            closestHoop = obj
                        end
                    end
                end
            end
        end
    end

    if closestHoop then return closestHoop end

    --  ()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Parent then
            local name = obj.Name:lower()
            if not name:find("backboard") and not name:find("board") and not name:find("pole") and not name:find("stand") then
                if name:find("hoop") or name:find("goal") or name:find("basket") then
                    if obj.Position.Y > 4 then
                        local dist = (myRoot.Position - obj.Position).Magnitude
                        if dist < minDistance then
                            minDistance = dist
                            closestHoop = obj
                        end
                    end
                end
            end
        end
    end

    return closestHoop
end

local lastLocalShootTime = 0
local isGuidingBall = false

-- :  100%
-- Ball Trajectory Guide: Teleport released ball above rim and drop through net 100%
guideBallToHoop = function(targetHoop)
    if not (Config.InstantShoot or Config.AutoPerfectShoot) then return end
    targetHoop = targetHoop or getNearestHoop()
    if not targetHoop or not targetHoop.Parent then return end

    if isGuidingBall and (tick() - lastLocalShootTime < 1.0) then return end
    isGuidingBall = true
    lastLocalShootTime = tick()

    task.spawn(function()
        local ball = nil
        --  Free Ball  Workspace ( 2.5 )
        for _ = 1, 150 do
            ball = findFreeBasketball()
            if ball and ball.Parent and not isAttachedToPlayer(ball) then break end
            task.wait(0.015)
        end

        if ball and targetHoop and targetHoop.Parent then
            local rimPos = getExactHoopCenter(targetHoop)
            local spawnHeight = Config.TeleportHeight or 9.0

            --  CanCollide  100% 
            local oldCanCollide = ball.CanCollide
            pcall(function() ball.CanCollide = false end)

            -- 1. Teleport ball directly above hoop center
            local aboveRimPos = Vector3.new(rimPos.X, rimPos.Y + spawnHeight, rimPos.Z)
            ball.CFrame = CFrame.new(aboveRimPos)

            local downVelocity = Vector3.new(0, -35, 0)
            if ball.AssemblyLinearVelocity then
                ball.AssemblyLinearVelocity = downVelocity
                ball.AssemblyAngularVelocity = Vector3.zero
            else
                ball.Velocity = downVelocity
                ball.RotVelocity = Vector3.zero
            end

            -- 2. Step drop vertically through net center
            local dropYOffsets = {
                spawnHeight * 0.75,
                spawnHeight * 0.50,
                spawnHeight * 0.25,
                2.0,   -- Above rim
                0.8,   -- At rim level
                0.0,   -- Hoop center
                -1.0,  -- Inside net
                -2.5   -- Below net exit
            }

            for _, yOff in ipairs(dropYOffsets) do
                if not ball or not ball.Parent or not targetHoop.Parent then break end

                --  X  Z  100% 
                ball.CFrame = CFrame.new(Vector3.new(rimPos.X, rimPos.Y + yOff, rimPos.Z))

                if ball.AssemblyLinearVelocity then
                    ball.AssemblyLinearVelocity = downVelocity
                    ball.AssemblyAngularVelocity = Vector3.zero
                else
                    ball.Velocity = downVelocity
                    ball.RotVelocity = Vector3.zero
                end

                task.wait(0.018)
            end

            --  CanCollide 
            task.wait(0.1)
            pcall(function() ball.CanCollide = oldCanCollide end)
        end
        isGuidingBall = false
    end)
end

--  BallController.Shoot 
refreshAndHookControllers()

-- Shoot animation detection & re-bind on round reset
local function bindCharacter(char)
    if not char then return end
    isGuidingBall = false
    lastLocalShootTime = 0
    refreshAndHookControllers()

    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        local animator = hum:WaitForChild("Animator", 3) or hum
        if animator then
            animator.AnimationPlayed:Connect(function(track)
                if not (Config.InstantShoot or Config.AutoPerfectShoot) then return end
                local anim = track.Animation
                local animName = (anim and anim.Name:lower()) or ""
                if animName:find("shoot") or animName:find("shot") or animName:find("jumpshot") or animName:find("fadeaway") or animName:find("stepback") or animName:find("pullup") then
                    task.spawn(function()
                        task.wait(0.04)
                        guideBallToHoop()
                    end)
                end
            end)
        end
    end
end

if LocalPlayer.Character then
    task.spawn(function() bindCharacter(LocalPlayer.Character) end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.spawn(function()
        task.wait(0.15)
        bindCharacter(char)
        if Config.BallESP then
            pcall(updateBallESP)
        end
    end)
end)

-- Continuous shoot detection and controller refresh listener
task.spawn(function()
    local hadBall = false
    local refreshCounter = 0
    while true do
        task.wait(0.02)
        if env.BasketballXINZ_RunID ~= runId then break end

        refreshCounter = refreshCounter + 1
        if refreshCounter >= 50 then
            refreshCounter = 0
            refreshAndHookControllers()
        end

        local hasBall = false
        if BallController and BallController.LocalPlayerPossessesBall then
            pcall(function() hasBall = BallController:LocalPlayerPossessesBall() end)
        end

        if hadBall and not hasBall and (Config.InstantShoot or Config.AutoPerfectShoot) then
            task.spawn(function()
                guideBallToHoop()
            end)
        end
        hadBall = hasBall
    end
end)

local function simulateMouseClick(holdTime)
    holdTime = holdTime or Config.ClickHoldTime or 0.12
    local mousePos = Vector2.new(400, 300)
    pcall(function()
        if workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize then
            local vs = workspace.CurrentCamera.ViewportSize
            mousePos = Vector2.new(vs.X / 2, vs.Y / 2)
        elseif UserInputService and UserInputService.GetMouseLocation then
            mousePos = UserInputService:GetMouseLocation()
        end
    end)

    -- Step 1: Send mouse button down event
    pcall(function()
        if VirtualInputManager then
            VirtualInputManager:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, true, game, 0)
        end
    end)
    pcall(function()
        if mouse1press then
            mouse1press()
        end
    end)
    pcall(function()
        if VirtualUser then
            VirtualUser:CaptureController()
            VirtualUser:Button1Down(Vector2.new(mousePos.X, mousePos.Y))
        end
    end)

    -- Step 2: Hold charge duration
    task.wait(holdTime)

    -- Step 3: Send mouse button up event
    pcall(function()
        if VirtualInputManager then
            VirtualInputManager:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, false, game, 0)
        end
    end)
    pcall(function()
        if mouse1release then
            mouse1release()
        elseif mouse1click then
            mouse1click()
        end
    end)
    pcall(function()
        if VirtualUser then
            VirtualUser:Button1Up(Vector2.new(mousePos.X, mousePos.Y))
        end
    end)
end

local function executePerfectShot()
    local hoop = getNearestHoop()
    lastLocalShootTime = tick()

    -- 1. Face the hoop if AutoFaceNet is enabled
    if Config.AutoFaceNet and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myRoot = LocalPlayer.Character.HumanoidRootPart
        if AbilityController and AbilityController.LookingAtNet then
            pcall(function() AbilityController:LookingAtNet() end)
        end
        if hoop then
            myRoot.CFrame = CFrame.new(myRoot.Position, Vector3.new(hoop.Position.X, myRoot.Position.Y, hoop.Position.Z))
        end
    end

    -- 2. 
    local hold = Config.ClickHoldTime or 0.12
    simulateMouseClick(hold)
    if Config.DoubleClickShoot then
        task.wait(0.2)
        simulateMouseClick(hold)
    end

    -- 3. Trigger ball trajectory guide after release
    if Config.AutoPerfectShoot then
        guideBallToHoop(hoop)
    end
end

-- 5.0 Auto Shoot on Possession
task.spawn(function()
    local isAutoShootingPossess = false
    while true do
        task.wait(0.05)
        if env.BasketballXINZ_RunID ~= runId then break end
        if Config.AutoShoot and not isAutoShootingPossess then
            local hasBall = false
            if BallController and BallController.LocalPlayerPossessesBall then
                pcall(function() hasBall = BallController:LocalPlayerPossessesBall() end)
            end
            if hasBall and (tick() - lastLocalShootTime > 1.2) then
                isAutoShootingPossess = true
                task.wait(0.08)
                executePerfectShot()
                task.wait(0.8)
                isAutoShootingPossess = false
            end
        end
    end
end)

-- 5.1 Auto Get Ball (Collect free balls only)
task.spawn(function()
    while true do
        task.wait(0.03)
        if env.BasketballXINZ_RunID ~= runId then break end
        if Config.AutoGetBall and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                if tick() - lastLocalShootTime < 2.5 then return end

                local hasBall = BallController and BallController.LocalPlayerPossessesBall and BallController:LocalPlayerPossessesBall()
                if not hasBall then
                    local ballHolder = BallController and BallController.GetPlayerPossessingBall and BallController:GetPlayerPossessingBall()
                    
                    local isShootingState = false
                    if BallController then
                        if BallController.BallIFrameIsActive and BallController:BallIFrameIsActive() then
                            isShootingState = true
                        elseif BallController.BallTeamIFrameIsActive and BallController:BallTeamIFrameIsActive() then
                            isShootingState = true
                        elseif BallController.BallSpeedIsLessThan and not BallController:BallSpeedIsLessThan(35) then
                            isShootingState = true
                        end
                    end

                    if not ballHolder and not isShootingState then
                        local ballPos = nil
                        local ballObj = nil
                        if BallController and BallController.GetServerBallPosition then
                            ballPos = BallController:GetServerBallPosition()
                        end

                        if not ballPos or ballPos == Vector3.new(0, 0, 0) then
                            for _, item in pairs(workspace:GetChildren()) do
                                if item.Name:lower():find("ball") and item:IsA("BasePart") then
                                    ballPos = item.Position
                                    ballObj = item
                                    break
                                end
                            end
                        end

                        if ballObj and (ballObj.AssemblyLinearVelocity or ballObj.Velocity) then
                            local speed = (ballObj.AssemblyLinearVelocity or ballObj.Velocity).Magnitude
                            if speed > 35 then return end
                        end

                        if ballPos then
                            local myRoot = LocalPlayer.Character.HumanoidRootPart
                            local dist = (myRoot.Position - ballPos).Magnitude
                            if dist > 1.5 then
                                if Config.GetBallMode == "Fly" then
                                    local dir = (ballPos - myRoot.Position).Unit
                                    myRoot.Velocity = dir * Config.FlySpeed
                                    myRoot.CFrame = CFrame.new(myRoot.Position, Vector3.new(ballPos.X, myRoot.Position.Y, ballPos.Z))
                                else
                                    myRoot.CFrame = CFrame.new(ballPos.X, ballPos.Y + 1.2, ballPos.Z)
                                    myRoot.Velocity = Vector3.new(0, 0, 0)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 5.2 Auto Steal
local lastStealTime = 0
task.spawn(function()
    while true do
        task.wait(0.05)
        if env.BasketballXINZ_RunID ~= runId then break end
        if Config.AutoSteal and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                if tick() - lastStealTime < Config.StealCooldown then return end
                local myPos = LocalPlayer.Character.HumanoidRootPart.Position

                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and not isTeammate(player) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local targetPos = player.Character.HumanoidRootPart.Position
                        local dist = (myPos - targetPos).Magnitude

                        if dist <= Config.AutoStealRange then
                            local enemyHasBall = false
                            if BallController and BallController.GetPlayerPossessingBall then
                                enemyHasBall = (BallController:GetPlayerPossessingBall() == player)
                            end

                            if not enemyHasBall then
                                for _, item in pairs(player.Character:GetDescendants()) do
                                    if item.Name:lower():find("ball") and item:IsA("BasePart") then
                                        enemyHasBall = true
                                        break
                                    end
                                end
                            end

                            if enemyHasBall then
                                lastStealTime = tick()
                                if DefenseController and DefenseController.Input then
                                    DefenseController:Input("Steal")
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 5.3 Auto Block
local lastBlockTime = 0
task.spawn(function()
    while true do
        task.wait(0.04)
        if env.BasketballXINZ_RunID ~= runId then break end
        if Config.AutoBlock and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                if tick() - lastBlockTime < Config.BlockCooldown then return end
                local myPos = LocalPlayer.Character.HumanoidRootPart.Position

                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and not isTeammate(player) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local enemyChar = player.Character
                        local targetPos = enemyChar.HumanoidRootPart.Position
                        local dist = (myPos - targetPos).Magnitude

                        if dist <= Config.AutoBlockRange then
                            local isEnemyShooting = false
                            local enemyHum = enemyChar:FindFirstChildOfClass("Humanoid")
                            
                            if enemyHum then
                                local state = enemyHum:GetState()
                                if state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall then
                                    local enemyBall = false
                                    if BallController and BallController.GetPlayerPossessingBall then
                                        enemyBall = (BallController:GetPlayerPossessingBall() == player)
                                    end
                                    if not enemyBall then
                                        for _, item in pairs(enemyChar:GetDescendants()) do
                                            if item.Name:lower():find("ball") and item:IsA("BasePart") then
                                                enemyBall = true
                                                break
                                            end
                                        end
                                    end
                                    if enemyBall then isEnemyShooting = true end
                                end
                            end

                            if isEnemyShooting then
                                lastBlockTime = tick()
                                local myHum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                                if myHum then myHum:ChangeState(Enum.HumanoidStateType.Jumping) end
                                if DefenseController and DefenseController.Input then
                                    DefenseController:Input("Block")
                                    DefenseController:Input("Contest")
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 5.4 Ball ESP
local function updateBallESP()
    for _, item in pairs(workspace:GetChildren()) do
        if item.Name:lower():find("ball") and item:IsA("BasePart") then
            local highlight = item:FindFirstChild("XINZ_BallHighlight")
            local billboard = item:FindFirstChild("XINZ_BallBillboard")

            if Config.BallESP then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "XINZ_BallHighlight"
                    highlight.FillColor = Color3.fromRGB(255, 140, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.35
                    highlight.OutlineTransparency = 0
                    highlight.Parent = item
                end

                if not billboard then
                    billboard = Instance.new("BillboardGui")
                    billboard.Name = "XINZ_BallBillboard"
                    billboard.Size = UDim2.new(0, 120, 0, 30)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.AlwaysOnTop = true
                    billboard.Parent = item

                    local label = Instance.new("TextLabel", billboard)
                    label.Name = "Label"
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = "Ball"
                    label.TextColor3 = Color3.fromRGB(255, 200, 0)
                    label.Font = Enum.Font.GothamBold
                    label.TextSize = 11
                    label.TextStrokeTransparency = 0.3
                end

                if billboard and billboard:FindFirstChild("Label") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - item.Position).Magnitude)
                    billboard.Label.Text = string.format("Ball [%dm]", dist)
                end
            else
                if highlight then highlight:Destroy() end
                if billboard then billboard:Destroy() end
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.2)
        if env.BasketballXINZ_RunID ~= runId then break end
        if Config.BallESP then
            pcall(updateBallESP)
        end
    end
end)

-- ==================================================================
-- // PROJECT XINZ X -- NATIVE STANDALONE SPRITESHEET ICON ENGINE
-- // 100% Self-Contained (Zero External Third-Party Dependencies)
-- ==================================================================
local XINZ_Icons = {
    Spritesheets = {
        ["1"]  = "rbxassetid://128927283736760",
        ["2"]  = "rbxassetid://81353574172342",
        ["3"]  = "rbxassetid://96693783610596",
        ["4"]  = "rbxassetid://71810268943113",
        ["5"]  = "rbxassetid://90615959421366",
        ["6"]  = "rbxassetid://139368732685813",
        ["7"]  = "rbxassetid://93333318277178",
        ["8"]  = "rbxassetid://133344323912973",
        ["9"]  = "rbxassetid://120008128000515",
        ["10"] = "rbxassetid://104497483720372",
        ["11"] = "rbxassetid://80140990251496",
        ["12"] = "rbxassetid://97131814650534",
        ["13"] = "rbxassetid://96078708260290",
        ["14"] = "rbxassetid://70903950566651",
        ["15"] = "rbxassetid://114026896479912",
        ["16"] = "rbxassetid://83367138989408",
    },
    Icons = {
        ["crosshair"]         = { ImageRectPosition = Vector2.new(384, 576), ImageRectSize = Vector2.new(96, 96), Image = 5 },
        ["target"]            = { ImageRectPosition = Vector2.new(288, 768), ImageRectSize = Vector2.new(96, 96), Image = 14 },
        ["shield"]            = { ImageRectPosition = Vector2.new(288, 192), ImageRectSize = Vector2.new(96, 96), Image = 13 },
        ["shield-check"]      = { ImageRectPosition = Vector2.new(480, 96),  ImageRectSize = Vector2.new(96, 96), Image = 13 },
        ["gauge"]             = { ImageRectPosition = Vector2.new(672, 672), ImageRectSize = Vector2.new(96, 96), Image = 7 },
        ["sliders-horizontal"]= { ImageRectPosition = Vector2.new(96, 480),  ImageRectSize = Vector2.new(96, 96), Image = 13 },
        ["rocket"]            = { ImageRectPosition = Vector2.new(672, 384), ImageRectSize = Vector2.new(96, 96), Image = 12 },
        ["play"]              = { ImageRectPosition = Vector2.new(864, 672), ImageRectSize = Vector2.new(96, 96), Image = 11 },
        ["info"]              = { ImageRectPosition = Vector2.new(768, 672), ImageRectSize = Vector2.new(96, 96), Image = 8 },
        ["bell"]              = { ImageRectPosition = Vector2.new(576, 480), ImageRectSize = Vector2.new(96, 96), Image = 2 },
        ["lock"]              = { ImageRectPosition = Vector2.new(672, 480), ImageRectSize = Vector2.new(96, 96), Image = 9 },
        ["check"]             = { ImageRectPosition = Vector2.new(384, 0),   ImageRectSize = Vector2.new(96, 96), Image = 4 },
        ["x"]                 = { ImageRectPosition = Vector2.new(864, 288), ImageRectSize = Vector2.new(96, 96), Image = 16 },
        ["search"]            = { ImageRectPosition = Vector2.new(480, 864), ImageRectSize = Vector2.new(96, 96), Image = 12 },
        ["flame"]             = { ImageRectPosition = Vector2.new(576, 96),  ImageRectSize = Vector2.new(96, 96), Image = 7 },
        ["zap"]               = { ImageRectPosition = Vector2.new(192, 384), ImageRectSize = Vector2.new(96, 96), Image = 16 },
        ["star"]              = { ImageRectPosition = Vector2.new(864, 288), ImageRectSize = Vector2.new(96, 96), Image = 14 },
        ["award"]             = { ImageRectPosition = Vector2.new(480, 0),   ImageRectSize = Vector2.new(96, 96), Image = 2 },
        ["trophy"]            = { ImageRectPosition = Vector2.new(288, 384), ImageRectSize = Vector2.new(96, 96), Image = 15 },
        ["activity"]          = { ImageRectPosition = Vector2.new(384, 0),   ImageRectSize = Vector2.new(96, 96), Image = 1 },
        ["mouse-pointer"]     = { ImageRectPosition = Vector2.new(864, 480), ImageRectSize = Vector2.new(96, 96), Image = 10 },
        ["settings"]          = { ImageRectPosition = Vector2.new(672, 0),   ImageRectSize = Vector2.new(96, 96), Image = 13 },
        ["shopping-cart"]     = { ImageRectPosition = Vector2.new(768, 96),  ImageRectSize = Vector2.new(96, 96), Image = 13 },
        ["keyboard"]          = { ImageRectPosition = Vector2.new(96, 384),  ImageRectSize = Vector2.new(96, 96), Image = 9 },
        ["key"]               = { ImageRectPosition = Vector2.new(0, 384),   ImageRectSize = Vector2.new(96, 96), Image = 9 },
        ["list"]              = { ImageRectPosition = Vector2.new(192, 480), ImageRectSize = Vector2.new(96, 96), Image = 9 },
        ["toggle-right"]      = { ImageRectPosition = Vector2.new(672, 288), ImageRectSize = Vector2.new(96, 96), Image = 15 },
        ["pen-tool"]          = { ImageRectPosition = Vector2.new(672, 480), ImageRectSize = Vector2.new(96, 96), Image = 11 },
    }
}

-- Load full local database if file exists
pcall(function()
    if isfile and isfile("icon.lua") then
        local fullDB = loadstring(readfile("icon.lua"))()
        if fullDB and fullDB.Icons and fullDB.Spritesheets then
            XINZ_Icons = fullDB
        end
    elseif isfile and isfile("lucide.lua") then
        local fullDB = loadstring(readfile("lucide.lua"))()
        if fullDB and fullDB.Icons and fullDB.Spritesheets then
            XINZ_Icons = fullDB
        end
    end
end)

local XINZ_AliasMap = {
    ["crosshair-stroke"] = "crosshair",
    ["shield-01-stroke"] = "shield",
    ["shield-check-02-stroke"] = "shield-check",
    ["speedmeter-01-stroke"] = "gauge",
    ["speedmeter-02-stroke"] = "gauge",
    ["speedmeter"] = "gauge",
    ["speed"] = "gauge",
    ["sliders"] = "sliders-horizontal",
    ["info-circle-stroke"] = "info",
    ["info-hexagon-stroke"] = "info",
    ["notification-stroke"] = "bell",
    ["notification"] = "bell",
    ["fire-stroke"] = "flame",
    ["fire"] = "flame",
    ["zap-stroke"] = "zap",
    ["play-stroke"] = "play",
    ["rocket-stroke"] = "rocket",
    ["football-stroke"] = "crosshair",
    ["football"] = "crosshair",
    ["cancel-forbidden-stroke"] = "x",
    ["close"] = "x",
    ["lock-01-stroke"] = "lock",
    ["star-rate-stroke"] = "star",
    ["prize-cup-stroke"] = "award",
    ["cog-settings-01-stroke"] = "settings",
}

local function getXINZIcon(iconName)
    if not iconName then return nil end
    local key = tostring(iconName):lower():gsub("^lucide%-", "")
    local mapped = XINZ_AliasMap[key] or key
    local data = XINZ_Icons.Icons[mapped] or XINZ_Icons.Icons[key]
    if not data then return nil end
    local sheetUrl = XINZ_Icons.Spritesheets[tostring(data.Image)]
    if not sheetUrl then return nil end
    return {
        Image = sheetUrl,
        RectOffset = data.ImageRectPosition or data.ImageRectOffset or Vector2.zero,
        RectSize = data.ImageRectSize or Vector2.new(96, 96),
    }
end

local function applyXINZIcon(imgLabel, iconName, tint)
    if not (imgLabel and iconName) then return false end
    local iconData = getXINZIcon(iconName)
    if not iconData then
        imgLabel.Visible = false
        return false
    end
    imgLabel.Image = iconData.Image
    imgLabel.ImageRectOffset = iconData.RectOffset
    imgLabel.ImageRectSize = iconData.RectSize
    if tint then imgLabel.ImageColor3 = tint end
    imgLabel.Visible = true
    return true
end

-- 6. NATIVE STANDALONE UI ENGINE (Clean Typography & Modern Minimal) --
local Library = {}

function Library:Window(options)
    options = options or {}
    local Title = options.Title or "Project XINZ X - Hoops Hub"
    local Desc = options.Desc or ""
    local Profile = options.Profile or {}
    local ProfileUsername = Profile.Username or LocalPlayer.DisplayName
    local ProfileEmail = Profile.Email or ("UID: " .. tostring(LocalPlayer.UserId))
    local ProfileAvatar = Profile.AvatarUrl or ("rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=150&h=150")
    local ToggleKey = (options.Config and options.Config.Keybind) or Enum.KeyCode.RightShift

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SingularityHoopsHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(ScreenGui)
            ScreenGui.Parent = CoreGui
        elseif gethui then
            ScreenGui.Parent = gethui()
        else
            ScreenGui.Parent = CoreGui
        end
    end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.fromOffset(590, 430)
    MainFrame.Position = UDim2.new(0.5, -295, 0.5, -215)
    MainFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 16)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner", MainFrame)
    MainCorner.CornerRadius = UDim.new(0, 10)

    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(55, 35, 18)
    MainStroke.Thickness = 1.2

    -- Dragging System
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Left Sidebar
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 175, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(9, 9, 12)
    Sidebar.BorderSizePixel = 0
    local SidebarCorner = Instance.new("UICorner", Sidebar)
    SidebarCorner.CornerRadius = UDim.new(0, 10)

    -- Profile Box
    local ProfileFrame = Instance.new("Frame", Sidebar)
    ProfileFrame.Size = UDim2.new(1, -16, 0, 50)
    ProfileFrame.Position = UDim2.new(0, 8, 0, 8)
    ProfileFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    local PCorner = Instance.new("UICorner", ProfileFrame)
    PCorner.CornerRadius = UDim.new(0, 8)

    local AvatarImg = Instance.new("ImageLabel", ProfileFrame)
    AvatarImg.Size = UDim2.fromOffset(36, 36)
    AvatarImg.Position = UDim2.new(0, 7, 0.5, -18)
    AvatarImg.BackgroundColor3 = Color3.fromRGB(28, 24, 20)
    AvatarImg.Image = ProfileAvatar
    local ACorner = Instance.new("UICorner", AvatarImg)
    ACorner.CornerRadius = UDim.new(1, 0)

    local UserLabel = Instance.new("TextLabel", ProfileFrame)
    UserLabel.Size = UDim2.new(1, -52, 0, 16)
    UserLabel.Position = UDim2.new(0, 48, 0, 9)
    UserLabel.BackgroundTransparency = 1
    UserLabel.Font = Enum.Font.GothamBold
    UserLabel.TextSize = 12
    UserLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    UserLabel.TextXAlignment = Enum.TextXAlignment.Left
    UserLabel.TextTruncate = Enum.TextTruncate.AtEnd
    UserLabel.Text = ProfileUsername

    local UidLabel = Instance.new("TextLabel", ProfileFrame)
    UidLabel.Size = UDim2.new(1, -52, 0, 14)
    UidLabel.Position = UDim2.new(0, 48, 0, 26)
    UidLabel.BackgroundTransparency = 1
    UidLabel.Font = Enum.Font.GothamMedium
    UidLabel.TextSize = 10
    UidLabel.TextColor3 = Color3.fromRGB(160, 150, 140)
    UidLabel.TextXAlignment = Enum.TextXAlignment.Left
    UidLabel.TextTruncate = Enum.TextTruncate.AtEnd
    UidLabel.Text = ProfileEmail

    -- Tab Buttons
    local TabButtonContainer = Instance.new("ScrollingFrame", Sidebar)
    TabButtonContainer.Size = UDim2.new(1, -12, 1, -70)
    TabButtonContainer.Position = UDim2.new(0, 6, 0, 64)
    TabButtonContainer.BackgroundTransparency = 1
    TabButtonContainer.ScrollBarThickness = 2
    TabButtonContainer.BorderSizePixel = 0
    local TabListLayout = Instance.new("UIListLayout", TabButtonContainer)
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Header
    local Header = Instance.new("Frame", MainFrame)
    Header.Size = UDim2.new(1, -185, 0, 44)
    Header.Position = UDim2.new(0, 180, 0, 0)
    Header.BackgroundTransparency = 1

    local TitleLabel = Instance.new("TextLabel", Header)
    TitleLabel.Size = UDim2.new(1, -40, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.TextColor3 = Color3.fromRGB(245, 245, 250)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Text = Title .. "  <font color='rgb(255,140,25)'>|</font> <font color='rgb(175,160,150)' size='11'>" .. Desc .. "</font>"
    TitleLabel.RichText = true

    local CloseBtn = Instance.new("TextButton", Header)
    CloseBtn.Size = UDim2.fromOffset(26, 26)
    CloseBtn.Position = UDim2.new(1, -34, 0.5, -13)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 18)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(220, 205, 195)
    CloseBtn.TextSize = 12
    local CBCorner = Instance.new("UICorner", CloseBtn)
    CBCorner.CornerRadius = UDim.new(0, 6)
    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
    end)

    -- Page Container
    local PageContainer = Instance.new("Frame", MainFrame)
    PageContainer.Size = UDim2.new(1, -190, 1, -54)
    PageContainer.Position = UDim2.new(0, 180, 0, 48)
    PageContainer.BackgroundTransparency = 1

    -- Notifications
    local NotifContainer = Instance.new("Frame", ScreenGui)
    NotifContainer.Size = UDim2.new(0, 260, 1, -20)
    NotifContainer.Position = UDim2.new(1, -270, 0, 10)
    NotifContainer.BackgroundTransparency = 1
    local NotifLayout = Instance.new("UIListLayout", NotifContainer)
    NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    NotifLayout.Padding = UDim.new(0, 6)

    local WindowObj = {}
    local tabs = {}

    function WindowObj:Notify(nOpt)
        nOpt = nOpt or {}
        local nTitle = nOpt.Title or "Notification"
        local nDesc = nOpt.Desc or ""
        local nTime = nOpt.Time or 3
        local nIcon = nOpt.Icon or "notification-stroke"

        local Card = Instance.new("Frame", NotifContainer)
        Card.Size = UDim2.new(1, 0, 0, 52)
        Card.BackgroundColor3 = Color3.fromRGB(18, 16, 14)
        local CCorner = Instance.new("UICorner", Card)
        CCorner.CornerRadius = UDim.new(0, 8)
        local CStroke = Instance.new("UIStroke", Card)
        CStroke.Color = Color3.fromRGB(255, 140, 25)
        CStroke.Thickness = 1

        local IconImg = Instance.new("ImageLabel", Card)
        IconImg.Size = UDim2.fromOffset(20, 20)
        IconImg.Position = UDim2.new(0, 10, 0.5, -10)
        IconImg.BackgroundTransparency = 1
        local hasNIcon = applyXINZIcon(IconImg, nIcon, Color3.fromRGB(255, 140, 25))

        local textLeft = hasNIcon and 36 or 10
        local textWidth = hasNIcon and -46 or -16

        local Txt1 = Instance.new("TextLabel", Card)
        Txt1.Size = UDim2.new(1, textWidth, 0, 16)
        Txt1.Position = UDim2.new(0, textLeft, 0, 6)
        Txt1.BackgroundTransparency = 1
        Txt1.Font = Enum.Font.GothamBold
        Txt1.TextSize = 12
        Txt1.TextColor3 = Color3.fromRGB(255, 140, 25)
        Txt1.TextXAlignment = Enum.TextXAlignment.Left
        Txt1.Text = nTitle

        local Txt2 = Instance.new("TextLabel", Card)
        Txt2.Size = UDim2.new(1, textWidth, 0, 22)
        Txt2.Position = UDim2.new(0, textLeft, 0, 24)
        Txt2.BackgroundTransparency = 1
        Txt2.Font = Enum.Font.GothamMedium
        Txt2.TextSize = 11
        Txt2.TextColor3 = Color3.fromRGB(230, 225, 220)
        Txt2.TextXAlignment = Enum.TextXAlignment.Left
        Txt2.TextTruncate = Enum.TextTruncate.AtEnd
        Txt2.Text = nDesc

        task.spawn(function()
            task.wait(nTime)
            TweenService:Create(Card, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            TweenService:Create(Txt1, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(Txt2, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(CStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            task.wait(0.35)
            Card:Destroy()
        end)
    end

    function WindowObj:Tab(tOpt)
        tOpt = tOpt or {}
        local tTitle = tOpt.Title or "Tab"
        local tIcon = tOpt.Icon

        local TabBtn = Instance.new("TextButton", TabButtonContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        local TBCorner = Instance.new("UICorner", TabBtn)
        TBCorner.CornerRadius = UDim.new(0, 6)

        local TabIconImg = Instance.new("ImageLabel", TabBtn)
        TabIconImg.Name = "Icon"
        TabIconImg.Size = UDim2.fromOffset(16, 16)
        TabIconImg.Position = UDim2.new(0, 8, 0.5, -8)
        TabIconImg.BackgroundTransparency = 1
        TabIconImg.ImageColor3 = Color3.fromRGB(160, 150, 140)
        local hasTIcon = tIcon and applyXINZIcon(TabIconImg, tIcon, Color3.fromRGB(160, 150, 140))

        local TabTitleLbl = Instance.new("TextLabel", TabBtn)
        TabTitleLbl.Name = "Title"
        TabTitleLbl.Size = UDim2.new(1, hasTIcon and -32 or -14, 1, 0)
        TabTitleLbl.Position = UDim2.new(0, hasTIcon and 30 or 8, 0, 0)
        TabTitleLbl.BackgroundTransparency = 1
        TabTitleLbl.Font = Enum.Font.GothamMedium
        TabTitleLbl.Text = tTitle
        TabTitleLbl.TextColor3 = Color3.fromRGB(160, 150, 140)
        TabTitleLbl.TextSize = 12
        TabTitleLbl.TextXAlignment = Enum.TextXAlignment.Left

        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Color3.fromRGB(60, 45, 30)
        Page.BorderSizePixel = 0
        Page.Visible = false
        local PLayout = Instance.new("UIListLayout", Page)
        PLayout.Padding = UDim.new(0, 6)
        PLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local function switchTab()
            for _, t in ipairs(tabs) do
                t.Page.Visible = false
                t.Title.TextColor3 = Color3.fromRGB(160, 150, 140)
                if t.Icon and t.Icon.Visible then
                    t.Icon.ImageColor3 = Color3.fromRGB(160, 150, 140)
                end
                t.Btn.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
                t.Btn.BackgroundTransparency = 1
            end
            Page.Visible = true
            TabTitleLbl.TextColor3 = Color3.fromRGB(255, 140, 25)
            if TabIconImg.Visible then
                TabIconImg.ImageColor3 = Color3.fromRGB(255, 140, 25)
            end
            TabBtn.BackgroundColor3 = Color3.fromRGB(32, 20, 12)
            TabBtn.BackgroundTransparency = 0
        end

        TabBtn.MouseButton1Click:Connect(switchTab)

        local TabObj = { Page = Page, Btn = TabBtn, Title = TabTitleLbl, Icon = TabIconImg }
        table.insert(tabs, TabObj)

        if #tabs == 1 then switchTab() end

        function TabObj:Section(sOpt)
            local sTitle = sOpt.Title or "Section"
            local sIcon = sOpt.Icon
            local SecFrame = Instance.new("Frame", Page)
            SecFrame.Size = UDim2.new(1, -6, 0, 22)
            SecFrame.BackgroundTransparency = 1

            local SIcon = Instance.new("ImageLabel", SecFrame)
            SIcon.Size = UDim2.fromOffset(13, 13)
            SIcon.Position = UDim2.new(0, 0, 0.5, -6)
            SIcon.BackgroundTransparency = 1
            local hasSIcon = sIcon and applyXINZIcon(SIcon, sIcon, Color3.fromRGB(255, 140, 25))

            local SecLbl = Instance.new("TextLabel", SecFrame)
            SecLbl.Size = UDim2.new(1, hasSIcon and -18 or 0, 1, 0)
            SecLbl.Position = UDim2.new(0, hasSIcon and 18 or 0, 0, 0)
            SecLbl.BackgroundTransparency = 1
            SecLbl.Font = Enum.Font.GothamBold
            SecLbl.TextSize = 11
            SecLbl.TextColor3 = Color3.fromRGB(255, 140, 25)
            SecLbl.TextXAlignment = Enum.TextXAlignment.Left
            SecLbl.Text = string.upper(sTitle)
        end

        function TabObj:Toggle(togOpt)
            togOpt = togOpt or {}
            local tgTitle = togOpt.Title or "Toggle"
            local tgDesc = togOpt.Desc or ""
            local tgVal = (togOpt.Value == true or togOpt.Default == true)
            local tgCallback = togOpt.Callback or function() end

            local Row = Instance.new("Frame", Page)
            Row.Size = UDim2.new(1, -6, 0, tgDesc ~= "" and 42 or 34)
            Row.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
            local RCorner = Instance.new("UICorner", Row)
            RCorner.CornerRadius = UDim.new(0, 6)

            local TLbl = Instance.new("TextLabel", Row)
            TLbl.Size = UDim2.new(1, -60, 0, 18)
            TLbl.Position = UDim2.new(0, 10, 0, tgDesc ~= "" and 4 or 8)
            TLbl.BackgroundTransparency = 1
            TLbl.Font = Enum.Font.GothamMedium
            TLbl.TextSize = 12
            TLbl.TextColor3 = Color3.fromRGB(245, 245, 250)
            TLbl.TextXAlignment = Enum.TextXAlignment.Left
            TLbl.Text = tgTitle

            if tgDesc ~= "" then
                local DLbl = Instance.new("TextLabel", Row)
                DLbl.Size = UDim2.new(1, -60, 0, 14)
                DLbl.Position = UDim2.new(0, 10, 0, 22)
                DLbl.BackgroundTransparency = 1
                DLbl.Font = Enum.Font.Gotham
                DLbl.TextSize = 10
                DLbl.TextColor3 = Color3.fromRGB(150, 140, 130)
                DLbl.TextXAlignment = Enum.TextXAlignment.Left
                DLbl.TextTruncate = Enum.TextTruncate.AtEnd
                DLbl.Text = tgDesc
            end

            local Switch = Instance.new("TextButton", Row)
            Switch.Size = UDim2.fromOffset(40, 20)
            Switch.Position = UDim2.new(1, -48, 0.5, -10)
            Switch.BackgroundColor3 = tgVal and Color3.fromRGB(255, 140, 25) or Color3.fromRGB(36, 36, 42)
            Switch.Text = ""
            local SCorner = Instance.new("UICorner", Switch)
            SCorner.CornerRadius = UDim.new(1, 0)

            local Dot = Instance.new("Frame", Switch)
            Dot.Size = UDim2.fromOffset(16, 16)
            Dot.Position = tgVal and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            local DCorner = Instance.new("UICorner", Dot)
            DCorner.CornerRadius = UDim.new(1, 0)

            local function updateToggle(newVal)
                tgVal = newVal
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = tgVal and Color3.fromRGB(255, 140, 25) or Color3.fromRGB(36, 36, 42)}):Play()
                TweenService:Create(Dot, TweenInfo.new(0.2), {Position = tgVal and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                pcall(tgCallback, tgVal)
            end

            Switch.MouseButton1Click:Connect(function() updateToggle(not tgVal) end)
            local ClickArea = Instance.new("TextButton", Row)
            ClickArea.Size = UDim2.new(1, -50, 1, 0)
            ClickArea.BackgroundTransparency = 1
            ClickArea.Text = ""
            ClickArea.MouseButton1Click:Connect(function() updateToggle(not tgVal) end)
        end

        function TabObj:Slider(slOpt)
            slOpt = slOpt or {}
            local sTitle = slOpt.Title or "Slider"
            local sMin = slOpt.Min or 0
            local sMax = slOpt.Max or 100
            local sDefault = slOpt.Default or slOpt.Value or sMin
            local sCallback = slOpt.Callback or function() end
            local curVal = sDefault

            local Row = Instance.new("Frame", Page)
            Row.Size = UDim2.new(1, -6, 0, 48)
            Row.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
            local RCorner = Instance.new("UICorner", Row)
            RCorner.CornerRadius = UDim.new(0, 6)

            local TLbl = Instance.new("TextLabel", Row)
            TLbl.Size = UDim2.new(1, -70, 0, 16)
            TLbl.Position = UDim2.new(0, 10, 0, 6)
            TLbl.BackgroundTransparency = 1
            TLbl.Font = Enum.Font.GothamMedium
            TLbl.TextSize = 12
            TLbl.TextColor3 = Color3.fromRGB(245, 245, 250)
            TLbl.TextXAlignment = Enum.TextXAlignment.Left
            TLbl.Text = sTitle

            local ValLbl = Instance.new("TextLabel", Row)
            ValLbl.Size = UDim2.new(0, 50, 0, 16)
            ValLbl.Position = UDim2.new(1, -60, 0, 6)
            ValLbl.BackgroundTransparency = 1
            ValLbl.Font = Enum.Font.GothamBold
            ValLbl.TextSize = 12
            ValLbl.TextColor3 = Color3.fromRGB(255, 140, 25)
            ValLbl.TextXAlignment = Enum.TextXAlignment.Right
            ValLbl.Text = tostring(math.floor(curVal))

            local Bar = Instance.new("Frame", Row)
            Bar.Size = UDim2.new(1, -20, 0, 6)
            Bar.Position = UDim2.new(0, 10, 0, 30)
            Bar.BackgroundColor3 = Color3.fromRGB(30, 28, 26)
            local BCorner = Instance.new("UICorner", Bar)
            BCorner.CornerRadius = UDim.new(1, 0)

            local pct = math.clamp((curVal - sMin) / (sMax - sMin), 0, 1)
            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new(pct, 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(255, 140, 25)
            local FCorner = Instance.new("UICorner", Fill)
            FCorner.CornerRadius = UDim.new(1, 0)

            local sliding = false
            local function moveSlider(input)
                local posX = input.Position.X - Bar.AbsolutePosition.X
                local percent = math.clamp(posX / Bar.AbsoluteSize.X, 0, 1)
                Fill.Size = UDim2.new(percent, 0, 1, 0)
                curVal = math.floor(sMin + ((sMax - sMin) * percent))
                ValLbl.Text = tostring(curVal)
                pcall(sCallback, curVal)
            end

            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    moveSlider(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    moveSlider(input)
                end
            end)
        end

        function TabObj:Button(bOpt)
            bOpt = bOpt or {}
            local bTitle = bOpt.Title or "Button"
            local bDesc = bOpt.Desc or ""
            local bIcon = bOpt.Icon
            local bCallback = bOpt.Callback or function() end

            local BtnRow = Instance.new("TextButton", Page)
            BtnRow.Size = UDim2.new(1, -6, 0, bDesc ~= "" and 42 or 34)
            BtnRow.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
            BtnRow.AutoButtonColor = false
            BtnRow.Text = ""
            local BRCorner = Instance.new("UICorner", BtnRow)
            BRCorner.CornerRadius = UDim.new(0, 6)

            local BIconImg = Instance.new("ImageLabel", BtnRow)
            BIconImg.Size = UDim2.fromOffset(16, 16)
            BIconImg.Position = UDim2.new(0, 10, 0.5, -8)
            BIconImg.BackgroundTransparency = 1
            local hasBIcon = bIcon and applyXINZIcon(BIconImg, bIcon, Color3.fromRGB(255, 140, 25))

            local textLeft = hasBIcon and 34 or 10
            local textWidth = hasBIcon and -(textLeft + 10) or -20

            local TLbl = Instance.new("TextLabel", BtnRow)
            TLbl.Size = UDim2.new(1, textWidth, 0, 18)
            TLbl.Position = UDim2.new(0, textLeft, 0, bDesc ~= "" and 4 or 8)
            TLbl.BackgroundTransparency = 1
            TLbl.Font = Enum.Font.GothamMedium
            TLbl.TextSize = 12
            TLbl.TextColor3 = Color3.fromRGB(245, 245, 250)
            TLbl.TextXAlignment = Enum.TextXAlignment.Left
            TLbl.Text = bTitle

            if bDesc ~= "" then
                local DLbl = Instance.new("TextLabel", BtnRow)
                DLbl.Size = UDim2.new(1, -20, 0, 14)
                DLbl.Position = UDim2.new(0, 10, 0, 22)
                DLbl.BackgroundTransparency = 1
                DLbl.Font = Enum.Font.Gotham
                DLbl.TextSize = 10
                DLbl.TextColor3 = Color3.fromRGB(150, 140, 130)
                DLbl.TextXAlignment = Enum.TextXAlignment.Left
                DLbl.TextTruncate = Enum.TextTruncate.AtEnd
                DLbl.Text = bDesc
            end

            BtnRow.MouseButton1Click:Connect(function()
                TweenService:Create(BtnRow, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(38, 28, 18)}):Play()
                delay(0.1, function()
                    TweenService:Create(BtnRow, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(18, 18, 23)}):Play()
                end)
                pcall(bCallback)
            end)

            return {
                SetTitle = function(self, newText) TLbl.Text = newText end
            }
        end

        function TabObj:Dropdown(dOpt)
            dOpt = dOpt or {}
            local dTitle = dOpt.Title or "Dropdown"
            local dList = dOpt.List or {}
            local dCur = dOpt.Default or dOpt.Value or dList[1] or ""
            local dCallback = dOpt.Callback or function() end

            local DropFrame = Instance.new("Frame", Page)
            DropFrame.Size = UDim2.new(1, -6, 0, 48)
            DropFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
            DropFrame.ClipsDescendants = true
            local DCorner = Instance.new("UICorner", DropFrame)
            DCorner.CornerRadius = UDim.new(0, 6)

            local TLbl = Instance.new("TextLabel", DropFrame)
            TLbl.Size = UDim2.new(1, -20, 0, 16)
            TLbl.Position = UDim2.new(0, 10, 0, 6)
            TLbl.BackgroundTransparency = 1
            TLbl.Font = Enum.Font.GothamMedium
            TLbl.TextSize = 12
            TLbl.TextColor3 = Color3.fromRGB(245, 245, 250)
            TLbl.TextXAlignment = Enum.TextXAlignment.Left
            TLbl.Text = dTitle

            local SelectBtn = Instance.new("TextButton", DropFrame)
            SelectBtn.Size = UDim2.new(1, -20, 0, 20)
            SelectBtn.Position = UDim2.new(0, 10, 0, 24)
            SelectBtn.BackgroundColor3 = Color3.fromRGB(26, 22, 20)
            SelectBtn.Font = Enum.Font.GothamMedium
            SelectBtn.Text = "  " .. tostring(dCur) .. "  v"
            SelectBtn.TextColor3 = Color3.fromRGB(255, 140, 25)
            SelectBtn.TextSize = 11
            SelectBtn.TextXAlignment = Enum.TextXAlignment.Left
            local SBCorner = Instance.new("UICorner", SelectBtn)
            SBCorner.CornerRadius = UDim.new(0, 4)

            local DropListFrame = Instance.new("ScrollingFrame", DropFrame)
            DropListFrame.Size = UDim2.new(1, -20, 0, 100)
            DropListFrame.Position = UDim2.new(0, 10, 0, 48)
            DropListFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
            DropListFrame.ScrollBarThickness = 2
            local DListLayout = Instance.new("UIListLayout", DropListFrame)
            DListLayout.Padding = UDim.new(0, 2)

            local isOpen = false
            local function refreshOptions()
                for _, child in ipairs(DropListFrame:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                for _, item in ipairs(dList) do
                    local ItemBtn = Instance.new("TextButton", DropListFrame)
                    ItemBtn.Size = UDim2.new(1, 0, 0, 22)
                    ItemBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
                    ItemBtn.Font = Enum.Font.Gotham
                    ItemBtn.Text = " " .. tostring(item)
                    ItemBtn.TextColor3 = Color3.fromRGB(210, 205, 200)
                    ItemBtn.TextSize = 11
                    ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
                    ItemBtn.MouseButton1Click:Connect(function()
                        dCur = item
                        SelectBtn.Text = "  " .. tostring(dCur) .. "  v"
                        isOpen = false
                        TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -6, 0, 48)}):Play()
                        pcall(dCallback, dCur)
                    end)
                end
            end

            SelectBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    refreshOptions()
                    TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -6, 0, 154)}):Play()
                else
                    TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -6, 0, 48)}):Play()
                end
            end)
        end

        function TabObj:Label(lOpt)
            lOpt = lOpt or {}
            local lTitle = lOpt.Title or ""
            local lDesc = lOpt.Desc or ""

            local Row = Instance.new("Frame", Page)
            Row.Size = UDim2.new(1, -6, 0, lDesc ~= "" and 44 or 28)
            Row.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
            local RCorner = Instance.new("UICorner", Row)
            RCorner.CornerRadius = UDim.new(0, 6)

            local TLbl = Instance.new("TextLabel", Row)
            TLbl.Size = UDim2.new(1, -20, 0, 16)
            TLbl.Position = UDim2.new(0, 10, 0, 6)
            TLbl.BackgroundTransparency = 1
            TLbl.Font = Enum.Font.GothamBold
            TLbl.TextSize = 11
            TLbl.TextColor3 = Color3.fromRGB(245, 245, 250)
            TLbl.TextXAlignment = Enum.TextXAlignment.Left
            TLbl.Text = lTitle

            if lDesc ~= "" then
                local DLbl = Instance.new("TextLabel", Row)
                DLbl.Size = UDim2.new(1, -20, 0, 16)
                DLbl.Position = UDim2.new(0, 10, 0, 22)
                DLbl.BackgroundTransparency = 1
                DLbl.Font = Enum.Font.Gotham
                DLbl.TextSize = 10
                DLbl.TextColor3 = Color3.fromRGB(150, 140, 130)
                DLbl.TextXAlignment = Enum.TextXAlignment.Left
                DLbl.Text = lDesc
            end
        end

        return TabObj
    end

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == ToggleKey then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    return WindowObj
end

-- 7. INITIALIZE HUB WINDOW ------------------------------------
local KeyAvatarURL = (getgenv and getgenv().KeyAvatar) or ("rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=150&h=150")

local Window = Library:Window({
    Profile = {
        Username = (getgenv and getgenv().KeyUsername) or LocalPlayer.DisplayName,
        Email = "UID: " .. tostring(LocalPlayer.UserId),
        AvatarUrl = KeyAvatarURL
    },
    Title = "Project XINZ X - Hoops Hub",
    Desc = "Basketball Automation & Knit Suite",
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.RightShift
    }
})

-- Tabs Setup
local OffenseTab  = Window:Tab({ Title = "Offense",  Icon = "crosshair" })
local DefenseTab  = Window:Tab({ Title = "Defense",  Icon = "shield" })
local MovementTab = Window:Tab({ Title = "Movement", Icon = "gauge" })
local InfoTab     = Window:Tab({ Title = "Info",     Icon = "info" })

-- Offense Tab
OffenseTab:Section({ Title = "Ball Automation", Icon = "crosshair" })

OffenseTab:Toggle({
    Title = "Auto TP Get Ball",
    Desc = "Teleport to free ball immediately (Instant TP)",
    Value = Config.AutoGetBall,
    Callback = function(v) Config.AutoGetBall = v end
})

OffenseTab:Toggle({
    Title = "Ball ESP",
    Desc = "Highlight basketball aura and distance through walls",
    Value = Config.BallESP,
    Callback = function(v)
        Config.BallESP = v
        pcall(updateBallESP)
    end
})

OffenseTab:Dropdown({
    Title = "Get Ball Mode",
    List = { "TP (Instant)", "Fly" },
    Default = Config.GetBallMode == "TP" and "TP (Instant)" or "Fly",
    Callback = function(choice)
        Config.GetBallMode = choice:find("TP") and "TP" or "Fly"
    end
})

OffenseTab:Slider({
    Title = "Fly Speed",
    Min = 20,
    Max = 120,
    Default = Config.FlySpeed,
    Callback = function(v) Config.FlySpeed = v end
})

OffenseTab:Section({ Title = "Shooting & Actions", Icon = "crosshair" })

OffenseTab:Toggle({
    Title = "Instant Shoot",
    Desc = "Teleport ball above hoop for a 100% swish score",
    Value = Config.InstantShoot,
    Callback = function(v)
        Config.InstantShoot = v
        Config.AutoPerfectShoot = v
    end
})

OffenseTab:Toggle({
    Title = "Auto Shoot on Possess",
    Desc = "Automatically shoot as soon as ball is possessed",
    Value = Config.AutoShoot,
    Callback = function(v) Config.AutoShoot = v end
})

OffenseTab:Toggle({
    Title = "Double Click Shoot",
    Desc = "Simulate double-click shoot for reliable release",
    Value = Config.DoubleClickShoot,
    Callback = function(v) Config.DoubleClickShoot = v end
})

OffenseTab:Slider({
    Title = "Teleport Height (Studs)",
    Min = 3,
    Max = 30,
    Default = math.floor(Config.TeleportHeight or 9),
    Callback = function(v)
        Config.TeleportHeight = v
    end
})

OffenseTab:Slider({
    Title = "Click Hold Duration (ms)",
    Min = 20,
    Max = 1000,
    Default = math.floor((Config.ClickHoldTime or 0.12) * 1000),
    Callback = function(v)
        Config.ClickHoldTime = v / 1000
    end
})

OffenseTab:Toggle({
    Title = "Auto Face Net on Shoot",
    Desc = "Automatically face hoop when shooting (disable for backwards shots)",
    Value = Config.AutoFaceNet,
    Callback = function(v) Config.AutoFaceNet = v end
})

OffenseTab:Button({
    Title = "Instant Shoot Now [Hotkey: E / F]", Icon = "play",
    Desc = "Teleport ball above hoop for a 100% swish score",
    Callback = function() executePerfectShot() end
})

OffenseTab:Button({
    Title = "Auto TP Dunk", Icon = "rocket",
    Desc = "Teleport under hoop and perform immediate dunk",
    Callback = function()
        if not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then return end
        if not (BallController and BallController.LocalPlayerPossessesBall and BallController:LocalPlayerPossessesBall()) then return end
        
        local myRoot = LocalPlayer.Character.HumanoidRootPart
        local hoop = getNearestHoop()
        
        if hoop then
            local floorY = myRoot.Position.Y
            local targetPos = Vector3.new(hoop.Position.X, floorY, hoop.Position.Z)
            myRoot.CFrame = CFrame.new(targetPos, Vector3.new(hoop.Position.X, floorY, hoop.Position.Z))
            myRoot.Velocity = Vector3.new(0, 0, 0)
            
            task.wait(0.04)
            if LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
            
            task.wait(0.06)
            if BallController and BallController.Dunk then
                pcall(function() BallController:Dunk() end)
            end
        end
    end
})

OffenseTab:Button({
    Title = "Safe Dribble", Icon = "crosshair",
    Desc = "Perform dribble and crossovers only while possessing ball",
    Callback = function()
        if not (BallController and BallController.LocalPlayerPossessesBall and BallController:LocalPlayerPossessesBall()) then return end
        if BallController and BallController.Dribble then
            pcall(function() BallController:Dribble() end)
        end
    end
})

OffenseTab:Button({
    Title = "Face Net",
    Callback = function()
        if AbilityController and AbilityController.LookingAtNet then pcall(function() AbilityController:LookingAtNet() end) end
    end
})

OffenseTab:Button({
    Title = "Instant Awakening",
    Callback = function()
        if AwakeningController and AwakeningController.Input then pcall(function() AwakeningController:Input() end) end
    end
})

-- Defense Tab
DefenseTab:Section({ Title = "Auto Defense", Icon = "shield-check" })

DefenseTab:Toggle({
    Title = "Auto Block",
    Desc = "Automatically block opponent shots (ignores teammates)",
    Value = Config.AutoBlock,
    Callback = function(v) Config.AutoBlock = v end
})

DefenseTab:Slider({
    Title = "Block Range",
    Min = 6,
    Max = 30,
    Default = Config.AutoBlockRange,
    Callback = function(v) Config.AutoBlockRange = v end
})

DefenseTab:Toggle({
    Title = "Auto Steal",
    Desc = "Steal basketball from opponents within range",
    Value = Config.AutoSteal,
    Callback = function(v) Config.AutoSteal = v end
})

DefenseTab:Slider({
    Title = "Steal Range",
    Min = 6,
    Max = 30,
    Default = Config.AutoStealRange,
    Callback = function(v) Config.AutoStealRange = v end
})

DefenseTab:Button({
    Title = "Force Block", Icon = "shield",
    Desc = "Perform a single emergency block jump",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        if DefenseController and DefenseController.Input then
            pcall(function() DefenseController:Input("Block") end)
        end
    end
})

-- Movement Tab
MovementTab:Section({ Title = "Movement & Speed", Icon = "gauge" })

MovementTab:Toggle({
    Title = "WalkSpeed Boost",
    Desc = "Enable custom movement speed (works across all courts)",
    Value = Config.SpeedEnabled,
    Callback = function(v)
        Config.SpeedEnabled = v
        if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
})

MovementTab:Dropdown({
    Title = "Speed Mode",
    List = { "Hybrid (Recommended)", "CFrame (Bypass 100%)", "Velocity (Smooth)", "WalkSpeed (Standard)" },
    Default = "Hybrid (Recommended)",
    Callback = function(choice)
        if choice:find("CFrame") then
            Config.SpeedMethod = "CFrame"
        elseif choice:find("Velocity") then
            Config.SpeedMethod = "Velocity"
        elseif choice:find("WalkSpeed") then
            Config.SpeedMethod = "WalkSpeed"
        else
    SpeedMethod = "Hybrid",    -- "Hybrid", "CFrame", "Velocity", "WalkSpeed"
        end
    end
})

MovementTab:Slider({
    Title = "Speed Amount",
    Min = 16,
    Max = 120,
    Default = Config.CustomSpeed,
    Callback = function(v) Config.CustomSpeed = v end
})

MovementTab:Toggle({
    Title = "Infinite Jump",
    Desc = "Allow continuous jumping in mid-air",
    Value = Config.InfJump,
    Callback = function(v) Config.InfJump = v end
})

MovementTab:Toggle({
    Title = "Noclip",
    Desc = "Walk through walls and obstacles",
    Value = Config.Noclip,
    Callback = function(v) Config.Noclip = v end
})

-- Info Tab
InfoTab:Section({ Title = "Hub Information", Icon = "info" })
InfoTab:Label({ Title = "Game:", Desc = "Basketball / Hoops" })
InfoTab:Label({ Title = "Engine:", Desc = "Knit Controller Full Integration" })
InfoTab:Label({ Title = "UI Version:", Desc = "100% Native Standalone (Loadstring-Free)" })
-- Hotkeys (E / F = Instant Shoot, Delete = Emergency Panic)
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe then
        if input.KeyCode == Enum.KeyCode.E or input.KeyCode == Enum.KeyCode.F then
            if Config.InstantShoot or Config.AutoPerfectShoot then
                executePerfectShot()
            end
        elseif input.KeyCode == Enum.KeyCode.Delete then
            Config.AutoGetBall = false
            Config.AutoBlock = false
            Config.AutoSteal = false
            Config.BallESP = false
            Config.SpeedEnabled = false
            Config.InfJump = false
            Config.Noclip = false
            Config.AutoShoot = false
            pcall(updateBallESP)
            Window:Notify({ Title = "PANIC ACTIVATED", Desc = "All cheat features disabled!", Time = 3 })
        end
    end
end)

env.BasketballXINZ_Cleanup = function()
    if renderConn then renderConn:Disconnect() end
    if steppedConn then steppedConn:Disconnect() end
end

-- Anti-AFK
if Config.AntiAFK then
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.zero)
    end)
end

Window:Notify({
    Title = "Project XINZ X Loaded",
    Desc = "Basketball Hub Ready!\nRight Shift = Toggle UI",
    Time = 5
})

print("Project XINZ X - Basketball Hub (Clean UI) Loaded Successfully!")
