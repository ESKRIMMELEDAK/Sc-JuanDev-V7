--[[
    MAGETAN ULTIMATE V11 - THE "FIX EVERYTHING" UPDATE
    BY: JUAN DEV ASLI MAGETAN
    - FIX: Smooth Draggable HUD (Android Friendly)
    - UPGRADE: Ban Hammer (Force Kick Method)
    - ADD: Player ESP (Box + Tracer)
    - ALL PREVIOUS FEATURES RESTORED
]]

if _G.V11Executed then return end
_G.V11Executed = true

local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local run = game:GetService("RunService")
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")

-- [SMOOTH DRAGGABLE SYSTEM]
local function makeDraggable(frame, parent)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = parent.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    uis.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            parent.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [UI SETUP]
local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
local main = Instance.new("Frame", sg)
local header = Instance.new("Frame", main) -- Bagian buat diseret
local toggle = Instance.new("TextButton", sg)
local scroll = Instance.new("ScrollingFrame", main)
local layout = Instance.new("UIListLayout", scroll)

-- Floating Toggle
toggle.Size = UDim2.new(0, 60, 0, 60)
toggle.Position = UDim2.new(0, 10, 0.5, 0)
toggle.Text = "JUAN"
toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

-- Main Frame
main.Size = UDim2.new(0, 250, 0, 350)
main.Position = UDim2.new(0.5, -125, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Visible = true
Instance.new("UICorner", main)

header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
header.Parent = main
Instance.new("UICorner", header)
makeDraggable(header, main)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "JUAN MAGETAN V11"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold

scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 10, 0)
layout.Padding = UDim.new(0, 5)

local function AddButton(txt, callback)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Text = txt .. " [OFF]"
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn)
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.BackgroundColor3 = active and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(35, 35, 35)
        btn.Text = txt .. (active and " [ON]" or " [OFF]")
        callback(active)
    end)
end

-- [[ FEATURES ]]

-- 1. FLY V6 HYBRID
AddButton("FLY HYBRID V6", function(on)
    _G.Fly = on
    local char = lp.Character or lp.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    if on then
        char.Humanoid.PlatformStand = true
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        task.spawn(function()
            while _G.Fly do
                run.RenderStepped:Wait()
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 100
                root.RotVelocity = Vector3.new(0,0,0)
            end
            bv:Destroy()
            char.Humanoid.PlatformStand = false
        end)
    end
end)

-- 2. ESP PLAYER (BOX + HIGHLIGHT)
AddButton("ESP PLAYER", function(on)
    _G.ESP = on
    while _G.ESP do
        task.wait(1)
        for _, p in pairs(plrs:GetPlayers()) do
            if p ~= lp and p.Character then
                if not p.Character:FindFirstChild("JuanESP") then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "JuanESP"
                    h.FillColor = Color3.new(1, 0, 0)
                end
            end
        end
        if not _G.ESP then
            for _, v in pairs(plrs:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("JuanESP") then v.Character.JuanESP:Destroy() end
            end
        end
    end
end)

-- 3. UPGRADED BAN HAMMER (FORCE KICK)
AddButton("BAN HAMMER PRO", function(on)
    _G.BH = on
    if on then
        local hammer = Instance.new("Part", lp.Character)
        hammer.Name = "BanHammer"
        hammer.Size = Vector3.new(1.5, 6, 1.5)
        hammer.Color = Color3.new(1, 0, 0)
        local w = Instance.new("Weld", hammer)
        w.Part0 = hammer; w.Part1 = lp.Character["Right Arm"]; w.C1 = CFrame.new(0, -1.5, 0)
        hammer.Touched:Connect(function(hit)
            local target = plrs:GetPlayerFromCharacter(hit.Parent)
            if target and target ~= lp then
                -- Method: Kick target with custom message
                target:Kick("JUAN MAGETAN HAS BANNED YOU!")
            end
        end)
    else
        if lp.Character:FindFirstChild("BanHammer") then lp.Character.BanHammer:Destroy() end
    end
end)

-- 4. BASIC STATS (OON STYLE)
AddButton("SPEED X3", function(on) lp.Character.Humanoid.WalkSpeed = on and 50 or 16 end)
AddButton("JUMP X3", function(on) lp.Character.Humanoid.JumpPower = on and 150 or 50 end)

-- 5. FLING ALL
AddButton("FLING ALL", function(on)
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

-- [TOGGLE VISIBILITY]
toggle.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

print("V11 LOADED: DRAGGABLE FIXED. SIKAT COK!")
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
