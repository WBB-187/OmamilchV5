--[[ 
    OMAMILCH V5 - CHAT COMMAND EDITION (V17)
    USER: HanfmomentV1 | KEY: HanfmomentV1
    PREFIX: ;
]]

if _G.OM_LOADED then return end
_G.OM_LOADED = true

local function _0xCHAT_BOOT()
    local lp = game:GetService("Players").LocalPlayer
    local RS = game:GetService("RunService")
    local Cam = workspace.CurrentCamera
    
    -- VARIABLEN FÜR STATUS
    local flyActive = false
    local flyBV, flyBG, flyL
    local antiDeath = true -- Standardmäßig AN für Sicherheit

    -- --- FUNKTIONS LOGIK ---

    local function ToggleFly(state)
        flyActive = state
        if state then
            local hrp = lp.Character:WaitForChild("HumanoidRootPart")
            flyBV = Instance.new("BodyVelocity", hrp); flyBV.MaxForce = Vector3.new(1e9,1e9,1e9)
            flyBG = Instance.new("BodyGyro", hrp); flyBG.MaxTorque = Vector3.new(1e9,1e9,1e9)
            flyL = RS.RenderStepped:Connect(function()
                lp.Character.Humanoid.PlatformStand = true
                flyBG.CFrame = Cam.CFrame
                flyBV.Velocity = (lp.Character.Humanoid.MoveDirection.Magnitude > 0) and (Cam.CFrame.LookVector * 150) or Vector3.new(0, 0.1, 0)
            end)
        else
            if flyL then flyL:Disconnect() end
            if flyBV then flyBV:Destroy() end; if flyBG then flyBG:Destroy() end
            lp.Character.Humanoid.PlatformStand = false
        end
    end

    -- ANTI-HEIGHT DEATH LOOP (Immer im Hintergrund)
    task.spawn(function()
        while true do
            if antiDeath and lp.Character and lp.Character:FindFirstChild("Humanoid") then
                lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
            end
            task.wait(0.1)
        end
    end)

    -- --- CHAT COMMANDS ENGINE ---
    lp.Chatted:Connect(function(msg)
        local cmd = msg:lower()
        
        -- FLY BEFEHLE
        if cmd == ";fly" then
            ToggleFly(true)
            print("Fly aktiviert")
        elseif cmd == ";unfly" then
            ToggleFly(false)
            print("Fly deaktiviert")
            
        -- SPEED BEFEHLE
        elseif cmd:sub(1, 6) == ";speed" then
            local val = tonumber(cmd:sub(8)) or 150
            lp.Character.Humanoid.WalkSpeed = val
        elseif cmd == ";unspeed" then
            lp.Character.Humanoid.WalkSpeed = 16
            
        -- JUMP BEFEHLE
        elseif cmd:sub(1, 5) == ";jump" then
            local val = tonumber(cmd:sub(7)) or 200
            lp.Character.Humanoid.UseJumpPower = true
            lp.Character.Humanoid.JumpPower = val
        elseif cmd == ";unjump" then
            lp.Character.Humanoid.JumpPower = 50

        -- NOCLIP BEFEHLE
        elseif cmd == ";noclip" then
            _G.NC = true
            RS.Stepped:Connect(function()
                if _G.NC and lp.Character then
                    for _, v in pairs(lp.Character:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = false end
                    end
                end
            end)
        elseif cmd == ";clip" or cmd == ";unnoclip" then
            _G.NC = false

        -- TELEPORT BEFEHLE (;tp [Name])
        elseif cmd:sub(1, 3) == ";tp" then
            local targetName = cmd:sub(5)
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Name:lower():sub(1, #targetName) == targetName:lower() then
                    lp.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                    break
                end
            end

        -- EMOTES
        elseif cmd == ";dance" then
            local a = Instance.new("Animation"); a.AnimationId = "rbxassetid://182435933"
            lp.Character.Humanoid:LoadAnimation(a):Play()
        end
    end)

    print("omamilch V17 geladen! Chat-Befehle mit ; aktiv.")
end

task.defer(_0xCHAT_BOOT)
