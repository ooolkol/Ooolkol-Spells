if not game.GameId == 527730528 then
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Ooolkol spells",
        Text = "This script can't be runned in this game."
    })
    return
else
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Ooolkol spells",
        Text = "Initializing, takes a while..."
    })
end

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local scriptVersion = "2.0.84"
local settingsFile = "Ooolkol scripts/Ooolkol spells/DataFile.data"

local Window = Rayfield:CreateWindow({
    Name = "Ooolkol spells " .. scriptVersion,
    Icon = "scroll-text",
    LoadingTitle = "Ooolkol scripts",
    LoadingSubtitle = "Made by ooolkol",
    DisableRayfieldPrompts = true
})

--! Tabs

local MainTab, TogglesTab, GodModeTab, AutoClashTab, TargetTab, WandModsTab, MacrosingTab, ScriptsTab, SettingsTab = {}, {}, {}, {}, {}, {}, {}, {}, {}

MainTab.Tab = Window:CreateTab("Main", "layout-template")
MainTab.Variables = {}

TogglesTab.Tab = Window:CreateTab("Toggles", "toggle-right")
TogglesTab.Variables = {}

GodModeTab.Tab = Window:CreateTab("God Mode", "infinity")
GodModeTab.Variables = {}

AutoClashTab.Tab = Window:CreateTab("Auto Clash", "repeat")
AutoClashTab.Variables = {}

TargetTab.Tab = Window:CreateTab("Target", "crosshair")
TargetTab.Variables = {}

WandModsTab.Tab = Window:CreateTab("Wand Mods", "wand-sparkles")
WandModsTab.Variables = {}

MacrosingTab.Tab = Window:CreateTab("Macrosing", "keyboard")
MacrosingTab.Variables = {}

ScriptsTab.Tab = Window:CreateTab("Scripts", "scroll-text")
ScriptsTab.Variables = {}

SettingsTab.Tab = Window:CreateTab("Settings", "settings")
SettingsTab.Variables = {}

--! Variables

local players = game:GetService("Players")
local plr = players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local Humanoid = char:WaitForChild("Humanoid")
local Animator = Humanoid:FindFirstChildOfClass("Animator")
local RootPart = Humanoid.RootPart
repeat
    RootPart = Humanoid.RootPart
until RootPart ~= nil

plr.CharacterAdded:Connect(function(newChar)
    char = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    Animator = Humanoid:FindFirstChildOfClass("Animator")
    RootPart = Humanoid.RootPart
    repeat
        RootPart = Humanoid.RootPart
    until RootPart ~= nil
end)

local CurrentSpell = ""
local chatbar = plr.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar
local startChatbarText = chatbar.Text

--Args

local CustomSpells = {
    ["Spells"] = {
        "meteorus",
        "soul decimatus",
        "aere mortemus",
        "melgorus",
        "walicus",
        "torturious",
        "fixius",
        "nuggetize",
        "invisius",
        "flyize",
        "helious",
        "bringius",
        "serious series, 100 punches!"
    }
}

local Spells = {
    ["Kill Spells"] = {
        "avada kedavra",
        "deletrius",
        "defodio",
        "sectumsempra"
    },
    ["Damage Spells"] = {
        "tonitro",
        "crucio",
        "flare",
        "baubillious",
        "incendio"
    },
    ["Explosive Spells"] = {
        "reducto",
        "verdimillious",
        "expulso",
        "bombarda",
        "confringo"
    },
    ["Revive Spells"] = {
        "episkey",
        "vulnera sanentur",
        "rennervate",
        "finite incantatem",
        "diffindo",
        "liberacorpus"
    },
    ["Unique Spells"] = {
        "aboleo",
        "accio",
        "relashio",
        "appa",
        "ascendio",
        "lumos",
        "nox",
        "protego",
        "protego totalum"
    },
    ["Immobilizing Spells"] = {
        "duro",
        "glacius",
        "incarcerous",
        "petrificus totalus",
        "impedimenta",
        "levicorpus",
        "ebublio",
        "locomotor wibbly"
    },
    ["Fling Spells"] = {
        "stupefy",
        "flipendo",
        "depulso",
        "everte statum",
        "rictusempra",
        "alarte ascendare",
        "carpe retractum"
    },
    ["Misc Spells"] = {
        "silencio",
        "obliviate",
        "obscuro",
        "confundo",
        "melofors",
        "tarantallegra",
        "calvorio",
        "engorgio skullus",
        "diminuendo",
        "expelliarmus",
        "morsmordre"
    },
    ["Elder Wand Spells"] = {
        "infernum",
        "pruina tempestatis",
        "protego diabolica"
    }
}

local defaultSettings = {
    ["CurrentTheme"] = "Default",
    ["TeleportCommandBool"] = false,
    ["TeleportCommand"] = "!tp",
    ["NotificationsDuration"] = 2,
    ["SpawnPoints"] = {},
    ["SpawnPointCommandBool"] = false,
    ["SpawnPointCommand"] = "!spawnpoint"
}
local settings = {}
local actions = {}

actions.AutoReviveSectionConnects = {}

actions.LoopBring = {}
actions.LoopBring.Bool = false

actions.Bring = {}
actions.Bring.Bool = false
actions.Bring.Target = 0

actions.LoopKill = {}
actions.LoopKill.Bool = false

actions.LoopSpell = {}
actions.LoopSpell.Bool = false

--Services

local UIS = game:GetService("UserInputService")
local CurrentCamera = game:GetService("Workspace").CurrentCamera
local Mouse = plr:GetMouse()
local RServ = game:GetService("ReplicatedStorage")
local IServ = game:GetService("InsertService")
local Debris = game:GetService("Debris")

--! Functions

function actions.Notify(content)
    Rayfield:Notify({
        Title = "Ooolkol spells",
        Content = content,
        Duration = settings["NotificationsDuration"],
        Image = "scroll-text"
    })
end

local function saveSettings()
    local json
    local HttpService = game:GetService("HttpService")
    if writefile then
        json = HttpService:JSONEncode(settings)
        writefile(settingsFile, json)
    end
end

local function loadSettings()
    local HttpService = game:GetService("HttpService")
    if readfile and isfile and isfile(settingsFile) then
        settings = HttpService:JSONDecode(readfile(settingsFile))

        for i = 1, #CustomSpells.Spells do
            if not settings[CustomSpells.Spells[i]] then
                settings[CustomSpells.Spells[i]] = "World76"
                saveSettings()
            end
        end

        for i,v in pairs(defaultSettings) do
            if not settings[i] then
                settings[i] = v
                saveSettings()
            end
        end
    else
        for i = 1, #CustomSpells.Spells do
            settings[CustomSpells.Spells[i]] = "World76"
        end
        for i,v in pairs(Spells) do
            for x = 1, #v do
                settings[Spells[i][x]] = "World76"
            end
        end
        saveSettings()
    end
end

loadSettings()
Window.ModifyTheme(settings["CurrentTheme"])

if not getgenv().MTLaunchCheck then
    Debris:AddItem(IServ:WaitForChild("Events").ExploitLog, 0)
    actions.Notify("Bypassed AC [RemoteEvent]")
end

getgenv().MTLaunchCheck = true

function actions.CalculateDistance(remoteName)
    local dataFolder = game:GetService("BadgeService"):FindFirstChild("data") 
    if not dataFolder then
        dataFolder = Instance.new("Folder")
        dataFolder.Name = "data"
        dataFolder.Parent = game:GetService("BadgeService")
    end

    local dataValue = dataFolder:FindFirstChild(remoteName)
    if not dataValue then
        dataValue = Instance.new("IntValue")
        dataValue.Name = remoteName
        dataValue.Value = 0
        dataValue.Parent = dataFolder
    end
    dataValue.Value = dataValue.Value + 1

    local distance = ((dataValue.Value + 0.5428) * 2) ^ (math.pi/2)
    return distance
end

function actions.GetWand(bool)
    local findIn = bool and char or plr.Backpack
    return findIn:FindFirstChild("Wand") or findIn:FindFirstChild("Elder Wand") or nil
end

function actions.CreateSpellId()
    return tostring(plr.Name .. game:GetService("Workspace").DistributedGameTime)
end

actions.OldSpell = ""

function actions.SendSpell(target, spell, noActor)
    if actions.OldSpell ~= spell then
        actions.OldSpell = spell
        
        startChatbarText = chatbar.Text
        chatbar:SetTextFromInput(spell)
        players:Chat(spell)
        chatbar.Text = startChatbarText
    end
    if TogglesTab.Variables.SecureMode and actions.GetWand(true) then
        IServ.Events.setSpellLoaded:FireServer({
            ["bool"] = false,
            ["distance"] = actions.CalculateDistance("setSpellLoaded"),
            ["tool"] = actions.GetWand(true)
        })
    end

    if target ~= nil and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        if noActor then
            IServ.Events.spellHit:FireServer({
                ["hitCf"] = target.Character.HumanoidRootPart.CFrame,
                ["hitPart"] = game:GetService("Workspace").Terrain,
                ["id"] = actions.CreateSpellId(),
                ["distance"] = actions.CalculateDistance("spellHit"),
                ["spellName"] = spell
            })
        else
            IServ.Events.spellHit:FireServer({
                ["hitCf"] = target.Character.HumanoidRootPart.CFrame,
                ["hitPart"] = target.Character.HumanoidRootPart,
                ["id"] = actions.CreateSpellId(),
                ["distance"] = actions.CalculateDistance("spellHit"),
                ["actor"] = target.Character,
                ["spellName"] = spell
            })
        end
    elseif target == nil then
        IServ.Events.spellHit:FireServer({
            ["hitCf"] = Mouse.Hit,
            ["hitPart"] = Mouse.Target,
            ["id"] = actions.CreateSpellId(),
            ["distance"] = actions.CalculateDistance("spellHit"),
            ["spellName"] = spell
        })
    end
end

function actions.spellFireEffect(shootPosition, targetPosition, spell, toolObject)
    if actions.OldSpell ~= spell then
        actions.OldSpell = spell

        startChatbarText = chatbar.Text
        chatbar:SetTextFromInput(spell)
        players:Chat(spell)
        chatbar.Text = startChatbarText
    end

    if TogglesTab.Variables.SecureMode and actions.GetWand(true) then
        IServ.Events.setSpellLoaded:FireServer({
            ["bool"] = false,
            ["distance"] = actions.CalculateDistance("setSpellLoaded"),
            ["tool"] = actions.GetWand(true)
        })
    end

    IServ.Events.spellFired:FireServer({
        a = shootPosition,
        b = targetPosition,
        spellName = spell,
        distance = actions.CalculateDistance("spellFired"),
        tool = toolObject,
        id = actions.CreateSpellId()
    })


    IServ.Events.fireSpellLocal:Fire({
        a = shootPosition,
        b = targetPosition,
        spellName = spell,
        caster = plr,
        id = actions.CreateSpellId()
    })
end

function actions.UniqueSpell(spell)
    if spell == "infernum" or spell == "pruina tempestatis" or spell == "protego diabolica" or spell == "ascendio" then
        IServ.Events.uniqueSpell:FireServer({
            ["spellName"] = spell,
            ["distance"] = actions.CalculateDistance("uniqueSpell")
        })
    elseif spell == "appa" then
        IServ.Events.uniqueSpell:FireServer({
            ["spellName"] = "appa",
            ["distance"] = actions.CalculateDistance("uniqueSpell"),
            ["mousePos"] = Mouse.Hit.Position
        })
    end
end

