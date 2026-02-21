--[[ 
    OMAMILCH V5 - FINAL REPAIR (V20)
    USER: HanfmomentV1 | KEY: HanfmomentV1
    FIXES: Animation Errors, Nil Arguments, Executor Crashes
]]

-- Sicherer Start-Check
if _G.OM_LOADED then _G.OM_LOADED = false end
task.wait(0.2)
_G.OM_LOADED = true

local lp = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Cam = workspace.CurrentCamera

-- Nachricht beim Start senden
local function SendStartMessage()
    local chatEvents = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvents then
        chatEvents.SayMessageRequest:FireServer("omamilch V5 Ist An", "All")
    end
end

local function StartScript()
    -- GUI ERSTELLUNG
    local SG = Instance.new("ScreenGui")
    pcall(function() SG.Parent = game:GetService("CoreGui") or lp:WaitForChild("PlayerGui") end)
    SG.Name = "omamilchV5_FinalFix"
    SG.ResetOnSpawn = false

    local MF = Instance.new("Frame", SG)
    MF.Size = UDim2.new(0, 800, 0, 500)
    MF.Position = UDim2.new(0.5, -400, 0.5, -250)
    MF.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
    MF.Active, MF.Draggable = true, true
    Instance.new("UIStroke", MF).Color = Color3.fromRGB(255, 0, 0)

    -- Rote Sterne (Hintergrund)
    for i = 1, 25 do
        local s = Instance.new("TextLabel", MF)
        s.Text = "★"; s.TextColor3 = Color3.fromRGB(200, 0, 0)
        s.BackgroundTransparency = 1; s.Position = UDim2.new(math.random(), 0, math.random(), 0)
    end

    local MainCon = Instance.new("ScrollingFrame", MF)
    MainCon.Size = UDim2.new(1, -20, 1, -120); MainCon.Position = UDim2.new(0, 10, 0, 70); MainCon.BackgroundTransparency = 1
    MainCon.CanvasSize = UDim2.new(0,0,3,0); MainCon.ScrollBarThickness = 2
    Instance.new("UIListLayout", MainCon).Padding = UDim.new(0, 8)

    -- FUNKTIONEN
    local function AddBtn(name, callback)
        local b = Instance.new("TextButton", MainCon)
        b.Size = UDim2.new(1, -10, 0, 45); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
        b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(callback)
    end

    -- 1. FLY & ANTI-KILL BYPASS (German Voice Update Fix)
    local flyV, flyG, flyL
    AddBtn("FLY / UNFLY (TOGGLE)", function()
        _G.FlyMode = not _G.FlyMode
        if _G.FlyMode then
            local hrp = lp.Character:WaitForChild("HumanoidRootPart")
            flyV = Instance.new("BodyVelocity", hrp); flyV.MaxForce = Vector3.new(1e9,1e9,1e9)
            flyG = Instance.new("BodyGyro", hrp); flyG.MaxTorque = Vector3.new(1e9,1e9,1e9)
            flyL = RS.RenderStepped:Connect(function()
                lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed) -- Bypass für High-Altitude Kill
                flyG.CFrame = Cam.CFrame
                flyV.Velocity = (lp.Character.Humanoid.MoveDirection.Magnitude > 0) and (Cam.CFrame.LookVector * 150) or Vector3.new(0, 0.1, 0)
            end)
        else
            if flyL then flyL:Disconnect() end
            if flyV then flyV:Destroy() end; if flyG then flyG:Destroy() end
            lp.Character.Humanoid.PlatformStand = false
        end
    end)

    -- 2. SPEED & JUMP (Fixed)
    AddBtn("SPEED (180)", function() lp.Character.Humanoid.WalkSpeed = 180 end)
    AddBtn("JUMP (250)", function() lp.Character.Humanoid.UseJumpPower = true; lp.Character.Humanoid.JumpPower = 250 end)
    AddBtn("RESET STATS", function() lp.Character.Humanoid.WalkSpeed = 16; lp.Character.Humanoid.JumpPower = 50 end)

    -- 3. NOCLIP
    AddBtn("NOCLIP (TOGGLE)", function()
        _G.NC = not _G.NC
        RS.Stepped:Connect(function()
            if _G.NC and lp.Character then
                for _, v in pairs(lp.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    end)

    -- CHAT COMMANDS ENGINE (;)
    lp.Chatted:Connect(function(msg)
        local m = msg:lower()
        if m == ";fly" then _G.FlyMode = true 
        elseif m == ";unfly" then _G.FlyMode = false
        elseif m:sub(1,6) == ";speed" then lp.Character.Humanoid.WalkSpeed = tonumber(m:sub(8)) or 150
        end
    end)

    -- INFOS UNTEN LINKS (Fixed IP Loading)
    local Info = Instance.new("TextLabel", MF)
    Info.Size = UDim2.new(1, -20, 0, 40); Info.Position = UDim2.new(0, 10, 1, -45)
    Info.BackgroundTransparency = 1; Info.TextColor3 = Color3.fromRGB(255, 0, 0); Info.Font = Enum.Font.GothamBold
    Info.Text = "Lade Daten..."
    
    task.spawn(function()
        local success, ip = pcall(function() return game:HttpGet("https://api.ipify.org") end)
        Info.Text = "IP: " .. (success and ip or "Hidden") .. " | USER: HanfmomentV1 | STATUS: IST AN"
    end)

    -- MENÜ SCHLIESSEN
    UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.F3 then MF.Visible = not MF.Visible end end)
    
    SendStartMessage()
end

-- Sicherer Start-Verzögerer gegen Abstürze
task.delay(1, function()
    pcall(StartScript)
end)
