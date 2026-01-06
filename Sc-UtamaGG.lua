--[[
    MAGETAN ULTIMATE OVERLORD V7 (GOD MODE FULL)
    BY: JUAN DEV ASLI MAGETAN
    SUPPORT: DELTA, VEGA, ARCEUS (ANDROID/MOBILE)
    FEATURES: ALL PREVIOUS + CATALOG + BOT SPAWN + ANIMATED UI
]]

if _G.UltimateExecuted then return end
_G.UltimateExecuted = true

local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local run = game:GetService("RunService")
local ts = game:GetService("TweenService")

-- [UI BUILDER]
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
local main = Instance.new("Frame", sg)
local toggle = Instance.new("TextButton", sg)
local title = Instance.new("TextLabel", main)
local scroll = Instance.new("ScrollingFrame", main)
local layout = Instance.new("UIListLayout", scroll)

-- Floating Toggle (Mobile Friendly)
toggle.Size = UDim2.new(0, 65, 0, 65)
toggle.Position = UDim2.new(0, 10, 0.4, 0)
toggle.Text = "JUAN"
toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Draggable = true
Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

-- Main Frame
main.Size = UDim2.new(0, 260, 0, 380)
main.Position = UDim2.new(0.5, -130, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.BorderSizePixel = 0
main.Visible = true
Instance.new("UICorner", main)

title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "JUAN MAGETAN V7"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold

scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 5, 0)
layout.Padding = UDim.new(0, 8)

-- [FEATURE BUILDER]
local function CreateButton(name, callback)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = name .. " [OFF]"
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        ts:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = active and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(30, 30, 30)}):Play()
        btn.Text = name .. (active and " [ON]" or " [OFF]")
        callback(active)
    end)
end

-- [CORE FEATURES]

-- 1. FIXED FLY (DARI V5)
local flySpeed = 60
CreateButton("FIXED FLY", function(on)
    _G.Flying = on
    local char = lp.Character or lp.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    if on then
        char.Humanoid.PlatformStand = true
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        task.spawn(function()
            while _G.Flying do
                run.RenderStepped:Wait()
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
                root.RotVelocity = Vector3.new(0,0,0)
            end
            bv:Destroy()
            char.Humanoid.PlatformStand = false
        end)
    end
end)

-- 2. FLING ALL (BRUTAL)
CreateButton("FLING ALL", function(on)
    _G.Fling = on
    task.spawn(function()
        while _G.Fling do
            run.Heartbeat:Wait()
            for _, v in pairs(plrs:GetPlayers()) do
                if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    lp.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                    lp.Character.HumanoidRootPart.Velocity = Vector3.new(500000, 500000, 500000)
                end
            end
        end
    end)
end)

-- 3. GRAB PLAYER
CreateButton("GRAB PLAYER", function(on)
    _G.Grab = on
    task.spawn(function()
        local target = nil
        while _G.Grab do
            run.RenderStepped:Wait()
            if not target then
                for _, v in pairs(plrs:GetPlayers()) do if v ~= lp then target = v break end end
            end
            if target and target.Character then
                target.Character.HumanoidRootPart.CFrame = lp.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -4)
            end
        end
    end)
end)

-- 4. SPAWN BOT RANDOM
CreateButton("SPAWN BOT", function(on)
    if on then
        local clone = lp.Character:Clone()
        clone.Parent = workspace
        clone:MoveTo(lp.Character.HumanoidRootPart.Position + Vector3.new(math.random(-10,10), 0, math.random(-10,10)))
        clone.Name = "JUAN_BOT_" .. math.random(100, 999)
    end
end)

-- 5. CATALOG CUSTOMIZER (JUAN STYLE)
CreateButton("JUAN OUTFIT", function(on)
    if on then
        local IDs = {13400511, 154734493, 11112444} -- Domino Crown, Valkyrie, etc.
        for _, id in pairs(IDs) do
            local acc = game:GetObjects("rbxassetid://" .. id)[1]
            acc.Parent = lp.Character
        end
    end
end)

-- 6. BAN HAMMER (TOUCH KICK)
CreateButton("BAN HAMMER", function(on)
    _G.BH = on
    if on then
        local h = Instance.new("Part", lp.Character)
        h.Size = Vector3.new(1, 6, 1)
        h.Color = Color3.new(1,0,0)
        h.Name = "Hammer"
        local w = Instance.new("Weld", h)
        w.Part0 = h; w.Part1 = lp.Character["Right Arm"]; w.C1 = CFrame.new(0,-1,0)
        h.Touched:Connect(function(hit)
            local p = plrs:GetPlayerFromCharacter(hit.Parent)
            if p and p ~= lp then p:Kick("DI-BAN SAMA JUAN MAGETAN!") end
        end)
    else
        if lp.Character:FindFirstChild("Hammer") then lp.Character.Hammer:Destroy() end
    end
end)

-- 7. RANDOM ANIMATIONS
CreateFeature = function() -- Hacky fix buat anim
    local anims = {"rbxassetid://3333499508", "rbxassetid://35154961"}
    local a = Instance.new("Animation")
    a.AnimationId = anims[math.random(1, #anims)]
    lp.Character.Humanoid:LoadAnimation(a):Play()
end
CreateButton("PLAY RANDOM ANIM", function(on) if on then CreateFeature() end end)

-- [TOGGLE UI]
toggle.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

print("MAGETAN V7 LOADED: FLY, FLING, GRAB, BOT, CATALOG, BAN. GASKEN!")