function actions.setAttackAnim(animTrackDel)
    local wandAnims = {
        RServ:WaitForChild("Animations")["cast1"];
        RServ:WaitForChild("Animations")["cast2"];
        RServ:WaitForChild("Animations")["cast3"];
    }
    coroutine.resume(coroutine.create(function()
        local animationTrack = Animator:LoadAnimation(wandAnims[math.random(1, #wandAnims)])
        animationTrack:Play(tonumber(animTrackDel))
        animationTrack.Stopped:Wait()
    end))
end

function actions.getClosestPlayerToMouse(includeLocalPlayer)
    local closestPlayer = nil
    local shortestDistance = math.huge

    for i,v in pairs(players:GetPlayers()) do
        if includeLocalPlayer then
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local pos = CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if magnitude < shortestDistance then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            end
        else
            if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local pos = CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if magnitude < shortestDistance then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            end
        end
    end

    return closestPlayer
end

function actions.GetPlayer(name)
    for i,v in pairs(players:GetPlayers()) do
        if string.lower(string.sub(v.Name, 1, string.len(name))) == string.lower(name) then
            return v
        elseif string.lower(string.sub(v.DisplayName, 1, string.len(name))) == string.lower(name) then
            return v
        end
    end
end

function actions.GetSpell(name)
    if name == "" then return nil end

    for i,v in pairs(Spells) do
        for z,x in pairs(v) do
            if string.sub(x, 1, string.len(name)) == name then
                return x
            end
        end
    end

    return nil
end

function actions.LoopBring:Start()
    self.Bool = true

    coroutine.resume(coroutine.create(function()
        while task.wait(0.2) do
            if self.Bool == false then return end

            if TargetTab.Variables.Target ~= 0 then

                local Target = TargetTab.Variables.Target
                
                if Target and Target ~= plr and Target.Character and Target.Character:FindFirstChild("Humanoid") and Target.Character.Humanoid.Health > 0 and Target.Character:FindFirstChild("HumanoidRootPart") then
                    actions.SendSpell(Target, "carpe retractum")
                elseif Target and Target.Character and Target.Character:FindFirstChild("Humanoid") and Target.Character.Humanoid.Health <= 0 then
                    self.Bool = false
                    actions.Notify("Target died.")
                    return
                end
            end
        end
    end))
    actions.Notify("Loop Bring has been started.")
end

function actions.LoopBring:Stop()
    self.Bool = false
    actions.Notify("Loop Bring has been stopped.")
end

function actions.Bring:Start()
    self.Bool = true

    coroutine.resume(coroutine.create(function()
        while task.wait(0.2) do
            if self.Bool == false then return end

            if self.Target ~= 0 then

                local Target = self.Target
                
                if Target and Target ~= plr and Target.Character and Target.Character:FindFirstChild("Humanoid") and Target.Character.Humanoid.Health > 0 and Target.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (Target.Character.HumanoidRootPart.Position - RootPart.Position).Magnitude

                    if distance > 20 then
                        actions.SendSpell(Target, "carpe retractum")
                    else
                        self.Bool = false
                        self.Target = 0
                        if MacrosingTab.Variables.OneCustomSpell and MacrosingTab.Variables.LastCustomSpell == "bringius" then
                            MacrosingTab.Variables.LastCustomSpell = ""
                        end
                        return
                    end
                elseif Target and Target.Character and Target.Character:FindFirstChild("Humanoid") and Target.Character.Humanoid.Health <= 0 then
                    self.Bool = false
                    self.Target = 0
                    if MacrosingTab.Variables.OneCustomSpell and MacrosingTab.Variables.LastCustomSpell == "bringius" then
                        MacrosingTab.Variables.LastCustomSpell = ""
                    end
                    actions.Notify("Target died.")
                    return
                end
            end
        end
    end))
    actions.Notify("Bring has been started.")
end

function actions.Bring:Stop()
    self.Bool = false
    self.Target = 0
    actions.Notify("Bring has been stopped.")
end

function actions.LoopKill:Start()
    self.Bool = true

    coroutine.resume(coroutine.create(function()
        while task.wait(0.2) do
            if self.Bool == false then return end

            if TargetTab.Variables.LoopKillUseType == 0 then
                local Target = plr

                if Target ~= 0 then
                    if self.Bool and Target.Character and Target.Character:FindFirstChild("Humanoid") and Target.Character.Humanoid.Health > 0 and Target.Character:FindFirstChild("HumanoidRootPart") then
                        actions.SendSpell(Target, "deletrius")
                    end
                end
            elseif TargetTab.Variables.LoopKillUseType == 1 then
                local Target = TargetTab.Variables.Target

                if Target ~= 0 then
                    if self.Bool and Target ~= plr and Target.Character and Target.Character:FindFirstChild("Humanoid") and Target.Character.Humanoid.Health > 0 and Target.Character:FindFirstChild("HumanoidRootPart") then
                        actions.SendSpell(Target, "deletrius")
                    end
                end
            else
                for i,v in pairs(players:GetPlayers()) do
                    if self.Bool and v and table.find(TargetTab.Variables.LoopKillList, v.Name) and v ~= plr and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") then
                        task.wait(0.21)
                        actions.SendSpell(v, "deletrius")
                    end
                end
            end
        end
    end))
    actions.Notify("Loop Kill has been started.")
end

function actions.LoopKill:Stop()
    self.Bool = false
    actions.Notify("Loop Kill has been stopped.")
end

function actions.LoopSpell:Start(spell)
    self.Bool = true

    coroutine.resume(coroutine.create(function()
        while task.wait(TargetTab.Variables.LoopSpellDelay) do
            if self.Bool == false then return end

            if TargetTab.Variables.Spell ~= "" then
                if TargetTab.Variables.LoopSpellUseType == 0 then
                    local Target = plr

                    if Target ~= 0 then
                        if self.Bool and Target.Character and Target.Character:FindFirstChild("Humanoid") and Target.Character.Humanoid.Health > 0 and Target.Character:FindFirstChild("HumanoidRootPart") then
                            local withoutActor = false
                            if TargetTab.Variables.Spell == "confringo" or TargetTab.Variables.Spell == "expulso" or TargetTab.Variables.Spell == "bombarda" then
                                withoutActor = true
                            end
                            actions.SendSpell(Target, TargetTab.Variables.Spell, withoutActor)
                        end
                    end
                elseif TargetTab.Variables.LoopSpellUseType == 1 then
                    local Target = TargetTab.Variables.Target

                    if Target ~= 0 then
                        if self.Bool and Target ~= plr and Target.Character and Target.Character:FindFirstChild("Humanoid") and Target.Character.Humanoid.Health > 0 and Target.Character:FindFirstChild("HumanoidRootPart") then
                            local withoutActor = false
                            if TargetTab.Variables.Spell == "confringo" or TargetTab.Variables.Spell == "expulso" or TargetTab.Variables.Spell == "bombarda" then
                                withoutActor = true
                            end
                            actions.SendSpell(Target, TargetTab.Variables.Spell, withoutActor)
                        end
                    end
                else
                    for i,v in pairs(players:GetPlayers()) do
                        if self.Bool and v and table.find(TargetTab.Variables.LoopSpellList, v.Name) and v ~= plr and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") then
                            task.wait(0.21)
                            local withoutActor = false
                            if TargetTab.Variables.Spell == "confringo" or TargetTab.Variables.Spell == "expulso" or TargetTab.Variables.Spell == "bombarda" then
                                withoutActor = true
                            end
                            actions.SendSpell(v, TargetTab.Variables.Spell, withoutActor)
                        end
                    end
                end
            end
        end
    end))
    actions.Notify("Loop Spell has been started.")
end

function actions.LoopSpell:Stop()
    self.Bool = false
    actions.Notify("Loop Spell has been stopped.")
end

function actions.getMouseTarget()
    if Mouse.Target and Mouse.Target:FindFirstChild("HumanoidRootPart") then
        if Mouse.Target ~= plr then
            for i,v in pairs(players:GetPlayers()) do
                if v.Character == Mouse.Target then
                    return v
                end
            end
        end
    elseif Mouse.Target and Mouse.Target.Parent:FindFirstChild("HumanoidRootPart") then
        if Mouse.Target.Parent ~= plr then
            for i,v in pairs(players:GetPlayers()) do
                if v.Character == Mouse.Target.Parent then
                    return v
                end
            end
        end
    elseif Mouse.Target and Mouse.Target.Parent.Parent:FindFirstChild("HumanoidRootPart") then
        if Mouse.Target.Parent.Parent ~= plr then
            for i,v in pairs(players:GetPlayers()) do
                if v.Character == Mouse.Target.Parent.Parent then
                    return v
                end
            end
        end
    else
        return 0
    end
end

plr.Chatted:Connect(function(message)
    local msg = string.lower(message)

    if WandModsTab.Variables.SilentAim or WandModsTab.Variables.FullSilentAim or WandModsTab.Variables.FullAuto or MacrosingTab.Variables.CustomSpells then

        local found = false

        if MacrosingTab.Variables.CustomSpells then
            if MacrosingTab.Variables.WandlessCustomSpells == false and actions.GetWand(true) == nil then return end

            for i,v in pairs(CustomSpells.Spells) do
                if string.find(msg, v) and MacrosingTab.Variables.LastCustomSpell then
                    MacrosingTab.Variables.LastCustomSpell = v
                    found = true
                    return
                else
                    found = false
                end
            end
        end

        for i,v in pairs(Spells) do
            for z,x in pairs(v) do
                if string.find(msg, x) then
                    CurrentSpell = x
                    found = true
                    return
                else
                    found = false
                end
            end
        end

        if found == false then
            CurrentSpell = ""
            MacrosingTab.Variables.LastCustomSpell = ""
        end
    end

    if settings["TeleportCommandBool"] == true then
        if string.sub(message, 1, string.len(settings["TeleportCommand"]) + 1) == settings["TeleportCommand"] .. " " then
            local targetToTeleport = actions.GetPlayer(string.sub(message, string.len(settings["TeleportCommand"]) + 2, string.len(message)))

            if targetToTeleport and targetToTeleport.Character and targetToTeleport.Character:FindFirstChild("HumanoidRootPart") then
                IServ.Events.uniqueSpell:FireServer({
                    ["spellName"] = "appa",
                    ["distance"] = actions.CalculateDistance("uniqueSpell"),
                    ["mousePos"] = targetToTeleport.Character.HumanoidRootPart.Position
                })
                return
            end
        end
    end

    if settings["SpawnPointCommandBool"] == true then
        if string.sub(message, 1, string.len(settings["SpawnPointCommand"]) + 1) == settings["SpawnPointCommand"] .. " " then
            local spawnPoint = settings["SpawnPoints"]
            local found

            local choosedSpawnPoint = string.lower(string.sub(message, string.len(settings["SpawnPointCommand"]) + 2, string.len(message)))

            for i,v in pairs(MainTab.Variables.SpawnPoints.Names) do
                if string.lower(string.sub(v, 1, string.len(choosedSpawnPoint))) == choosedSpawnPoint then
                    if spawnPoint[v] then
                        found = spawnPoint[v]
                        break
                    end
                end
            end

            if found then
                IServ.Events.uniqueSpell:FireServer({
                    ["spellName"] = "appa",
                    ["distance"] = actions.CalculateDistance("uniqueSpell"),
                    ["mousePos"] = Vector3.new(found.X, found.Y, found.Z)
                })
            else
                actions.Notify("Couldn't find the spawnpoint.")
            end
        end
    end
end)

function CustomSpells.Fixius(target)
    actions.SendSpell(target, "diminuendo")
    task.wait(0.225)
    actions.SendSpell(target, "rennervate")
    task.wait(0.225)
    actions.SendSpell(target, "finite incantatem")
    task.wait(0.225)
    actions.SendSpell(target, "liberacorpus")
    task.wait(0.225)
    actions.SendSpell(target, "diffindo")
    task.wait(0.225)
    actions.SendSpell(target, "episkey")
    task.wait(0.225)
    actions.SendSpell(target, "vulnera sanentur")
end

function CustomSpells.Nuggetize(target)
    actions.SendSpell(target, "diminuendo")
    task.wait(0.225)
    actions.SendSpell(target, "levicorpus")
    task.wait(0.225)
    actions.SendSpell(target, "finite incantatem")
    task.wait(0.225)
    actions.SendSpell(target, "liberacorpus")
end

function CustomSpells.Invisius(target)
    for i = 1,14 do
        actions.SendSpell(target, "vulnera sanentur")
        task.wait(0.225)
    end
    task.wait(0.225)
    actions.SendSpell(target, "deletrius")
    task.wait(0.225)
    actions.SendSpell(target, "duro")
    task.wait(0.225)
    actions.SendSpell(target, "rennervate")
end

function CustomSpells.Flyize(target)
    actions.SendSpell(target, "duro")
    task.wait(0.3)
    actions.SendSpell(target, "levicorpus")
    task.wait(0.4)
    actions.SendSpell(target, "finite incantatem")
    task.wait(0.3)
    actions.SendSpell(target, "ebublio")
end

function CustomSpells.Helious(target)
    for i = 1,7 do
        actions.SendSpell(target, "episkey")
        task.wait(0.05)
    end
    task.wait(0.1)
    for i = 1,7 do
        actions.SendSpell(target, "vulnera sanentur")
        task.wait(0.05)
    end
end

function CustomSpells.AereMortemus(target)
    for i = 1,5 do
        actions.SendSpell(target, "alarte ascendare")
        task.wait(0.15)
    end

    task.wait(0.8)

    for i = 1,7 do
        actions.SendSpell(target, "defodio")
        task.wait(0.15)
    end
end

function CustomSpells.Melgorus(target)
    actions.SendSpell(target, "engorgio skullus")
    task.wait(0.225)
    actions.SendSpell(target, "melofors")
end

function CustomSpells.Walicus(target)
    actions.SendSpell(target, "duro")
    task.wait(0.225)
    actions.SendSpell(target, "glacius")
    task.wait(0.5)
    actions.SendSpell(target, "finite incantatem")
end

function CustomSpells.Torturious(target)
    actions.SendSpell(target, "petrificus totalus")
    task.wait(0.225)
    actions.SendSpell(target, "obliviate")
    task.wait(0.225)
    actions.SendSpell(target, "obscuro")
    task.wait(0.225)
    actions.SendSpell(target, "silencio")
end

--! Main Tab

MainTab.Variables.PermanentFlight = false

MainTab.Variables.StealWand = true

MainTab.Variables.Storm = {}
MainTab.Variables.Storm.Bool = false
MainTab.Variables.Storm.Delay = 0.1
MainTab.Variables.Storm.PartyMode = false
MainTab.Variables.Storm.Type = "infernum"
MainTab.Variables.Storm.Toggle = 0

MainTab.Variables.FlightColor = "Auror"

MainTab.Variables.PlayersWandGlow = {}
MainTab.Variables.PlayersWandGlow.Target = 0
MainTab.Variables.PlayersWandGlow.UseType = 0
MainTab.Variables.PlayersWandGlow.Spell = ""
MainTab.Variables.PlayersWandGlow.ClickPlayerBool = false

MainTab.Variables.SpellAura = {}
MainTab.Variables.SpellAura.Bool = false
MainTab.Variables.SpellAura.Target = 0
MainTab.Variables.SpellAura.UseType = 0
MainTab.Variables.SpellAura.ClickPlayerBool = false
MainTab.Variables.SpellAura.Spell = ""
MainTab.Variables.SpellAura.Distance = 10
MainTab.Variables.SpellAura.ExceptedPlayers = {}

MainTab.Variables.SpawnPoints = {}
MainTab.Variables.SpawnPoints.Name = ""

MainTab.Tab:CreateButton({
    Name = "Get Wand",
    Callback = function()
        if MainTab.Variables.StealWand then
            local Result = false
            
            for i,v in pairs(players:GetPlayers()) do
                if v ~= plr and v.Character then
                    local Wand = v.Character:FindFirstChild("Wand")
                    if Wand then
                        actions.SendSpell(v, "expelliarmus")
                        task.wait(0.5)
                        Wand.Handle.Position = RootPart.Position
                        Result = true
                        break
                    end
                end
            end
            
            if Result == false then
                actions.Notify("Couldn't find player's Wand.")
            end
        else
            if game:GetService("Workspace"):FindFirstChild("Wand") then
                game:GetService("Workspace")["Wand"].Handle.Position = RootPart.Position
            else
                actions.Notify("Couldn't find Wand in Workspace.")
            end
        end
    end
})

MainTab.Tab:CreateButton({
    Name = "Get Elder Wand",
    Callback = function()
        if MainTab.Variables.StealWand then
            local Result = false

            for i,v in pairs(players:GetPlayers()) do
                if v ~= plr and v.Character then
                    local Wand = v.Character:FindFirstChild("Elder Wand")
                    if Wand then
                        actions.SendSpell(v, "expelliarmus")
                        task.wait(0.5)
                        Wand.Handle.Position = RootPart.Position
                        Result = true
                        break
                    end
                end
            end
            
            if Result == false then
                actions.Notify("Couldn't find player's Elder Wand.")
            end
        else
            if game:GetService("Workspace"):FindFirstChild("Elder Wand") then
                game:GetService("Workspace")["Elder Wand"].Handle.Position = RootPart.Position
            else
                actions.Notify("Couldn't find Elder Wand in Workspace.")
            end
        end
    end
})

MainTab.Tab:CreateButton({
    Name = "Get Flight",
    Callback = function()
        if not plr.Backpack:FindFirstChild("Flight") and not char:FindFirstChild("Flight") then
            local result = false
    
            for i,v in pairs(players:GetPlayers()) do
                if v ~= plr then
                    local Flight = v.Backpack:FindFirstChild("Flight") or v.Character:FindFirstChild("Flight")
    
                    if Flight then
                        Flight:Clone().Parent = plr.Backpack
                        result = true
                        break
                    else
                        result = false
                    end
                end
            end
            if result == false then actions.Notify("Couldn't find player's Flight.") end
        end
    end
})

MainTab.Tab:CreateToggle({
    Name = "Permanent Flight",
    CurrentValue = false,
    Callback = function(bool)
        MainTab.Variables.PermanentFlight = bool

        if bool then
            if not RServ:FindFirstChild("Flight") then
                local Flight = plr.Backpack:FindFirstChild("Flight") or char:FindFirstChild("Flight")

                if Flight then
                    Flight:Clone().Parent = RServ
                end
            end
        end
    end
})

plr.CharacterAdded:Connect(function(newChar)
    if MainTab.Variables.PermanentFlight then
        local Flight = RServ:FindFirstChild("Flight")

        if Flight then
            Flight:Clone().Parent = plr.Backpack
        end
    end
end)

MainTab.Tab:CreateToggle({
    Name = "Steal Wand",
    CurrentValue = true,
    Callback = function(bool)
        MainTab.Variables.StealWand = bool
    end
})

MainTab.Tab:CreateButton({
    Name = "Delete Holding Wand",
    Callback = function()
        local Wand = char:FindFirstChild("Wand") or char:FindFirstChild("Elder Wand")

        Wand.Parent = plr.Backpack
        
        if Wand then
            Debris:AddItem(Wand, 0)
        end
    end
})

MainTab.Tab:CreateParagraph({Title = "Steal Wand", Content = "If enabled then script will steal wand from random player."})

--Storm

MainTab.Tab:CreateSection("Storm")

MainTab.Variables.Storm.Toggle = MainTab.Tab:CreateToggle({
    Name = "Storm",
    CurrentValue = false,
    Callback = function(bool)
        MainTab.Variables.Storm.Bool = bool
    end
})

MainTab.Tab:CreateDropdown({
    Name = "Storm Type",
    Options = {"infernum", "pruina tempestatis", "disco"},
    CurrentOption = "infernum",
    Callback = function(option)
        MainTab.Variables.Storm.Type = option[1]
    end
})

MainTab.Tab:CreateSlider({
    Name = "Delay",
    Range = {0.1, 3},
    Increment = 0.1,
    Suffix = "Seconds",
    CurrentValue = MainTab.Variables.Storm.Delay,
    Callback = function(value)
        MainTab.Variables.Storm.Delay = value
    end
})

MainTab.Tab:CreateToggle({
    Name = "Party Mode",
    CurrentValue = false,
    Callback = function(bool)
        MainTab.Variables.Storm.PartyMode = bool
    end
})

coroutine.resume(coroutine.create(function()
    while task.wait(MainTab.Variables.Storm.Delay) do
        if MainTab.Variables.Storm.Bool then
            if MainTab.Variables.Storm.Type ~= "disco" then
                actions.UniqueSpell(MainTab.Variables.Storm.Type)
            else
                actions.UniqueSpell("pruina tempestatis")
                task.wait(0.05)
                actions.UniqueSpell("infernum")
            end
        end
    end
end))

MainTab.Tab:CreateParagraph({Title = "Party Mode", Content = "Disables storm if you got any wand in your hand."})

--Flight

MainTab.Tab:CreateSection("Flight")

MainTab.Tab:CreateDropdown({
    Name = "Flight Color",
    Options = {"Auror", "Deatheater"},
    CurrentOption = "Auror",
    Callback = function(option)
        MainTab.Variables.FlightColor = option[1]
    end
})

MainTab.Tab:CreateButton({
    Name = "Invisible",
    Callback = function()
        IServ.Events.toggleFlight:FireServer({
            ["bool"] = true,
            ["distance"] = actions.CalculateDistance("toggleFlight"),
            ["flightType"] = MainTab.Variables.FlightColor
        })
        
        IServ.Events.toggleFlight:FireServer({
            ["bool"] = false,
            ["distance"] = actions.CalculateDistance("toggleFlight"),
            ["flightType"] = MainTab.Variables.FlightColor
        })
        
        IServ.Events.toggleFlight:FireServer({
            ["bool"] = true,
            ["distance"] = actions.CalculateDistance("toggleFlight"),
            ["flightType"] = MainTab.Variables.FlightColor
        })
    end
})

MainTab.Tab:CreateButton({
    Name = "Particles",
    Callback = function()
        IServ.Events.toggleFlight:FireServer({
            ["bool"] = true,
            ["distance"] = actions.CalculateDistance("toggleFlight"),
            ["flightType"] = MainTab.Variables.FlightColor
        })
    end
})

MainTab.Tab:CreateButton({
    Name = "Walk",
    Callback = function()
        IServ.Events.toggleFlight:FireServer({
            ["bool"] = true,
            ["distance"] = actions.CalculateDistance("toggleFlight"),
            ["flightType"] = MainTab.Variables.FlightColor
        })
        
        IServ.Events.uniqueSpell:FireServer({
            ["distance"] = actions.CalculateDistance("uniqueSpell"),
            ["mousePos"] = RootPart.Position,
            ["spellName"] = "appa"
        })
    end
})

MainTab.Tab:CreateButton({
    Name = "Delete Effects",
    Callback = function()
        IServ.Events.toggleFlight:FireServer({
            ["bool"] = false,
            ["distance"] = actions.CalculateDistance("toggleFlight"),
            ["flightType"] = MainTab.Variables.FlightColor
        })
    end
})

--Steal All Wands

MainTab.Tab:CreateSection("Steal All Wands")

MainTab.Tab:CreateButton({
    Name = "Steal All Wands",
    Callback = function()
        for i,v in pairs(players:GetPlayers()) do
            if v ~= plr and v.Character and v.Character:FindFirstChild("Wand") then
                task.wait(0.21)
                actions.SendSpell(v, "expelliarmus")
            end
        end
    end
})

MainTab.Tab:CreateButton({
    Name = "Steal All Elder Wands",
    Callback = function()
        for i,v in pairs(players:GetPlayers()) do
            if v ~= plr and v.Character and v.Character:FindFirstChild("Elder Wand") then
                task.wait(0.21)
                actions.SendSpell(v, "expelliarmus")
            end
        end
    end
})

--Wand Glow

MainTab.Tab:CreateSection("Wand Glow")

MainTab.Variables.PlayersWandGlow.CurrentTargetText = 0

MainTab.Tab:CreateInput({
    Name = "Target",
    CurrentValue = "",
    PlaceholderText = "Name or Displayname",
    RemoveTextAfterFocusLost = true,
    Callback = function(value)
        if actions.GetPlayer(value) and actions.GetPlayer(value) ~= plr then
            MainTab.Variables.PlayersWandGlow.Target = actions.GetPlayer(value)
            if MainTab.Variables.PlayersWandGlow.CurrentTargetText ~= 0 then
                MainTab.Variables.PlayersWandGlow.CurrentTargetText:Set("Current Target: " .. actions.GetPlayer(value).Name .. " | " .. actions.GetPlayer(value).DisplayName)
            end
            actions.Notify("Target: " .. actions.GetPlayer(value).Name .. " | " .. actions.GetPlayer(value).DisplayName)
        end
    end
})

MainTab.Tab:CreateButton({
    Name = "Choose Player",
    Callback = function()
        task.wait(0.1)
        MainTab.Variables.PlayersWandGlow.ClickPlayerBool = true
    end
})

Mouse.Button1Down:Connect(function()
    if MainTab.Variables.PlayersWandGlow.ClickPlayerBool then
        MainTab.Variables.PlayersWandGlow.ClickPlayerBool = false
        local closestPlayer = actions.getClosestPlayerToMouse(false)
        if closestPlayer then
            MainTab.Variables.PlayersWandGlow.Target = closestPlayer
            if MainTab.Variables.PlayersWandGlow.CurrentTargetText ~= 0 then
                MainTab.Variables.PlayersWandGlow.CurrentTargetText:Set("Current Target: " .. closestPlayer.Name .. " | " .. closestPlayer.DisplayName)
            end
            actions.Notify("Target: " .. closestPlayer.Name .. " | " .. closestPlayer.DisplayName)
        end
    else
        MainTab.Variables.PlayersWandGlow.ClickPlayerBool = false
    end
end)

MainTab.Variables.PlayersWandGlow.CurrentTargetText = MainTab.Tab:CreateLabel("Current Target: ")

MainTab.Tab:CreateDropdown({
    Name = "Use Type",
    Options = {"Me", "Target", "Everyone", "Others"},
    CurrentOption = "Me",
    Callback = function(option)
        MainTab.Variables.PlayersWandGlow.UseType = option[1] == "Me" and 0 or option[1] == "Target" and 1 or option[1] == "Everyone" and 2 or 3
    end
})

MainTab.Tab:CreateDivider()

MainTab.Variables.PlayersWandGlow.CurrentSpellText = 0

MainTab.Tab:CreateInput({
    Name = "Spell",
    CurrentValue = "",
    PlaceholderText = "Spell",
    RemoveTextAfterFocusLost = true,
    Callback = function(value)
        if value ~= "" and actions.GetSpell(value) then
            MainTab.Variables.PlayersWandGlow.Spell = actions.GetSpell(value)
            if MainTab.Variables.PlayersWandGlow.CurrentSpellText ~= 0 then
                MainTab.Variables.PlayersWandGlow.CurrentSpellText:Set("Current Spell: " .. actions.GetSpell(value))
            end
            actions.Notify("Spell choosed: " .. actions.GetSpell(value))
        elseif value == "" then
            MainTab.Variables.PlayersWandGlow.Spell = ""
            if MainTab.Variables.PlayersWandGlow.CurrentSpellText ~= 0 then
                MainTab.Variables.PlayersWandGlow.CurrentSpellText:Set("Current Spell: ")
            end
            actions.Notify("Spell cleared.")
        elseif actions.GetSpell(value) == nil then
            actions.Notify("Spell not found.")
        end
    end
})

MainTab.Variables.PlayersWandGlow.CurrentSpellText = MainTab.Tab:CreateLabel("Current Spell: ")

MainTab.Tab:CreateDivider()

MainTab.Tab:CreateButton({
    Name = "Glow Wand",
    Callback = function()
        local AllOk = false
        local FinalTarget = nil
        
        if MainTab.Variables.PlayersWandGlow.UseType == 0 then
            FinalTarget = plr
            AllOk = true
        elseif MainTab.Variables.PlayersWandGlow.UseType == 1 then
            if MainTab.Variables.PlayersWandGlow.Target ~= 0 then
                FinalTarget = MainTab.Variables.PlayersWandGlow.Target
                AllOk = true
            end
        else
            AllOk = true
        end
        
        for i,v in pairs(players:GetPlayers()) do
            if AllOk then
                local Wand
        
                if MainTab.Variables.PlayersWandGlow.UseType == 2 or MainTab.Variables.PlayersWandGlow.UseType == 3 then
                    task.wait(0.1)
                end
        
                if MainTab.Variables.PlayersWandGlow.UseType == 0 or MainTab.Variables.PlayersWandGlow.UseType == 1 then
                    Wand = FinalTarget.Character:FindFirstChild("Wand") or FinalTarget.Character:FindFirstChild("Elder Wand")
                elseif MainTab.Variables.PlayersWandGlow.UseType == 2 then
                    Wand = v.Character:FindFirstChild("Wand") or v.Character:FindFirstChild("Elder Wand")
                elseif MainTab.Variables.PlayersWandGlow.UseType == 3 and v ~= plr then
                    Wand = v.Character:FindFirstChild("Wand") or v.Character:FindFirstChild("Elder Wand")
                end
        
                if Wand then
                    IServ.Events.setSpellLoaded:FireServer({
                        ["bool"] = true,
                        ["distance"] = actions.CalculateDistance("setSpellLoaded"),
                        ["tool"] = Wand,
                        ["spellName"] = MainTab.Variables.PlayersWandGlow.Spell
                    })
        
                    if MainTab.Variables.PlayersWandGlow.UseType == 0 or MainTab.Variables.PlayersWandGlow.UseType == 1 then
                        actions.Notify("Target's wand has been glowed.")
                        break
                    end
                else
                    if MainTab.Variables.PlayersWandGlow.UseType == 1 then
                        actions.Notify("Target doesn't holds a wand.")
                    end
                end
            end
        end
    end
})

MainTab.Tab:CreateButton({
    Name = "Unglow Wand",
    Callback = function()
        local AllOk = false
        local FinalTarget = nil
        
        if MainTab.Variables.PlayersWandGlow.UseType == 0 then
            FinalTarget = plr
            AllOk = true
        elseif MainTab.Variables.PlayersWandGlow.UseType == 1 then
            if MainTab.Variables.PlayersWandGlow.Target ~= 0 then
                FinalTarget = MainTab.Variables.PlayersWandGlow.Target
                AllOk = true
            end
        else
            AllOk = true
        end
        
        for i,v in pairs(players:GetPlayers()) do
            if AllOk then
                local Wand
        
                if MainTab.Variables.PlayersWandGlow.UseType == 2 or MainTab.Variables.PlayersWandGlow.UseType == 3 then
                    task.wait(0.1)
                end
        
                if MainTab.Variables.PlayersWandGlow.UseType == 0 or MainTab.Variables.PlayersWandGlow.UseType == 1 then
                    Wand = FinalTarget.Character:FindFirstChild("Wand") or FinalTarget.Character:FindFirstChild("Elder Wand")
                elseif MainTab.Variables.PlayersWandGlow.UseType == 2 then
                    Wand = v.Character:FindFirstChild("Wand") or v.Character:FindFirstChild("Elder Wand")
                elseif MainTab.Variables.PlayersWandGlow.UseType == 3 and v ~= plr then
                    Wand = v.Character:FindFirstChild("Wand") or v.Character:FindFirstChild("Elder Wand")
                end
        
                if Wand then
                    IServ.Events.setSpellLoaded:FireServer({
                        ["bool"] = false,
                        ["distance"] = actions.CalculateDistance("setSpellLoaded"),
                        ["tool"] = Wand,
                        ["spellName"] = MainTab.Variables.PlayersWandGlow.Spell
                    })
        
                    if MainTab.Variables.PlayersWandGlow.UseType == 0 or MainTab.Variables.PlayersWandGlow.UseType == 1 then
                        actions.Notify("Target's wand has been glowed.")
                        break
                    end
                else
                    if MainTab.Variables.PlayersWandGlow.UseType == 1 then
                        actions.Notify("Target doesn't holds a wand.")
                    end
                end
            end
        end
    end
})

--Spell Aura

MainTab.Tab:CreateSection("Spell Aura")

MainTab.Variables.SpellAura.CurrentTargetText = 0

MainTab.Tab:CreateInput({
    Name = "Target",
    CurrentValue = "",
    PlaceholderText = "Name or Displayname",
    RemoveTextAfterFocusLost = true,
    Callback = function(value)
        if actions.GetPlayer(value) and actions.GetPlayer(value) ~= plr then
            MainTab.Variables.SpellAura.Target = actions.GetPlayer(value)
            if MainTab.Variables.SpellAura.CurrentTargetText ~= 0 then
                MainTab.Variables.SpellAura.CurrentTargetText:Set("Current Target: " .. actions.GetPlayer(value).Name .. " | " .. actions.GetPlayer(value).DisplayName)
            end
            actions.Notify("Target: " .. actions.GetPlayer(value).Name .. " | " .. actions.GetPlayer(value).DisplayName)
        end
    end
})

MainTab.Tab:CreateButton({
    Name = "Choose Player",
    Callback = function()
        task.wait(0.1)
        MainTab.Variables.SpellAura.ClickPlayerBool = true
    end
})

Mouse.Button1Down:Connect(function()
    if MainTab.Variables.SpellAura.ClickPlayerBool then
        MainTab.Variables.SpellAura.ClickPlayerBool = false
        local closestPlayer = actions.getClosestPlayerToMouse(false)
        if closestPlayer then
            MainTab.Variables.SpellAura.Target = closestPlayer
            if MainTab.Variables.SpellAura.CurrentTargetText ~= 0 then
                MainTab.Variables.SpellAura.CurrentTargetText:Set("Current Target: " .. closestPlayer.Name .. " | " .. closestPlayer.DisplayName)
            end
            actions.Notify("Target: " .. closestPlayer.Name .. " | " .. closestPlayer.DisplayName)
        end
    else
        MainTab.Variables.SpellAura.ClickPlayerBool = false
    end
end)

MainTab.Variables.SpellAura.CurrentTargetText = MainTab.Tab:CreateLabel("Current Target: ")

MainTab.Tab:CreateDropdown({
    Name = "Use Type",
    Options = {"Me", "Target"},
    CurrentOption = "Me",
    Callback = function(option)
        MainTab.Variables.SpellAura.UseType = option[1] == "Me" and 0 or 1
    end
})

MainTab.Tab:CreateDivider()

MainTab.Variables.SpellAura.CurrentSpellText = 0

MainTab.Tab:CreateInput({
    Name = "Spell",
    CurrentValue = "",
    PlaceholderText = "Spell",
    RemoveTextAfterFocusLost = true,
    Callback = function(value)
        if value ~= "" and actions.GetSpell(value) then
            MainTab.Variables.SpellAura.Spell = actions.GetSpell(value)
            if MainTab.Variables.SpellAura.CurrentSpellText ~= 0 then
                MainTab.Variables.SpellAura.CurrentSpellText:Set("Current Spell: " .. actions.GetSpell(value))
            end
            actions.Notify("Spell choosed: " .. actions.GetSpell(value))
        elseif value == "" then
            MainTab.Variables.SpellAura.Spell = ""
            if MainTab.Variables.SpellAura.CurrentSpellText ~= 0 then
                MainTab.Variables.SpellAura.CurrentSpellText:Set("Current Spell: ")
            end
            actions.Notify("Spell cleared.")
        elseif actions.GetSpell(value) == nil then
            actions.Notify("Spell not found.")
        end
    end
})

MainTab.Variables.SpellAura.CurrentSpellText = MainTab.Tab:CreateLabel("Current Spell: ")

MainTab.Tab:CreateDivider()

MainTab.Variables.SpellAura.ExceptionDropdown = 0

MainTab.Tab:CreateInput({
    Name = "Exception",
    CurrentValue = "",
    PlaceholderText = "Name or Displayname",
    RemoveTextAfterFocusLost = true,
    Callback = function(value)
        if actions.GetPlayer(value) then
            if MainTab.Variables.SpellAura.UseType == 0 and actions.GetPlayer(value) == plr then return end

            if not table.find(MainTab.Variables.SpellAura.ExceptedPlayers, actions.GetPlayer(value).Name) then
                table.insert(MainTab.Variables.SpellAura.ExceptedPlayers, actions.GetPlayer(value).Name)
                if MainTab.Variables.SpellAura.ExceptionDropdown ~= 0 then
                    MainTab.Variables.SpellAura.ExceptionDropdown:Refresh(MainTab.Variables.SpellAura.ExceptedPlayers)
                end
                actions.Notify(actions.GetPlayer(value).Name .. " | " .. actions.GetPlayer(value).DisplayName .. " has been added in the exception list.")
            end
        end
    end
})

MainTab.Variables.SpellAura.ExceptionDropdown = MainTab.Tab:CreateDropdown({
    Name = "Exception List",
    Options = {},
    CurrentOption = "",
    Callback = function(option)
        if table.find(MainTab.Variables.SpellAura.ExceptedPlayers, option[1]) then
            table.remove(MainTab.Variables.SpellAura.ExceptedPlayers, table.find(MainTab.Variables.SpellAura.ExceptedPlayers, option[1]))
            MainTab.Variables.SpellAura.ExceptionDropdown:Refresh(MainTab.Variables.SpellAura.ExceptedPlayers)
            MainTab.Variables.SpellAura.ExceptionDropdown:Set("")
            actions.Notify("Player has been removed from exception list.")
        end
    end
})

MainTab.Tab:CreateButton({
    Name = "Clear Exception List",
    Callback = function()
        MainTab.Variables.SpellAura.ExceptedPlayers = {}
        if MainTab.Variables.SpellAura.ExceptionDropdown ~= 0 then
            MainTab.Variables.SpellAura.ExceptionDropdown:Refresh({})
            MainTab.Variables.SpellAura.ExceptionDropdown:Set("")
        end
        actions.Notify("Exception list has been cleared.")
    end
})

MainTab.Tab:CreateDivider()

MainTab.Tab:CreateSlider({
    Name = "Distance",
    Range = {1, 500},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = MainTab.Variables.SpellAura.Distance,
    Callback = function(value)
        MainTab.Variables.SpellAura.Distance = value
    end
})

MainTab.Tab:CreateButton({
    Name = "Spell Aura",
    Callback = function()
        MainTab.Variables.SpellAura.Bool = true
        actions.Notify("Spell Aura has been enabled.")
    end
})

MainTab.Tab:CreateButton({
    Name = "Unspell Aura",
    Callback = function()
        MainTab.Variables.SpellAura.Bool = false
        actions.Notify("Spell Aura has been disabled.")
    end
})

--Teleport

MainTab.Tab:CreateSection("Teleport")

MainTab.Tab:CreateToggle({
    Name = "Teleport Command",
    CurrentValue = settings["TeleportCommandBool"],
    Callback = function(bool)
        settings["TeleportCommandBool"] = bool
        saveSettings()
    end
})

MainTab.Tab:CreateInput({
    Name = "Command",
    CurrentValue = settings["TeleportCommand"],
    PlaceholderText = "Command",
    RemoveTextAfterFocusLost = false,
    Callback = function(value)
        settings["TeleportCommand"] = value
        saveSettings()

        actions.Notify("Command applied.")
    end
})

--Spawn Points

MainTab.Tab:CreateSection("Spawn Points")

MainTab.Variables.SpawnPoints.SpawnPointNameInput = MainTab.Tab:CreateInput({
    Name = "Spawn Point Name",
    CurrentValue = MainTab.Variables.SpawnPoints.Name,
    PlaceholderText = "Name",
    RemoveTextAfterFocusLost = false,
    Callback = function(value)
        MainTab.Variables.SpawnPoints.Name = value
    end
})

MainTab.Variables.SpawnPoints.SpawnPointsDropdown = 0
MainTab.Variables.SpawnPoints.RemoveSpawnPointsDropdown = 0
MainTab.Variables.SpawnPoints.Names = {}
MainTab.Variables.SpawnPoints.NamesF = {}
function MainTab.Variables.SpawnPoints.NamesF:Refresh()
    MainTab.Variables.SpawnPoints.Names = {}

    for i,v in pairs(settings["SpawnPoints"]) do
        table.insert(MainTab.Variables.SpawnPoints.Names, i)
    end
end
MainTab.Variables.SpawnPoints.NamesF:Refresh()

MainTab.Tab:CreateButton({
    Name = "Create Spawn Point",
    Callback = function()
        if RootPart and MainTab.Variables.SpawnPoints.Name ~= "" then
            settings["SpawnPoints"][MainTab.Variables.SpawnPoints.Name] = {["X"] = RootPart.Position.X, ["Y"] = RootPart.Position.Y, ["Z"] = RootPart.Position.Z}
            saveSettings()

            MainTab.Variables.SpawnPoints.NamesF:Refresh()

            if MainTab.Variables.SpawnPoints.SpawnPointsDropdown ~= 0 then
                MainTab.Variables.SpawnPoints.SpawnPointsDropdown:Refresh(MainTab.Variables.SpawnPoints.Names)
            end
            if MainTab.Variables.SpawnPoints.RemoveSpawnPointsDropdown ~= 0 then
                MainTab.Variables.SpawnPoints.RemoveSpawnPointsDropdown:Refresh(MainTab.Variables.SpawnPoints.Names)
            end
            MainTab.Variables.SpawnPoints.SpawnPointNameInput:Set("")
            actions.Notify("Spawn Point created.")
        end
    end
})

MainTab.Tab:CreateDivider()

MainTab.Tab:CreateInput({
    Name = "Spawn Points",
    CurrentValue = "",
    PlaceholderText = "Name",
    RemoveTextAfterFocusLost = true,
    Callback = function(value)
        local spawnPoint = settings["SpawnPoints"]
        local found

        for i,v in pairs(MainTab.Variables.SpawnPoints.Names) do
            if string.lower(string.sub(v, 1, string.len(value))) == string.lower(value) then
                if spawnPoint[v] then
                    found = spawnPoint[v]
                    break
                end
            end
        end

        if found then
            IServ.Events.uniqueSpell:FireServer({
                ["spellName"] = "appa",
                ["distance"] = actions.CalculateDistance("uniqueSpell"),
                ["mousePos"] = Vector3.new(found.X, found.Y, found.Z)
            })
        else
            actions.Notify("Couldn't find the spawnpoint.")
        end
    end
})

MainTab.Variables.SpawnPoints.SpawnPointsDropdown = MainTab.Tab:CreateDropdown({
    Name = "Spawn Points",
    Options = MainTab.Variables.SpawnPoints.Names,
    CurrentOption = "",
    Callback = function(option)
        if settings["SpawnPoints"][option[1]] then
            local spawnPoint = settings["SpawnPoints"][option[1]]

            IServ.Events.uniqueSpell:FireServer({
                ["spellName"] = "appa",
                ["distance"] = actions.CalculateDistance("uniqueSpell"),
                ["mousePos"] = Vector3.new(spawnPoint.X, spawnPoint.Y, spawnPoint.Z)
            })
            MainTab.Variables.SpawnPoints.SpawnPointsDropdown:Set("")
        end
    end
})

MainTab.Tab:CreateDivider()

MainTab.Variables.SpawnPoints.RemoveSpawnPointsDropdown = MainTab.Tab:CreateDropdown({
    Name = "Remove Spawn Point",
    Options = MainTab.Variables.SpawnPoints.Names,
    CurrentOption = "",
    Callback = function(option)
        if settings["SpawnPoints"][option[1]] then
            for i,v in pairs(settings["SpawnPoints"]) do
                if i == option[1] then
                    settings["SpawnPoints"][i] = nil
                end
            end
            saveSettings()

            MainTab.Variables.SpawnPoints.NamesF:Refresh()

            MainTab.Variables.SpawnPoints.RemoveSpawnPointsDropdown:Set("")
            MainTab.Variables.SpawnPoints.RemoveSpawnPointsDropdown:Refresh(MainTab.Variables.SpawnPoints.Names)

            if MainTab.Variables.SpawnPoints.SpawnPointsDropdown ~= 0 then
                MainTab.Variables.SpawnPoints.SpawnPointsDropdown:Refresh(MainTab.Variables.SpawnPoints.Names)
            end
            actions.Notify("Spawn Point removed.")
        end
    end
})

MainTab.Tab:CreateButton({
    Name = "Remove All Spawn Points",
    Callback = function()
        settings["SpawnPoints"] = {}
        saveSettings()

        MainTab.Variables.SpawnPoints.NamesF:Refresh()

        if MainTab.Variables.SpawnPoints.RemoveSpawnPointsDropdown ~= 0 then
            MainTab.Variables.SpawnPoints.RemoveSpawnPointsDropdown:Refresh(MainTab.Variables.SpawnPoints.Names)
        end

        if MainTab.Variables.SpawnPoints.SpawnPointsDropdown ~= 0 then
            MainTab.Variables.SpawnPoints.SpawnPointsDropdown:Refresh(MainTab.Variables.SpawnPoints.Names)
        end
        actions.Notify("Removed every Spawn Point.")
    end
})

MainTab.Tab:CreateDivider()

MainTab.Tab:CreateToggle({
    Name = "Spawnpoint Command",
    CurrentValue = settings["SpawnPointCommandBool"],
    Callback = function(bool)
        settings["SpawnPointCommandBool"] = bool
        saveSettings()
    end
})

MainTab.Tab:CreateInput({
    Name = "Command",
    CurrentValue = settings["SpawnPointCommand"],
    PlaceholderText = "Command",
    RemoveTextAfterFocusLost = false,
    Callback = function(value)
        settings["SpawnPointCommand"] = value
        saveSettings()

        actions.Notify("Command applied.")
    end
})

--! Toggles Tab

TogglesTab.Variables.AutoHeal = false
TogglesTab.Variables.AutoDiffindo = false
TogglesTab.Variables.AutoRevive = false

TogglesTab.Variables.AutoBlock = false

TogglesTab.Variables.AntiFling = false

TogglesTab.Variables.AntiElderWandSpells = {}
TogglesTab.Variables.AntiElderWandSpells.Bool = false
TogglesTab.Variables.AntiElderWandSpells.DistanceType = 0
TogglesTab.Variables.AntiElderWandSpells.Distance = 35
TogglesTab.Variables.AntiElderWandSpells.ExceptedPlayers = {}
TogglesTab.Variables.AntiElderWandSpells.Spell = "stupefy"

TogglesTab.Variables.AutoRespawn = {}
TogglesTab.Variables.AutoRespawn.Bool = false
TogglesTab.Variables.AutoRespawn.LastPos = Vector3.zero

TogglesTab.Variables.AutoKick = {}
TogglesTab.Variables.AutoKick.Bool = false
TogglesTab.Variables.AutoKick.List = {
    1311715825, --p4trixx 
    3003526 --OceanArcher
}

TogglesTab.Variables.ChatDuringClash = false

TogglesTab.Tab:CreateToggle({
    Name = "Auto Heal",
    CurrentValue = false,
    Callback = function(bool)
        TogglesTab.Variables.AutoHeal = bool
    end
})

TogglesTab.Tab:CreateToggle({
    Name = "Auto Revive",
    CurrentValue = false,
    Callback = function(bool)
        TogglesTab.Variables.AutoRevive = bool
    end
})

TogglesTab.Tab:CreateToggle({
    Name = "Auto Diffindo",
    CurrentValue = false,
    Callback = function(bool)
        TogglesTab.Variables.AutoDiffindo = bool
    end
})

--Protection Toggles

TogglesTab.Tab:CreateSection("Protection Toggles")

TogglesTab.Tab:CreateToggle({
    Name = "Auto Block",
    CurrentValue = false,
    Callback = function(bool)
        TogglesTab.Variables.AutoBlock = bool
    end
})

TogglesTab.Tab:CreateToggle({
    Name = "Anti Fling",
    CurrentValue = false,
    Callback = function(bool)
        TogglesTab.Variables.AntiFling = bool
    end
})

TogglesTab.Tab:CreateToggle({
    Name = "Auto Kick",
    CurrentValue = false,
    Callback = function(bool)
        TogglesTab.Variables.AutoKick.Bool = bool
        
        for i,v in pairs(players:GetPlayers()) do
            if table.find(TogglesTab.Variables.AutoKick.List, v.UserId) and bool then
                plr:Kick("ooolkol scripts: Admin joined.")
            end
        end
    end
})

TogglesTab.Tab:CreateToggle({
    Name = "Secure Mode",
    CurrentValue = false,
    Callback = function(bool)
        TogglesTab.Variables.SecureMode = bool
    end
})

--Anti Elder Wand Spells

TogglesTab.Tab:CreateSection("Anti Elder Wand Spells")

TogglesTab.Tab:CreateToggle({
    Name = "Anti Elder Wand Spells",
    CurrentValue = false,
    Callback = function(bool)
        TogglesTab.Variables.AntiElderWandSpells.Bool = bool
    end
})

TogglesTab.Tab:CreateDropdown({
    Name = "Distance type",
    Options = {"Number", "Whole Map"},
    CurrentOption = "Number",
    Callback = function(option)
        TogglesTab.Variables.AntiElderWandSpells.DistanceType = option[1] == "Number" and 0 or 1
    end
})

TogglesTab.Tab:CreateSlider({
    Name = "Distance",
    Range = {1, 500},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = TogglesTab.Variables.AntiElderWandSpells.Distance,
    Callback = function(value)
        TogglesTab.Variables.AntiElderWandSpells.Distance = value
    end
})

TogglesTab.Tab:CreateDivider()

TogglesTab.Variables.AntiElderWandSpells.ExceptionDropdown = 0

TogglesTab.Tab:CreateInput({
    Name = "Exception",
    CurrentValue = "",
    PlaceholderText = "Name or Displayname",
    RemoveTextAfterFocusLost = true,
    Callback = function(value)
        if actions.GetPlayer(value) and actions.GetPlayer(value) ~= plr then
            if not table.find(TogglesTab.Variables.AntiElderWandSpells.ExceptedPlayers, actions.GetPlayer(value).Name) then
                table.insert(TogglesTab.Variables.AntiElderWandSpells.ExceptedPlayers, actions.GetPlayer(value).Name)
                if TogglesTab.Variables.AntiElderWandSpells.ExceptionDropdown ~= 0 then
                    TogglesTab.Variables.AntiElderWandSpells.ExceptionDropdown:Refresh(TogglesTab.Variables.AntiElderWandSpells.ExceptedPlayers)
                end
                actions.Notify(actions.GetPlayer(value).Name .. " | " .. actions.GetPlayer(value).DisplayName .. " has been added in the exception list.")
            end
        end
    end
})

TogglesTab.Variables.AntiElderWandSpells.ExceptionDropdown = TogglesTab.Tab:CreateDropdown({
    Name = "Exception List",
    Options = {},
    CurrentOption = "",
    Callback = function(option)
        if table.find(TogglesTab.Variables.AntiElderWandSpells.ExceptedPlayers, option[1]) then
            table.remove(TogglesTab.Variables.AntiElderWandSpells.ExceptedPlayers, table.find(TogglesTab.Variables.AntiElderWandSpells.ExceptedPlayers, option[1]))
            TogglesTab.Variables.AntiElderWandSpells.ExceptionDropdown:Refresh(TogglesTab.Variables.AntiElderWandSpells.ExceptedPlayers)
            TogglesTab.Variables.AntiElderWandSpells.ExceptionDropdown:Set("")
            actions.Notify("Player has been removed from exception list.")
        end
    end
})

TogglesTab.Tab:CreateButton({
    Name = "Clear Exception List",
    Callback = function()
        TogglesTab.Variables.AntiElderWandSpells.ExceptedPlayers = {}
        if TogglesTab.Variables.AntiElderWandSpells.ExceptionDropdown ~= 0 then
            TogglesTab.Variables.AntiElderWandSpells.ExceptionDropdown:Refresh({})
            TogglesTab.Variables.AntiElderWandSpells.ExceptionDropdown:Set("")
        end
        actions.Notify("Exception list has been cleared.")
    end
})

TogglesTab.Tab:CreateDivider()

TogglesTab.Variables.AntiElderWandSpells.CurrentSpellText = 0

TogglesTab.Tab:CreateInput({
    Name = "Spell",
    CurrentValue = "",
    PlaceholderText = "Spell",
    RemoveTextAfterFocusLost = true,
    Callback = function(value)
        if value ~= "" and actions.GetSpell(value) then
            TogglesTab.Variables.AntiElderWandSpells.Spell = actions.GetSpell(value)
            if TogglesTab.Variables.AntiElderWandSpells.CurrentSpellText ~= 0 then
                TogglesTab.Variables.AntiElderWandSpells.CurrentSpellText:Set("Current Spell: " .. actions.GetSpell(value))
            end
            actions.Notify("Spell choosed: " .. actions.GetSpell(value))
        elseif value == "" then
            TogglesTab.Variables.AntiElderWandSpells.Spell = ""
            if TogglesTab.Variables.AntiElderWandSpells.CurrentSpellText ~= 0 then
                TogglesTab.Variables.AntiElderWandSpells.CurrentSpellText:Set("Current Spell: ")
            end
            actions.Notify("Spell cleared.")
        elseif actions.GetSpell(value) == nil then
            actions.Notify("Spell not found.")
        end
    end
})

TogglesTab.Variables.AntiElderWandSpells.CurrentSpellText = TogglesTab.Tab:CreateLabel("Current Spell: " .. TogglesTab.Variables.AntiElderWandSpells.Spell)

game:GetService("Workspace"):WaitForChild("spellEffects").ChildAdded:Connect(function(obj)
    if obj.Name == "stormModel" and TogglesTab.Variables.AntiElderWandSpells.Bool then
        local closestPlayer
        local closestDistanceToLocal = TogglesTab.Variables.AntiElderWandSpells.DistanceType == 0 and TogglesTab.Variables.AntiElderWandSpells.Distance or math.huge
        local closestDistance = 100
        local spelled = false
        local whitelisted = obj:WaitForChild("Center"):FindFirstChild("whitelisted")

        for i,v in pairs(players:GetPlayers()) do
            if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (v.Character.HumanoidRootPart.Position - obj:WaitForChild("Center").Position).Magnitude
                if (v.Character.HumanoidRootPart.Position - RootPart.Position).Magnitude < TogglesTab.Variables.AntiElderWandSpells.Distance and distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = v
                end
            end
        end
        if closestPlayer and table.find(TogglesTab.Variables.AntiElderWandSpells.ExceptedPlayers, closestPlayer.Name) then
            if not whitelisted then
                whitelisted = Instance.new("BoolValue")
                whitelisted.Name = "whitelisted"
                whitelisted.Parent = obj.Center
            end
        end
        if closestPlayer and TogglesTab.Variables.AntiElderWandSpells.Spell ~= "" and not whitelisted then
            if spelled == false then
                for i = 1,5 do
                    actions.SendSpell(closestPlayer, TogglesTab.Variables.AntiElderWandSpells.Spell)
                    task.wait()
                end
                spelled = true
            end
        end
    end
end)

--Additional Toggles

TogglesTab.Tab:CreateSection("Additional Toggles")

TogglesTab.Tab:CreateToggle({
    Name = "Auto Respawn",
    CurrentValue = false,
    Callback = function(bool)
        TogglesTab.Variables.AutoRespawn.Bool = bool
        if bool then
            plr.Character.Humanoid.Died:Connect(function()
                if TogglesTab.Variables.AutoRespawn.Bool then
                    TogglesTab.Variables.AutoRespawn.LastPos = RootPart.Position
                end
            end)
        end
    end
})

plr.CharacterAdded:Connect(function(newChar)
    if TogglesTab.Variables.AutoRespawn.Bool then
        newChar:WaitForChild("Humanoid").Died:Connect(function()
            TogglesTab.Variables.AutoRespawn.LastPos = RootPart.Position
        end)
        task.wait(0.1)
        char:WaitForChild("Humanoid")
        char:MoveTo(TogglesTab.Variables.AutoRespawn.LastPos)
    end
end)

--Clash

TogglesTab.Tab:CreateSection("Clash")

TogglesTab.Tab:CreateToggle({
    Name = "Chat During Clash",
    CurrentValue = false,
    Callback = function(bool)
        TogglesTab.Variables.ChatDuringClash = bool
    end
})

plr.PlayerGui.Chat.Frame:GetPropertyChangedSignal("Visible"):Connect(function()
    if TogglesTab.Variables.ChatDuringClash then
        plr.PlayerGui.Chat.Frame.Visible = true
    end
end)

plr.PlayerGui.Chat.Frame.ChatBarParentFrame:GetPropertyChangedSignal("Visible"):Connect(function()
    if TogglesTab.Variables.ChatDuringClash then
        plr.PlayerGui.Chat.Frame.ChatBarParentFrame.Visible = true
    end
end)

--! God Mode Tab

GodModeTab.Variables.Target = 0
GodModeTab.Variables.ClickPlayerBool = false
GodModeTab.Variables.GodModeLoop = false
GodModeTab.Variables.LocalGodMode = false

GodModeTab.Variables.TargetGodModeCurrentTargetText = 0

GodModeTab.Tab:CreateInput({
    Name = "Target",
    CurrentValue = "",
    PlaceholderText = "Name or Displayname",
    RemoveTextAfterFocusLost = true,
    Callback = function(value)
        if actions.GetPlayer(value) and actions.GetPlayer(value) ~= plr then
            GodModeTab.Variables.Target = actions.GetPlayer(value).Name
            if GodModeTab.Variables.TargetGodModeCurrentTargetText ~= 0 then
                GodModeTab.Variables.TargetGodModeCurrentTargetText:Set("Current Target: " .. actions.GetPlayer(value).Name .. " | " .. actions.GetPlayer(value).DisplayName)
            end
            actions.Notify("Target: " .. actions.GetPlayer(value).Name .. " | " .. actions.GetPlayer(value).DisplayName)
        end
    end
})

GodModeTab.Tab:CreateButton({
    Name = "Choose Player",
    Callback = function()
        task.wait(0.1)
        GodModeTab.Variables.ClickPlayerBool = true
    end
})

Mouse.Button1Down:Connect(function()
    if GodModeTab.Variables.ClickPlayerBool then
        GodModeTab.Variables.ClickPlayerBool = false
        local closestPlayer = actions.getClosestPlayerToMouse(false)
        if closestPlayer then
            GodModeTab.Variables.Target = closestPlayer.Name
            if GodModeTab.Variables.TargetGodModeCurrentTargetText ~= 0 then
                GodModeTab.Variables.TargetGodModeCurrentTargetText:Set("Current Target: " .. closestPlayer.Name .. " | " .. closestPlayer.DisplayName)
            end
            actions.Notify("Target: " .. closestPlayer.Name .. " | " .. closestPlayer.DisplayName)
        end
    else
        GodModeTab.Variables.ClickPlayerBool = false
    end
end)

GodModeTab.Variables.TargetGodModeCurrentTargetText = GodModeTab.Tab:CreateLabel("Current Target: ")

GodModeTab.Tab:CreateDivider()

GodModeTab.Tab:CreateButton({
    Name = "Loop Target",
    Callback = function()
        if GodModeTab.Variables.GodModeLoop == false then
            GodModeTab.Variables.GodModeLoop = true
    
            actions.Notify("Target is looping.")
        end
    end
})

GodModeTab.Tab:CreateButton({
    Name = "Unloop Target",
    Callback = function()
        if GodModeTab.Variables.GodModeLoop then
            GodModeTab.Variables.GodModeLoop = false
    
            actions.Notify("Target is unlooped.")
        end
    end
})

--Local God Mode

GodModeTab.Tab:CreateSection("Local God Mode")

GodModeTab.Tab:CreateButton({
    Name = "God Mode",
    Callback = function()
        if char and Humanoid and RootPart then
            Humanoid.WalkSpeed = 0
            RootPart.Anchored = true
            for i,v in pairs(Humanoid:GetPlayingAnimationTracks()) do
                v:Stop()
            end
            Humanoid:Destroy()
    
            actions.SendSpell(plr, "avada kedavra")
    
            task.wait(1)
    
            RootPart.Anchored = false
    
            Instance.new("Humanoid", char)
    
            if plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid.HipHeight = 2
            end
    
            GodModeTab.Variables.LocalGodMode = true
        end
    end
})

GodModeTab.Tab:CreateButton({
    Name = "Ungod Mode",
    Callback = function()
        if char and Humanoid then
            char:MoveTo(Vector3.new(-400, -400, -400))
            GodModeTab.Variables.LocalGodMode = false
        end
    end
})

UIS.InputBegan:Connect(function(input, chatting)
    if chatting == false then
        if GodModeTab.Variables.LocalGodMode and input.KeyCode == Enum.KeyCode.Space then
            if plr.Character and plr.Character.Humanoid then
                plr.Character.Humanoid.Jump = true
            end
        end
    end
end)

--! Auto Clash Tab

AutoClashTab.Variables.AutoClash = {}
AutoClashTab.Variables.AutoClash.Bool = false
AutoClashTab.Variables.AutoClash.Delay = 0.2
AutoClashTab.Variables.AutoClash.Instant = false

AutoClashTab.Tab:CreateToggle({
    Name = "Auto Clash",
    CurrentValue = false,
    Callback = function(bool)
        AutoClashTab.Variables.AutoClash.Bool = bool
    end
})

AutoClashTab.Tab:CreateSlider({
    Name = "Delay",
    Range = {0.1, 3},
    Increment = 0.1,
    Suffix = "Seconds",
    CurrentValue = 0.2,
    Callback = function(value)
        AutoClashTab.Variables.AutoClash.Delay = value
    end
})

coroutine.resume(coroutine.create(function()
    while task.wait(AutoClashTab.Variables.AutoClash.Delay) do
        if AutoClashTab.Variables.AutoClash.Bool then
            IServ.Events.advanceClash:FireServer({
                ["distance"] = actions.CalculateDistance("advanceClash")
            })
        end
    end
end))

AutoClashTab.Tab:CreateToggle({
    Name = "Instant Clash",
    CurrentValue = false,
    Callback = function(bool)
        AutoClashTab.Variables.AutoClash.Instant = bool
    end
})

--! Target Tab

TargetTab.Variables.Target = 0
TargetTab.Variables.UseType = 1
TargetTab.Variables.ClickPlayerBool = false
TargetTab.Variables.LoopSpellDelay = 0.2
TargetTab.Variables.Spell = ""

TargetTab.Variables.LoopKillList = {}
TargetTab.Variables.LoopSpellList = {}

TargetTab.Variables.LoopKillUseType = 1
TargetTab.Variables.LoopSpellUseType = 1

TargetTab.Variables.TargetCurrentTargetText = 0

TargetTab.Tab:CreateInput({
    Name = "Target",
    CurrentValue = "",
    PlaceholderText = "Name or Displayname",
    RemoveTextAfterFocusLost = true,
    Callback = function(value)
        if actions.GetPlayer(value) and actions.GetPlayer(value) ~= plr then
            TargetTab.Variables.Target = actions.GetPlayer(value)
            if TargetTab.Variables.TargetCurrentTargetText ~= 0 then
                TargetTab.Variables.TargetCurrentTargetText:Set("Current Target: " .. actions.GetPlayer(value).Name .. " | " .. actions.GetPlayer(value).DisplayName)
            end
            actions.Notify("Target: " .. actions.GetPlayer(value).Name .. " | " .. actions.GetPlayer(value).DisplayName)
        end
    end
})

TargetTab.Tab:CreateButton({
    Name = "Choose Player",
    Callback = function()
        task.wait(0.1)
        TargetTab.Variables.ClickPlayerBool = true
    end
})

Mouse.Button1Down:Connect(function()
    if TargetTab.Variables.ClickPlayerBool then
        TargetTab.Variables.ClickPlayerBool = false
        local closestPlayer = actions.getClosestPlayerToMouse(false)
        if closestPlayer then
            TargetTab.Variables.Target = closestPlayer
            if TargetTab.Variables.TargetCurrentTargetText ~= 0 then
                TargetTab.Variables.TargetCurrentTargetText:Set("Current Target: " .. closestPlayer.Name .. " | " .. closestPlayer.DisplayName)
            end
            actions.Notify("Target: " .. closestPlayer.Name .. " | " .. closestPlayer.DisplayName)
        end
    else
        TargetTab.Variables.ClickPlayerBool = false
    end
end)

TargetTab.Variables.TargetCurrentTargetText = TargetTab.Tab:CreateLabel("Current Target: ")

TargetTab.Tab:CreateDropdown({
    Name = "Use Type",
    Options = {"Me", "Target", "Everyone", "Others"},
    CurrentOption = "Target",
    Callback = function(option)
        TargetTab.Variables.UseType = option[1] == "Me" and 0 or option[1] == "Target" and 1 or option[1] == "Everyone" and 2 or 3
    end
})

TargetTab.Tab:CreateDivider()

TargetTab.Variables.CurrentSpellText = 0

TargetTab.Tab:CreateInput({
    Name = "Spell",
    CurrentValue = "",
    PlaceholderText = "Spell",
    RemoveTextAfterFocusLost = true,
    Callback = function(value)
        if value ~= "" and actions.GetSpell(value) then
            TargetTab.Variables.Spell = actions.GetSpell(value)
            if TargetTab.Variables.CurrentSpellText ~= 0 then
                TargetTab.Variables.CurrentSpellText:Set("Current Spell: " .. actions.GetSpell(value))
            end
            actions.Notify("Speel choosed: " .. actions.GetSpell(value))
        elseif value == "" then
            TargetTab.Variables.Spell = ""
            if TargetTab.Variables.CurrentSpellText ~= 0 then
                TargetTab.Variables.CurrentSpellText:Set("Current Spell: ")
            end
            actions.Notify("Spell cleared.")
        elseif actions.GetSpell(value) == nil then
            actions.Notify("Spell not found.")
        end
    end
})

TargetTab.Variables.CurrentSpellText = TargetTab.Tab:CreateLabel("Current Spell: ")

TargetTab.Tab:CreateButton({
    Name = "Send Spell",
    Callback = function()
        if TargetTab.Variables.Spell == "" then
            actions.Notify("Please choose the spell above.")
            return
        elseif TargetTab.Variables.UseType == 1 and TargetTab.Variables.Target == 0 then
            actions.Notify("Please select a target above.")
            return
        else
            actions.Notify("Sending " .. TargetTab.Variables.Spell .. "...")
        end

        local AllOk = false
        local FinalTarget = nil

        if TargetTab.Variables.UseType == 0 then
            FinalTarget = plr
            AllOk = true
        elseif TargetTab.Variables.UseType == 1 then
            if TargetTab.Variables.Target ~= 0 then
                FinalTarget = TargetTab.Variables.Target
                AllOk = true
            end
        else
            AllOk = true
        end

        for i,v in pairs(players:GetPlayers()) do
            if AllOk then
                if TargetTab.Variables.UseType == 2 or TargetTab.Variables.UseType == 3 then
                    task.wait(0.21)
                end

                if TargetTab.Variables.UseType == 2 then
                    FinalTarget = v
                elseif TargetTab.Variables.UseType == 3 and v ~= plr then
                    FinalTarget = v
                end

                local withoutActor = false
                if TargetTab.Variables.Spell == "confringo" or TargetTab.Variables.Spell == "expulso" or TargetTab.Variables.Spell == "bombarda" then
                    withoutActor = true
                end
                actions.SendSpell(FinalTarget, TargetTab.Variables.Spell, withoutActor)

                if TargetTab.Variables.UseType == 0 or TargetTab.Variables.UseType == 1 then
                    break
                end
            end
        end
    end
})

--Loop Bring

TargetTab.Tab:CreateSection("Loop Bring")

TargetTab.Tab:CreateButton({
    Name = "Loop Bring",
    Callback = function()
        if actions.LoopBring.Bool == false then
            if TargetTab.Variables.UseType == 1 then
                actions.LoopBring:Start()
            else
                actions.Notify("Bring can be used only on Target.")
            end
        end
    end
})

TargetTab.Tab:CreateButton({
    Name = "Unloop Bring",
    Callback = function()
        if actions.LoopBring.Bool then actions.LoopBring:Stop() end
    end
})

--Bring

TargetTab.Tab:CreateSection("Bring")

TargetTab.Tab:CreateButton({
    Name = "Bring",
    Callback = function()
        if actions.Bring.Bool == false then
            if TargetTab.Variables.UseType == 1 then
                actions.Bring.Target = TargetTab.Variables.Target
                actions.Bring:Start()
            else
                actions.Notify("Bring can be used only on Target.")
            end
        end
    end
})

TargetTab.Tab:CreateButton({
    Name = "Unbring",
    Callback = function()
        if actions.Bring.Bool then actions.Bring:Stop() end
    end
})

--Custom Spells

TargetTab.Tab:CreateSection("Custom Spells")

TargetTab.Tab:CreateButton({
    Name = "Fixius",
    Callback = function()
        if TargetTab.Variables.UseType == 1 and TargetTab.Variables.Target == 0 then
            actions.Notify("Please select a target above.")
            return
        else
            actions.Notify("Sending fixius...")
        end

        local AllOk = false
        local FinalTarget = nil

        if TargetTab.Variables.UseType == 0 then
            FinalTarget = plr
            AllOk = true
        elseif TargetTab.Variables.UseType == 1 then
            if TargetTab.Variables.Target ~= 0 then
                FinalTarget = TargetTab.Variables.Target
                AllOk = true
            end
        else
            AllOk = true
        end

        for i,v in pairs(players:GetPlayers()) do
            if AllOk then
                if TargetTab.Variables.UseType == 2 or TargetTab.Variables.UseType == 3 then
                    task.wait(0.21)
                end

                if TargetTab.Variables.UseType == 2 then
                    FinalTarget = v
                elseif TargetTab.Variables.UseType == 3 and v ~= plr then
                    FinalTarget = v
                end

                CustomSpells.Fixius(FinalTarget)

                if TargetTab.Variables.UseType == 0 or TargetTab.Variables.UseType == 1 then
                    break
                end
            end
        end
    end
})

TargetTab.Tab:CreateButton({
    Name = "Nuggetize",
    Callback = function()
        if TargetTab.Variables.UseType == 1 and TargetTab.Variables.Target == 0 then
            actions.Notify("Please select a target above.")
            return
        else
            actions.Notify("Sending nuggetize...")
        end

        local AllOk = false
        local FinalTarget = nil

        if TargetTab.Variables.UseType == 0 then
            FinalTarget = plr
            AllOk = true
        elseif TargetTab.Variables.UseType == 1 then
            if TargetTab.Variables.Target ~= 0 then
                FinalTarget = TargetTab.Variables.Target
                AllOk = true
            end
        else
            AllOk = true
        end

        for i,v in pairs(players:GetPlayers()) do
            if AllOk then
                if TargetTab.Variables.UseType == 2 or TargetTab.Variables.UseType == 3 then
                    task.wait(0.21)
                end

                if TargetTab.Variables.UseType == 2 then
                    FinalTarget = v
                elseif TargetTab.Variables.UseType == 3 and v ~= plr then
                    FinalTarget = v
                end

                CustomSpells.Nuggetize(FinalTarget)

                if TargetTab.Variables.UseType == 0 or TargetTab.Variables.UseType == 1 then
                    break
                end
            end
        end
    end
})

TargetTab.Tab:CreateButton({
    Name = "Invisius",
    Callback = function()
        if TargetTab.Variables.UseType == 1 and TargetTab.Variables.Target == 0 then
            actions.Notify("Please select a target above.")
            return
        else
            actions.Notify("Sending invisius...")
        end

        local AllOk = false
        local FinalTarget = nil

        if TargetTab.Variables.UseType == 0 then
            FinalTarget = plr
            AllOk = true
        elseif TargetTab.Variables.UseType == 1 then
            if TargetTab.Variables.Target ~= 0 then
                FinalTarget = TargetTab.Variables.Target
                AllOk = true
            end
        else
            AllOk = true
        end

        for i,v in pairs(players:GetPlayers()) do
            if AllOk then
                if TargetTab.Variables.UseType == 2 or TargetTab.Variables.UseType == 3 then
                    task.wait(0.21)
                end

                if TargetTab.Variables.UseType == 2 then
                    FinalTarget = v
                elseif TargetTab.Variables.UseType == 3 and v ~= plr then
                    FinalTarget = v
                end

                CustomSpells.Invisius(FinalTarget)

                if TargetTab.Variables.UseType == 0 or TargetTab.Variables.UseType == 1 then
                    break
                end
            end
        end
    end
})

TargetTab.Tab:CreateButton({
    Name = "Flyize",
    Callback = function()
        if TargetTab.Variables.UseType == 1 and TargetTab.Variables.Target == 0 then
            actions.Notify("Please select a target above.")
            return
        else
            actions.Notify("Sending flyize...")
        end

        local AllOk = false
        local FinalTarget = nil

        if TargetTab.Variables.UseType == 0 then
            FinalTarget = plr
            AllOk = true
        elseif TargetTab.Variables.UseType == 1 then
            if TargetTab.Variables.Target ~= 0 then
                FinalTarget = TargetTab.Variables.Target
                AllOk = true
            end
        else
            AllOk = true
        end

        for i,v in pairs(players:GetPlayers()) do
            if AllOk then
                if TargetTab.Variables.UseType == 2 or TargetTab.Variables.UseType == 3 then
                    task.wait(0.21)
                end

                if TargetTab.Variables.UseType == 2 then
                    FinalTarget = v
                elseif TargetTab.Variables.UseType == 3 and v ~= plr then
                    FinalTarget = v
                end

                CustomSpells.Flyize(FinalTarget)

                if TargetTab.Variables.UseType == 0 or TargetTab.Variables.UseType == 1 then
                    break
                end
            end
        end
    end
})

TargetTab.Tab:CreateButton({
    Name = "Helious",
    Callback = function()
        if TargetTab.Variables.UseType == 1 and TargetTab.Variables.Target == 0 then
            actions.Notify("Please select a target above.")
            return
        else
            actions.Notify("Sending helious...")
        end

        local AllOk = false
        local FinalTarget = nil

        if TargetTab.Variables.UseType == 0 then
            FinalTarget = plr
            AllOk = true
        elseif TargetTab.Variables.UseType == 1 then
            if TargetTab.Variables.Target ~= 0 then
                FinalTarget = TargetTab.Variables.Target
                AllOk = true
            end
        else
            AllOk = true
        end

        for i,v in pairs(players:GetPlayers()) do
            if AllOk then
                if TargetTab.Variables.UseType == 2 or TargetTab.Variables.UseType == 3 then
                    task.wait(0.21)
                end

                if TargetTab.Variables.UseType == 2 then
                    FinalTarget = v
                elseif TargetTab.Variables.UseType == 3 and v ~= plr then
                    FinalTarget = v
                end

                CustomSpells.Helious(FinalTarget)

                if TargetTab.Variables.UseType == 0 or TargetTab.Variables.UseType == 1 then
                    break
                end
            end
        end
    end
})

TargetTab.Tab:CreateButton({
    Name = "Aere mortemus",
    Callback = function()
        if TargetTab.Variables.UseType == 1 and TargetTab.Variables.Target == 0 then
            actions.Notify("Please select a target above.")
            return
        else
            actions.Notify("Sending aere mortemus...")
        end

        local AllOk = false
        local FinalTarget = nil

        if TargetTab.Variables.UseType == 0 then
            FinalTarget = plr
            AllOk = true
        elseif TargetTab.Variables.UseType == 1 then
            if TargetTab.Variables.Target ~= 0 then
                FinalTarget = TargetTab.Variables.Target
                AllOk = true
            end
        else
            AllOk = true
        end

        for i,v in pairs(players:GetPlayers()) do
            if AllOk then
                if TargetTab.Variables.UseType == 2 or TargetTab.Variables.UseType == 3 then
                    task.wait(0.21)
                end

                if TargetTab.Variables.UseType == 2 then
                    FinalTarget = v
                elseif TargetTab.Variables.UseType == 3 and v ~= plr then
                    FinalTarget = v
                end

                CustomSpells.AereMortemus(FinalTarget)

                if TargetTab.Variables.UseType == 0 or TargetTab.Variables.UseType == 1 then
                    break
                end
            end
        end
    end
})

TargetTab.Tab:CreateButton({
    Name = "Melgorus",
    Callback = function()
        if TargetTab.Variables.UseType == 1 and TargetTab.Variables.Target == 0 then
            actions.Notify("Please select a target above.")
            return
        else
            actions.Notify("Sending melgorus...")
        end

        local AllOk = false
        local FinalTarget = nil

        if TargetTab.Variables.UseType == 0 then
            FinalTarget = plr
            AllOk = true
        elseif TargetTab.Variables.UseType == 1 then
            if TargetTab.Variables.Target ~= 0 then
                FinalTarget = TargetTab.Variables.Target
                AllOk = true
            end
        else
            AllOk = true
        end

        for i,v in pairs(players:GetPlayers()) do
            if AllOk then
                if TargetTab.Variables.UseType == 2 or TargetTab.Variables.UseType == 3 then
                    task.wait(0.21)
                end

                if TargetTab.Variables.UseType == 2 then
                    FinalTarget = v
                elseif TargetTab.Variables.UseType == 3 and v ~= plr then
                    FinalTarget = v
                end

                CustomSpells.Melgorus(FinalTarget)

                if TargetTab.Variables.UseType == 0 or TargetTab.Variables.UseType == 1 then
                    break
                end
            end
        end
    end
})

TargetTab.Tab:CreateButton({
    Name = "Walicus",
    Callback = function()
        if TargetTab.Variables.UseType == 1 and TargetTab.Variables.Target == 0 then
            actions.Notify("Please select a target above.")
            return
        else
            actions.Notify("Sending walicus...")
        end

        local AllOk = false
        local FinalTarget = nil

        if TargetTab.Variables.UseType == 0 then
            FinalTarget = plr
            AllOk = true
        elseif TargetTab.Variables.UseType == 1 then
            if TargetTab.Variables.Target ~= 0 then
                FinalTarget = TargetTab.Variables.Target
                AllOk = true
            end
        else
            AllOk = true
        end

        for i,v in pairs(players:GetPlayers()) do
            if AllOk then
                if TargetTab.Variables.UseType == 2 or TargetTab.Variables.UseType == 3 then
                    task.wait(0.21)
                end

                if TargetTab.Variables.UseType == 2 then
                    FinalTarget = v
                elseif TargetTab.Variables.UseType == 3 and v ~= plr then
                    FinalTarget = v
                end

                CustomSpells.Walicus(FinalTarget)

                if TargetTab.Variables.UseType == 0 or TargetTab.Variables.UseType == 1 then
                    break
                end
            end
        end
    end
})

TargetTab.Tab:CreateButton({
    Name = "Torturious",
    Callback = function()
        if TargetTab.Variables.UseType == 1 and TargetTab.Variables.Target == 0 then
            actions.Notify("Please select a target above.")
            return
        else
            actions.Notify("Sending torturious...")
        end

        local AllOk = false
        local FinalTarget = nil

        if TargetTab.Variables.UseType == 0 then
            FinalTarget = plr
            AllOk = true
        elseif TargetTab.Variables.UseType == 1 then
            if TargetTab.Variables.Target ~= 0 then
                FinalTarget = TargetTab.Variables.Target
                AllOk = true
            end
        else
            AllOk = true
        end

        for i,v in pairs(players:GetPlayers()) do
            if AllOk then
                if TargetTab.Variables.UseType == 2 or TargetTab.Variables.UseType == 3 then
                    task.wait(0.21)
                end

                if TargetTab.Variables.UseType == 2 then
                    FinalTarget = v
                elseif TargetTab.Variables.UseType == 3 and v ~= plr then
                    FinalTarget = v
                end

                CustomSpells.Torturious(FinalTarget)

                if TargetTab.Variables.UseType == 0 or TargetTab.Variables.UseType == 1 then
                    break
                end
            end
        end
    end
})

--Loop Kill

TargetTab.Tab:CreateSection("Loop Kill")

TargetTab.Tab:CreateDropdown({
    Name = "Use Type",
    Options = {"Me", "Target", "List"},
    CurrentOption = "Target",
    Callback = function(option)
        TargetTab.Variables.LoopKillUseType = option[1] == "Me" and 0 or option[1] == "Target" and 1 or 2
    end
})

TargetTab.Tab:CreateDivider()

TargetTab.Variables.LoopKillListDropdown = 0

TargetTab.Tab:CreateInput({
    Name = "List",
    CurrentValue = "",
    PlaceholderText = "Name or Displayname",
    RemoveTextAfterFocusLost = true,
    Callback = function(value)
        if actions.GetPlayer(value) then
            if not table.find(TargetTab.Variables.LoopKillList, actions.GetPlayer(value).Name) then
                table.insert(TargetTab.Variables.LoopKillList, actions.GetPlayer(value).Name)
                if TargetTab.Variables.LoopKillListDropdown ~= 0 then
                    TargetTab.Variables.LoopKillListDropdown:Refresh(TargetTab.Variables.LoopKillList)
                end
                actions.Notify(actions.GetPlayer(value).Name .. " | " .. actions.GetPlayer(value).DisplayName .. " has been added in the Loop Kill List.")
            end
        end
    end
})

TargetTab.Variables.LoopKillListDropdown = TargetTab.Tab:CreateDropdown({
    Name = "Loop Kill List",
    Options = {},
    CurrentOption = "",
    Callback = function(option)
        if table.find(TargetTab.Variables.LoopKillList, option[1]) then
            table.remove(TargetTab.Variables.LoopKillList, table.find(TargetTab.Variables.LoopKillList, option[1]))
            TargetTab.Variables.LoopKillListDropdown:Refresh(TargetTab.Variables.LoopKillList)
            TargetTab.Variables.LoopKillListDropdown:Set("")
            actions.Notify("Player has been removed from Loop Kill List.")
        end
    end
})

TargetTab.Tab:CreateButton({
    Name = "Clear Loop Kill List",
    Callback = function()
        TargetTab.Variables.LoopKillList = {}
        if TargetTab.Variables.LoopKillListDropdown ~= 0 then
            TargetTab.Variables.LoopKillListDropdown:Refresh({})
            TargetTab.Variables.LoopKillListDropdown:Set("")
        end
        actions.Notify("Loop Kill List has been cleared.")
    end
})

TargetTab.Tab:CreateDivider()

TargetTab.Tab:CreateButton({
    Name = "Loop Kill",
    Callback = function()
        if TargetTab.Variables.LoopKillUseType == 1 and TargetTab.Variables.Target == 0 then
            actions.Notify("Please select a target above.")
            return
        end

        actions.LoopKill:Start()
    end
})

TargetTab.Tab:CreateButton({
    Name = "Unloop Kill",
    Callback = function()
        actions.LoopKill:Stop()
    end
})

--Loop Spell

TargetTab.Tab:CreateSection("Loop Spell")

TargetTab.Tab:CreateDropdown({
    Name = "Use Type",
    Options = {"Me", "Target", "List"},
    CurrentOption = "Target",
    Callback = function(option)
        TargetTab.Variables.LoopSpellUseType = option[1] == "Me" and 0 or option[1] == "Target" and 1 or 2
    end
})

TargetTab.Tab:CreateDivider()

TargetTab.Variables.LoopSpellListDropdown = 0

TargetTab.Tab:CreateInput({
    Name = "List",
    CurrentValue = "",
    PlaceholderText = "Name or Displayname",
    RemoveTextAfterFocusLost = true,
    Callback = function(value)
        if actions.GetPlayer(value) then
            if not table.find(TargetTab.Variables.LoopSpellList, actions.GetPlayer(value).Name) then
                table.insert(TargetTab.Variables.LoopSpellList, actions.GetPlayer(value).Name)
                if TargetTab.Variables.LoopSpellListDropdown ~= 0 then
                    TargetTab.Variables.LoopSpellListDropdown:Refresh(TargetTab.Variables.LoopSpellList)
                end
                actions.Notify(actions.GetPlayer(value).Name .. " | " .. actions.GetPlayer(value).DisplayName .. " has been added in the Loop Spell List.")
            end
        end
    end
})

TargetTab.Variables.LoopSpellListDropdown = TargetTab.Tab:CreateDropdown({
    Name = "Loop Spell List",
    Options = {},
    CurrentOption = "",
    Callback = function(option)
        if table.find(TargetTab.Variables.LoopSpellList, option[1]) then
            table.remove(TargetTab.Variables.LoopSpellList, table.find(TargetTab.Variables.LoopSpellList, option[1]))
            TargetTab.Variables.LoopSpellListDropdown:Refresh(TargetTab.Variables.LoopKillList)
            TargetTab.Variables.LoopSpellListDropdown:Set("")
            actions.Notify("Player has been removed from Loop Spell List.")
        end
    end
})

TargetTab.Tab:CreateButton({
    Name = "Clear Loop Spell List",
    Callback = function()
        TargetTab.Variables.LoopSpellList = {}
        if TargetTab.Variables.LoopSpellListDropdown ~= 0 then
            TargetTab.Variables.LoopSpellListDropdown:Refresh({})
            TargetTab.Variables.LoopSpellListDropdown:Set("")
        end
        actions.Notify("Loop Spell List has been cleared.")
    end
})

TargetTab.Tab:CreateDivider()

TargetTab.Tab:CreateSlider({
    Name = "Delay",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "Seconds",
    CurrentValue = TargetTab.Variables.LoopSpellDelay,
    Callback = function(value)
        TargetTab.Variables.LoopSpellDelay = value
    end
})

TargetTab.Tab:CreateButton({
    Name = "Loop Spell",
    Callback = function()
        if TargetTab.Variables.Spell == "" then
            actions.Notify("Please choose the spell above.")
            return
        elseif TargetTab.Variables.LoopSpellUseType == 1 and TargetTab.Variables.Target == 0 then
            actions.Notify("Please select a target above.")
            return
        end

        actions.LoopSpell:Start()
    end
})

TargetTab.Tab:CreateButton({
    Name = "Unloop Spell",
    Callback = function()
        actions.LoopSpell:Stop()
    end
})

--! Wand Mods Tab

WandModsTab.Variables.SilentAim = {}
WandModsTab.Variables.SilentAim.Bool = false
WandModsTab.Variables.SilentAim.Animation = false
WandModsTab.Variables.SilentAim.IncludeLocalPlayer = false

WandModsTab.Variables.FullSilentAim = {}
WandModsTab.Variables.FullSilentAim.Bool = false
WandModsTab.Variables.FullSilentAim.Animation = false
WandModsTab.Variables.FullSilentAim.Delay = 0.1
WandModsTab.Variables.FullSilentAim.Hold = false

WandModsTab.Variables.FullAuto = {}
WandModsTab.Variables.FullAuto.Bool = false
WandModsTab.Variables.FullAuto.Animation = false
WandModsTab.Variables.FullAuto.Delay = 0.1
WandModsTab.Variables.FullAuto.Hold = false
WandModsTab.Variables.FullAuto.FireEffects = false
WandModsTab.Variables.FullAuto.Wandless = false
WandModsTab.Variables.FullAuto.ElderWandSpells = false
WandModsTab.Variables.FullAuto.Target = 0

WandModsTab.Variables.ElderWandSpells = false

WandModsTab.Tab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Callback = function(bool)
        WandModsTab.Variables.SilentAim.Bool = bool
    end
})

WandModsTab.Tab:CreateToggle({
    Name = "Include Animation(Wand required)",
    CurrentValue = false,
    Callback = function(bool)
        WandModsTab.Variables.SilentAim.Animation = bool
    end
})

WandModsTab.Tab:CreateToggle({
    Name = "Include Local Player",
    CurrentValue = false,
    Callback = function(bool)
        WandModsTab.Variables.SilentAim.IncludeLocalPlayer = bool
    end
})

Mouse.Button1Down:Connect(function()
    if WandModsTab.Variables.SilentAim.Bool then
        local closestPlayer = actions.getClosestPlayerToMouse(WandModsTab.Variables.SilentAim.IncludeLocalPlayer)
        if closestPlayer then
            if CurrentSpell ~= "" and CurrentSpell ~= "nox" and CurrentSpell ~= "lumos" and CurrentSpell ~= "appa" and CurrentSpell ~= "ascendio" and not table.find(Spells["Elder Wand Spells"], CurrentSpell) and not table.find(CustomSpells.Spells, CurrentSpell) and CurrentSpell ~= "protego" and CurrentSpell ~= "protego totalum" and CurrentSpell ~= "morsmordre" then
                if WandModsTab.Variables.SilentAim.Animation and actions.GetWand(true) then
                    actions.setAttackAnim("0.2, 1, 3")
                end
                actions.SendSpell(closestPlayer, CurrentSpell)
            end
        end
    end
end)

--Full Silent Aim

WandModsTab.Tab:CreateSection("Full Silent Aim")

WandModsTab.Tab:CreateToggle({
    Name = "Full Silent Aim",
    CurrentValue = false,
    Callback = function(bool)
        WandModsTab.Variables.FullSilentAim.Bool = bool
    end
})

WandModsTab.Tab:CreateToggle({
    Name = "Include Animation(Wand required)",
    CurrentValue = false,
    Callback = function(bool)
        WandModsTab.Variables.FullSilentAim.Animation = bool
    end
})

WandModsTab.Tab:CreateSlider({
    Name = "Delay",
    Range = {0, 2},
    Increment = 0.1,
    Suffix = "Seconds",
    CurrentValue = WandModsTab.Variables.FullSilentAim.Delay,
    Callback = function(value)
        WandModsTab.Variables.FullSilentAim.Delay = value
    end
})

UIS.InputBegan:Connect(function(input, chatting)
    if chatting == false and input.UserInputType == Enum.UserInputType.MouseButton1 then
        WandModsTab.Variables.FullSilentAim.Hold = true
    end
end)

UIS.InputEnded:Connect(function(input, chatting)
    if chatting == false and input.UserInputType == Enum.UserInputType.MouseButton1 then
        WandModsTab.Variables.FullSilentAim.Hold = false
    end
end)

coroutine.resume(coroutine.create(function()
    while task.wait(WandModsTab.Variables.FullSilentAim.Delay) do
        if WandModsTab.Variables.FullSilentAim.Hold and WandModsTab.Variables.FullSilentAim.Bool and CurrentSpell ~= "" and CurrentSpell ~= "nox" and CurrentSpell ~= "lumos" and CurrentSpell ~= "appa" and CurrentSpell ~= "ascendio" and not table.find(Spells["Elder Wand Spells"], CurrentSpell) and not table.find(CustomSpells.Spells, CurrentSpell) and CurrentSpell ~= "protego" and CurrentSpell ~= "protego totalum" and CurrentSpell ~= "morsmordre" then
            local closestPlayer = actions.getClosestPlayerToMouse(WandModsTab.Variables.SilentAim.IncludeLocalPlayer)
            if closestPlayer then
                if WandModsTab.Variables.FullSilentAim.Animation then
                    actions.setAttackAnim(WandModsTab.Variables.FullSilentAim.Delay .. ", 1, 3")
                end
                actions.SendSpell(closestPlayer, CurrentSpell)
            end
        end
    end
end))

--Full Auto

WandModsTab.Tab:CreateSection("Full Auto")

WandModsTab.Tab:CreateToggle({
    Name = "Full Auto",
    CurrentValue = false,
    Callback = function(bool)
        WandModsTab.Variables.FullAuto.Bool = bool
    end
})

WandModsTab.Tab:CreateToggle({
    Name = "Include Animation",
    CurrentValue = false,
    Callback = function(bool)
        WandModsTab.Variables.FullAuto.Animation = bool
    end
})

WandModsTab.Tab:CreateToggle({
    Name = "Include Fire Effects",
    CurrentValue = false,
    Callback = function(bool)
        WandModsTab.Variables.FullAuto.FireEffects = bool
    end
})

WandModsTab.Tab:CreateSlider({
    Name = "Delay",
    Range = {0, 2},
    Increment = 0.1,
    Suffix = "Seconds",
    CurrentValue = WandModsTab.Variables.FullAuto.Delay,
    Callback = function(value)
        WandModsTab.Variables.FullAuto.Delay = value
    end
})

WandModsTab.Tab:CreateToggle({
    Name = "Wandless Cast",
    CurrentValue = false,
    Callback = function(bool)
        WandModsTab.Variables.FullAuto.Wandless = bool
    end
})

WandModsTab.Tab:CreateToggle({
    Name = "Elder Wand Spells",
    CurrentValue = false,
    Callback = function(bool)
        WandModsTab.Variables.FullAuto.ElderWandSpells = bool
    end
})

UIS.InputBegan:Connect(function(input, chatting)
    if chatting == false and input.UserInputType == Enum.UserInputType.MouseButton1 then
        WandModsTab.Variables.FullAuto.Hold = true
    end
end)

UIS.InputEnded:Connect(function(input, chatting)
    if chatting == false and input.UserInputType == Enum.UserInputType.MouseButton1 then
        WandModsTab.Variables.FullAuto.Hold = false
    end
end)

coroutine.resume(coroutine.create(function()
    while task.wait(WandModsTab.Variables.FullAuto.Delay) do
        if WandModsTab.Variables.FullAuto.Bool and WandModsTab.Variables.FullAuto.Hold and CurrentSpell ~= "" then
            WandModsTab.Variables.FullAuto.Target = actions.getMouseTarget()

            if (WandModsTab.Variables.FullAuto.Wandless == false and actions.GetWand(true)) or WandModsTab.Variables.FullAuto.Wandless then
                if CurrentSpell ~= "lumos" and CurrentSpell ~= "nox" and not table.find(Spells["Elder Wand Spells"], CurrentSpell) and CurrentSpell ~= "appa" and CurrentSpell ~= "ascendio" and CurrentSpell ~= "morsmordre" and CurrentSpell ~= "protego" and CurrentSpell ~= "protego totalum" then
                    if WandModsTab.Variables.FullAuto.Animation then
                        actions.setAttackAnim(WandModsTab.Variables.FullAuto.Delay .. ", 1, 3")
                    end

                    if WandModsTab.Variables.FullAuto.FireEffects then
                        local shootFrom
                        local shootFromPosition

                        if WandModsTab.Variables.FullAuto.Wandless and char:FindFirstChild("RightHand") then
                            shootFrom = char.RightHand
                        elseif WandModsTab.Variables.FullAuto.Wandless == false and actions.GetWand(true) then
                            shootFrom = actions.GetWand(true)
                        end

                        if shootFrom then
                            if shootFrom.Name == "RightHand" then shootFromPosition = shootFrom.Position else shootFromPosition = shootFrom.Handle.Position + Vector3.new(0, 1, 0) end
                        end

                        if shootFrom then actions.spellFireEffect(shootFromPosition,  Mouse.Hit.Position, CurrentSpell, shootFrom) end
                    end
                elseif table.find(Spells["Elder Wand Spells"], CurrentSpell) and WandModsTab.Variables.FullAuto.ElderWandSpells and WandModsTab.Variables.FullAuto.Wandless == false then
                    actions.UniqueSpell(CurrentSpell)
                elseif CurrentSpell == "appa" then
                    actions.UniqueSpell(CurrentSpell)
                elseif CurrentSpell == "ascendio" and WandModsTab.Variables.FullAuto.Wandless == false then
                    actions.UniqueSpell(CurrentSpell)
                end
            end
        end
    end
end))

--Elder Wand Spells

WandModsTab.Tab:CreateSection("Elder Wand Spells")

WandModsTab.Tab:CreateToggle({
    Name = "Elder Wand Spells",
    CurrentValue = false,
    Callback = function(bool)
        WandModsTab.Variables.ElderWandSpells = bool
    end
})

Mouse.Button1Down:Connect(function()
    if table.find(Spells["Elder Wand Spells"], CurrentSpell) and WandModsTab.Variables.ElderWandSpells then
        actions.UniqueSpell(CurrentSpell)
    end
end)

--! Macrosing Tab

MacrosingTab.Variables.Macrosing = false
MacrosingTab.Variables.ChatSpell = ""
MacrosingTab.Variables.CustomSpells = false
MacrosingTab.Variables.OneCustomSpell = false
MacrosingTab.Variables.CustomSpellsSilentAim = false
MacrosingTab.Variables.CustomSpellsSilentAimIncludeLocalPlayer = false
MacrosingTab.Variables.WandlessCustomSpells = false

MacrosingTab.Variables.LastCustomSpell = ""

MacrosingTab.Variables.MeteorusHold = false

MacrosingTab.Variables.SoulDecimatus = true
MacrosingTab.Variables.AereMortemus = true

MacrosingTab.Tab:CreateToggle({
    Name = "Macrosing",
    CurrentValue = false,
    Callback = function(bool)
        MacrosingTab.Variables.Macrosing = bool
    end
})

MacrosingTab.Tab:CreateToggle({
    Name = "Hide Spells",
    CurrentValue = true,
    Callback = function(bool)
        MacrosingTab.Variables.ChatSpell = bool and "/c system" or "All"
    end
})

--Custom Spells Preferences

MacrosingTab.Tab:CreateSection("Custom Spells Preferences")

MacrosingTab.Tab:CreateToggle({
    Name = "Use Custom Spells",
    CurrentValue = false,
    Callback = function(bool)
        MacrosingTab.Variables.CustomSpells = bool
    end
})

MacrosingTab.Tab:CreateToggle({
    Name = "One Custom Spell",
    CurrentValue = false,
    Callback = function(bool)
        MacrosingTab.Variables.OneCustomSpell = bool
    end
})

MacrosingTab.Tab:CreateDivider()

MacrosingTab.Tab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Callback = function(bool)
        MacrosingTab.Variables.CustomSpellsSilentAim = bool
    end
})

