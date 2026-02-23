local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "OmamilchV5" .. Fluent.Version,
    SubTitle = "by bmw3blitz",
    TabWidth = 160,
    Size = UDim2.fromOffset(460, 360),
    Acrylic = false, -- Blur ausschalten = false
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
local VoiceSection = Tabs.Voice:AddSection("Voice")
local CharacterSection = Tabs.Character:AddSection("Charakter")
local DropdownSection = Tabs.Misc:AddSection("Teleport")
local EspSection = Tabs.Misc:AddSection("ESP")
local ScriptsSection = Tabs.Scripts:AddSection("Scripts")
local VersionSection = Tabs.Settings:AddSection("Version")
local CreditSection = Tabs.Settings:AddSection("Credits")

-- Spieler Teleport Dropdown
local selectedPlayerName = nil

local function teleportToPlayer()
    if not selectedPlayerName or selectedPlayerName == "Select Player" then
        warn("Kein gültiger Spieler ausgewählt!")
        return
    end

    local player = game.Players:FindFirstChild(selectedPlayerName)
    if player and player.Character then
        local character = player.Character
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local playerHRP = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if hrp and playerHRP then
            playerHRP.CFrame = hrp.CFrame  -- Teleportiere dich zum Spieler
        else
            warn("HumanoidRootPart nicht gefunden!")
        end
    else
        warn("Spieler nicht gefunden oder hat keinen Charakter!")
    end
end

local players = {"Select Player"}

local function updateDropdown()
    task.wait(0.2)  -- Kleine Verzögerung, um unnötige Updates zu reduzieren
    Dropdown:SetValues(players)
end

-- Spieler zu Dropdown hinzufügen
for _, player in ipairs(game.Players:GetPlayers()) do
    table.insert(players, player.Name)
end

local Dropdown = DropdownSection:AddDropdown("Dropdown", {
    Title = "Teleport zu Spieler",
    Description = "Wähle einen Spieler aus",
    Values = players,
    Multi = false,
    Default = 1,
    Callback = function(value)
        selectedPlayerName = value
    end
})

DropdownSection:AddButton({
    Title = "Teleport",
    Description = "Teleportiert dich zum ausgewählten Spieler",
    Callback = function()
        teleportToPlayer()
    end
})

-- Spieler-Update-Events
game.Players.PlayerAdded:Connect(function(player)
    table.insert(players, player.Name)
    updateDropdown()
end)

game.Players.PlayerRemoving:Connect(function(player)
    for i = #players, 1, -1 do
        if players[i] == player.Name then
            table.remove(players, i)
            break
        end
    end
    updateDropdown()
end)

-- EspToggle
EspSection:AddToggle("MyToggle", {
    Title = "Esp Toggle", 
    Description = "Lets you toggle ESP",
    Default = false,
    Callback = function(state)
        if state then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Latura1/Voicechat/refs/heads/main/Esp%20on"))()
        else
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Latura1/Voicechat/refs/heads/main/Esp%20off"))()
        end
    end 
})

-- Scripts-Buttons
ScriptsSection:AddButton({
    Title = "Banger",
    Description = "banger script",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/pPCkzSJG"))()
    end
})

ScriptsSection:AddButton({
    Title = "Fly",
    Description = "F for fly | X for Mode Switch",
    Callback = function()
        local success, response = pcall(function()
            return game:HttpGet("https://pastebin.com/raw/My57idN9")
        end)

        if success then
            print("Skript geladen:", response)
            local runSuccess, errorMsg = pcall(function()
                loadstring(response)()
            end)
            
            if not runSuccess then
                warn("Fehler im Skript: " .. errorMsg)
            end
        else
            warn("Fehler beim Laden des Skripts!")
        end
    end
})

-- Voice-Tab Buttons
VoiceSection:AddButton({
    Title = "Unban",
    Description = "Gets you unbanned",
    Callback = function()
        local voiceChatService = game:GetService("VoiceChatService")
        voiceChatService:joinVoice()
    end
})

-- Speed-Slider
local SpeedSlider = CharacterSection:AddSlider("SpeedSlider", {
    Title = "Speed",
    Description = "Set the Speed",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 1,
    Callback = function(Value)
        print("Slider geändert:", Value)
        getgenv().Enabled = true
        getgenv().Speed = Value
        loadstring(game:HttpGet("https://raw.githubusercontent.com/eclipsology/SimpleSpeed/main/SimpleSpeed.lua"))()
    end
})
