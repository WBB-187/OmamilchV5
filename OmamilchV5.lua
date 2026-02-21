--[[ 
    OMAMILCH V5 - GUI RECOVERY (V22)
    USER: HanfmomentV1 | KEY: HanfmomentV1
    FEATURES: ESP, FLY, SPEED, JUMP, NOCLIP
    TOGGLE: F3
]]

if _G.OM_RUNNING then _G.OM_RUNNING = false end
task.wait(0.3)
_G.OM_RUNNING = true

local lp = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Cam = workspace.CurrentCamera

-- --- START NACHRICHT ---
pcall(function()
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("omamilch V5 Ist An", "All")
end)

local function InitGUI()
    local SG = Instance.new("ScreenGui")
    SG.Name = "omamilchV5_V22"
    SG.ResetOnSpawn = false
    pcall(function() SG.Parent = game:GetService("CoreGui") end)
    if not SG.Parent then SG.Parent = lp:WaitForChild("PlayerGui") end

    local MF = Instance.new("Frame", SG)
    MF.Size = UDim2.new(0, 800, 0, 500)
    MF.Position = UDim2.new(0.5, -400, 0.5, -250)
    MF.BackgroundColor3 = Color3.fromRGB(8, 0, 0)
    MF.Active, MF.Draggable = true, true
    Instance.new("UIStroke", MF).Color = Color3.fromRGB(255, 0, 0)

    -- Rote Sterne (Hanfmoment Style)
    for i = 1, 25 do
        local s = Instance.new("TextLabel", MF)
        s.Text = "★"; s.TextColor3 = Color3.fromRGB(255, 0, 0)
        s.BackgroundTransparency = 1; s.Position = UDim2.new(math.random(), 0, math.random(), 0)
    end

    local Content = Instance.new("ScrollingFrame", MF)
    Content.Size = UDim2.new(1, -20, 1, -100); Content.Position = UDim2.new(0, 10, 0, 20)
    Content.BackgroundTransparency = 1; Content.CanvasSize = UDim2.new(0, 0, 3, 0)
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 8)

    local function AddToggle(name, callback)
        local b = Instance.new("TextButton", Content)
        b.Size = UDim2.new(1, -10, 0, 45); b.Text = name .. " [OFF]"; b.BackgroundColor3 = Color3.fromRGB(35, 0, 0)
        b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
        local s = false
        b.MouseButton1Click:Connect(function()
            s = not s
            b.Text = name .. (s and " [ON]" or " [OFF]")
            b.BackgroundColor3 = s and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(35, 0, 0)
            pcall(function() callback(s) end)
        end)
    end

    -- --- FEATURES ---

    -- 1. ESP (Boxen um Spieler)
    AddToggle("PLAYER ESP", function(s)
        _G.ESP = s
        while _G.ESP do
            for _, p in pairs(game:GetService("Players"):GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if not p.Character:FindFirstChild("OM_ESP") then
                        local b = Instance.new("BoxHandleAdornment", p.Character)
                        b.Name = "OM_ESP"; b.Adornee = p.Character.HumanoidRootPart; b.AlwaysOnTop = true
                        b.ZIndex = 5; b.Size = Vector3.new(4, 6, 1); b.Transparency = 0.5; b.Color3 = Color3.new(1, 0, 0)
                    end
                end
            end
            task.wait(1)
            if not _G.ESP then 
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p.Character and p.Character:FindFirstChild("OM_ESP") then p.Character.OM_ESP:Destroy() end
                end
            end
        end
    end)

    -- 2. FLY & ANTI-HEIGHT BYPASS
    local fV, fG, fL
    AddToggle("FLY BYPASS", function(s)
        if s then
            local hrp = lp.Character:WaitForChild("HumanoidRootPart")
            fV = Instance.new("BodyVelocity", hrp); fV.MaxForce = Vector3.new(1e9,1e9,1e9)
            fG = Instance.new("BodyGyro", hrp); fG.MaxTorque = Vector3.new(1e9,1e9,1e9)
            fL = RS.RenderStepped:Connect(function()
                lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                fG.CFrame = Cam.CFrame
                fV.Velocity = (lp.Character.Humanoid.MoveDirection.Magnitude > 0) and (Cam.CFrame.LookVector * 150) or Vector3.new(0, 0.1, 0)
            end)
        else
            if fL then fL:Disconnect() end; if fV then fV:Destroy() end; if fG then fG:Destroy() end
            lp.Character.Humanoid.PlatformStand = false
        end
    end)

    -- 3. SPEED & JUMP
    AddToggle("SPEED (180)", function(s) lp.Character.Humanoid.WalkSpeed = s and 180 or 16 end)
    AddToggle("JUMP (250)", function(s) lp.Character.Humanoid.UseJumpPower = true; lp.Character.Humanoid.JumpPower = s and 250 or 50 end)

    -- 4. NOCLIP
    AddToggle("NOCLIP", function(s)
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
    Info.Size = UDim2.new(1, 0, 0, 40); Info.Position = UDim2.new(0, 0, 1, -45)
    Info.BackgroundTransparency = 1; Info.TextColor3 = Color3.fromRGB(255, 0, 0); Info.Font = Enum.Font.GothamBold
    Info.Text = "omamilch V5 | USER: HanfmomentV1 | TOGGLE: F3"

    -- F3 TOGGLE
    UIS.InputBegan:Connect(function(io, g) if not g and io.KeyCode == Enum.KeyCode.F3 then MF.Visible = not MF.Visible end end)
end

task.delay(0.5, function() pcall(InitGUI) end)