MacrosingTab.Tab:CreateToggle({
    Name = "Include Local Player",
    CurrentValue = false,
    Callback = function(bool)
        MacrosingTab.Variables.CustomSpellsSilentAimIncludeLocalPlayer = bool
    end
})

MacrosingTab.Tab:CreateToggle({
    Name = "Wandless Custom Spell",
    CurrentValue = false,
    Callback = function(bool)
        MacrosingTab.Variables.WandlessCustomSpells = bool
    end
})

MacrosingTab.Tab:CreateParagraph({Title = "Wandless Custom Spell", Content = "Can't use meteorus, soul decimatus."})

--@ Custom Spells

MacrosingTab.Tab:CreateSection("Custom Spells")
for i = 1, #CustomSpells.Spells do
    local InLoopSpell = CustomSpells.Spells

    MacrosingTab.Tab:CreateKeybind({
        Name = InLoopSpell[i]:sub(1,1):upper() .. InLoopSpell[i]:sub(2),
        CurrentKeybind = settings[InLoopSpell[i]],
        HoldToInteract = false,
        CallOnChange = true,
        Callback = function(newKey)
            if newKey then
                settings[InLoopSpell[i]] = newKey
                saveSettings()
            end
        end
    })

    UIS.InputBegan:Connect(function(input, chatting)
        if chatting == false and input.KeyCode == Enum.KeyCode[settings[InLoopSpell[i]]] then
            if MacrosingTab.Variables.Macrosing then
                players:Chat(InLoopSpell[i])
                RServ.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(InLoopSpell[i], MacrosingTab.Variables.ChatSpell)
            end
        end
    end)
