--[[ 
    OMAMILCH V5 - PASTEBIN FLY EDITION (V35)
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
    if not selectedPlayerName or selectedPlayerName == "Select Player" then return end
    local player = game.Players:FindFirstChild(selectedPlayerName)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
    end
end

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
    Callback = teleportToPlayer
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

-- SCRIPTS & FLY (PASTEBIN WIEDER AKTIVIERT)
ScriptsSection:AddButton({
    Title = "Banger",
    Callback = function() loadstring(game:HttpGet("https://pastebin.com/raw/pPCkzSJG"))() end
})

ScriptsSection:AddButton({
    Title = "Fly",
    Description = "F für Fly | X für Mode Switch",
    Callback = function()
        local success, response = pcall(function()
            return game:HttpGet("https://pastebin.com/raw/My57idN9")
        end)

        if success then
            local runSuccess, errorMsg = pcall(function()
                loadstring(response)()
            end)
            if not runSuccess then warn("Fehler im Fly-Skript: " .. errorMsg) end
        else
            warn("Fehler beim Laden des Fly-Skripts!")
        end
    end
})

-- Voice-Tab
VoiceSection:AddButton({
    Title = "Unban",
    Callback = function() game:GetService("VoiceChatService"):joinVoice() end
})

-- Speed-Slider (Character Section)
CharacterSection:AddSlider("SpeedSlider", {
    Title = "Speed",
    Default = 16, Min = 16, Max = 250, Rounding = 1,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

-- Credits
VersionSection:AddParagraph({Title = "Version", Content = "omamilch V5.35"})
CreditSection:AddParagraph({Title = "Owner", Content = "HanfmomentV1"})

Window:SelectTab(1)
Fluent:Notify({Title = "omamilch V5", Content = "Altes Fly-Script geladen!", Duration = 5})
