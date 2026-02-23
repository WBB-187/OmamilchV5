--[[ 
    OMAMILCH V5 - INTERNAL TURBO (V33)
    USER: HanfmomentV1 | KEY: HanfmomentV1
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

-- Tabs erstellen
local Tabs = {
    Voice = Window:AddTab({ Title = "Voice", Icon = "mic" }),
    Character = Window:AddTab({ Title = "Character", Icon = "user" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "component" }),
    Scripts = Window:AddTab({ Title = "Scripts", Icon = "scroll" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Sections
local CharacterSection = Tabs.Character:AddSection("Charakter")
local DropdownSection = Tabs.Misc:AddSection("Teleport")
local EspSection = Tabs.Misc:AddSection("ESP")
local ScriptsSection = Tabs.Scripts:AddSection("Scripts")

-- --- INTERNE TURBO FLY LOGIK (KEIN PASTEBIN) ---
local flyMode = false
local speedLevels = {50, 150, 400, 800} -- Deutlich schneller als das alte Fly
local currentSpeedIdx = 2
local flyV, flyG, flyL

local function ToggleFly()
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    flyMode = not flyMode
    
    if flyMode and hrp then
        flyV = Instance.new("BodyVelocity", hrp)
        flyV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyG = Instance.new("BodyGyro", hrp)
        flyG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        
        flyL = game:GetService("RunService").RenderStepped:Connect(function()
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Landed) -- Anti-Height Bypass
            flyG.CFrame = workspace.CurrentCamera.CFrame
            local moveDir = char.Humanoid.MoveDirection
            local speed = speedLevels[currentSpeedIdx]
            flyV.Velocity = (moveDir.Magnitude > 0) and (workspace.CurrentCamera.CFrame:VectorToWorldSpace(Vector3.new(moveDir.X, 0, moveDir.Z * 1.5)) * speed) or Vector3.new(0, 0.1, 0)
        end)
        Fluent:Notify({Title = "Fly", Content = "Eingeschaltet (Speed: " .. speedLevels[currentSpeedIdx] .. ")", Duration = 2})
    else
        if flyL then flyL:Disconnect() end
        if flyV then flyV:Destroy() end
        if flyG then flyG:Destroy() end
        if char and char:FindFirstChildOfClass("Humanoid") then char.Humanoid.PlatformStand = false end
        Fluent:Notify({Title = "Fly", Content = "Ausgeschaltet", Duration = 2})
    end
end

-- Fly Steuerung über Tasten (wie im alten Script)
game:GetService("UserInputService").InputBegan:Connect(function(input, g)
    if g then return end
    if input.KeyCode == Enum.KeyCode.F then
        ToggleFly()
    elseif input.KeyCode == Enum.KeyCode.X and flyMode then
        currentSpeedIdx = (currentSpeedIdx % #speedLevels) + 1
        Fluent:Notify({Title = "Fly Speed", Content = "Neuer Speed: " .. speedLevels[currentSpeedIdx], Duration = 2})
    end
end)

-- --- RESTLICHE FUNKTIONEN (DEIN ORIGINAL CODE) ---

-- Teleport Dropdown
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
        if target and target.Character then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        end
    end
})

-- Spieler-Update-Events
local function updateDropdown() Dropdown:SetValues(players) end
game.Players.PlayerAdded:Connect(function(p) table.insert(players, p.Name) updateDropdown() end)
game.Players.PlayerRemoving:Connect(function(p)
    for i, v in ipairs(players) do if v == p.Name then table.remove(players, i) break end end
    updateDropdown()
end)
for _, p in ipairs(game.Players:GetPlayers()) do table.insert(players, p.Name) end

-- ESP
EspSection:AddToggle("EspToggle", {
    Title = "Esp Toggle",
    Default = false,
    Callback = function(state)
        if state then loadstring(game:HttpGet("https://raw.githubusercontent.com/Latura1/Voicechat/refs/heads/main/Esp%20on"))()
        else loadstring(game:HttpGet("https://raw.githubusercontent.com/Latura1/Voicechat/refs/heads/main/Esp%20off"))() end
    end 
})

-- SCRIPTS
ScriptsSection:AddButton({
    Title = "Banger",
    Callback = function() loadstring(game:HttpGet("https://pastebin.com/raw/pPCkzSJG"))() end
})

ScriptsSection:AddButton({
    Title = "Fly Aktivieren",
    Description = "Aktiviert das interne Fly-System (F zum Starten)",
    Callback = function()
        Fluent:Notify({Title = "Info", Content = "Nutze F zum Fliegen und X für Speed!", Duration = 5})
    end
})

-- Speed-Slider
CharacterSection:AddSlider("SpeedSlider", {
    Title = "WalkSpeed",
    Default = 16, Min = 16, Max = 250, Rounding = 1,
    Callback = function(Value) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value end
})

Window:SelectTab(1)
Fluent:Notify({Title = "omamilch V5", Content = "Turbo Fly (V33) geladen!", Duration = 5})
