--------------------------------------------------------------------------------
--// 1️⃣  LOAD LIBRARIES
--------------------------------------------------------------------------------
local MrLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/YT-MrXT/lab/refs/heads/main/cat/libary/mrxtlibz"
))()

-- Core Roblox services ---------------------------------------------------------
local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local TweenService       = game:GetService("TweenService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local VirtualUser        = game:GetService("VirtualUser")
local VirtualInputManager= game:GetService("VirtualInputManager")
local UserInputService   = game:GetService("UserInputService")
local Workspace          = game:GetService("Workspace")

local player = Players.LocalPlayer
local lp     = player

-- Detect current world --------------------------------------------------------
local World1, World2, World3 = false, false, false
pcall(function()
    if Workspace:FindFirstChild("Map") then
        if Workspace.Map:FindFirstChild("Grass") then World1 = true
        elseif Workspace.Map:FindFirstChild("Dressrosa") then World2 = true
        elseif Workspace.Map:FindFirstChild("Zou") then World3 = true
        end
    end
end)

--------------------------------------------------------------------------------
--// 2️⃣  WINDOW & TABS (MrLib UI)
--------------------------------------------------------------------------------
local window = MrLib:CreateWindow({
    Title        = "Topi Hub",
    Subtitle     = "by Topi & AI",
    Icon         = "rbxassetid://",
    Size         = UDim2.new(0, 530, 0, 400),
    Theme        = "Yellow",
    FloatingButton = {
        Enabled = true,
        Icon    = "rbxassetid://",
        Size    = UDim2.new(0, 60, 0, 60),
        Position= UDim2.new(0, 20, 0, 100),
        Shape   = "Square"
    }
})

-- Create all needed tabs -------------------------------------------------------
local tabSettings   = window:CreateTab({Name="Settings",   Title="Settings",   Subtitle="Configure hub",   Icon="rbxassetid://"})
local tabMain      = window:CreateTab({Name="Main",      Title="Farming",   Subtitle="Level / Bone / Kata / Aura / Tyrant", Icon="rbxassetid://"})
local tabQuests    = window:CreateTab({Name="Quests",    Title="Quests",    Subtitle="Stack / Elite / Travel", Icon="rbxassetid://"})
local tabStats     = window:CreateTab({Name="Stats",     Title="Stats",     Subtitle="Auto‑upgrade", Icon="rbxassetid://"})
local tabStatus    = window:CreateTab({Name="Status",    Title="Status",    Subtitle="Devil Fruit / Eyes / Busos", Icon="rbxassetid://"})
local tabOther     = window:CreateTab({Name="Other",     Title="Other",     Subtitle="Future features", Icon="rbxassetid://"})
local tabDungeon   = window:CreateTab({Name="Dungeon",   Title="Dungeon",   Subtitle="Auto dungeon farm", Icon="rbxassetid://"})
local tabTravel    = window:CreateTab({Name="Travel",    Title="Travel",    Subtitle="World / Island / NPC", Icon="rbxassetid://"})
local tabShop      = window:CreateTab({Name="Shop",      Title="Shop",      Subtitle="Buy fighting styles", Icon="rbxassetid://"})

--------------------------------------------------------------------------------
--// 3️⃣  GLOBAL FLAGS
--------------------------------------------------------------------------------
getgenv().FarmLevel        = false
getgenv().FarmBone         = false
getgenv().FarmKata         = false
getgenv().FarmAura         = false
getgenv().FarmTyrant       = false
getgenv().FarmPhaBinh      = false
getgenv().FarmDungeon      = false
getgenv().AcceptQuestC     = false
getgenv().FarmEliteHunt    = false
getgenv().AutoMaterial     = false
getgenv().SelectMaterial   = nil
getgenv().Auto_Melee       = false
getgenv().Auto_Sword       = false
getgenv().Auto_Gun         = false
getgenv().Auto_DevilFruit  = false
getgenv().Auto_Defense     = false
getgenv().pSats            = 10
getgenv().FastAttack       = false
getgenv().BringMob         = true
getgenv().FlySpeed         = 300
getgenv().FlyHeight        = 30
getgenv().BringRange       = 350
getgenv().TargetRange      = 10000
getgenv().Noclip           = false
getgenv().SpinFarm         = false
getgenv().SpinDistance     = 30
getgenv().IsFarming        = false
getgenv().AutoBusoLoop     = false
getgenv().BuddhaFarm       = false
getgenv().BuddhaActive     = false
getgenv().BuddhaTransforming = false
getgenv().CurrentTargetMob = nil
getgenv().TravelToIsland   = false
getgenv().TPNpc            = false
getgenv().AutoZou          = false
getgenv().TravelDres       = false
getgenv().AutoRaid         = false
getgenv().SelectChip       = "Ice"

-- Initialize weapon choice
_G.ChooseWP = "Melee"

--------------------------------------------------------------------------------
--// 4️⃣  CORE HELPERS
--------------------------------------------------------------------------------
local function getChar()
    repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    return player.Character
end

local function getRoot()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- Noclip -----------------------------------------------------------------------
RunService.Stepped:Connect(function()
    if getgenv().Noclip and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Fly ---------------------------------------------------------------------------
local flyConn
local flyBodyVelocity

local function startFly()
    if flyConn then flyConn:Disconnect() end
    local char = getChar()
    if not char then return end
    local hrp  = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if not flyBodyVelocity then
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)
        flyBodyVelocity.Velocity = Vector3.new()
        flyBodyVelocity.Parent = hrp
    end

    flyConn = RunService.RenderStepped:Connect(function()
        if hrp and getgenv().IsFarming then
            hrp.Velocity = Vector3.new()
            if flyBodyVelocity.Parent ~= hrp then flyBodyVelocity.Parent = hrp end
        end
    end)
end

local function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
end

-- Tween -----------------------------------------------------------------------
local activeTween = nil
local YTeleportThreshold = 300
local INTERMEDIATE_THRESHOLD = 3000
local INTERMEDIATE_COOLDOWN = 5
local _lastIntermediateTele = 0
local IntermediateIslands = {}

local function doIntermediateTeleport(targetPos)
    local char = player.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    if tick() - _lastIntermediateTele < INTERMEDIATE_COOLDOWN then return false end

    local playerPos = hrp.Position
    local dist = (Vector2.new(playerPos.X, playerPos.Z) -
                  Vector2.new(targetPos.X, targetPos.Z)).Magnitude
    if dist < INTERMEDIATE_THRESHOLD then return false end

    local best, bestDist = nil, math.huge
    for _, island in ipairs(IntermediateIslands) do
        local d = (Vector2.new(island.pos.X, island.pos.Z) -
                   Vector2.new(targetPos.X, targetPos.Z)).Magnitude
        if d < bestDist then bestDist = d; best = island end
    end
    if best and bestDist < dist then
        _lastIntermediateTele = tick()
        print("🚀 Intermediate teleport via: "..best.name)
        local t = tick() + 0.5
        while tick() < t do
            hrp.CFrame = CFrame.new(best.pos + Vector3.new(0,2,0))
            task.wait()
        end
        return true
    end
    return false
end

local function TweenObject(obj, cf, speed)
    if not obj or not cf then return end
    if getgenv().BuddhaTransforming then return end
    if activeTween then activeTween:Cancel(); activeTween = nil end

    local currentY = obj.Position.Y
    local targetY  = cf.Position.Y
    if math.abs(targetY - currentY) > YTeleportThreshold then
        obj.CFrame = CFrame.new(obj.Position.X, targetY, obj.Position.Z)
        task.wait(0.5)
    end

    local distance = (obj.Position - cf.Position).Magnitude
    local finalSpeed = (distance <= 350) and 1000 or speed
    activeTween = TweenService:Create(
        obj,
        TweenInfo.new(distance / finalSpeed, Enum.EasingStyle.Linear),
        {CFrame = cf}
    )
    activeTween:Play()
    activeTween.Completed:Connect(function() activeTween = nil end)
end

local function doTweenToPos(targetCF, speed)
    local root = getRoot()
    if not root then return end
    doIntermediateTeleport(targetCF.Position)
    TweenObject(root, targetCF, speed or getgenv().FlySpeed)
end

-- Targeting / Combat -----------------------------------------------------------
local function GetNearestEnemy(names)
    local root = getRoot()
    if not root then return nil end
    local nearest, dist = nil, math.huge
    if not Workspace:FindFirstChild("Enemies") then return nil end
    
    for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid")
        and mob:FindFirstChild("HumanoidRootPart")
        and mob.Humanoid.Health > 0 then
            local match = false
            if type(names) == "table" then
                for _, n in ipairs(names) do if mob.Name == n then match = true; break end end
            else
                match = mob.Name == names
            end
            if match then
                local d = (mob.HumanoidRootPart.Position - root.Position).Magnitude
                if d < dist then dist = d; nearest = mob end
            end
        end
    end
    return nearest
end

local function GetFarmCFrame(mob)
    if not mob or not mob:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = mob.HumanoidRootPart
    local pos = hrp.Position
    local look = hrp.CFrame.LookVector
    local flat = Vector3.new(look.X,0,look.Z).Unit
    local targetPos
    if _G.ChooseWP == "Blox Fruit" then
        targetPos = pos + Vector3.new(0,10,0)
    else
        targetPos = pos - flat*25 + Vector3.new(0,25,0)
    end
    return CFrame.new(targetPos, targetPos + flat)
end

local function AttackEnemy(enemy)
    if getgenv().BuddhaTransforming then return end
    if enemy and enemy:FindFirstChild("Humanoid")
       and enemy.Humanoid.Health > 0 then
        pcall(function()
            if getgenv().IsFarming or getgenv().AutoMaterial then selectWeapon() end
            ReplicatedStorage.Remotes.Combat:FireServer(enemy)
        end)
    end
end

local function selectWeapon()
    pcall(function()
        if not getgenv().IsFarming and not getgenv().FarmPhaBinh then return end
        if getgenv().BuddhaTransforming then return end
        local wanted = _G.ChooseWP
        for _, tool in ipairs(player.Backpack:GetChildren()) do
            if tool.ToolTip == wanted then
                player.Character.Humanoid:EquipTool(tool)
                break
            end
        end
    end)
end

--------------------------------------------------------------------------------
--// PLACEHOLDER FARM FUNCTIONS (to be expanded by user)
--------------------------------------------------------------------------------
local farmLoops = {}

local function startLevelFarm()
    if farmLoops.level then return end
    farmLoops.level = RunService.Heartbeat:Connect(function()
        if not getgenv().FarmLevel then farmLoops.level:Disconnect(); farmLoops.level = nil; return end
        -- TODO: Add level farming logic
    end)
end

local function stopLevelFarm()
    if farmLoops.level then farmLoops.level:Disconnect(); farmLoops.level = nil end
end

local function startBoneFarm()
    if farmLoops.bone then return end
    farmLoops.bone = RunService.Heartbeat:Connect(function()
        if not getgenv().FarmBone then farmLoops.bone:Disconnect(); farmLoops.bone = nil; return end
        -- TODO: Add bone farming logic
    end)
end

local function stopBoneFarm()
    if farmLoops.bone then farmLoops.bone:Disconnect(); farmLoops.bone = nil end
end

local function startKataFarm()
    if farmLoops.kata then return end
    farmLoops.kata = RunService.Heartbeat:Connect(function()
        if not getgenv().FarmKata then farmLoops.kata:Disconnect(); farmLoops.kata = nil; return end
        -- TODO: Add kata farming logic
    end)
end

local function stopKataFarm()
    if farmLoops.kata then farmLoops.kata:Disconnect(); farmLoops.kata = nil end
end

local function startAuraFarm()
    if farmLoops.aura then return end
    farmLoops.aura = RunService.Heartbeat:Connect(function()
        if not getgenv().FarmAura then farmLoops.aura:Disconnect(); farmLoops.aura = nil; return end
        -- TODO: Add aura farming logic
    end)
end

local function stopAuraFarm()
    if farmLoops.aura then farmLoops.aura:Disconnect(); farmLoops.aura = nil end
end

local function startTyrantFarm()
    if farmLoops.tyrant then return end
    farmLoops.tyrant = RunService.Heartbeat:Connect(function()
        if not getgenv().FarmTyrant then farmLoops.tyrant:Disconnect(); farmLoops.tyrant = nil; return end
        -- TODO: Add tyrant farming logic
    end)
end

local function stopTyrantFarm()
    if farmLoops.tyrant then farmLoops.tyrant:Disconnect(); farmLoops.tyrant = nil end
end

local function startPhaBinhFarm()
    if farmLoops.phabinh then return end
    farmLoops.phabinh = RunService.Heartbeat:Connect(function()
        if not getgenv().FarmPhaBinh then farmLoops.phabinh:Disconnect(); farmLoops.phabinh = nil; return end
        -- TODO: Add pha binh farming logic
    end)
end

local function stopPhaBinhFarm()
    if farmLoops.phabinh then farmLoops.phabinh:Disconnect(); farmLoops.phabinh = nil end
end

local function startDungeonFarm()
    if farmLoops.dungeon then return end
    farmLoops.dungeon = RunService.Heartbeat:Connect(function()
        if not getgenv().FarmDungeon then farmLoops.dungeon:Disconnect(); farmLoops.dungeon = nil; return end
        -- TODO: Add dungeon farming logic
    end)
end

local function stopDungeonFarm()
    if farmLoops.dungeon then farmLoops.dungeon:Disconnect(); farmLoops.dungeon = nil end
end

local function TeleportToSubmerged()
    pcall(function()
        local root = getRoot()
        if root then
            root.CFrame = CFrame.new(Vector3.new(11520.80, -2154.99, 9829.51) + Vector3.new(0, 5, 0))
        end
    end)
end

--------------------------------------------------------------------------------
--// 5️⃣  UI: SETTINGS TAB
--------------------------------------------------------------------------------
tabSettings:AddSection("Settings")

tabSettings:AddDropdown({
    Name     = "Weapon",
    Options  = {"Melee","Sword","Blox Fruit","Gun"},
    Default  = "Melee",
    Callback = function(v) _G.ChooseWP = v end
})

tabSettings:AddSlider({
    Name  = "Fly Speed",
    Min   = 150,
    Max   = 350,
    Default= 300,
    Callback = function(v) getgenv().FlySpeed = v end
})

tabSettings:AddToggle({
    Name     = "Auto Attack",
    Default  = false,
    Callback = function(v) getgenv().FastAttack = v end
})

tabSettings:AddToggle({
    Name     = "Buddha Farm",
    Description = "Enable Buddha transform while farming (requires Buddha fruit)",
    Default  = false,
    Callback = function(v) getgenv().BuddhaFarm = v end
})

--------------------------------------------------------------------------------
--// 6️⃣  UI: MAIN (LEVEL / BONE / KATA / AURA / TYRANT)
--------------------------------------------------------------------------------
tabMain:AddSection("Level Farm")

local SelectedFarm = "Farm cấp"
local function checkWorldRequirement(farmType)
    if (farmType == "Farm bone" or farmType == "Farm kata" or farmType == "Tyrant of the Skie")
       and not World3 then
        window:Notify({Title="Wrong World", Text="This feature works only in World 3!", Duration=5})
        return false
    end
    return true
end

tabMain:AddDropdown({
    Name     = "Farm Type",
    Options  = {"Farm cấp","Farm bone","Farm kata","Farm aura","Tyrant of the Skie"},
    Default  = "Farm cấp",
    Callback = function(v)
        SelectedFarm = v
        if getgenv().IsFarming then
            stopLevelFarm(); stopBoneFarm(); stopKataFarm(); stopAuraFarm()
            stopTyrantFarm(); stopPhaBinhFarm(); stopFly()
            if not checkWorldRequirement(v) then
                getgenv().IsFarming = false
                return
            end
            if v == "Farm cấp"   then getgenv().FarmLevel = true   startLevelFarm()
            elseif v == "Farm bone"   then getgenv().FarmBone  = true   startBoneFarm()
            elseif v == "Farm kata"   then getgenv().FarmKata  = true   startKataFarm()
            elseif v == "Farm aura"   then getgenv().FarmAura  = true   startAuraFarm()
            elseif v == "Tyrant of the Skie" then getgenv().FarmTyrant = true startTyrantFarm()
            end
        end
    end
})

tabMain:AddToggle({
    Name     = "Auto Farm",
    Description = "Toggle auto‑farm for the selected mode",
    Default  = false,
    Callback = function(v)
        getgenv().FarmLevel = false; getgenv().FarmBone = false
        getgenv().FarmKata  = false; getgenv().FarmAura = false
        getgenv().FarmTyrant= false; getgenv().FarmPhaBinh = false

        getgenv().Noclip      = v
        getgenv().IsFarming   = v
        getgenv().AutoBusoLoop= v

        if v then
            if not checkWorldRequirement(SelectedFarm) then
                getgenv().IsFarming = false
                return
            end
            if SelectedFarm == "Farm cấp" then getgenv().FarmLevel = true   startLevelFarm()
            elseif SelectedFarm == "Farm bone" then getgenv().FarmBone = true   startBoneFarm()
            elseif SelectedFarm == "Farm kata" then getgenv().FarmKata = true   startKataFarm()
            elseif SelectedFarm == "Farm aura" then getgenv().FarmAura = true   startAuraFarm()
            elseif SelectedFarm == "Tyrant of the Skie" then getgenv().FarmTyrant = true startTyrantFarm()
            end
        else
            stopLevelFarm(); stopBoneFarm(); stopKataFarm()
            stopAuraFarm(); stopTyrantFarm(); stopPhaBinhFarm()
            stopFly()
        end
    end
})

tabMain:AddToggle({
    Name     = "Accept Quest (Manual)",
    Description = "Automatically accept quest for Bone/Kata",
    Default  = false,
    Callback = function(v) getgenv().AcceptQuestC = v end
})

--------------------------------------------------------------------------------
--// 7️⃣  UI: MATERIAL FARM
--------------------------------------------------------------------------------
tabMain:AddSection("Material Farm")

tabMain:AddDropdown({
    Name     = "Select Material",
    Options  = (function()
        if World1 then return {"Angel Wings","Leather + Scrap Metal","Magma Ore","Fish Tail"}
        elseif World2 then return {"Leather + Scrap Metal","Magma Ore","Ectoplasm","Mystic Droplet","Radioactive Material","Vampire Fang"}
        else return {"Scrap Metal","Fish Tail","Conjured Cocoa","Dragon Scale","Gunpowder","Mini Tusk","Demonic Wisp"} end
    end)(),
    Default  = "Angel Wings",
    Callback = function(v) getgenv().SelectMaterial = v end
})

tabMain:AddToggle({
    Name     = "Auto Material",
    Description = "Automatically farm the selected material",
    Default  = false,
    Callback = function(v)
        getgenv().AutoMaterial = v
        getgenv().IsFarming   = v
        getgenv().Noclip      = v
        getgenv().AutoBusoLoop= v
        if v then
            getgenv().FarmLevel = false; stopLevelFarm()
            startFly()
        else
            stopFly()
        end
    end
})

--------------------------------------------------------------------------------
--// 8️⃣  UI: STATS UPGRADE
--------------------------------------------------------------------------------
tabStats:AddSection("Stats Upgrade")

tabStats:AddSlider({
    Name      = "Points per Upgrade",
    Min       = 1,
    Max       = 1000,
    Default   = 10,
    Callback  = function(v) getgenv().pSats = v end
})

local function statsSetings(statType, points)
    pcall(function()
        if ReplicatedStorage:FindFirstChild("Remotes")
        and ReplicatedStorage.Remotes:FindFirstChild("CommF_") then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", statType, points)
        end
    end)
end

tabStats:AddToggle({Name="Auto Melee",   Callback=function(v) getgenv().Auto_Melee   = v end})
tabStats:AddToggle({Name="Auto Sword",   Callback=function(v) getgenv().Auto_Sword   = v end})
tabStats:AddToggle({Name="Auto Gun",     Callback=function(v) getgenv().Auto_Gun     = v end})
tabStats:AddToggle({Name="Auto Devil Fruit",Callback=function(v) getgenv().Auto_DevilFruit = v end})
tabStats:AddToggle({Name="Auto Defense",Callback=function(v) getgenv().Auto_Defense = v end})

spawn(function()
    while wait(0.1) do
        if getgenv().Auto_Melee       then statsSetings("Melee",   getgenv().pSats) end
        if getgenv().Auto_Sword       then statsSetings("Sword",   getgenv().pSats) end
        if getgenv().Auto_Gun         then statsSetings("Gun",     getgenv().pSats) end
        if getgenv().Auto_DevilFruit  then statsSetings("Devil",   getgenv().pSats) end
        if getgenv().Auto_Defense     then statsSetings("Defense", getgenv().pSats) end
    end
end)

--------------------------------------------------------------------------------
--// 9️⃣  UI: STATUS (Devil Fruit, Eyes, Auto‑Buso)
--------------------------------------------------------------------------------
tabStatus:AddSection("Devil Fruit")

local fruitLabel = tabStatus:AddParagraph({Title="Devil Fruit", Text="Loading..."})
spawn(function()
    while wait(1) do
        pcall(function()
            if player.Data and player.Data:FindFirstChild("DevilFruit") then
                local fruit = player.Data.DevilFruit.Value
                if (player.Character and player.Character:FindFirstChild(fruit))
                   or player.Backpack:FindFirstChild(fruit) then
                    fruitLabel:SetText("Devil Fruit: "..fruit)
                else
                    fruitLabel:SetText("No Devil Fruit")
                end
            end
        end)
    end
end)

local eyesLabel = tabStatus:AddParagraph({Title="Eyes Status", Text="Loading..."})
spawn(function()
    while wait(1) do
        pcall(function()
            if World3 and workspace:FindFirstChild("Map")
               and workspace.Map:FindFirstChild("TikiOutpost") then
                local eyes = {
                    workspace.Map.TikiOutpost.IslandModel:FindFirstChild("Eye1"),
                    workspace.Map.TikiOutpost.IslandModel:FindFirstChild("Eye2"),
                    workspace.Map.TikiOutpost.IslandModel:FindFirstChild("Eye3"),
                    workspace.Map.TikiOutpost.IslandModel:FindFirstChild("Eye4")
                }
                local cnt = 0
                for _,e in ipairs(eyes) do
                    if e and e:IsA("BasePart") and e.Transparency==0 then cnt = cnt+1 end
                end
                eyesLabel:SetText("Eyes: "..cnt..(cnt==4 and " ✅ Ready" or ""))
            else
                eyesLabel:SetText("Not in Tiki Outpost")
            end
        end)
    end
end)

spawn(function()
    while wait(1) do
        pcall(function()
            if getgenv().IsFarming then
                local hasBuso = player.Character and (player.Character:FindFirstChild("HasBuso") or player.Character:FindFirstChild("Buso"))
                if not hasBuso then ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso") end
            end
        end)
    end
end)

--------------------------------------------------------------------------------
--// 🔟  UI: ELITE HUNT
--------------------------------------------------------------------------------
tabQuests:AddSection("Elite Hunt")

local EliteNames = {"Diablo","Urban","Deandre"}

local function IsEliteName(name)
    for _,e in ipairs(EliteNames) do if string.find(name,e) then return true end end
    return false
end

local function GetNearestElite()
    local root = getRoot()
    if not root then return nil end
    local nearest,dist = nil,math.huge
    if not Workspace:FindFirstChild("Enemies") then return nil end
    
    for _,mob in ipairs(Workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart")
        and mob.Humanoid.Health>0 and IsEliteName(mob.Name) then
            local d = (mob.HumanoidRootPart.Position-root.Position).Magnitude
            if d<dist then dist= d; nearest = mob end
        end
    end
    return nearest
end

local function IsEliteAvailable()
    for _,v in ipairs(ReplicatedStorage:GetChildren()) do
        if IsEliteName(v.Name) and v:FindFirstChild("HumanoidRootPart") then return true end
    end
    local questUI = player.PlayerGui:FindFirstChild("Main")
    if questUI and questUI:FindFirstChild("Quest")
       and questUI.Quest.Visible then
        local txt = questUI.Quest.Container.QuestTitle.Title.Text
        if IsEliteName(txt) then return true end
    end
    return false
end

local eliteHuntConn = nil
local eliteWatchConn = nil
local elitePaused = false

local function PauseNormalFarms()
    if elitePaused then return end
    elitePaused = true
    stopLevelFarm(); stopBoneFarm(); stopKataFarm()
    stopAuraFarm(); stopTyrantFarm(); stopPhaBinhFarm()
end

local function ResumeNormalFarms()
    if not elitePaused then return end
    elitePaused = false
    if getgenv().FarmLevel  and SelectedFarm=="Farm cấp" then startLevelFarm() end
    if getgenv().FarmBone   and SelectedFarm=="Farm bone" then startBoneFarm() end
    if getgenv().FarmKata   and SelectedFarm=="Farm kata" then startKataFarm() end
    if getgenv().FarmAura   and SelectedFarm=="Farm aura" then startAuraFarm() end
    if getgenv().FarmTyrant and SelectedFarm=="Tyrant of the Skie" then startTyrantFarm() end
end

local function startEliteHunt()
    if eliteHuntConn then eliteHuntConn:Disconnect() end
    eliteHuntConn = RunService.Heartbeat:Connect(function()
        if not getgenv().FarmEliteHunt then return end
        pcall(function()
            local root = getRoot()
            if not root then return end
            local questUI = player.PlayerGui:FindFirstChild("Main")
            if questUI and questUI:FindFirstChild("Quest") then
                local panel = questUI.Quest
                if panel.Visible then
                    local title = panel.Container.QuestTitle.Title.Text
                    if IsEliteName(title) then
                        local enemy = GetNearestElite()
                        getgenv().CurrentTargetMob = enemy
                        if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                            local cf = GetFarmCFrame(enemy)
                            if cf then TweenObject(root, cf, getgenv().FlySpeed) end
                            AttackEnemy(enemy)
                        end
                    else
                        pcall(function()
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
                        end)
                        task.wait(0.5)
                    end
                else
                    pcall(function()
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("EliteHunter")
                    end)
                    task.wait(1)
                end
            end
        end)
    end)
end

local function stopEliteHunt()
    if eliteHuntConn then eliteHuntConn:Disconnect(); eliteHuntConn = nil end
    getgenv().CurrentTargetMob = nil
    ResumeNormalFarms()
end

local function startEliteWatcher()
    if eliteWatchConn then eliteWatchConn:Disconnect() end
    eliteWatchConn = RunService.Heartbeat:Connect(function()
        if not getgenv().FarmEliteHunt then return end
        if eliteHuntConn then return end
        pcall(function()
            if IsEliteAvailable() then
                print("⚡ Elite spotted – starting elite hunt")
                if getgenv().FarmLevel or getgenv().FarmBone or getgenv().FarmKata
                or getgenv().FarmAura or getgenv().FarmTyrant then
                    PauseNormalFarms()
                end
                if not getgenv().IsFarming then
                    getgenv().IsFarming   = true
                    getgenv().Noclip      = true
                    getgenv().AutoBusoLoop= true
                    startFly()
                end
                startEliteHunt()
            end
        end)
    end)
end

tabQuests:AddToggle({
    Name     = "Auto Elite Quest",
    Description = "Automatically accept elite quests, defeat them, then wait for the next one.",
    Default  = false,
    Callback = function(v)
        getgenv().FarmEliteHunt = v
        if v then
            print("✅ Elite‑hunt enabled – waiting for an elite to appear")
            startEliteWatcher()
        else
            if eliteWatchConn then eliteWatchConn:Disconnect(); eliteWatchConn = nil end
            stopEliteHunt()
        end
    end
})

--------------------------------------------------------------------------------
--// 1️⃣1️⃣  UI: TRAVEL (Worlds, Islands, NPCs)
--------------------------------------------------------------------------------
tabTravel:AddSection("World Travel")
tabTravel:AddButton({
    Name     = "Travel East Blue (World 1)",
    Callback = function()
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelMain")
        end)
    end
})
tabTravel:AddButton({
    Name     = "Travel Dressrosa (World 2)",
    Callback = function()
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
        end)
    end
})
tabTravel:AddButton({
    Name     = "Travel Zou (World 3)",
    Callback = function()
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
        end)
    end
})

