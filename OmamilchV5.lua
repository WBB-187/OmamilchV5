--[[ 
    [ZENSIERT] V5 - REPAIRED EDITION
    USER: [ZENSIERT] | KEY: [ZENSIERT]
]]

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- FIX: Modernes Chat-System Support
local function sendChatMessage(msg)
    local textChatService = game:GetService("TextChatService")
    if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channel = textChatService.TextChannels:FindFirstChild("RBXGeneral")
        if channel then channel:SendAsync(msg) end
    else
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
    end
end

pcall(function()
    sendChatMessage("omamilch V5 Ist An")
end)

local Window = Fluent:CreateWindow({
    Title = "omamilch V5 " .. Fluent.Version,
    SubTitle = "by [ZENSIERT]",
    TabWidth = 160,
    Size = UDim2.fromOffset(460, 400),
    Acrylic = false,
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Voice = Window:AddTab({ Title = "Voice", Icon = "mic" }),
    Character = Window:AddTab({ Title = "Character", Icon = "user" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "component" }),
    Scripts = Window:AddTab({ Title = "Scripts", Icon = "scroll" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- SECTIONS
local VoiceSection = Tabs.Voice:AddSection("Voice")
local CharacterSection = Tabs.Character:AddSection("Charakter")
local DropdownSection = Tabs.Misc:AddSection("Teleport")
local EspSection = Tabs.Misc:AddSection("ESP")
local ScriptsSection = Tabs.Scripts:AddSection("Scripts")

-- TELEPORT SYSTEM (Stabiler gemacht)
local players = {"Select Player"}
for _, p in ipairs(game.Players:GetPlayers()) do
    if p ~= game.Players.LocalPlayer then table.insert(players, p.Name) end
end

local Dropdown = DropdownSection:AddDropdown("PlayerDropdown", {
    Title = "Teleport zu Spieler",
    Values = players,
    Multi = false,
    Default = 1,
    Callback = function(value)
        local target = game.Players:FindFirstChild(value)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        end
    end
})

-- SCRIPTS (Mit Fehlerprüfung)
ScriptsSection:AddButton({
    Title = "Fly (Fix)",
    Description = "F für Fly | X für Mode Switch",
    Callback = function()
        -- Falls der Pastebin-Link tot ist, wird hier ein Ersatz-Loader empfohlen
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://pastebin.com/raw/My57idN9"))()
        end)
        if not success then
            Fluent:Notify({Title = "Fehler", Content = "Fly-Script konnte nicht geladen werden (Link evtl. abgelaufen)", Duration = 5})
        end
    end
})

-- CHARACTER SETTINGS
CharacterSection:AddSlider("SpeedSlider", {
    Title = "Speed",
    Default = 16, Min = 16, Max = 250, Rounding = 1,
    Callback = function(Value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

-- VOICE UNBAN (Versuch)
VoiceSection:AddButton({
    Title = "Voice Reconnect",
    Callback = function()
        local vcs = game:GetService("VoiceChatService")
        if vcs then pcall(function() vcs:joinVoice() end) end
    end
})

-- CREDITS
Tabs.Settings:AddParagraph({Title = "Info", Content = "Website: Willstaett-Zentrum"})
Tabs.Settings:AddParagraph({Title = "Version", Content = "omamilch V5.35"})

Window:SelectTab(1)
Fluent:Notify({Title = "System", Content = "Script erfolgreich geladen!", Duration = 3})