end

UIS.InputBegan:Connect(function(input, chatting)
    if chatting == false and input.UserInputType == Enum.UserInputType.MouseButton1 then
        MacrosingTab.Variables.MeteorusHold = true
    end
end)

UIS.InputEnded:Connect(function(input, chatting)
    if chatting == false and input.UserInputType == Enum.UserInputType.MouseButton1 then
        MacrosingTab.Variables.MeteorusHold = false
        if MacrosingTab.Variables.OneCustomSpell then
            MacrosingTab.Variables.LastCustomSpell = MacrosingTab.Variables.LastCustomSpell == "meteorus" and "" or MacrosingTab.Variables.LastCustomSpell
        end
    end
end)

--Meteorus

coroutine.resume(coroutine.create(function()
    while task.wait(0.05) do
		if MacrosingTab.Variables.CustomSpells and MacrosingTab.Variables.LastCustomSpell == "meteorus" and MacrosingTab.Variables.MeteorusHold and actions.GetWand(true) then
            local finalPosition = Mouse.Hit * Vector3.new(math.random(-10, 15), 5, math.random(-10, 10))

            if RootPart and (finalPosition - RootPart.Position).Magnitude < 76 then
                actions.spellFireEffect(finalPosition + Vector3.new(math.random(-10, 10), 50, math.random(-10, 10)), finalPosition, "confringo", actions.GetWand(true))
            end
		end
	end
end))

