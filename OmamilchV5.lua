--[[ 
    OMAMILCH V5 - ULTRA STABILITY (V21)
    USER: HanfmomentV1 | KEY: HanfmomentV1
    FIXES: Spawn-Errors, Animation-Crashes, German Voice Death-Link
]]

-- Anti-Double Load & Crash Prevention
if _G.OM_RUNNING then _G.OM_RUNNING = false end
task.wait(0.5)
_G.OM_RUNNING = true

local lp = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- Nachricht beim Start (Sicherer Event-Check)
local function Broadcast()
    pcall(function()
        local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
        if chat then
            chat.SayMessageRequest:FireServer("omamilch V5 Ist An", "All")
        end
    end)
end

local function InitScript()
    -- GUI CONTAINER
    local SG = Instance.new("ScreenGui")
    SG.Name = "omamilch_V21"
    SG.ResetOnSpawn = false
    pcall(function() SG.Parent = game:GetService("CoreGui") end)
    if not SG.Parent then SG.Parent = lp:WaitForChild("PlayerGui") end

    -- MAIN WINDOW
    local MF = Instance.new("Frame", SG)
    MF.Size = UDim2.new(0, 750, 0, 450)
    MF.Position = UDim2.new(0.5, -375, 0.5, -225)
    MF.BackgroundColor3 = Color3.fromRGB(5, 0, 0)
    MF.BorderSizePixel = 0
    MF.Active, MF.Draggable = true, true
    Instance.new("UIStroke", MF).Color = Color3.fromRGB(255, 0, 0)

    -- Rote Sterne (Optimiert gegen Lag)
    for i = 1, 15 do
        local star = Instance.new("TextLabel", MF)
        star.Text = "★"; star.TextColor3 = Color3.fromRGB(150, 0, 0)
        star.BackgroundTransparency = 1; star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    end

    local Content = Instance.new("ScrollingFrame", MF)
    Content.Size = UDim2.new(1, -20, 1, -100)
    Content.Position = UDim2.new(0, 10, 0, 20)
    Content.BackgroundTransparency = 1; Content.CanvasSize = UDim2.new(0, 0, 2, 0)
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 10)

    local function MakeBtn(txt, callback)
        local b = Instance.new("TextButton", Content)
        b.Size = UDim2.new(1, -10, 0, 50); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
        b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.SourceSansBold; b.TextSize = 20
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() pcall(callback) end)
    end

    -- --- BYPASS FEATURES ---

    -- FLY & ANTI-HEIGHT-DEATH
    local flyConn, bv, bg
    MakeBtn("FLY (TOGGLE)", function()
        _G.Flying = not _G.Flying
        if _G.Flying then
            local hrp = lp.Character:WaitForChild("HumanoidRootPart")
            bv = Instance.new("BodyVelocity", hrp); bv.MaxForce = Vector3.new(1e9,1e9,1e9)
            bg = Instance.new("BodyGyro", hrp); bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
            flyConn = RS.RenderStepped:Connect(function()
                lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                bg.CFrame = workspace.CurrentCamera.CFrame
                bv.Velocity = (lp.Character.Humanoid.MoveDirection.Magnitude > 0) and (workspace.CurrentCamera.CFrame.LookVector * 150) or Vector3.new(0, 0.1, 0)
            end)
        else
            if flyConn then flyConn:Disconnect() end
            if bv then bv:Destroy() end; if bg then bg:Destroy() end
            lp.Character.Humanoid.PlatformStand = false
        end
    end)

    -- STATS
    MakeBtn("SPEED (180)", function() lp.Character.Humanoid.WalkSpeed = 180 end)
    MakeBtn("JUMP (250)", function() lp.Character.Humanoid.UseJumpPower = true; lp.Character.Humanoid.JumpPower = 250 end)
    MakeBtn("RESET ALL", function() lp.Character.Humanoid.WalkSpeed = 16; lp.Character.Humanoid.JumpPower = 50; _G.Flying = false end)

    -- INFO FOOTER
    local Info = Instance.new("TextLabel", MF)
    Info.Size = UDim2.new(1, 0, 0, 40); Info.Position = UDim2.new(0, 0, 1, -45)
    Info.BackgroundTransparency = 1; Info.TextColor3 = Color3.fromRGB(255, 0, 0)
    Info.Text = "omamilch V5 | USER: HanfmomentV1 | STATUS: IST AN"

    -- F3 Toggle
    UIS.InputBegan:Connect(function(io, g) if not g and io.KeyCode == Enum.KeyCode.F3 then MF.Visible = not MF.Visible end end)
    
    Broadcast()
end

-- Start mit Delay gegen Executor-Spam
task.wait(1)
pcall(InitScript)