-- === Island list ============================================================
local islandNames = {}
local islandMap   = {}
do
    local list = {}
    if World1 then
        list = {
            {"Marine Start",          Vector3.new(-2573.34, 15.89,  2047.00)},
            {"Start Island",          Vector3.new( 1071.28, 25.31,  1426.87)},
            {"Middle Town",           Vector3.new( -655.82, 15.89,  1436.68)},
            {"Jungle",                Vector3.new(-1249.77, 20.89,   341.36)},
            {"Pirate Village",        Vector3.new(-1122.35, 10.79,  3855.92)},
            {"Desert",                Vector3.new( 1094.15, 15.47,  4192.89)},
            {"Frozen Village",        Vector3.new( 1198.01, 35.01, -1211.73)},
            {"MarineFord",            Vector3.new(-4505.38, 30.69,  4260.56)},
            {"Fountain City",        Vector3.new( 5132.71, 10.54,  4037.86)},
            {"Colosseum",             Vector3.new(-1428.35, 15.39, -3014.37)},
            {"Sky 1",                 Vector3.new(-4970.22, 717.71,-2622.35)},
            {"Sky 2",                 Vector3.new(-4607.82, 872.58,-1667.56)},
            {"Sky 3",                 Vector3.new(-7894.62,5545.49,  -380.25)},
            {"Magma Village",         Vector3.new(-5231.76, 15.62,  8467.88)},
            {"Shanks Room",           Vector3.new(-1442.17, 29.88,   -28.35)},
            {"Prison",                Vector3.new( 4854.16, 15.17,   740.19)},
            {"Underwater City",       Vector3.new(61163.85,  5.34,  1819.78)},
            {"Whirlpool",             Vector3.new( 3864.69,  5.41, -1926.21)},
        }
    elseif World2 then
        list = {
            {"Magma Side",            Vector3.new(-5478.39,  30.98, -5246.91)},
            {"Ghost Island",          Vector3.new(-5571.84, 200.18,  -795.43)},
            {"Hot and Cold",          Vector3.new(-6026.96,  20.75, -5071.96)},
            {"First Spot",            Vector3.new(   82.95,  25.07,  2834.99)},
            {"Snow Mountain",         Vector3.new( 1384.68, 470.57, -4990.10)},
            {"Green Bit",             Vector3.new(-2372.15,  80.99, -3166.51)},
            {"Cafe",                  Vector3.new( -385.25,  80.05,   297.39)},
            {"Forgotten Island",      Vector3.new(-3043.32, 250.88,-10191.58)},
            {"Frosted Island",        Vector3.new( 5400.40,  35.22, -6236.99)},
            {"Flamingo Mansion",      Vector3.new( -287.53, 306.17,   597.60)},
            {"Flamingo Room",         Vector3.new( 2284.01,  15.19,   908.03)},
            {"Dark Area",             Vector3.new( 3807.10,  30.00, -3452.20)},
            {"Factory",               Vector3.new(  430.43, 230.02,  -432.50)},
            {"Raid Low",              Vector3.new(-5530,224,-5903)},
            {"Ghost Ship Gate",       Vector3.new(-6491,305,-4729)},
            {"Ghost Ship",            Vector3.new(  923.21,135.98,32852.83)},
            {"Raid Fruit",            Vector3.new(-6445.45,270.68,-4486.27)},
        }
    else
        list = {
            {"Hydar Island",          Vector3.new(  3567.22,   51.38,  1927.11)},
            {"Peanut Island",         Vector3.new(-1943.60,   44.90,-10288.01)},
            {"Ice Cream Island",      Vector3.new(  -950.00,   59.00,-10907.00)},
            {"House Hydar Island",    Vector3.new(  5661.53,1013.41,  -334.96)},
            {"Tiki",                  Vector3.new(-16813.44,   58.29,   304.87)},
            {"Haunted Castle",        Vector3.new( -9387.11, 141.36,  5616.04)},
            {"Mansion",               Vector3.new(-12463.81, 374.95, -7550.29)},
            {"Port Town",             Vector3.new(  -306.00,   20.65,  5557.35)},
            {"Great Tree",            Vector3.new(  2262.59,   28.96, -6462.95)},
            {"Room Enma/Yama",        Vector3.new(  5251.19,   23.92,   450.37)},
            {"Secret Temple",         Vector3.new(  5692.08,   21.01,   324.07)},
            {"CakeLoaf",              Vector3.new( -2106.07,   45.10,-11908.52)},
            {"Castle on the Sea",     Vector3.new(-5047.54, 314.55, -3159.34)},
            {"North Poles",           Vector3.new(  -986.51,   26.67,-14087.59)},
            {"Cacao Island",          Vector3.new(   471.13,   42.35,-12212.00)},
            {"Submerged Island",      Vector3.new(11520.80,-2154.99,  9829.51), special = true},
        }
    end

    for _,info in ipairs(list) do
        local name = info[1]
        local pos  = info[2]
        local sp   = info[3]
        islandNames[#islandNames]+1 = name
        islandMap[name] = {pos = pos, special = sp}
    end
end

local selectedIsland = islandNames[1] or "Hydar Island"
tabTravel:AddDropdown({
    Name     = "Select Island",
    Options  = islandNames,
    Default  = islandNames[1],
    Callback = function(v) selectedIsland = v end
})

local flyIslandToggle = tabTravel:AddToggle({
    Name     = "Fly to Island",
    Default  = false,
    Callback = function(v)
        getgenv().TravelToIsland = v
        if not v then
            local anyFarm = getgenv().FarmLevel or getgenv().FarmBone or getgenv().FarmKata
                or getgenv().FarmAura or getgenv().FarmTyrant or getgenv().AutoMaterial
                or getgenv().FarmDungeon or getgenv().AutoRaid or getgenv().FarmEliteHunt
            if not anyFarm then
                getgenv().IsFarming = false
                stopFly()
            end
            return
        end
        getgenv().IsFarming = true
        startFly()
        task.spawn(function()
            local data = islandMap[selectedIsland]
            if not data then return end
            if data.special then
                TeleportToSubmerged()
                getgenv().TravelToIsland = false
                flyIslandToggle:SetValue(false)
                return
            end
            local targetCF = CFrame.new(data.pos + Vector3.new(0,5,0))
            doIntermediateTeleport(data.pos)
            doTweenToPos(targetCF, getgenv().FlySpeed)

            local deadline = tick() + 60
            repeat
                task.wait(0.3)
                local r = getRoot()
                if not r then break end
            until (r.Position - data.pos).Magnitude <= 100 or tick() > deadline

            getgenv().TravelToIsland = false
            flyIslandToggle:SetValue(false)
        end)
    end
})

-- === NPC TELEPORT ============================================================
local npcNames = {}
pcall(function()
    for _,v in ipairs(ReplicatedStorage.NPCs:GetChildren()) do table.insert(npcNames, v.Name) end
    table.sort(npcNames)
end)
if #npcNames==0 then npcNames = {"(No NPC)"} end

local selectedNPC = npcNames[1]
tabTravel:AddDropdown({
    Name     = "Select NPC",
    Options  = npcNames,
    Default  = npcNames[1],
    Callback = function(v) selectedNPC = v end
})

local npcToggle = tabTravel:AddToggle({
    Name     = "Teleport to NPC",
    Default  = false,
    Callback = function(v)
        getgenv().TPNpc = v
        if v then
            getgenv().IsFarming = true
            startFly()
        else
            local anyFarm = getgenv().FarmLevel or getgenv().FarmBone or getgenv().FarmKata
                or getgenv().FarmAura or getgenv().FarmTyrant or getgenv().AutoMaterial
                or getgenv().FarmDungeon or getgenv().AutoRaid or getgenv().FarmEliteHunt
            if not anyFarm then
                getgenv().IsFarming = false
                stopFly()
            end
        end
    end
})

spawn(function()
    while wait(1) do
        if getgenv().TPNpc then
            for _,npc in ipairs(ReplicatedStorage.NPCs:GetChildren()) do
                if npc.Name == selectedNPC and npc:FindFirstChild("HumanoidRootPart") then
                    doIntermediateTeleport(npc.HumanoidRootPart.Position)
                    doTweenToPos(npc.HumanoidRootPart.CFrame, getgenv().FlySpeed)
                    break
                end
            end
        end
    end
end)

--------------------------------------------------------------------------------
--// 1️⃣2️⃣  UI: DUNGEON
--------------------------------------------------------------------------------
tabDungeon:AddSection("Dungeon Farm")
tabDungeon:AddToggle({
    Name     = "Auto Dungeon Farm",
    Description = "Works only when you are inside the Dungeon place",
    Default  = false,
    Callback = function(v)
        getgenv().FarmDungeon = v
        getgenv().Noclip = v
        getgenv().AutoBusoLoop = v
        if v then
            if game.PlaceId ~= 73902483975735 then
                window:Notify({Title="Wrong Place", Text="Dungeon farm only works inside the Dungeon!", Duration=5})
                getgenv().FarmDungeon = false
                getgenv().Noclip = false
                getgenv().AutoBusoLoop = false
                return
            end
            getgenv().IsFarming = true
            startFly()
            startDungeonFarm()
        else
            stopDungeonFarm()
            local anyFarm = getgenv().FarmLevel or getgenv().FarmBone or getgenv().FarmKata
                or getgenv().FarmAura or getgenv().FarmTyrant or getgenv().AutoMaterial or getgenv().AutoRaid
            if not anyFarm then
                getgenv().IsFarming = false
                getgenv().Noclip = false
                getgenv().AutoBusoLoop = false
                stopFly()
            end
        end
    end
})

--------------------------------------------------------------------------------
--// 1️⃣3️⃣  UI: RAID
--------------------------------------------------------------------------------
tabDungeon:AddSection("Auto Raid")
tabDungeon:AddDropdown({
    Name     = "Select Chip",
    Options  = {"Flame","Ice","Quake","Light","Dark","String","Rumble","Magma",
                "Human: Buddha","Sand","Bird: Phoenix","Dough"},
    Default  = "Ice",
    Callback = function(v) getgenv().SelectChip = v end
})
tabDungeon:AddToggle({
    Name     = "Auto Raid",
    Description = "Buy chip → start raid → farm mobs → island hop → repeat",
    Default  = false,
    Callback = function(v)
        getgenv().AutoRaid = v
        if v then
            getgenv().IsFarming   = true
            getgenv().Noclip      = true
            getgenv().AutoBusoLoop= true
            startFly()
        else
            local anyFarm = getgenv().FarmLevel or getgenv().FarmBone or getgenv().FarmKata
                or getgenv().FarmAura or getgenv().FarmTyrant or getgenv().AutoMaterial
                or getgenv().FarmDungeon or getgenv().FarmEliteHunt
            if not anyFarm then
                getgenv().IsFarming = false
                getgenv().Noclip = false
                stopFly()
            end
        end
    end
})

--------------------------------------------------------------------------------
--// 1️⃣4️⃣  UI: SHOP
--------------------------------------------------------------------------------
tabShop:AddSection("Fighting Styles")

local fightingStyles = {
    ["Black Leg"] = {
        world1 = Vector3.new(-984, 17, 3990),
        world2 = Vector3.new(-4753, 37, -4853),
        world3 = Vector3.new(-5050, 374, -3201),
        remote = function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyBlackLeg") end
    },
    ["Electro"] = {
        world1 = Vector3.new(-5383, 17, -2149),
        world2 = Vector3.new(-4960, 39, -4663),
        world3 = Vector3.new(-5000, 317, -3201),
        remote = function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyElectro") end
    },
    ["Fishman Karate"] = {
        world1 = Vector3.new(61586, 23, 987),
        world2 = Vector3.new(-4870, 37, -4769),
        world3 = Vector3.new(-5026, 375, -3196),
        remote = function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyFishmanKarate") end
    },
    ["Dragon Claw"] = {
        world2 = Vector3.new(695, 189, 654),
        world3 = Vector3.new(-4983, 374, -3213),
        remote = function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2") end
    },
    ["Superhuman"] = {
        world2 = Vector3.new(1380, 250, -5188),
        world3 = Vector3.new(-5007, 374, -3203),
        remote = function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySuperhuman") end
    },
    ["Death Step"] = {
        world2 = Vector3.new(6352, 300, -6762),
        world3 = Vector3.new(-5002, 318, -3225),
        remote = function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyDeathStep") end
    },
    ["Sharkman Karate"] = {
        world2 = Vector3.new(-2604, 242, -10318),
        world3 = Vector3.new(-4969, 317, -3226),
        remote = function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySharkmanKarate") end
    },
    ["Electric Claw"] = {
        world3 = Vector3.new(-10373, 334, -10136),
        remote = function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyElectricClaw") end
    },
    ["Dragon Talon"] = {
        world3 = Vector3.new(5659, 1214, 859),
        remote = function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyDragonTalon") end
    },
    ["Godhuman"] = {
        world3 = Vector3.new(-13771, 337, -9881),
        remote = function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyGodhuman") end
    },
    ["Sanguine Art"] = {
        world3 = Vector3.new(-16517, 26, -185),
        remote = function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySanguineArt") end
    },
}

local currentWorldKey = World1 and "world1" or World2 and "world2" or "world3"

local function purchaseStyle(name, data)
    local targetPos = data[currentWorldKey]
    if not targetPos then
        window:Notify({Title="Unavailable", Text=name.." cannot be bought in this world.", Duration=4})
        return
    end
    getgenv().IsFarming = true
    startFly()
    coroutine.wrap(function()
        local targetCF = CFrame.new(targetPos + Vector3.new(0,3,0))
        doTweenToPos(targetCF, getgenv().FlySpeed)
        local deadline = tick() + 30
        repeat
            task.wait(0.2)
            local r = getRoot()
            if not r then break end
        until (r.Position - targetPos).Magnitude <= 150 or tick() > deadline
        if (getRoot().Position - targetPos).Magnitude <= 150 then
            task.wait(0.3)
            data.remote()
            window:Notify({Title="Shop", Text="Requested purchase of "..name, Duration=4})
        else
            window:Notify({Title="Shop", Text="Couldn't reach "..name.." (too far)", Duration=5})
        end
        local anyFarm = getgenv().FarmLevel or getgenv().FarmBone or getgenv().FarmKata
            or getgenv().FarmAura or getgenv().FarmTyrant or getgenv().AutoMaterial
            or getgenv().FarmDungeon
        if not anyFarm then
            getgenv().IsFarming = false
            stopFly()
        end
    end)()
end

for name,data in pairs(fightingStyles) do
    if data[currentWorldKey] then
        tabShop:AddButton({
            Name = "Buy "..name,
            Callback = function() purchaseStyle(name, data) end
        })
    end
end

--------------------------------------------------------------------------------
--// 1️⃣5️⃣  NOTIFICATION
--------------------------------------------------------------------------------
window:Notify({
    Title    = "Hub Loaded",
    Text     = "Topi Hub is ready! All features loaded.",
    Duration = 5
})

print("✅ Topi Hub loaded successfully!")