--Soul decimatus

Mouse.Button1Down:Connect(function()
    if MacrosingTab.Variables.CustomSpells and MacrosingTab.Variables.LastCustomSpell == "soul decimatus" and actions.GetWand(true) and MacrosingTab.Variables.SoulDecimatus then
        local Target = MacrosingTab.Variables.CustomSpellsSilentAim and actions.getClosestPlayerToMouse(false) or actions.getMouseTarget()

        if Target ~= 0 and Target ~= nil then
            MacrosingTab.Variables.SoulDecimatus = false
            actions.SendSpell(Target, "alarte ascendare")

            task.wait(0.8)
            for i = 1,8 do
                actions.SendSpell(Target, "duro")
                task.wait()
            end
            task.wait(0.8)
            for i = 1,20 do
                if char and char:FindFirstChild("RightHand") and char:FindFirstChild("LeftHand") and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
                    actions.spellFireEffect(plr.Character.LeftHand.Position, Target.Character.HumanoidRootPart.Position, "sectumsempra", actions.GetWand(true))
                    actions.spellFireEffect(plr.Character.RightHand.Position, Target.Character.HumanoidRootPart.Position, "sectumsempra", actions.GetWand(true))
                    task.wait(0.05)
                end
            end
            task.wait(0.5)

            MacrosingTab.Variables.SoulDecimatus = true
            if MacrosingTab.Variables.OneCustomSpell then
                MacrosingTab.Variables.LastCustomSpell = ""
            end
        end
    end
end)

