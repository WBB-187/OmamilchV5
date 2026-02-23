--[[ 
    OMAMILCH V5 - OFFICIAL INTERFACE (V27)
    USER: HanfmomentV1 | KEY: HanfmomentV1
    STATUS: VISUAL BYPASS ACTIVE (NO FAKE LABELS)
]]

if _G.OM_RUNNING then _G.OM_RUNNING = false end
task.wait(0.2)
_G.OM_RUNNING = true

local lp = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Cam = workspace.CurrentCamera

-- Offizielle Start-Sequenz
pcall(function()
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("omamilch V5 Ist An", "All")
end)

local function InitV27()
    local SG = Instance.new("ScreenGui")
    SG.Name = "HDAdminInterface" -- Name aus deinen Screenshots übernommen
    pcall(function() SG.Parent = game:GetService("CoreGui") or lp:WaitForChild("PlayerGui") end)

    -- --- CMDR CONSOLE (AUTHENTIC LOOK) ---
    local CmdrFrame = Instance.new("Frame", SG)
    CmdrFrame.Size = UDim2.new(1, 0, 0, 35); CmdrFrame.Position = UDim2.new(0, 0, 0, -35)
    CmdrFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); CmdrFrame.Visible = false
    local CmdrText = Instance.new("TextBox", CmdrFrame)
    CmdrText.Size = UDim2.new(1, -20, 1, 0); CmdrText.Position = UDim2.new(0, 10, 0, 0)
    CmdrText.BackgroundTransparency = 1; CmdrText.TextColor3 = Color3.new(1,1,1); CmdrText.Text = "> "
    CmdrText.TextXAlignment = Enum.TextXAlignment.Left; CmdrText.Font = Enum.Font.Code

    -- --- MAIN PANEL (SUPREME RED) ---
    local MF = Instance.new("Frame", SG)
    MF.Size = UDim2.new(0, 800, 0, 500); MF.Position = UDim2.new(0.5, -400, 0.5, -250)
    MF.BackgroundColor3 = Color3.fromRGB(5, 0, 0); MF.Active, MF.Draggable = true, true
    Instance.new("UIStroke", MF).Color = Color3.fromRGB(255, 0, 0)
    
    -- Sterne Deko
    for i = 1, 30 do
        local s = Instance.new("TextLabel", MF)
        s.Text = "★"; s.TextColor3 = Color3.fromRGB(255, 0, 0); s.BackgroundTransparency = 1
        s.Position = UDim2.new(math.random(), 0, math.random(), 0)
    end

    local Content = Instance.new("ScrollingFrame", MF)
    Content.Size = UDim2.new(1, -20, 1, -100); Content.Position = UDim2.new(0, 10, 0, 20)
    Content.BackgroundTransparency = 1; Content.CanvasSize = UDim2.new(0, 0, 4, 0)
    Instance.new("UIListLayout", Content).Padding = UDim.new(0, 8)

    local function AddBtn(name, callback)
        local b = Instance.new("TextButton", Content)
        b.Size = UDim2.new(1, -10, 0, 50); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(25, 0, 0)
        b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() pcall(callback) end)
    end

    -- --- ADMIN COMMANDS ---

    -- Fly System (Vollständige 360° Kontrolle)
    local flyV, flyG, flyL
    AddBtn("ADMIN FLY (ACTIVE)", function()
        _G.HD_Fly = not _G.HD_Fly
        if _G.HD_Fly then
            local hrp = lp.Character.HumanoidRootPart
            flyV = Instance.new("BodyVelocity", hrp); flyV.MaxForce = Vector3.new(1e9,1e9,1e9)
            flyG = Instance.new("BodyGyro", hrp); flyG.MaxTorque = Vector3.new(1e9,1e9,1e9)
            flyL = RS.RenderStepped:Connect(function()
                lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                flyG.CFrame = Cam.CFrame
                local moveDir = lp.Character.Humanoid.MoveDirection
                flyV.Velocity = (moveDir.Magnitude > 0) and (Cam.CFrame:VectorToWorldSpace(Vector3.new(moveDir.X, 0, moveDir.Z * 1.5)) * 180) or Vector3.new(0, 0.1, 0)
            end)
        else
            if flyL then flyL:Disconnect() end; if flyV then flyV:Destroy() end; if flyG then flyG:Destroy() end
        end
    end)

    AddBtn("ENHANCED NOCLIP", function()
        _G.NC = not _G.NC
        RS.Stepped:Connect(function()
            if _G.NC and lp.Character then
                for _, v in pairs(lp.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide and v.Name ~= "HumanoidRootPart" then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end)

    AddBtn("CMD INTERFACE", function()
        CmdrFrame.Visible = not CmdrFrame.Visible
        CmdrFrame:TweenPosition(CmdrFrame.Visible and UDim2.new(0,0,0,0) or UDim2.new(0,0,0,-35), "Out", "Quart", 0.2)
    end)

    AddBtn("SERVER BYPASS (GODMODE)", function()
        RS.Heartbeat:Connect(function()
            if lp.Character and lp.Character:FindFirstChild("Humanoid") then
                lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                if lp.Character.HumanoidRootPart.Position.Y < -45 then
                    lp.Character.HumanoidRootPart.CFrame = CFrame.new(lp.Character.HumanoidRootPart.Position.X, 15, lp.Character.HumanoidRootPart.Position.Z)
                end
            end
        end)
    end)

    -- FOOTER
    local Info = Instance.new("TextLabel", MF)
    Info.Size = UDim2.new(1, 0, 0, 40); Info.Position = UDim2.new(0, 0, 1, -45)
    Info.BackgroundTransparency = 1; Info.TextColor3 = Color3.fromRGB(255, 0, 0); Info.Font = Enum.Font.GothamBold
    Info.Text = "ADMIN PANEL | HanfmomentV1 | TOGGLE: F3"

    -- F3 & F2 Steuerung
    UIS.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Enum.KeyCode.F3 then MF.Visible = not MF.Visible end
        if not g and i.KeyCode == Enum.KeyCode.F2 then 
            CmdrFrame.Visible = not CmdrFrame.Visible
            CmdrFrame:TweenPosition(CmdrFrame.Visible and UDim2.new(0,0,0,0) or UDim2.new(0,0,0,-35), "Out", "Quart", 0.2)
        end
    end)
end

task.delay(0.5, function() pcall(InitV27) end)
