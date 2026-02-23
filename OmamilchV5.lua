--[[ 
    OMAMILCH V5 - STABILITY UPDATE (V34)
    USER: HanfmomentV1 | KEY: HanfmomentV1
    FIXES: Lag Reduction, Death-Bypass, Physics-Stability
]]

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- START-NACHRICHT
pcall(function()
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("omamilch V5 Ist An", "All")
end)

local Window = Fluent:CreateWindow({
    Title = "omamilch V5 " .. Fluent.Version,
    SubTitle = "by HanfmomentV1",
    TabWidth = 160,
    Size = UDim2.fromOffset(460, 400),
    Acrylic = false,
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Tabs
local Tabs = {
    Voice = Window:AddTab({ Title = "Voice", Icon = "mic" }),
    Character = Window:AddTab({ Title = "Character", Icon = "user" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "component" }),
    Scripts = Window:AddTab({ Title = "Scripts", Icon = "scroll" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- --- OPTIMIERTE FLY LOGIK (KEIN LAG) ---
local flyMode = false
local speedLevels = {30, 70, 120, 200} -- Sicherere Geschwindigkeiten gegen Insta-Death
local currentSpeedIdx = 2
local flyBV, flyBG

local function ToggleFly()
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    flyMode = not flyMode
    
    if flyMode and hrp and hum then
        -- Bestehende Kräfte löschen
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
        
        flyBV = Instance.new("BodyVelocity", hrp)
        flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyBV.Velocity = Vector3.new(0, 0, 0)
        
        flyBG = Instance.new("BodyGyro", hrp)
        flyBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        flyBG.D = 500 -- Dämpfung gegen Zittern/Lag
        
        task.spawn(function()
            while flyMode and char and hrp do
                local dt = game:GetService("RunService").RenderStepped:Wait()
                hum:ChangeState(Enum.HumanoidStateType.Landed) -- Anti-Height Kill Bypass
                
                flyBG.CFrame = workspace.CurrentCamera.CFrame
                local moveDir = hum.MoveDirection
                local speed = speedLevels[currentSpeedIdx]
                
                if moveDir.Magnitude > 0 then
                    flyBV.Velocity = workspace.CurrentCamera.CFrame:VectorToWorldSpace(Vector3.new(moveDir.X, 0, moveDir.Z * 1.5)) * speed
                else
                    flyBV.Velocity = Vector3.new(0, 0.1, 0) -- Schweben ohne Sinken
                end
            end
            -- Aufräumen wenn Fly aus
            if flyBV then flyBV:Destroy() end
            if flyBG then flyBG:Destroy() end
            hum.PlatformStand = false
        end)
        Fluent:Notify({Title = "Fly", Content = "An (Speed: "..speedLevels[currentSpeedIdx]..")", Duration = 2})
    else
        Fluent:Notify({Title = "Fly", Content = "Aus", Duration = 2})
    end
end

-- Keybinds
game:GetService("UserInputService").InputBegan:Connect(function(input, g)
    if g then return end
    if input.KeyCode == Enum.KeyCode.F then
        ToggleFly()
    elseif input.KeyCode == Enum.KeyCode.X and flyMode then
        currentSpeedIdx = (currentSpeedIdx % #speedLevels) + 1
        Fluent:Notify({Title = "Fly Speed", Content = "Speed: "..speedLevels[currentSpeedIdx], Duration = 1.5})
    end
end)

-- --- RESTLICHE FUNKTIONEN (DEIN ORIGINAL CODE) ---
local CharacterSection = Tabs.Character:AddSection("Charakter")
local DropdownSection = Tabs.Misc:AddSection("Teleport")
local EspSection = Tabs.Misc:AddSection("ESP")
local ScriptsSection = Tabs.Scripts:AddSection("Scripts")

-- Teleport (Optimiert)
local selectedPlayerName = nil
local players = {"Select Player"}
local Dropdown = DropdownSection:AddDropdown("Dropdown", {
    Title = "Teleport zu Spieler",
    Values = players,
    Multi = false,
    Default = 1,
    Callback = function(value) selectedPlayerName = value end
})

DropdownSection:AddButton({
    Title = "Teleport",
    Callback = function()
        local target = game.Players:FindFirstChild(selectedPlayerName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        end
    end
})

-- Dropdown Refresh
local function updateDropdown() Dropdown:SetValues(players) end
game.Players.PlayerAdded:Connect(function(p) table.insert(players, p.Name) updateDropdown() end)
game.Players.PlayerRemoving:Connect(function(p)
    for i, v in ipairs(players) do if v == p.Name then table.remove(players, i) break end end
    updateDropdown()
end)
for _, p in ipairs(game.Players:GetPlayers()) do table.insert(players, p.Name) end

-- ESP & Banger
EspSection:AddToggle("EspToggle", {
    Title = "Esp Toggle",
    Default = false,
    Callback = function(state)
        if state then loadstring(game:HttpGet("https://raw.githubusercontent.com/Latura1/Voicechat/refs/heads/main/Esp%20on"))()
        else loadstring(game:HttpGet("https://raw.githubusercontent.com/Latura1/Voicechat/refs/heads/main/Esp%20off"))() end
    end 
})

ScriptsSection:AddButton({
    Title = "Banger",
    Callback = function() loadstring(game:HttpGet("https://pastebin.com/raw/pPCkzSJG"))() end
})

CharacterSection:AddSlider("SpeedSlider", {
    Title = "WalkSpeed",
    Default = 16, Min = 16, Max = 250, Rounding = 1,
    Callback = function(Value) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value end
})

Window:SelectTab(1)
Fluent:Notify({Title = "omamilch V5", Content = "Lag-Fix V34 geladen!", Duration = 5})
