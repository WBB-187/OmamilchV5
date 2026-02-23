--[[ 
    OMAMILCH V5 - ADMIN LEVEL EDITION (V23)
    USER: HanfmomentV1 | KEY: HanfmomentV1
    THEME: Supreme Admin Red
    BYPASS: High-Altitude Death, Fall Damage, Void-Kill
]]

if _G.OM_RUNNING then _G.OM_RUNNING = false end
task.wait(0.3)
_G.OM_RUNNING = true

local lp = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Cam = workspace.CurrentCamera

-- --- ADMIN NOTIFICATION ---
pcall(function()
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("omamilch V5 Ist An", "All")
end)

local function InitAdminGUI()
    local SG = Instance.new("ScreenGui")
    SG.Name = "omamilch_AdminV23"
    SG.ResetOnSpawn = false
    pcall(function() SG.Parent = game:GetService("CoreGui") end)
    if not SG.Parent then SG.Parent = lp:WaitForChild("PlayerGui") end

    local MF = Instance.new("Frame", SG)
    MF.Size = UDim2.new(0, 850, 0, 550)
    MF.Position = UDim2.new(0.5, -425, 0.5, -275)
    MF.BackgroundColor3 = Color3.fromRGB(5, 0, 0)
    MF.Active, MF.Draggable = true, true
    Instance.new("UIStroke", MF).Color = Color3.fromRGB(255, 0, 0)
    Instance.new("UICorner", MF)

    -- Rote Sterne (Hanfmoment Signature)
    for i = 1, 35 do
        local s = Instance.new("TextLabel", MF)
        s.Text = "★"; s.TextColor3 = Color3.fromRGB(255, 0, 0)
        s.BackgroundTransparency = 1; s.Position = UDim2.new(math.random(), 0, math.random(), 0)
    end

    local Title = Instance.new("TextLabel", MF)
    Title.Size = UDim2.new(1, 0, 0, 50); Title.Text = "omamilch V5 - ADMIN PANEL"; Title.TextColor3 = Color3.new(1,0,0)
    Title.Font = Enum.Font.GothamBold; Title.TextSize = 25; Title.BackgroundTransparency = 1

    local Content = Instance.new("ScrollingFrame", MF)
    Content.Size = UDim2.new(1, -30, 1, -120); Content.Position = UDim2.new(0, 15, 0, 60)
    Content.BackgroundTransparency = 1; Content.CanvasSize = UDim2.new(0, 0, 4, 0)
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 10)

    local function AddBtn(name, callback)
        local b = Instance.new("TextButton", Content)
        b.Size = UDim2.new(1, -10, 0, 50); b.Text = name .. " [OFF]"; b.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
        b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
        local active = false
        b.MouseButton1Click:Connect(function()
            active = not active
            b.Text = name .. (active and " [ON]" or " [OFF]")
            b.BackgroundColor3 = active and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(30, 0, 0)
            pcall(function() callback(active) end)
        end)
    end

    -- --- ADMIN FEATURES ---

    -- 1. ADMIN FLY (V2 - Ultra Smooth)
    local fV, fG, fL
    AddBtn("ADMIN FLY (V2)", function(s)
        if s then
            local hrp = lp.Character:WaitForChild("HumanoidRootPart")
            fV = Instance.new("BodyVelocity", hrp); fV.MaxForce = Vector3.new(1e9,1e9,1e9)
            fG = Instance.new("BodyGyro", hrp); fG.MaxTorque = Vector3.new(1e9,1e9,1e9)
            fL = RS.RenderStepped:Connect(function()
                lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed) -- Anti-Height Bypass
                fG.CFrame = Cam.CFrame
                local dir = lp.Character.Humanoid.MoveDirection
                fV.Velocity = (dir.Magnitude > 0) and (Cam.CFrame:VectorToWorldSpace(Vector3.new(dir.X, 0, dir.Z * 1.5)) * 150) or Vector3.new(0, 0.1, 0)
            end)
        else
            if fL then fL:Disconnect() end; if fV then fV:Destroy() end; if fG then fG:Destroy() end
            lp.Character.Humanoid.PlatformStand = false
        end
    end)

    -- 2. SUPREME ESP (Namen + Boxen)
    AddBtn("SUPREME ESP", function(s)
        _G.ESP_Active = s
        while _G.ESP_Active do
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if not p.Character:FindFirstChild("AdminESP") then
                        local b = Instance.new("BoxHandleAdornment", p.Character)
                        b.Name = "AdminESP"; b.Adornee = p.Character.HumanoidRootPart; b.AlwaysOnTop = true
                        b.Size = Vector3.new(4, 5, 1); b.Transparency = 0.6; b.Color3 = Color3.new(1,0,0)
                    end
                end
            end
            task.wait(1.5)
            if not _G.ESP_Active then
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p.Character and p.Character:FindFirstChild("AdminESP") then p.Character.AdminESP:Destroy() end
                end
            end
        end
    end)

    -- 3. GODMODE / ANTI-DIE (Bypass Fall & Height)
    AddBtn("ANTI-DEATH BYPASS", function(s)
        _G.AntiDeath = s
        task.spawn(function()
            while _G.AntiDeath do
                if lp.Character and lp.Character:FindFirstChild("Humanoid") then
                    lp.Character.Humanoid.SetStateEnabled(lp.Character.Humanoid, Enum.HumanoidStateType.Dead, false)
                    lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                    -- Anti-Void: Wenn du zu tief fällst, wirst du hochteleportiert
                    if lp.Character.HumanoidRootPart.Position.Y < -50 then
                        lp.Character.HumanoidRootPart.CFrame = CFrame.new(lp.Character.HumanoidRootPart.Position.X, 50, lp.Character.HumanoidRootPart.Position.Z)
                    end
                end
                task.wait(0.1)
            end
        end)
    end)

    -- 4. SPEED & JUMP MODS
    AddBtn("ADMIN SPEED (250)", function(s) lp.Character.Humanoid.WalkSpeed = s and 250 or 16 end)
    AddBtn("ADMIN JUMP (300)", function(s) lp.Character.Humanoid.UseJumpPower = true; lp.Character.Humanoid.JumpPower = s and 300 or 50 end)

    -- 5. NOCLIP
    AddBtn("NOCLIP (WALLWALK)", function(s)
        _G.NC = s
        RS.Stepped:Connect(function()
            if _G.NC and lp.Character then
                for _, v in pairs(lp.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    end)

    -- INFO FOOTER
    local Info = Instance.new("TextLabel", MF)
    Info.Size = UDim2.new(1, 0, 0, 50); Info.Position = UDim2.new(0, 0, 1, -50)
    Info.BackgroundTransparency = 1; Info.TextColor3 = Color3.fromRGB(255, 0, 0); Info.Font = Enum.Font.GothamBold
    Info.Text = "omamilch V5 | HanfmomentV1 | F3 zum Schließen"

    -- F3 TOGGLE
    UIS.InputBegan:Connect(function(io, g) if not g and io.KeyCode == Enum.KeyCode.F3 then MF.Visible = not MF.Visible end end)
end

task.delay(0.5, function() pcall(InitAdminGUI) end)