--Aere mortemus

Mouse.Button1Down:Connect(function()
    if MacrosingTab.Variables.WandlessCustomSpells == false and actions.GetWand(true) == nil then return end

    if MacrosingTab.Variables.CustomSpells and MacrosingTab.Variables.LastCustomSpell == "aere mortemus" and MacrosingTab.Variables.AereMortemus then
        local Target = MacrosingTab.Variables.CustomSpellsSilentAim and actions.getClosestPlayerToMouse(MacrosingTab.Variables.CustomSpellsSilentAimIncludeLocalPlayer) or actions.getMouseTarget()

        if Target ~= 0 and Target ~= nil then
            MacrosingTab.Variables.AereMortemus = false

            CustomSpells.AereMortemus(Target)

            MacrosingTab.Variables.AereMortemus = true
            if MacrosingTab.Variables.OneCustomSpell then
                MacrosingTab.Variables.LastCustomSpell = ""
            end
        end
    end
end)

--Melgorus

Mouse.Button1Down:Connect(function()
    if MacrosingTab.Variables.WandlessCustomSpells == false and actions.GetWand(true) == nil then return end

    if MacrosingTab.Variables.CustomSpells and MacrosingTab.Variables.LastCustomSpell == "melgorus" then
        local Target = MacrosingTab.Variables.CustomSpellsSilentAim and actions.getClosestPlayerToMouse(MacrosingTab.Variables.CustomSpellsSilentAimIncludeLocalPlayer) or actions.getMouseTarget()

        if Target ~= 0 and Target ~= nil then
            CustomSpells.Melgorus(Target)
            
            if MacrosingTab.Variables.OneCustomSpell then
                MacrosingTab.Variables.LastCustomSpell = ""
            end
        end
    end
end)

