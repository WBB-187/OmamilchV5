--[[ 
    OMAMILCH V5 - MESSAGE EDITION (V19)
    USER: HanfmomentV1 | KEY: HanfmomentV1
    NEW: Schickt Nachricht "Ist An" beim Start
]]

-- Sicherstellen, dass nichts doppelt lädt
if _G.OM_LOADED then _G.OM_LOADED = false end 
task.wait(0.1)
_G.OM_LOADED = true

local lp = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Cam = workspace.CurrentCamera

-- --- ANTI-CRASH BOOT ---
local function StartScript()
    
    -- NACHRICHT BEIM START (Im Chat anzeigen)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("omamilch V5 Ist An", "All")
    
    -- GUI ERSTELLUNG (Red Star Design)
    local SG = Instance.new("ScreenGui")
    pcall(function() SG.Parent = game:GetService("CoreGui") or lp:WaitForChild("PlayerGui") end)
    SG.Name = "omamilchV5_V19"
    SG.ResetOnSpawn = false

    local MF = Instance.new("Frame", SG)
    MF.Size = UDim2.new(0, 800, 0, 500)
    MF.Position = UDim2.new(0.5, -400, 0.5, -250)
    MF.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
    MF.Active, MF.Draggable = true, true
    Instance.new("UIStroke", MF).Color = Color3.fromRGB(255, 0, 0)

    -- Rote Sterne Deko
    for i = 1, 30 do
        local s = Instance.new("TextLabel", MF)
        s.Text = "★"; s.TextColor3 = Color3.fromRGB(255, 0, 0)
        s.BackgroundTransparency = 1; s.Position = UDim2.new(math.random(), 0, math.random(), 0)
    end

    local MainCon = Instance.new("ScrollingFrame", MF)
    MainCon.Size = UDim2.new(1, -20, 1, -120); MainCon.Position = UDim2.new(0, 10, 0, 70); MainCon.BackgroundTransparency = 1
    MainCon.CanvasSize = UDim2.new(0,0,5,0)
    Instance.new("UIListLayout", MainCon).Padding = UDim.new(0, 8)

    local function CreateButton(name, callback)
        local b = Instance.new("TextButton", MainCon)
        b.Size = UDim2.new(1, -10, 0, 45); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
        b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(callback)
    end

    -- FEATURES
    local fV, fG, fL
    CreateButton("FLY (AN/AUS)", function()
        _G.Fly = not _G.Fly
        if _G.Fly then
            local hrp = lp.Character:WaitForChild("HumanoidRootPart")
            fV = Instance.new("BodyVelocity", hrp); fV.MaxForce = Vector3.new(1e9,1e9,1e9)
            fG = Instance.new("BodyGyro", hrp); fG.MaxTorque = Vector3.new(1e9,1e9,1e9)
            fL = RS.RenderStepped:Connect(function()
                lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                lp.Character.Humanoid.PlatformStand = true
                fG.CFrame = Cam.CFrame
                fV.Velocity = (lp.Character.Humanoid.MoveDirection.Magnitude > 0) and (Cam.CFrame.LookVector * 150) or Vector3.new(0, 0.1, 0)
            end)
        else
            if fL then fL:Disconnect() end; if fV then fV:Destroy() end; if fG then fG:Destroy() end
            lp.Character.Humanoid.PlatformStand = false
        end
    end)

    CreateButton("SPEED (180)", function() lp.Character.Humanoid.WalkSpeed = 180 end)
    CreateButton("JUMP (250)", function() lp.Character.Humanoid.UseJumpPower = true; lp.Character.Humanoid.JumpPower = 250 end)
    CreateButton("NOCLIP (Toggle)", function()
        _G.NC = not _G.NC
        RS.Stepped:Connect(function()
            if _G.NC and lp.Character then
                for _, v in pairs(lp.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    end)

    -- CHAT COMMANDS (;)
    lp.Chatted:Connect(function(m)
        local c = m:lower()
        if c == ";fly" then _G.Fly = true 
        elseif c == ";unfly" then _G.Fly = false
        elseif c:sub(1,6) == ";speed" then lp.Character.Humanoid.WalkSpeed = tonumber(c:sub(8)) or 150
        end
    end)

    -- NETWORK INFO
    local Net = Instance.new("TextLabel", MF)
    Net.Size = UDim2.new(0, 500, 0, 40); Net.Position = UDim2.new(0, 15, 1, -45)
    Net.BackgroundTransparency = 1; Net.TextColor3 = Color3.fromRGB(255, 0, 0); Net.Font = Enum.Font.GothamBold
    task.spawn(function()
        local ip = game:HttpGet("https://api.ipify.org")
        while task.wait(1) do
            Net.Text = "IP: " .. ip .. " | USER: HanfmomentV1 | STATUS: ONLINE"
        end
    end)

    UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.F3 then MF.Visible = not MF.Visible end end)
end

task.delay(0.5, function()
    pcall(StartScript)
end)