--Walicus

Mouse.Button1Down:Connect(function()
    if MacrosingTab.Variables.WandlessCustomSpells == false and actions.GetWand(true) == nil then return end

    if MacrosingTab.Variables.CustomSpells and MacrosingTab.Variables.LastCustomSpell == "walicus" then
        local Target = MacrosingTab.Variables.CustomSpellsSilentAim and actions.getClosestPlayerToMouse(MacrosingTab.Variables.CustomSpellsSilentAimIncludeLocalPlayer) or actions.getMouseTarget()

        if Target ~= 0 and Target ~= nil then
            CustomSpells.Walicus(Target)
            
            if MacrosingTab.Variables.OneCustomSpell then
                MacrosingTab.Variables.LastCustomSpell = ""
            end
        end
    end
end)

--Torturious

Mouse.Button1Down:Connect(function()
    if MacrosingTab.Variables.WandlessCustomSpells == false and actions.GetWand(true) == nil then return end

    if MacrosingTab.Variables.CustomSpells and MacrosingTab.Variables.LastCustomSpell == "torturious" then
        local Target = MacrosingTab.Variables.CustomSpellsSilentAim and actions.getClosestPlayerToMouse(MacrosingTab.Variables.CustomSpellsSilentAimIncludeLocalPlayer) or actions.getMouseTarget()

        if Target ~= 0 and Target ~= nil then
            CustomSpells.Torturious(Target)
            
            if MacrosingTab.Variables.OneCustomSpell then
                MacrosingTab.Variables.LastCustomSpell = ""
            end
        end
    end
end)

--Fixius

Mouse.Button1Down:Connect(function()
    if MacrosingTab.Variables.WandlessCustomSpells == false and actions.GetWand(true) == nil then return end

    if MacrosingTab.Variables.CustomSpells and MacrosingTab.Variables.LastCustomSpell == "fixius" then
        local Target = MacrosingTab.Variables.CustomSpellsSilentAim and actions.getClosestPlayerToMouse(MacrosingTab.Variables.CustomSpellsSilentAimIncludeLocalPlayer) or actions.getMouseTarget()

        if Target ~= 0 and Target ~= nil then
            CustomSpells.Fixius(Target)
            
            if MacrosingTab.Variables.OneCustomSpell then
                MacrosingTab.Variables.LastCustomSpell = ""
            end
        end
    end
end)

--Nuggetize

Mouse.Button1Down:Connect(function()
    if MacrosingTab.Variables.WandlessCustomSpells == false and actions.GetWand(true) == nil then return end

    if MacrosingTab.Variables.CustomSpells and MacrosingTab.Variables.LastCustomSpell == "nuggetize" then
        local Target = MacrosingTab.Variables.CustomSpellsSilentAim and actions.getClosestPlayerToMouse(MacrosingTab.Variables.CustomSpellsSilentAimIncludeLocalPlayer) or actions.getMouseTarget()

        if Target ~= 0 and Target ~= nil then
            CustomSpells.Nuggetize(Target)
            
            if MacrosingTab.Variables.OneCustomSpell then
                MacrosingTab.Variables.LastCustomSpell = ""
            end
        end
    end
end)

--Invisius

Mouse.Button1Down:Connect(function()
    if MacrosingTab.Variables.WandlessCustomSpells == false and actions.GetWand(true) == nil then return end

    if MacrosingTab.Variables.CustomSpells and MacrosingTab.Variables.LastCustomSpell == "invisius" then
        local Target = MacrosingTab.Variables.CustomSpellsSilentAim and actions.getClosestPlayerToMouse(MacrosingTab.Variables.CustomSpellsSilentAimIncludeLocalPlayer) or actions.getMouseTarget()

        if Target ~= 0 and Target ~= nil then
            CustomSpells.Invisius(Target)
            
            if MacrosingTab.Variables.OneCustomSpell then
                MacrosingTab.Variables.LastCustomSpell = ""
            end
        end
    end
end)

--Flyize

Mouse.Button1Down:Connect(function()
    if MacrosingTab.Variables.WandlessCustomSpells == false and actions.GetWand(true) == nil then return end

    if MacrosingTab.Variables.CustomSpells and MacrosingTab.Variables.LastCustomSpell == "flyize" then
        local Target = MacrosingTab.Variables.CustomSpellsSilentAim and actions.getClosestPlayerToMouse(MacrosingTab.Variables.CustomSpellsSilentAimIncludeLocalPlayer) or actions.getMouseTarget()

        if Target ~= 0 and Target ~= nil then
            CustomSpells.Flyize(Target)
            
            if MacrosingTab.Variables.OneCustomSpell then
                MacrosingTab.Variables.LastCustomSpell = ""
            end
        end
    end
end)

--Helious

Mouse.Button1Down:Connect(function()
    if MacrosingTab.Variables.WandlessCustomSpells == false and actions.GetWand(true) == nil then return end

    if MacrosingTab.Variables.CustomSpells and MacrosingTab.Variables.LastCustomSpell == "helious" then
        local Target = MacrosingTab.Variables.CustomSpellsSilentAim and actions.getClosestPlayerToMouse(MacrosingTab.Variables.CustomSpellsSilentAimIncludeLocalPlayer) or actions.getMouseTarget()

        if Target ~= 0 and Target ~= nil then
            CustomSpells.Helious(Target)
            
            if MacrosingTab.Variables.OneCustomSpell then
                MacrosingTab.Variables.LastCustomSpell = ""
            end
        end
    end
end)

--Bringius

Mouse.Button1Down:Connect(function()
    if MacrosingTab.Variables.WandlessCustomSpells == false and actions.GetWand(true) == nil then return end

    if MacrosingTab.Variables.CustomSpells and MacrosingTab.Variables.LastCustomSpell == "bringius" then
        local Target = MacrosingTab.Variables.CustomSpellsSilentAim and actions.getClosestPlayerToMouse(false) or actions.getMouseTarget()

        if Target ~= 0 and Target ~= nil then
            if actions.Bring.Bool then
                actions.Bring:Stop()
                if MacrosingTab.Variables.OneCustomSpell then
                    MacrosingTab.Variables.LastCustomSpell = ""
                end
            else
                actions.Bring.Target = Target
                actions.Bring:Start()
            end
        end
    end
end)

--Serious series, 100 punches!

Mouse.Button1Down:Connect(function()
    if actions.GetWand(true) == nil then return end

    if MacrosingTab.Variables.CustomSpells and MacrosingTab.Variables.LastCustomSpell == "serious series, 100 punches!" then
        local Target = MacrosingTab.Variables.CustomSpellsSilentAim and actions.getClosestPlayerToMouse(false) or actions.getMouseTarget()

        if Target ~= 0 and Target ~= nil then
            actions.SendSpell(Target, "glacius")

            task.wait(0.1)

            for i = 1,100 do
                if not Target.Character or not Target.Character:FindFirstChild("HumanoidRootPart") then return end
                
                IServ.Events.uniqueSpell:FireServer({
                    ["distance"] = actions.CalculateDistance("uniqueSpell"),
                    ["mousePos"] = Target.Character.HumanoidRootPart.Position + Vector3.new(math.random(4, 8), 0, math.random(4, 8)),
                    ["spellName"] = "appa"
                })
                actions.spellFireEffect(actions.GetWand(true).Handle.Tip.WorldPosition, Target.Character.HumanoidRootPart.Position, "flare", actions.GetWand(true))
                task.wait(0.05)
            end
            
            if MacrosingTab.Variables.OneCustomSpell then
                MacrosingTab.Variables.LastCustomSpell = ""
            end
        end
    end
end)

MacrosingTab.Tab:CreateParagraph({Title = "Serious series, 100 punches!", Content = "Wand required!"})

--@ Kill Spells

MacrosingTab.Tab:CreateSection("Kill Spells")
for i = 1, #Spells["Kill Spells"] do
    local InLoopSpell = Spells["Kill Spells"]

    MacrosingTab.Tab:CreateKeybind({
        Name = InLoopSpell[i]:sub(1,1):upper() .. InLoopSpell[i]:sub(2),
        CurrentKeybind = settings[InLoopSpell[i]],
        HoldToInteract = false,
        CallOnChange = true,
        Callback = function(newKey)
            if newKey then
                settings[InLoopSpell[i]] = newKey
                saveSettings()
            end
        end
    })

    UIS.InputBegan:Connect(function(input, chatting)
        if chatting == false and input.KeyCode == Enum.KeyCode[settings[InLoopSpell[i]]] then
            if MacrosingTab.Variables.Macrosing then
                players:Chat(InLoopSpell[i])
                RServ.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(InLoopSpell[i], MacrosingTab.Variables.ChatSpell)
            end
        end
    end)
end

--@ Damage Spells

MacrosingTab.Tab:CreateSection("Damage Spells")
for i = 1, #Spells["Damage Spells"] do
    local InLoopSpell = Spells["Damage Spells"]

    MacrosingTab.Tab:CreateKeybind({
        Name = InLoopSpell[i]:sub(1,1):upper() .. InLoopSpell[i]:sub(2),
        CurrentKeybind = settings[InLoopSpell[i]],
        HoldToInteract = false,
        CallOnChange = true,
        Callback = function(newKey)
            if newKey then
                settings[InLoopSpell[i]] = newKey
                saveSettings()
            end
        end
    })

    UIS.InputBegan:Connect(function(input, chatting)
        if chatting == false and input.KeyCode == Enum.KeyCode[settings[InLoopSpell[i]]] then
            if MacrosingTab.Variables.Macrosing then
                players:Chat(InLoopSpell[i])
                RServ.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(InLoopSpell[i], MacrosingTab.Variables.ChatSpell)
            end
        end
    end)
end

--@ Explosive Spells

MacrosingTab.Tab:CreateSection("Explosive Spells")
for i = 1, #Spells["Explosive Spells"] do
    local InLoopSpell = Spells["Explosive Spells"]

    MacrosingTab.Tab:CreateKeybind({
        Name = InLoopSpell[i]:sub(1,1):upper() .. InLoopSpell[i]:sub(2),
        CurrentKeybind = settings[InLoopSpell[i]],
        HoldToInteract = false,
        CallOnChange = true,
        Callback = function(newKey)
            if newKey then
                settings[InLoopSpell[i]] = newKey
                saveSettings()
            end
        end
    })

    UIS.InputBegan:Connect(function(input, chatting)
        if chatting == false and input.KeyCode == Enum.KeyCode[settings[InLoopSpell[i]]] then
            if MacrosingTab.Variables.Macrosing then
                players:Chat(InLoopSpell[i])
                RServ.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(InLoopSpell[i], MacrosingTab.Variables.ChatSpell)
            end
        end
    end)
end

--@ Revive Spells

MacrosingTab.Tab:CreateSection("Revive Spells")
for i = 1, #Spells["Revive Spells"] do
    local InLoopSpell = Spells["Revive Spells"]

    MacrosingTab.Tab:CreateKeybind({
        Name = InLoopSpell[i]:sub(1,1):upper() .. InLoopSpell[i]:sub(2),
        CurrentKeybind = settings[InLoopSpell[i]],
        HoldToInteract = false,
        CallOnChange = true,
        Callback = function(newKey)
            if newKey then
                settings[InLoopSpell[i]] = newKey
                saveSettings()
            end
        end
    })

    UIS.InputBegan:Connect(function(input, chatting)
        if chatting == false and input.KeyCode == Enum.KeyCode[settings[InLoopSpell[i]]] then
            if MacrosingTab.Variables.Macrosing then
                players:Chat(InLoopSpell[i])
                RServ.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(InLoopSpell[i], MacrosingTab.Variables.ChatSpell)
            end
        end
    end)
end

--@ Unique Spells

MacrosingTab.Tab:CreateSection("Unique Spells")
for i = 1, #Spells["Unique Spells"] do
    local InLoopSpell = Spells["Unique Spells"]

    MacrosingTab.Tab:CreateKeybind({
        Name = InLoopSpell[i]:sub(1,1):upper() .. InLoopSpell[i]:sub(2),
        CurrentKeybind = settings[InLoopSpell[i]],
        HoldToInteract = false,
        CallOnChange = true,
        Callback = function(newKey)
            if newKey then
                settings[InLoopSpell[i]] = newKey
                saveSettings()
            end
        end
    })

    UIS.InputBegan:Connect(function(input, chatting)
        if chatting == false and input.KeyCode == Enum.KeyCode[settings[InLoopSpell[i]]] then
            if MacrosingTab.Variables.Macrosing then
                players:Chat(InLoopSpell[i])
                RServ.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(InLoopSpell[i], MacrosingTab.Variables.ChatSpell)
            end
        end
    end)
end

--@ Immobilizing Spells

MacrosingTab.Tab:CreateSection("Immobilizing Spells")
for i = 1, #Spells["Immobilizing Spells"] do
    local InLoopSpell = Spells["Immobilizing Spells"]

    MacrosingTab.Tab:CreateKeybind({
        Name = InLoopSpell[i]:sub(1,1):upper() .. InLoopSpell[i]:sub(2),
        CurrentKeybind = settings[InLoopSpell[i]],
        HoldToInteract = false,
        CallOnChange = true,
        Callback = function(newKey)
            if newKey then
                settings[InLoopSpell[i]] = newKey
                saveSettings()
            end
        end
    })

    UIS.InputBegan:Connect(function(input, chatting)
        if chatting == false and input.KeyCode == Enum.KeyCode[settings[InLoopSpell[i]]] then
            if MacrosingTab.Variables.Macrosing then
                players:Chat(InLoopSpell[i])
                RServ.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(InLoopSpell[i], MacrosingTab.Variables.ChatSpell)
            end
        end
    end)
end

--@ Fling Spells

MacrosingTab.Tab:CreateSection("Fling Spells")
for i = 1, #Spells["Fling Spells"] do
    local InLoopSpell = Spells["Fling Spells"]

    MacrosingTab.Tab:CreateKeybind({
        Name = InLoopSpell[i]:sub(1,1):upper() .. InLoopSpell[i]:sub(2),
        CurrentKeybind = settings[InLoopSpell[i]],
        HoldToInteract = false,
        CallOnChange = true,
        Callback = function(newKey)
            if newKey then
                settings[InLoopSpell[i]] = newKey
                saveSettings()
            end
        end
    })

    UIS.InputBegan:Connect(function(input, chatting)
        if chatting == false and input.KeyCode == Enum.KeyCode[settings[InLoopSpell[i]]] then
            if MacrosingTab.Variables.Macrosing then
                players:Chat(InLoopSpell[i])
                RServ.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(InLoopSpell[i], MacrosingTab.Variables.ChatSpell)
            end
        end
    end)
end

--@ Misc Spells

MacrosingTab.Tab:CreateSection("Misc Spells")
for i = 1, #Spells["Misc Spells"] do
    local InLoopSpell = Spells["Misc Spells"]

    MacrosingTab.Tab:CreateKeybind({
        Name = InLoopSpell[i]:sub(1,1):upper() .. InLoopSpell[i]:sub(2),
        CurrentKeybind = settings[InLoopSpell[i]],
        HoldToInteract = false,
        CallOnChange = true,
        Callback = function(newKey)
            if newKey then
                settings[InLoopSpell[i]] = newKey
                saveSettings()
            end
        end
    })

    UIS.InputBegan:Connect(function(input, chatting)
        if chatting == false and input.KeyCode == Enum.KeyCode[settings[InLoopSpell[i]]] then
            if MacrosingTab.Variables.Macrosing then
                players:Chat(InLoopSpell[i])
                RServ.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(InLoopSpell[i], MacrosingTab.Variables.ChatSpell)
            end
        end
    end)
end

--@ Elder Wand Spells

MacrosingTab.Tab:CreateSection("Elder Wand Spells")
for i = 1, #Spells["Elder Wand Spells"] do
    local InLoopSpell = Spells["Elder Wand Spells"]

    MacrosingTab.Tab:CreateKeybind({
        Name = InLoopSpell[i]:sub(1,1):upper() .. InLoopSpell[i]:sub(2),
        CurrentKeybind = settings[InLoopSpell[i]],
        HoldToInteract = false,
        CallOnChange = true,
        Callback = function(newKey)
            if newKey then
                settings[InLoopSpell[i]] = newKey
                saveSettings()
            end
        end
    })

    UIS.InputBegan:Connect(function(input, chatting)
        if chatting == false and input.KeyCode == Enum.KeyCode[settings[InLoopSpell[i]]] then
            if MacrosingTab.Variables.Macrosing then
                players:Chat(InLoopSpell[i])
                RServ.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(InLoopSpell[i], MacrosingTab.Variables.ChatSpell)
            end
        end
    end)
end

--! Scripts Tab

ScriptsTab.Tab:CreateButton({
    Name = "Sirius",
    Callback = function()
        loadstring(game:HttpGet("https://sirius.menu/sirius"))()
    end
})

ScriptsTab.Tab:CreateButton({
    Name = "IY(Infinite Yield)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source"))()
    end
})

ScriptsTab.Tab:CreateButton({
    Name = "Dex(Explorer)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ooolkol/Dex/refs/heads/main/main"))()
    end
})

ScriptsTab.Tab:CreateButton({
    Name = "Jerk Off Tool R15",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ooolkol/Jerk-Off-Tool-R15/refs/heads/main/main"))()
    end
})

--! Settings Tab

SettingsTab.Tab:CreateDropdown({
    Name = "Theme",
    Options = {"Default", "AmberGlow", "Amethyst", "Bloom", "DarkBlue", "Green", "Light", "Ocean", "Serenity"},
    CurrentOption = settings["CurrentTheme"],
    Callback = function(option)
        Window.ModifyTheme(option[1])
        settings["CurrentTheme"] = option[1]
        saveSettings()
    end
})

--Notifications

SettingsTab.Tab:CreateSection("Notifications")

SettingsTab.Tab:CreateSlider({
    Name = "Duration",
    Range = {1, 10},
    Increment = 0.5,
    Suffix = "Seconds",
    CurrentValue = settings["NotificationsDuration"],
    Callback = function(value)
        settings["NotificationsDuration"] = value
        saveSettings()
    end
})

--! Players Methods

players.PlayerAdded:Connect(function(addedPlayer)
    --@ Toggles Tab
    --Auto Kick
    if table.find(TogglesTab.Variables.AutoKick.List, addedPlayer.UserId) then
        if TogglesTab.Variables.AutoKick.Bool then
            plr:Kick("ooolkol scripts: Admin joined.")
        else
            actions.Notify("Admin joined.")
        end
    end
end)

players.PlayerRemoving:Connect(function(removedPlayer)
    --@ Main Tab
    --Wand Glow
    if MainTab.Variables.PlayersWandGlow.Target ~= 0 and removedPlayer.UserId == MainTab.Variables.PlayersWandGlow.Target.UserId then
        MainTab.Variables.PlayersWandGlow.Target = 0
        MainTab.Variables.PlayersWandGlowCurrentTargetText:Set("Current Target: ")
        actions.Notify("Main Tab Wand Glow: target left the game.")
    end

    --Spell Aura
    if MainTab.Variables.SpellAura.Target ~= 0 and removedPlayer.UserId == MainTab.Variables.SpellAura.Target.UserId then
        MainTab.Variables.SpellAura.Target = 0
        MainTab.Variables.SpellAura.CurrentTargetText:Set("Current Target: ")
        actions.Notify("Main Tab Spell Aura: target left the game.")
    end

    --@ Target Tab
    if TargetTab.Variables.Target ~= 0 and removedPlayer.UserId == TargetTab.Variables.Target.UserId then
        TargetTab.Variables.Target = 0
        TargetTab.Variables.TargetCurrentTargetText:Set("Current Target: ")
        actions.Notify("Target: target left the game.")
    end
end)

--! Main loop

coroutine.resume(coroutine.create(function()
    while task.wait() do
        --@ Main Tab
        --Storm | Party Mode
        if MainTab.Variables.Storm.PartyMode and actions.GetWand(true) and MainTab.Variables.Storm.Bool then MainTab.Variables.Storm.Toggle:Set(false) end

        --Spell Aura
        if MainTab.Variables.SpellAura.UseType == 0 then
            MainTab.Variables.SpellAura.Target = plr
        end

        if MainTab.Variables.SpellAura.Bool and MainTab.Variables.SpellAura.Target ~= 0 and MainTab.Variables.SpellAura.Spell ~= "" then
            for i,v in pairs(players:GetPlayers()) do
                if v ~= MainTab.Variables.SpellAura.Target and not table.find(MainTab.Variables.SpellAura.ExceptedPlayers, v.Name) and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") and MainTab.Variables.SpellAura.Target.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (v.Character.HumanoidRootPart.Position - MainTab.Variables.SpellAura.Target.Character.HumanoidRootPart.Position).Magnitude

                    if distance <= MainTab.Variables.SpellAura.Distance then
                        actions.SendSpell(v, MainTab.Variables.SpellAura.Spell)
                        task.wait(0.12)
                    end
                end
            end
        end

        --@ Toggles Tab
        local pg = plr.PlayerGui
        if Humanoid and Humanoid.Health > 0 and not Humanoid:FindFirstChild("isClashing") and pg and (TogglesTab.Variables.AutoHeal or TogglesTab.Variables.AutoRevive or TogglesTab.Variables.AutoDiffindo) then
            --Auto Heal
            if Humanoid and Humanoid.Health > 0 and Humanoid.Health < 50 and TogglesTab.Variables.AutoHeal then
                actions.SendSpell(plr, "episkey")
            elseif Humanoid and Humanoid.Health > 0 and Humanoid.Health ~= 100 and Humanoid.Health > 50 and TogglesTab.Variables.AutoHeal then
                actions.SendSpell(plr, "vulnera sanentur")
            end
    
            --Auto Diffindo
            if char:FindFirstChild("frozenData") and TogglesTab.Variables.AutoDiffindo then
                repeat
                    if TogglesTab.Variables.AutoDiffindo == false then return end

                    actions.SendSpell(plr, "diffindo")
                    task.wait()
                until not char:FindFirstChild("frozenData")
            end
            if char:FindFirstChild("bondageFolder") and TogglesTab.Variables.AutoDiffindo then
                repeat
                    if TogglesTab.Variables.AutoDiffindo == false then return end

                    actions.SendSpell(plr, "diffindo")
                    task.wait()
                until not char:FindFirstChild("bondageFolder")
            end
            if char:FindFirstChild("ragdollModel") and char:FindFirstChild("LowerTorso") and char.LowerTorso:FindFirstChild("floatRotation") and char.LowerTorso:FindFirstChild("floatVelocity") and char:FindFirstChild("ragdollModel"):FindFirstChild("LeftFoot") and not char.ragdollModel.LeftFoot:FindFirstChild("floatBodyPosition") and TogglesTab.Variables.AutoDiffindo then
                repeat
                    if TogglesTab.Variables.AutoDiffindo == false then return end

                    actions.SendSpell(plr, "diffindo")
                    task.wait()
                until not char:FindFirstChild("ragdollModel")
            end
    
            --Auto Revive
            if pg:FindFirstChild("obscuroGui") and TogglesTab.Variables.AutoRevive then
                repeat
                    if TogglesTab.Variables.AutoRevive == false then return end

                    actions.SendSpell(plr, "finite incantatem")
                    task.wait()
                until not pg:FindFirstChild("obscuroGui")
            end
            if game:GetService("StarterGui"):GetCoreGuiEnabled(Enum.CoreGuiType.Chat) == false and TogglesTab.Variables.AutoRevive then
                repeat
                    if TogglesTab.Variables.AutoRevive == false then return end

                    actions.SendSpell(plr, "finite incantatem")
                    task.wait()
                until game:GetService("StarterGui"):GetCoreGuiEnabled(Enum.CoreGuiType.Chat)
            end
            if Humanoid:FindFirstChild("obliviateTag") and TogglesTab.Variables.AutoRevive then
                repeat
                    if TogglesTab.Variables.AutoRevive == false then return end

                    task.wait()
                    actions.SendSpell(plr, "finite incantatem")
                until not Humanoid:FindFirstChild("obliviateTag")
            end
            if char:FindFirstChild("stoneData") and TogglesTab.Variables.AutoRevive then
                repeat
                    if TogglesTab.Variables.AutoRevive == false then return end

                    actions.SendSpell(plr, "finite incantatem")
                    task.wait()
                until not char:FindFirstChild("stoneData")
            end
            if char:FindFirstChild("ragdollModel") and not char:FindFirstChild("bondageFolder") and TogglesTab.Variables.AutoRevive then
                repeat
                    if TogglesTab.Variables.AutoRevive == false then return end

                    actions.SendSpell(plr, "liberacorpus")
                    task.wait(0.225)
                    actions.SendSpell(plr, "rennervate")
                    task.wait()
                until not char:FindFirstChild("ragdollModel")
            end
            if Humanoid and Humanoid.PlatformStand == true and Humanoid.WalkSpeed == 0 and Humanoid.JumpPower == 0 and TogglesTab.Variables.AutoRevive then
                actions.SendSpell(plr, "rennervate")
            end
        end

        --Auto Block
        if TogglesTab.Variables.AutoBlock == true and char and Humanoid and Humanoid.Health > 0 and RootPart then
            IServ.Events.protego:FireServer({
                ["rootPos"] = RootPart.Position,
                ["distance"] = actions.CalculateDistance("protego"),
                ["dir"] = Vector3.new(-180, 0, 0)
            })

            IServ.Events.protego:FireServer({
                ["rootPos"] = RootPart.Position,
                ["distance"] = actions.CalculateDistance("protego"),
                ["dir"] = Vector3.new(180, 0, 0)
            })

            IServ.Events.protego:FireServer({
                ["rootPos"] = RootPart.Position,
                ["distance"] = actions.CalculateDistance("protego"),
                ["dir"] = Vector3.new(0, 0, -90)
            })

            IServ.Events.protego:FireServer({
                ["rootPos"] = RootPart.Position,
                ["distance"] = actions.CalculateDistance("protego"),
                ["dir"] = Vector3.new(0, 0, 90)
            })
        end

        --Anti Fling
        if TogglesTab.Variables.AntiFling then
            for i,v in pairs(players:GetPlayers()) do
                if v ~= plr then
                    if v.Character then
                        for z,x in pairs(v.Character:GetDescendants()) do
                            if x:IsA("BasePart") then
                                x.Velocity = Vector3.zero
                                x.RotVelocity = Vector3.zero
                            end
                        end
                    end
                end
            end
        end

        --@ God Mode Tab
        --Target God Mode
        if GodModeTab.Variables.GodModeLoop and players:FindFirstChild(GodModeTab.Variables.Target) then
            actions.SendSpell(players:FindFirstChild(GodModeTab.Variables.Target), "avada kedavra")
        end

        --@ Auto Clash Tab
        --Instant Auto Clash
        if AutoClashTab.Variables.AutoClash.Instant then
            local EventArgs = {
                ["distance"] = actions.CalculateDistance("advanceClash")
            }
            local Event = IServ.Events.advanceClash
            Event:FireServer(EventArgs)
            Event:FireServer(EventArgs)
            Event:FireServer(EventArgs)
        end
    end
end))
