--------------------------------------------------------------------------------
--// TopiHub Combined — Lógica do Topi_Hub + UI do MrLib (Source)
--// Combinado automaticamente
--------------------------------------------------------------------------------

--// ================= LOAD LIBRARIES =================
local MrLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/YT-MrXT/lab/refs/heads/main/cat/libary/mrxtlibz"
))()

--// ================= SERVICES =================
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

--// ================= WORLD DETECTION =================
local World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
local World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
local World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089
local DungeonPlaceId = 73902483975735

local TeamSelf = player.Team and player.Team.Name or "Pirates"

--// ================= WINDOW & TABS (MrLib) =================
local Window = MrLib:CreateWindow({
    Title    = "Topi Hub",
    Subtitle = "by Topi & AI",
    Icon     = "rbxassetid://",
    Size     = UDim2.new(0, 530, 0, 400),
    Theme    = "Yellow",
    FloatingButton = {
        Enabled  = true,
        Icon     = "rbxassetid://96866982801235",
        Size     = UDim2.new(0, 60, 0, 60),
        Position = UDim2.new(0, 20, 0, 100),
        Shape    = "Square"
    }
})


local Tabs = {
    Settings  = Window:CreateTab({Name="Settings",  Title="Settings",       Subtitle="Configure",                  Icon="rbxassetid://"}),
    Main      = Window:CreateTab({Name="Main",      Title="Farming",        Subtitle="Level/Bone/Kata/Aura/Tyrant", Icon="rbxassetid://"}),
    Quests    = Window:CreateTab({Name="Quests",    Title="Stack Farming",  Subtitle="Elite / Sea Travel",          Icon="rbxassetid://"}),
    Stats     = Window:CreateTab({Name="Stats",     Title="Stats",          Subtitle="Auto upgrade",                Icon="rbxassetid://"}),
    FruitRaid = Window:CreateTab({Name="FruitRaid", Title="Dungeon",        Subtitle="Dungeon / Raid",              Icon="rbxassetid://"}),
    Travel    = Window:CreateTab({Name="Travel",    Title="Travel",         Subtitle="World / Island / NPC",        Icon="rbxassetid://"}),
    Shop      = Window:CreateTab({Name="Shop",      Title="Shop",           Subtitle="Fighting Styles",             Icon="rbxassetid://"}),
}

--// ================= FLAGS =================
getgenv().FarmLevel       = false
getgenv().FarmBone        = false
getgenv().FarmKata        = false
getgenv().FarmAura        = false
getgenv().FarmTyrant      = false
getgenv().FarmPhaBinh     = false
getgenv().FarmDungeon     = false
getgenv().AcceptQuestC    = false
getgenv().FarmEliteHunt   = false
getgenv().AutoMaterial    = false
getgenv().SelectMaterial  = nil
getgenv().Auto_Melee      = false
getgenv().Auto_Sword      = false
getgenv().Auto_Gun        = false
getgenv().Auto_DevilFruit = false
getgenv().Auto_Defense    = false
getgenv().pSats           = 10
getgenv().FastAttack      = false
getgenv().BringMob        = true
getgenv().FlySpeed        = 300
getgenv().FlyHeight       = 30
getgenv().BringRange      = 350
getgenv().TargetRange     = 10000
getgenv().Noclip          = false
getgenv().SpinFarm        = false
getgenv().SpinDistance    = 30
getgenv().IsFarming       = false
getgenv().AutoBusoLoop    = false
getgenv().BuddhaFarm      = false
getgenv().BuddhaActive    = false
getgenv().BuddhaTransforming = false
getgenv().CurrentTargetMob = nil
getgenv().TravelToIsland  = false
getgenv().TPNpc           = false
getgenv().AutoZou         = false
getgenv().TravelDres      = false
getgenv().AutoRaid        = false
getgenv().SelectChip      = "Ice"
getgenv().EliteActive     = false
getgenv().NormalPaused    = false
getgenv().DualQuestNext   = {}

_G.ChooseWP     = "Melee"
_G.SelectWeapon = nil

local Sec = 0.1

--// ================= INTERMEDIATE ISLANDS =================
local IntermediateIslands = {}
if World1 then
    IntermediateIslands = {
        {name="Sky2",      pos=Vector3.new(-4607.82, 872.58, -1667.56)},
        {name="UnderWater",pos=Vector3.new(61163.85, 5.34, 1819.78)},
        {name="Whirlpool", pos=Vector3.new(3864.69, 5.41, -1926.21)},
        {name="Sky3",      pos=Vector3.new(-7894.62, 5545.49, -380.2)},
    }
elseif World2 then
    IntermediateIslands = {
        {name="GhostShipGate",   pos=Vector3.new(-6505.30, 75.22, -126.66)},
        {name="GhostShip",       pos=Vector3.new(923.21, 120.98, 32852.83)},
        {name="FlamingoMansion", pos=Vector3.new(-287.53, 280.17, 597.60)},
        {name="FlamingoRoom",    pos=Vector3.new(2284.01, 45.19, 908.03)},
    }
elseif World3 then
    IntermediateIslands = {
        {name="HouseHydarIsland", pos=Vector3.new(5655, 1013, -317)},
        {name="Mansion",          pos=Vector3.new(-12465, 459, -7561)},
        {name="CastleOnTheSea",   pos=Vector3.new(-5083, 371, -3177)},
    }
else
    IntermediateIslands = {
        {name="Sky2",      pos=Vector3.new(-4607.82, 872.58, -1667.56)},
        {name="UnderWater",pos=Vector3.new(61163.85, 5.34, 1819.78)},
        {name="Whirlpool", pos=Vector3.new(3864.69, 5.41, -1926.21)},
    }
end

local INTERMEDIATE_THRESHOLD = 3000
local INTERMEDIATE_COOLDOWN  = 5
local _lastIntermediateTele  = 0

local function teleportSpam(position, duration)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local t = tick() + duration
    while tick() < t do
        hrp.CFrame = CFrame.new(position + Vector3.new(0, 2, 0))
        task.wait()
    end
end

local function doIntermediateTeleport(targetPos)
    local char = player.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    if tick() - _lastIntermediateTele < INTERMEDIATE_COOLDOWN then return false end
    local playerPos = hrp.Position
    local dist = (Vector2.new(playerPos.X, playerPos.Z) - Vector2.new(targetPos.X, targetPos.Z)).Magnitude
    if dist < INTERMEDIATE_THRESHOLD then return false end
    local best, bestDist = nil, math.huge
    for _, island in ipairs(IntermediateIslands) do
        local d = (Vector2.new(island.pos.X, island.pos.Z) - Vector2.new(targetPos.X, targetPos.Z)).Magnitude
        if d < bestDist then bestDist = d; best = island end
    end
    if best and bestDist < dist then
        _lastIntermediateTele = tick()
        print("🚀 Intermediate teleport via: " .. best.name)
        local distToIsland = (Vector2.new(playerPos.X, playerPos.Z) - Vector2.new(best.pos.X, best.pos.Z)).Magnitude
        local spamDuration = distToIsland < 5000 and 0.3 or 2
        teleportSpam(best.pos, spamDuration)
        return true
    end
    return false
end

--// ================= CORE HELPERS =================
local function getChar()
    repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    return player.Character
end

local function getRoot()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- Noclip
RunService.Stepped:Connect(function()
    if getgenv().Noclip and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

--// ================= FLY =================
local flyConn
local flyBodyVelocity

local _origStartFly, _origStopFly

_origStartFly = function()
    if flyConn then flyConn:Disconnect() end
    local char = getChar()
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not flyBodyVelocity then
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.Parent = hrp
    end
    flyConn = RunService.RenderStepped:Connect(function()
        if hrp and getgenv().IsFarming then
            hrp.Velocity = Vector3.new(0, 0, 0)
            if flyBodyVelocity and flyBodyVelocity.Parent ~= hrp then
                flyBodyVelocity.Parent = hrp
            end
        end
    end)
end

_origStopFly = function()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
end

function startFly()
    if getgenv().BuddhaFarm and IsBuddhaFruit and IsBuddhaFruit() and not getgenv().BuddhaActive then
        getgenv().BuddhaActive = true
        _origStartFly()
        task.spawn(function() ActivateBuddha() end)
    else
        _origStartFly()
    end
end

function stopFly()
    _origStopFly()
    if getgenv().BuddhaActive and getgenv().BuddhaFarm then
        task.spawn(function()
            task.wait(0.1)
            getgenv().BuddhaTransforming = true
            local char    = player.Character
            local backpack = player.Backpack
            if char and backpack then
                local currentTool = char:FindFirstChildOfClass("Tool")
                if currentTool then currentTool.Parent = backpack end
                task.wait(0.1)
                local buddhaItem = nil
                for _, v in pairs(backpack:GetChildren()) do
                    if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then buddhaItem = v; break end
                end
                if buddhaItem then char.Humanoid:EquipTool(buddhaItem) end
                task.wait(0.3)
                VirtualInputManager:SendKeyEvent(true, "Z", false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, "Z", false, game)
                task.wait(0.5)
                local fruitTool = char:FindFirstChildOfClass("Tool")
                if fruitTool and fruitTool.ToolTip == "Blox Fruit" then
                    fruitTool.Parent = backpack
                end
            end
            getgenv().BuddhaTransforming = false
            getgenv().BuddhaActive       = false
        end)
    end
end

--// ================= TWEEN =================
local activeTween = nil
local YTeleportThreshold = 300

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

    local distance   = (obj.Position - cf.Position).Magnitude
    local finalSpeed = (distance <= 350) and 1000 or speed
    activeTween = TweenService:Create(
        obj,
        TweenInfo.new(distance / finalSpeed, Enum.EasingStyle.Linear),
        {CFrame = cf}
    )
    activeTween:Play()
    activeTween.Completed:Connect(function() activeTween = nil end)
end

local function TweenToPos(targetCF, speed)
    local root = getRoot()
    if not root then return end
    doIntermediateTeleport(targetCF.Position)
    TweenObject(root, targetCF, speed or getgenv().FlySpeed)
end

local function TweenToFixedPos(root, targetCF, speed)
    if not root or not targetCF then return end
    doIntermediateTeleport(targetCF.Position)
    TweenObject(root, targetCF, speed or getgenv().FlySpeed)
end

--// ================= WEAPON / ATTACK =================
local function selectWeapon()
    pcall(function()
        if not getgenv().IsFarming and not getgenv().FarmPhaBinh then return end
        if getgenv().BuddhaTransforming then return end
        for _, v in pairs(player.Backpack:GetChildren()) do
            if v.ToolTip == _G.ChooseWP then
                _G.SelectWeapon = v.Name
                if player.Character then
                    player.Character.Humanoid:EquipTool(v)
                end
                break
            end
        end
    end)
end

local function AttackEnemy(enemy)
    if getgenv().BuddhaTransforming then return end
    if enemy and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
        pcall(function()
            if getgenv().IsFarming or getgenv().FarmPhaBinh or getgenv().AutoMaterial then
                selectWeapon()
            end
            ReplicatedStorage.Remotes.Combat:FireServer(enemy)
        end)
    end
end

--// ================= ENEMY FINDERS =================
local function GetNearestEnemy(enemyNames)
    local root = getRoot()
    if not root then return nil end
    if not workspace:FindFirstChild("Enemies") then return nil end
    local nearest, dist = nil, math.huge
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
            local isTarget = false
            if type(enemyNames) == "table" then
                for _, name in pairs(enemyNames) do
                    if mob.Name == name then isTarget = true; break end
                end
            elseif mob.Name == enemyNames then
                isTarget = true
            end
            if isTarget then
                local mag = (mob.HumanoidRootPart.Position - root.Position).Magnitude
                if mag < dist then dist = mag; nearest = mob end
            end
        end
    end
    return nearest
end

local function GetAnyEnemy()
    local root = getRoot()
    if not root then return nil end
    if not workspace:FindFirstChild("Enemies") then return nil end
    local nearest, dist = nil, math.huge
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
            local mag = (mob.HumanoidRootPart.Position - root.Position).Magnitude
            if mag < dist then dist = mag; nearest = mob end
        end
    end
    return nearest
end

local function GetFarmCFrame(mob)
    if not mob or not mob:FindFirstChild("HumanoidRootPart") then return nil end
    local mobHRP = mob.HumanoidRootPart
    local mobPos = mobHRP.Position
    local mobCF  = mobHRP.CFrame
    local lookRaw  = Vector3.new(mobCF.LookVector.X, 0, mobCF.LookVector.Z)
    local lookFlat = lookRaw.Magnitude > 0.01 and lookRaw.Unit or Vector3.new(0, 0, 1)
    local targetPos
    if _G.ChooseWP == "Blox Fruit" then
        targetPos = Vector3.new(mobPos.X, mobPos.Y + 10, mobPos.Z)
    else
        local offset = -lookFlat * 25
        targetPos = Vector3.new(mobPos.X + offset.X, mobPos.Y + 25, mobPos.Z + offset.Z)
    end
    return CFrame.new(targetPos, targetPos + lookFlat)
end

--// ================= BRING MOB =================
local function BringMobs()
    if not getgenv().BringMob or not getgenv().IsFarming then return end
    local targetMob = getgenv().CurrentTargetMob
    if not targetMob or not targetMob:FindFirstChild("HumanoidRootPart") or not targetMob:FindFirstChild("Humanoid") then return end
    if targetMob.Humanoid.Health <= 0 then return end
    local targetPos  = targetMob.HumanoidRootPart.Position
    local targetName = targetMob.Name
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == targetName and v ~= targetMob then
            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                local dist = (v.HumanoidRootPart.Position - targetPos).Magnitude
                if dist > 3 and dist <= getgenv().BringRange then
                    pcall(function()
                        v.HumanoidRootPart.CFrame    = targetMob.HumanoidRootPart.CFrame
                        v.HumanoidRootPart.CanCollide = false
                        v.HumanoidRootPart.Velocity  = Vector3.new(0, 0, 0)
                        if v.Humanoid:FindFirstChild("Animator") then v.Humanoid.Animator:Destroy() end
                        pcall(function() sethiddenproperty(player, "SimulationRadius", math.huge) end)
                    end)
                end
            end
        end
    end
end

spawn(function()
    while task.wait(0.2) do
        pcall(BringMobs)
    end
end)

--// ================= AUTO BUSO =================
spawn(function()
    while task.wait(1) do
        pcall(function()
            if getgenv().IsFarming then
                local hasBuso1 = player.Character and player.Character:FindFirstChild("HasBuso")
                local hasBuso2 = player.Character and player.Character:FindFirstChild("Buso")
                if not hasBuso1 and not hasBuso2 then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
                end
            end
        end)
    end
end)

--// ================= BUDDHA LOGIC =================
function IsBuddhaFruit()
    local ok, result = pcall(function() return player.Data.DevilFruit.Value end)
    if ok and result then
        return string.lower(result) == "buddha" or string.find(string.lower(result), "buddha") ~= nil
    end
    return false
end

function ActivateBuddha()
    pcall(function()
        local char    = player.Character
        local backpack = player.Backpack
        if not char or not backpack then return end
        getgenv().BuddhaTransforming = true
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool then currentTool.Parent = backpack end
        task.wait(0.1)
        local buddhaItem = nil
        for _, v in pairs(backpack:GetChildren()) do
            if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then buddhaItem = v; break end
        end
        if buddhaItem then char.Humanoid:EquipTool(buddhaItem) end
        task.wait(0.3)
        VirtualInputManager:SendKeyEvent(true, "Z", false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, "Z", false, game)
        task.wait(0.5)
        getgenv().BuddhaTransforming = false
    end)
end

local function DeactivateBuddha()
    pcall(function()
        local char = player.Character
        if not char then return end
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then
                v.Parent = player.Backpack; break
            end
        end
    end)
end

-- Buddha respawn
player.CharacterAdded:Connect(function(newChar)
    local hum = newChar:WaitForChild("Humanoid", 10)
    if hum then
        hum.Died:Connect(function()
            if (getgenv().IsFarming or getgenv().AutoMaterial) and IsBuddhaFruit() and getgenv().BuddhaFarm then
                getgenv().BuddhaTransforming = true
                getgenv().BuddhaActive       = false
            end
        end)
    end
    if not getgenv().IsFarming and not getgenv().AutoMaterial then return end
    if not IsBuddhaFruit() or not getgenv().BuddhaFarm then return end
    getgenv().BuddhaTransforming = true
    getgenv().BuddhaActive       = false
    task.spawn(function()
        local hrp = newChar:WaitForChild("HumanoidRootPart", 10)
        local hum2 = newChar:WaitForChild("Humanoid", 10)
        if not hrp or not hum2 then getgenv().BuddhaTransforming = false; return end
        task.wait(1)
        local backpack = player.Backpack
        local currentTool = newChar:FindFirstChildOfClass("Tool")
        if currentTool then currentTool.Parent = backpack end
        task.wait(0.1)
        local buddhaItem = nil
        for _, v in pairs(backpack:GetChildren()) do
            if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then buddhaItem = v; break end
        end
        if buddhaItem then hum2:EquipTool(buddhaItem) end
        task.wait(0.3)
        VirtualInputManager:SendKeyEvent(true, "Z", false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, "Z", false, game)
        task.wait(0.5)
        getgenv().BuddhaActive       = true
        getgenv().BuddhaTransforming = false
    end)
end)

pcall(function()
    local currentChar = player.Character
    if currentChar then
        local hum = currentChar:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Died:Connect(function()
                if (getgenv().IsFarming or getgenv().AutoMaterial) and IsBuddhaFruit() and getgenv().BuddhaFarm then
                    getgenv().BuddhaTransforming = true
                    getgenv().BuddhaActive       = false
                end
            end)
        end
    end
end)

--// ================= STATS =================
local function statsSetings(statType, points)
    pcall(function()
        if not ReplicatedStorage:FindFirstChild("Remotes") then return end
        if not ReplicatedStorage.Remotes:FindFirstChild("CommF_") then return end
        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", statType, points)
    end)
end

--// ================= SKILL UTILITIES =================
local function sendSkillKey(key)
    if not VirtualInputManager then return end
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

local function equipAndUseSkills(toolType)
    if not getgenv().FarmPhaBinh then return end
    local char    = player.Character
    local backpack = player.Backpack
    if not char or not backpack then return end
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") and item.ToolTip == toolType then
            item.Parent = char
            task.wait(0.12)
            local skills = {"Z", "X"}
            if toolType == "Melee"      then skills = {"Z", "X", "C"} end
            if toolType == "Blox Fruit" then skills = {"Z", "X", "C", "V", "F"} end
            for _, skill in ipairs(skills) do
                if not getgenv().FarmPhaBinh then break end
                pcall(sendSkillKey, skill)
                task.wait(0.12)
            end
            item.Parent = backpack
            break
        end
    end
end

--// ================= MATERIAL LIST =================
local MMon = {}
local MPos = nil

local MaterialList = {}
if World1 then
    MaterialList = {"Angel Wings","Leather + Scrap Metal","Magma Ore","Fish Tail"}
elseif World2 then
    MaterialList = {"Leather + Scrap Metal","Magma Ore","Ectoplasm","Mystic Droplet","Radioactive Material","Vampire Fang"}
elseif World3 then
    MaterialList = {"Scrap Metal","Fish Tail","Conjured Cocoa","Dragon Scale","Gunpowder","Mini Tusk","Demonic Wisp"}
end

--// ================= DUAL QUEST PAIRINGS =================
local DualQuestPairings = {
    JungleQuest       = {Mon="Monkey",           Qdata=1, NameMon="Monkey",           PosM=CFrame.new(-1448.5180664062,  67.853012084961,    11.465796470642)},
    BuggyQuest1       = {Mon="Pirate",            Qdata=1, NameMon="Pirate",            PosM=CFrame.new(-1103.5134277344,  13.752052307129,  3896.0910644531)},
    DesertQuest       = {Mon="Desert Bandit",     Qdata=1, NameMon="Desert Bandit",     PosM=CFrame.new(924.7998046875,    6.4486746788025,  4481.5859375)},
    SnowQuest         = {Mon="Snow Bandit",       Qdata=1, NameMon="Snow Bandit",       PosM=CFrame.new(1354.3479003906,  87.272773742676, -1393.9465332031)},
    SkyQuest          = {Mon="Sky Bandit",        Qdata=1, NameMon="Sky Bandit",        PosM=CFrame.new(-4953.20703125,   295.74420166016, -2899.2290039062)},
    PrisonerQuest     = {Mon="Prisoner",          Qdata=1, NameMon="Prisoner",          PosM=CFrame.new(5098.9736328125,  -0.3204058110714,   474.23733520508)},
    ColosseumQuest    = {Mon="Toga Warrior",      Qdata=1, NameMon="Toga Warrior",      PosM=CFrame.new(-1820.21484375,   51.683856964111, -2740.6650390625)},
    MagmaQuest        = {Mon="Military Soldier",  Qdata=1, NameMon="Military Soldier",  PosM=CFrame.new(-5411.1645507812, 11.081554412842,  8454.29296875)},
    FishmanQuest      = {Mon="Fishman Warrior",   Qdata=1, NameMon="Fishman Warrior",   PosM=CFrame.new(60878.30078125,   18.482830047607,  1543.7574462891)},
    SkyExp2Quest      = {Mon="Royal Squad",       Qdata=1, NameMon="Royal Squad",       PosM=CFrame.new(-7624.2524414062, 5658.1333007812, -1467.3542480469)},
    FountainQuest     = {Mon="Galley Pirate",     Qdata=1, NameMon="Galley Pirate",     PosM=CFrame.new(5551.0219726562,  78.901351928711,  3930.4128417969)},
    Area1Quest        = {Mon="Raider",            Qdata=1, NameMon="Raider",            PosM=CFrame.new(-728.32672119141, 52.779319763184,  2345.7705078125)},
    Area2Quest        = {Mon="Swan Pirate",       Qdata=1, NameMon="Swan Pirate",       PosM=CFrame.new(1068.6643066406, 137.61428833008,   1322.1060791016)},
    MarineQuest3      = {Mon="Marine Lieutenant", Qdata=1, NameMon="Marine Lieutenant", PosM=CFrame.new(-2821.3723144531, 75.897277832031, -3070.0891113281)},
    ZombieQuest       = {Mon="Zombie",            Qdata=1, NameMon="Zombie",            PosM=CFrame.new(-5657.7768554688, 78.969734191895,  -928.68701171875)},
    SnowMountainQuest = {Mon="Snow Trooper",      Qdata=1, NameMon="Snow Trooper",      PosM=CFrame.new(549.14733886719, 427.38705444336,  -5563.6987304688)},
    IceSideQuest      = {Mon="Lab Subordinate",   Qdata=1, NameMon="Lab Subordinate",   PosM=CFrame.new(-5707.4716796875, 15.951709747314, -4513.3920898438)},
    FireSideQuest     = {Mon="Magma Ninja",       Qdata=1, NameMon="Magma Ninja",       PosM=CFrame.new(-5449.6728515625, 76.658744812012, -5808.2006835938)},
    ShipQuest1        = {Mon="Ship Deckhand",     Qdata=1, NameMon="Ship Deckhand",     PosM=CFrame.new(1212.0111083984, 150.79205322266,  33059.24609375)},
    ShipQuest2        = {Mon="Ship Steward",      Qdata=1, NameMon="Ship Steward",      PosM=CFrame.new(919.43853759766, 129.55599975586,  33436.03515625)},
    FrostQuest        = {Mon="Arctic Warrior",    Qdata=1, NameMon="Arctic Warrior",    PosM=CFrame.new(5966.24609375,   62.970020294189, -6179.3828125)},
    ForgottenQuest    = {Mon="Sea Soldier",       Qdata=1, NameMon="Sea Soldier",       PosM=CFrame.new(-3028.2236328125, 64.674514770508, -9775.4267578125)},
    PiratePortQuest   = {Mon="Pirate Millionaire",Qdata=1, NameMon="Pirate Millionaire",PosM=CFrame.new(-246.00,47.31,5584.10)},
    DragonCrewQuest   = {Mon="Dragon Crew Warrior",Qdata=1, NameMon="Dragon Crew Warrior",PosM=CFrame.new(6709.76367,52.3442993,-1139.02966)},
    VenomCrewQuest    = {Mon="Hydra Enforcer",    Qdata=1, NameMon="Hydra Enforcer",    PosM=CFrame.new(4547.11523,1003.10217,334.194824)},
    MarineTreeIsland  = {Mon="Marine Commodore",  Qdata=1, NameMon="Marine Commodore",  PosM=CFrame.new(2519,109,-7633)},
    HauntedQuest1     = {Mon="Reborn Skeleton",   Qdata=1, NameMon="Reborn Skeleton",   PosM=CFrame.new(-8763.7236328125, 165.72299194336,  6159.8618164062)},
    HauntedQuest2     = {Mon="Demonic Soul",      Qdata=1, NameMon="Demonic Soul",      PosM=CFrame.new(-9505.8720703125, 172.10482788086,  6158.9931640625)},
    CakeQuest1        = {Mon="Cookie Crafter",    Qdata=1, NameMon="Cookie Crafter",    PosM=CFrame.new(-2374.13671875,37.798263549805,-12125.30859375)},
    CakeQuest2        = {Mon="Baking Staff",      Qdata=1, NameMon="Baking Staff",      PosM=CFrame.new(-1887.8099365234,77.618507385254,-12998.350585938)},
    TikiQuest1        = {Mon="Isle Outlaw",       Qdata=1, NameMon="Isle Outlaw",       PosM=CFrame.new(-16479.900390625,226.6117401123,-300.31143188477)},
    TikiQuest2        = {Mon="Sun-kissed Warrior",Qdata=1, NameMon="kissed Warrior",    PosM=CFrame.new(-16347,64,984)},
    TikiQuest3        = {Mon="Serpent Hunter",    Qdata=1, NameMon="Serpent Hunter",    PosM=CFrame.new(-16645.64,163.09,1352.87)},
    SubmergedQuest1   = {Mon="Reef Bandit",       Qdata=1, NameMon="Reef Bandit",       PosM=CFrame.new(11019.1318,-2146.06812,9342.3916)},
    SubmergedQuest2   = {Mon="Sea Chanter",       Qdata=1, NameMon="Sea Chanter",       PosM=CFrame.new(10671.2715,-2057.59155,10047.2588)},
    SubmergedQuest3   = {Mon="High Disciple",     Qdata=1, NameMon="High Disciple",     PosM=CFrame.new(9750.41602,-1966.93884,9753.36035)},
}

--// ================= QUEST DATA =================
-- (QuestNeta function — copiada integralmente do Topi_Hub)
local function QuestNeta()
    local I = player.Data.Level.Value
    local Mon, Qdata, Qname, NameMon, PosM, PosQ

    if World1 then
        if     I <= 9   then
            if tostring(TeamSelf)=="Marines" then
                Mon="Trainee"; Qname="MarineQuest"; Qdata=1; NameMon="Trainee"
                PosM=CFrame.new(-2709.67944,24.5206585,2104.24585); PosQ=PosM
            else
                Mon="Bandit"; Qdata=1; Qname="BanditQuest1"; NameMon="Bandit"
                PosM=CFrame.new(1045.9626464844,27.002508163452,1560.8203125); PosQ=PosM
            end
        elseif I <= 14  then Mon="Monkey";            Qdata=1; Qname="JungleQuest";    NameMon="Monkey";            PosQ=CFrame.new(-1598.08911,35.5501175,153.377838,0,0,1,0,1,0,-1,0,0);                                   PosM=CFrame.new(-1448.5180664062,67.853012084961,11.465796470642)
        elseif I <= 29  then Mon="Gorilla";           Qdata=2; Qname="JungleQuest";    NameMon="Gorilla";           PosQ=CFrame.new(-1598.08911,35.5501175,153.377838,0,0,1,0,1,0,-1,0,0);                                   PosM=CFrame.new(-1129.8836669922,40.46354675293,-525.42370605469)
        elseif I <= 39  then Mon="Pirate";            Qdata=1; Qname="BuggyQuest1";    NameMon="Pirate";            PosQ=CFrame.new(-1141.07483,4.10001802,3831.5498,.965929627,0,-0.258804798,0,1,0,.258804798,0,.965929627); PosM=CFrame.new(-1103.5134277344,13.752052307129,3896.0910644531)
        elseif I <= 59  then Mon="Brute";             Qdata=2; Qname="BuggyQuest1";    NameMon="Brute";             PosQ=CFrame.new(-1141.07483,4.10001802,3831.5498,.965929627,0,-0.258804798,0,1,0,.258804798,0,.965929627); PosM=CFrame.new(-1140.0837402344,14.809885025024,4322.9213867188)
        elseif I <= 74  then Mon="Desert Bandit";     Qdata=1; Qname="DesertQuest";    NameMon="Desert Bandit";     PosQ=CFrame.new(894.488647,5.14000702,4392.43359,.819155693,0,-0.573571265,0,1,0,.573571265,0,.819155693);   PosM=CFrame.new(924.7998046875,6.4486746788025,4481.5859375)
        elseif I <= 89  then Mon="Desert Officer";    Qdata=2; Qname="DesertQuest";    NameMon="Desert Officer";    PosQ=CFrame.new(894.488647,5.14000702,4392.43359,.819155693,0,-0.573571265,0,1,0,.573571265,0,.819155693);   PosM=CFrame.new(1608.2822265625,8.6142244338989,4371.0073242188)
        elseif I <= 99  then Mon="Snow Bandit";       Qdata=1; Qname="SnowQuest";      NameMon="Snow Bandit";       PosQ=CFrame.new(1389.74451,88.1519318,-1298.90796,-0.342042685,0,.939684391,0,1,0,-0.939684391,0,-0.342042685); PosM=CFrame.new(1354.3479003906,87.272773742676,-1393.9465332031)
        elseif I <= 119 then Mon="Snowman";           Qdata=2; Qname="SnowQuest";      NameMon="Snowman";           PosQ=CFrame.new(1389.74451,88.1519318,-1298.90796,-0.342042685,0,.939684391,0,1,0,-0.939684391,0,-0.342042685); PosM=CFrame.new(1200,144,-1550)
        elseif I <= 149 then Mon="Chief Petty Officer"; Qdata=1; Qname="MarineQuest2"; NameMon="Chief Petty Officer"; PosQ=CFrame.new(-5039.58643,27.3500385,4324.68018,0,0,-1,0,1,0,1,0,0); PosM=CFrame.new(-4881.2309570312,22.652044296265,4273.7524414062)
        elseif I <= 174 then Mon="Sky Bandit";        Qdata=1; Qname="SkyQuest";       NameMon="Sky Bandit";        PosQ=CFrame.new(-4839.53027,716.368591,-2619.44165,.866007268,0,.500031412,0,1,0,-0.500031412,0,.866007268);   PosM=CFrame.new(-4953.20703125,295.74420166016,-2899.2290039062)
        elseif I <= 189 then Mon="Dark Master";       Qdata=2; Qname="SkyQuest";       NameMon="Dark Master";       PosQ=CFrame.new(-4839.53027,716.368591,-2619.44165,.866007268,0,.500031412,0,1,0,-0.500031412,0,.866007268);   PosM=CFrame.new(-5259.8447265625,391.39767456055,-2229.0354003906)
        elseif I <= 209 then Mon="Prisoner";          Qdata=1; Qname="PrisonerQuest";  NameMon="Prisoner";          PosQ=CFrame.new(5308.93115,1.65517521,475.120514,-0.0894274712,-5.00292918e-09,-0.995993316,1.60817859e-09,1,-5.16744869e-09,.995993316,-2.06384709e-09,-0.0894274712); PosM=CFrame.new(5098.9736328125,-0.3204058110714,474.23733520508)
        elseif I <= 249 then Mon="Dangerous Prisoner"; Qdata=2; Qname="PrisonerQuest"; NameMon="Dangerous Prisoner"; PosQ=CFrame.new(5308.93115,1.65517521,475.120514,-0.0894274712,-5.00292918e-09,-0.995993316,1.60817859e-09,1,-5.16744869e-09,.995993316,-2.06384709e-09,-0.0894274712); PosM=CFrame.new(5654.5634765625,15.633401870728,866.29919433594)
        elseif I <= 274 then Mon="Toga Warrior";      Qdata=1; Qname="ColosseumQuest"; NameMon="Toga Warrior";      PosQ=CFrame.new(-1580.04663,6.35000277,-2986.47534,-0.515037298,0,-0.857167721,0,1,0,.857167721,0,-0.515037298); PosM=CFrame.new(-1820.21484375,51.683856964111,-2740.6650390625)
        elseif I <= 299 then Mon="Gladiator";         Qdata=2; Qname="ColosseumQuest"; NameMon="Gladiator";         PosQ=CFrame.new(-1580.04663,6.35000277,-2986.47534,-0.515037298,0,-0.857167721,0,1,0,.857167721,0,-0.515037298); PosM=CFrame.new(-1292.8381347656,56.380882263184,-3339.0314941406)
        elseif I <= 324 then Mon="Military Soldier";  Qdata=1; Qname="MagmaQuest";     NameMon="Military Soldier";  PosQ=CFrame.new(-5313.37012,10.9500084,8515.29395,-0.499959469,0,.866048813,0,1,0,-0.866048813,0,-0.499959469); PosM=CFrame.new(-5411.1645507812,11.081554412842,8454.29296875)
        elseif I <= 374 then Mon="Military Spy";      Qdata=2; Qname="MagmaQuest";     NameMon="Military Spy";      PosQ=CFrame.new(-5313.37012,10.9500084,8515.29395,-0.499959469,0,.866048813,0,1,0,-0.866048813,0,-0.499959469); PosM=CFrame.new(-5802.8681640625,86.262413024902,8828.859375)
        elseif I <= 399 then Mon="Fishman Warrior";   Qdata=1; Qname="FishmanQuest";   NameMon="Fishman Warrior";   PosQ=CFrame.new(61122.65234375,18.497442245483,1569.3997802734); PosM=CFrame.new(60878.30078125,18.482830047607,1543.7574462891)
        elseif I <= 449 then Mon="Fishman Commando";  Qdata=2; Qname="FishmanQuest";   NameMon="Fishman Commando";  PosQ=CFrame.new(61122.65234375,18.497442245483,1569.3997802734); PosM=CFrame.new(61922.6328125,18.482830047607,1493.9343261719)
        elseif I <= 474 then Mon="God's Guard";       Qdata=1; Qname="SkyExp1Quest";   NameMon="God's Guard";       PosQ=CFrame.new(-4721.88867,843.874695,-1949.96643,.996191859,0,-0.0871884301,0,1,0,.0871884301,0,.996191859); PosM=CFrame.new(-4710.04296875,845.27697753906,-1927.3079833984)
        elseif I <= 524 then Mon="Shanda";            Qdata=2; Qname="SkyExp1Quest";   NameMon="Shanda";            PosQ=CFrame.new(-7859.09814,5544.19043,-381.476196,-0.422592998,0,.906319618,0,1,0,-0.906319618,0,-0.422592998); PosM=CFrame.new(-7678.4897460938,5566.4038085938,-497.21560668945)
        elseif I <= 549 then Mon="Royal Squad";       Qdata=1; Qname="SkyExp2Quest";   NameMon="Royal Squad";       PosQ=CFrame.new(-7906.81592,5634.6626,-1411.99194,0,0,-1,0,1,0,1,0,0); PosM=CFrame.new(-7624.2524414062,5658.1333007812,-1467.3542480469)
        elseif I <= 624 then Mon="Royal Soldier";     Qdata=2; Qname="SkyExp2Quest";   NameMon="Royal Soldier";     PosQ=CFrame.new(-7906.81592,5634.6626,-1411.99194,0,0,-1,0,1,0,1,0,0); PosM=CFrame.new(-7836.7534179688,5645.6640625,-1790.6236572266)
        elseif I <= 649 then Mon="Galley Pirate";     Qdata=1; Qname="FountainQuest";  NameMon="Galley Pirate";     PosQ=CFrame.new(5259.81982,37.3500175,4050.0293,.087131381,0,.996196866,0,1,0,-0.996196866,0,.087131381); PosM=CFrame.new(5551.0219726562,78.901351928711,3930.4128417969)
        elseif I <= 699 then Mon="Galley Captain";    Qdata=2; Qname="FountainQuest";  NameMon="Galley Captain";    PosQ=CFrame.new(5259.81982,37.3500175,4050.0293,.087131381,0,.996196866,0,1,0,-0.996196866,0,.087131381); PosM=CFrame.new(5441.9516601562,42.502059936523,4950.09375)
        end
    elseif World2 then
        if     I <= 724  then Mon="Raider";           Qdata=1; Qname="Area1Quest";     NameMon="Raider";            PosQ=CFrame.new(-429.543518,71.7699966,1836.18188,-0.22495985,0,-0.974368095,0,1,0,.974368095,0,-0.22495985); PosM=CFrame.new(-728.32672119141,52.779319763184,2345.7705078125)
        elseif I <= 774  then Mon="Mercenary";        Qdata=2; Qname="Area1Quest";     NameMon="Mercenary";         PosQ=CFrame.new(-429.543518,71.7699966,1836.18188,-0.22495985,0,-0.974368095,0,1,0,.974368095,0,-0.22495985); PosM=CFrame.new(-1004.3244018555,80.158866882324,1424.6193847656)
        elseif I <= 799  then Mon="Swan Pirate";      Qdata=1; Qname="Area2Quest";     NameMon="Swan Pirate";       PosQ=CFrame.new(638.43811,71.769989,918.282898,.139203906,0,.99026376,0,1,0,-0.99026376,0,.139203906);         PosM=CFrame.new(1068.6643066406,137.61428833008,1322.1060791016)
        elseif I <= 874  then Mon="Factory Staff";    Qdata=2; Qname="Area2Quest";     NameMon="Factory Staff";     PosQ=CFrame.new(632.698608,73.1055908,918.666321,-0.0319722369,8.96074881e-10,-0.999488771,1.36326533e-10,1,8.92172336e-10,.999488771,-1.07732087e-10,-0.0319722369); PosM=CFrame.new(73.078674316406,81.863441467285,-27.470672607422)
        elseif I <= 899  then Mon="Marine Lieutenant";Qdata=1; Qname="MarineQuest3";   NameMon="Marine Lieutenant"; PosQ=CFrame.new(-2440.79639,71.7140732,-3216.06812,.866007268,0,.500031412,0,1,0,-0.500031412,0,.866007268);   PosM=CFrame.new(-2821.3723144531,75.897277832031,-3070.0891113281)
        elseif I <= 949  then Mon="Marine Captain";   Qdata=2; Qname="MarineQuest3";   NameMon="Marine Captain";    PosQ=CFrame.new(-2440.79639,71.7140732,-3216.06812,.866007268,0,.500031412,0,1,0,-0.500031412,0,.866007268);   PosM=CFrame.new(-1861.2310791016,80.176582336426,-3254.6975097656)
        elseif I <= 974  then Mon="Zombie";           Qdata=1; Qname="ZombieQuest";    NameMon="Zombie";            PosQ=CFrame.new(-5497.06152,47.5923004,-795.237061,-0.29242146,0,-0.95628953,0,1,0,.95628953,0,-0.29242146);   PosM=CFrame.new(-5657.7768554688,78.969734191895,-928.68701171875)
        elseif I <= 999  then Mon="Vampire";          Qdata=2; Qname="ZombieQuest";    NameMon="Vampire";           PosQ=CFrame.new(-5497.06152,47.5923004,-795.237061,-0.29242146,0,-0.95628953,0,1,0,.95628953,0,-0.29242146);   PosM=CFrame.new(-6037.66796875,32.184638977051,-1340.6597900391)
        elseif I <= 1049 then Mon="Snow Trooper";     Qdata=1; Qname="SnowMountainQuest"; NameMon="Snow Trooper";   PosQ=CFrame.new(609.858826,400.119904,-5372.25928,-0.374604106,0,.92718488,0,1,0,-0.92718488,0,-0.374604106);   PosM=CFrame.new(549.14733886719,427.38705444336,-5563.6987304688)
        elseif I <= 1099 then Mon="Winter Warrior";   Qdata=2; Qname="SnowMountainQuest"; NameMon="Winter Warrior";  PosQ=CFrame.new(609.858826,400.119904,-5372.25928,-0.374604106,0,.92718488,0,1,0,-0.92718488,0,-0.374604106);   PosM=CFrame.new(1142.7451171875,475.63980102539,-5199.4165039062)
        elseif I <= 1124 then Mon="Lab Subordinate";  Qdata=1; Qname="IceSideQuest";   NameMon="Lab Subordinate";   PosQ=CFrame.new(-6064.06885,15.2422857,-4902.97852,.453972578,0,-0.891015649,0,1,0,.891015649,0,.453972578);     PosM=CFrame.new(-5707.4716796875,15.951709747314,-4513.3920898438)
        elseif I <= 1174 then Mon="Horned Warrior";   Qdata=2; Qname="IceSideQuest";   NameMon="Horned Warrior";    PosQ=CFrame.new(-6064.06885,15.2422857,-4902.97852,.453972578,0,-0.891015649,0,1,0,.891015649,0,.453972578);     PosM=CFrame.new(-6341.3666992188,15.951770782471,-5723.162109375)
        elseif I <= 1199 then Mon="Magma Ninja";      Qdata=1; Qname="FireSideQuest";  NameMon="Magma Ninja";       PosQ=CFrame.new(-5428.03174,15.0622921,-5299.43457,-0.882952213,0,.469463557,0,1,0,-0.469463557,0,-0.882952213); PosM=CFrame.new(-5449.6728515625,76.658744812012,-5808.2006835938)
        elseif I <= 1249 then Mon="Lava Pirate";      Qdata=2; Qname="FireSideQuest";  NameMon="Lava Pirate";       PosQ=CFrame.new(-5428.03174,15.0622921,-5299.43457,-0.882952213,0,.469463557,0,1,0,-0.469463557,0,-0.882952213); PosM=CFrame.new(-5213.3315429688,49.737880706787,-4701.451171875)
        elseif I <= 1274 then Mon="Ship Deckhand";    Qdata=1; Qname="ShipQuest1";     NameMon="Ship Deckhand";     PosQ=CFrame.new(1037.80127,125.092171,32911.6016); PosM=CFrame.new(1212.0111083984,150.79205322266,33059.24609375)
        elseif I <= 1299 then Mon="Ship Engineer";    Qdata=2; Qname="ShipQuest1";     NameMon="Ship Engineer";     PosQ=CFrame.new(1037.80127,125.092171,32911.6016); PosM=CFrame.new(919.47863769531,43.544013977051,32779.96875)
        elseif I <= 1324 then Mon="Ship Steward";     Qdata=1; Qname="ShipQuest2";     NameMon="Ship Steward";      PosQ=CFrame.new(968.80957,125.092171,33244.125); PosM=CFrame.new(919.43853759766,129.55599975586,33436.03515625)
        elseif I <= 1349 then Mon="Ship Officer";     Qdata=2; Qname="ShipQuest2";     NameMon="Ship Officer";      PosQ=CFrame.new(968.80957,125.092171,33244.125); PosM=CFrame.new(1036.0179443359,181.4390411377,33315.7265625)
        elseif I <= 1374 then Mon="Arctic Warrior";   Qdata=1; Qname="FrostQuest";     NameMon="Arctic Warrior";    PosQ=CFrame.new(5667.6582,26.7997818,-6486.08984,-0.933587909,0,-0.358349502,0,1,0,.358349502,0,-0.933587909);   PosM=CFrame.new(5966.24609375,62.970020294189,-6179.3828125)
        elseif I <= 1424 then Mon="Snow Lurker";      Qdata=2; Qname="FrostQuest";     NameMon="Snow Lurker";       PosQ=CFrame.new(5667.6582,26.7997818,-6486.08984,-0.933587909,0,-0.358349502,0,1,0,.358349502,0,-0.933587909);   PosM=CFrame.new(5407.0737304688,69.194374084473,-6880.8803710938)
        elseif I <= 1449 then Mon="Sea Soldier";      Qdata=1; Qname="ForgottenQuest"; NameMon="Sea Soldier";       PosQ=CFrame.new(-3054.44458,235.544281,-10142.8193,.990270376,0,-0.13915664,0,1,0,.13915664,0,.990270376);       PosM=CFrame.new(-3028.2236328125,64.674514770508,-9775.4267578125)
        elseif I <= 1499 then Mon="Water Fighter";    Qdata=2; Qname="ForgottenQuest"; NameMon="Water Fighter";     PosQ=CFrame.new(-3054.44458,235.544281,-10142.8193,.990270376,0,-0.13915664,0,1,0,.13915664,0,.990270376);       PosM=CFrame.new(-3352.9013671875,285.01556396484,-10534.841796875)
        end
    elseif World3 then
        if     I <= 1524 then Mon="Pirate Millionaire";   Qdata=1; Qname="PiratePortQuest";  NameMon="Pirate Millionaire";   PosQ=CFrame.new(-290.07,42.90,5581.59); PosM=CFrame.new(-246.00,47.31,5584.10)
        elseif I <= 1574 then Mon="Pistol Billionaire";   Qdata=2; Qname="PiratePortQuest";  NameMon="Pistol Billionaire";   PosQ=CFrame.new(-290.07,42.90,5581.59); PosM=CFrame.new(-187.33,86.24,6013.51)
        elseif I <= 1599 then Mon="Dragon Crew Warrior";  Qdata=1; Qname="DragonCrewQuest";  NameMon="Dragon Crew Warrior";  PosQ=CFrame.new(6737.06055,127.417763,-712.300659,-0.463954359,-7.19574755e-09,0.885859072,7.69187665e-08,1,4.84078626e-08,-0.885859072,9.05982276e-08,-0.463954359); PosM=CFrame.new(6709.76367,52.3442993,-1139.02966)
        elseif I <= 1624 then Mon="Dragon Crew Archer";   Qdata=2; Qname="DragonCrewQuest";  NameMon="Dragon Crew Archer";   PosQ=CFrame.new(6737.06055,127.417763,-712.300659,-0.463954359,-7.19574755e-09,0.885859072,7.69187665e-08,1,4.84078626e-08,-0.885859072,9.05982276e-08,-0.463954359); PosM=CFrame.new(6668.76172,481.376923,329.12207)
        elseif I <= 1649 then Mon="Hydra Enforcer";       Qdata=1; Qname="VenomCrewQuest";   NameMon="Hydra Enforcer";       PosQ=CFrame.new(5206.40185546875,1004.10498046875,748.3504638671875); PosM=CFrame.new(4547.11523,1003.10217,334.194824)
        elseif I <= 1699 then Mon="Venomous Assailant";   Qdata=2; Qname="VenomCrewQuest";   NameMon="Venomous Assailant";   PosQ=CFrame.new(5206.40185546875,1004.10498046875,748.3504638671875); PosM=CFrame.new(4674.92676,1134.82654,996.308838)
        elseif I <= 1724 then Mon="Marine Commodore";     Qdata=1; Qname="MarineTreeIsland"; NameMon="Marine Commodore";     PosQ=CFrame.new(2482,74,-6788); PosM=CFrame.new(2519,109,-7633)
        elseif I <= 1774 then Mon="Marine Rear Admiral";  Qdata=2; Qname="MarineTreeIsland"; NameMon="Marine Rear Admiral";  PosQ=CFrame.new(2482,74,-6788); PosM=CFrame.new(3722,169,-7038)
        elseif I <= 1799 then Mon="Fishman Raider";       Qdata=1; Qname="DeepForestIsland3";NameMon="Fishman Raider";       PosQ=CFrame.new(-10581.6563,330.872955,-8761.18652); PosM=CFrame.new(-10407.526367188,331.76263427734,-8368.5166015625)
        elseif I <= 1824 then Mon="Fishman Captain";      Qdata=2; Qname="DeepForestIsland3";NameMon="Fishman Captain";      PosQ=CFrame.new(-10581.6563,330.872955,-8761.18652); PosM=CFrame.new(-10994.701171875,352.38140869141,-9002.1103515625)
        elseif I <= 1849 then Mon="Forest Pirate";        Qdata=1; Qname="DeepForestIsland"; NameMon="Forest Pirate";        PosQ=CFrame.new(-13234.04,331.488495,-7625.40137,.707134247,0,-0.707079291,0,1,0,.707079291,0,.707134247); PosM=CFrame.new(-13274.478515625,332.37814331055,-7769.5805664062)
        elseif I <= 1899 then Mon="Mythological Pirate";  Qdata=2; Qname="DeepForestIsland"; NameMon="Mythological Pirate";  PosQ=CFrame.new(-13234.04,331.488495,-7625.40137,.707134247,0,-0.707079291,0,1,0,.707079291,0,.707134247); PosM=CFrame.new(-13680.607421875,501.08154296875,-6991.189453125)
        elseif I <= 1924 then Mon="Jungle Pirate";        Qdata=1; Qname="DeepForestIsland2";NameMon="Jungle Pirate";        PosQ=CFrame.new(-12680.3818,389.971039,-9902.01953,-0.0871315002,0,.996196866,0,1,0,-0.996196866,0,-0.0871315002); PosM=CFrame.new(-12256.16015625,331.73828125,-10485.836914062)
        elseif I <= 1974 then Mon="Musketeer Pirate";     Qdata=2; Qname="DeepForestIsland2";NameMon="Musketeer Pirate";     PosQ=CFrame.new(-12680.3818,389.971039,-9902.01953,-0.0871315002,0,.996196866,0,1,0,-0.996196866,0,-0.0871315002); PosM=CFrame.new(-13457.904296875,391.54565429688,-9859.177734375)
        elseif I <= 1999 then Mon="Reborn Skeleton";      Qdata=1; Qname="HauntedQuest1";    NameMon="Reborn Skeleton";      PosQ=CFrame.new(-9479.2168,141.215088,5566.09277,0,0,1,0,1,0,-1,0,0); PosM=CFrame.new(-8763.7236328125,165.72299194336,6159.8618164062)
        elseif I <= 2024 then Mon="Living Zombie";        Qdata=2; Qname="HauntedQuest1";    NameMon="Living Zombie";        PosQ=CFrame.new(-9479.2168,141.215088,5566.09277,0,0,1,0,1,0,-1,0,0); PosM=CFrame.new(-10144.131835938,138.6266784668,5838.0888671875)
        elseif I <= 2049 then Mon="Demonic Soul";         Qdata=1; Qname="HauntedQuest2";    NameMon="Demonic Soul";         PosQ=CFrame.new(-9516.99316,172.017181,6078.46533,0,0,-1,0,1,0,1,0,0); PosM=CFrame.new(-9505.8720703125,172.10482788086,6158.9931640625)
        elseif I <= 2074 then Mon="Posessed Mummy";       Qdata=2; Qname="HauntedQuest2";    NameMon="Posessed Mummy";       PosQ=CFrame.new(-9516.99316,172.017181,6078.46533,0,0,-1,0,1,0,1,0,0); PosM=CFrame.new(-9582.0224609375,6.2515273094177,6205.478515625)
        elseif I <= 2099 then Mon="Peanut Scout";         Qdata=1; Qname="NutsIslandQuest";  NameMon="Peanut Scout";         PosQ=CFrame.new(-2104.3908691406,38.104167938232,-10194.21875,0,0,-1,0,1,0,1,0,0); PosM=CFrame.new(-2143.2419433594,47.721984863281,-10029.995117188)
        elseif I <= 2124 then Mon="Peanut President";     Qdata=2; Qname="NutsIslandQuest";  NameMon="Peanut President";     PosQ=CFrame.new(-2104.3908691406,38.104167938232,-10194.21875,0,0,-1,0,1,0,1,0,0); PosM=CFrame.new(-1859.3540039062,38.103168487549,-10422.4296875)
        elseif I <= 2149 then Mon="Ice Cream Chef";       Qdata=1; Qname="IceCreamIslandQuest"; NameMon="Ice Cream Chef";    PosQ=CFrame.new(-820.64825439453,65.819526672363,-10965.795898438,0,0,-1,0,1,0,1,0,0); PosM=CFrame.new(-872.24658203125,65.81957244873,-10919.95703125)
        elseif I <= 2199 then Mon="Ice Cream Commander";  Qdata=2; Qname="IceCreamIslandQuest"; NameMon="Ice Cream Commander"; PosQ=CFrame.new(-820.64825439453,65.819526672363,-10965.795898438,0,0,-1,0,1,0,1,0,0); PosM=CFrame.new(-558.06103515625,112.04895782471,-11290.774414062)
        elseif I <= 2224 then Mon="Cookie Crafter";       Qdata=1; Qname="CakeQuest1";       NameMon="Cookie Crafter";       PosQ=CFrame.new(-2021.32007,37.7982254,-12028.7295,.957576931,-8.80302053e-08,.288177818,6.9301187e-08,1,7.51931211e-08,-0.288177818,-5.2032135e-08,.957576931); PosM=CFrame.new(-2374.13671875,37.798263549805,-12125.30859375)
        elseif I <= 2249 then Mon="Cake Guard";           Qdata=2; Qname="CakeQuest1";       NameMon="Cake Guard";           PosQ=CFrame.new(-2021.32007,37.7982254,-12028.7295,.957576931,-8.80302053e-08,.288177818,6.9301187e-08,1,7.51931211e-08,-0.288177818,-5.2032135e-08,.957576931); PosM=CFrame.new(-1598.3070068359,43.773197174072,-12244.581054688)
        elseif I <= 2274 then Mon="Baking Staff";         Qdata=1; Qname="CakeQuest2";       NameMon="Baking Staff";         PosQ=CFrame.new(-1927.91602,37.7981339,-12842.5391,-0.96804446,4.22142143e-08,.250778586,4.74911062e-08,1,1.49904711e-08,-0.250778586,2.64211941e-08,-0.96804446); PosM=CFrame.new(-1887.8099365234,77.618507385254,-12998.350585938)
        elseif I <= 2299 then Mon="Head Baker";           Qdata=2; Qname="CakeQuest2";       NameMon="Head Baker";           PosQ=CFrame.new(-1927.91602,37.7981339,-12842.5391,-0.96804446,4.22142143e-08,.250778586,4.74911062e-08,1,1.49904711e-08,-0.250778586,2.64211941e-08,-0.96804446); PosM=CFrame.new(-2216.1882324219,82.884521484375,-12869.293945312)
        elseif I <= 2324 then Mon="Cocoa Warrior";        Qdata=1; Qname="ChocQuest1";       NameMon="Cocoa Warrior";        PosQ=CFrame.new(233.22836303711,29.876001358032,-12201.233398438); PosM=CFrame.new(-21.553283691406,80.574996948242,-12352.387695312)
        elseif I <= 2349 then Mon="Chocolate Bar Battler";Qdata=2; Qname="ChocQuest1";       NameMon="Chocolate Bar Battler";PosQ=CFrame.new(233.22836303711,29.876001358032,-12201.233398438); PosM=CFrame.new(582.59057617188,77.188095092773,-12463.162109375)
        elseif I <= 2374 then Mon="Sweet Thief";          Qdata=1; Qname="ChocQuest2";       NameMon="Sweet Thief";          PosQ=CFrame.new(150.50663757324,30.693693161011,-12774.502929688); PosM=CFrame.new(165.1884765625,76.058853149414,-12600.836914062)
        elseif I <= 2399 then Mon="Candy Rebel";          Qdata=2; Qname="ChocQuest2";       NameMon="Candy Rebel";          PosQ=CFrame.new(150.50663757324,30.693693161011,-12774.502929688); PosM=CFrame.new(134.86563110352,77.247680664062,-12876.547851562)
        elseif I <= 2449 then Mon="Candy Pirate";         Qdata=1; Qname="CandyQuest1";      NameMon="Candy Pirate";         PosQ=CFrame.new(-1150.0400390625,20.378934860229,-14446.334960938); PosM=CFrame.new(-1310.5003662109,26.016523361206,-14562.404296875)
        elseif I <= 2474 then Mon="Isle Outlaw";          Qdata=1; Qname="TikiQuest1";       NameMon="Isle Outlaw";          PosQ=CFrame.new(-16548.8164,55.6059914,-172.8125,.213092566,0,-0.977032006,0,1,0,.977032006,0,.213092566); PosM=CFrame.new(-16479.900390625,226.6117401123,-300.31143188477)
        elseif I <= 2499 then Mon="Island Boy";           Qdata=2; Qname="TikiQuest1";       NameMon="Island Boy";           PosQ=CFrame.new(-16548.8164,55.6059914,-172.8125,.213092566,0,-0.977032006,0,1,0,.977032006,0,.213092566); PosM=CFrame.new(-16849.396484375,192.86505126953,-150.78532409668)
        elseif I <= 2524 then Mon="Sun-kissed Warrior";   Qdata=1; Qname="TikiQuest2";       NameMon="kissed Warrior";       PosM=CFrame.new(-16347,64,984); PosQ=CFrame.new(-16538,55,1049)
        elseif I <= 2550 then Mon="Isle Champion";        Qdata=2; Qname="TikiQuest2";       NameMon="Isle Champion";        PosQ=CFrame.new(-16541.0215,57.3082275,1051.46118,.0410757065,0,-0.999156058,0,1,0,.999156058,0,.0410757065); PosM=CFrame.new(-16602.1015625,130.38734436035,1087.2456054688)
        elseif I <= 2574 then Mon="Serpent Hunter";       Qdata=1; Qname="TikiQuest3";       NameMon="Serpent Hunter";       PosQ=CFrame.new(-16668.03,105.32,1568.60); PosM=CFrame.new(-16645.64,163.09,1352.87)
        elseif I <= 2599 then Mon="Skull Slayer";         Qdata=2; Qname="TikiQuest3";       NameMon="Skull Slayer";         PosQ=CFrame.new(-16668.03,105.32,1568.60); PosM=CFrame.new(-16709.49,419.68,1751.09)
        elseif I <= 2624 then Mon="Reef Bandit";          Qdata=1; Qname="SubmergedQuest1";  NameMon="Reef Bandit";          PosQ=CFrame.new(10778.875,-2087.72437,9265.18359,0.934615612,-9.33109447e-08,-0.355659455,9.17655143e-08,1,-2.12154276e-08,0.355659455,-1.28090019e-08,0.934615612); PosM=CFrame.new(11019.1318,-2146.06812,9342.3916)
        elseif I <= 2649 then Mon="Coral Pirate";         Qdata=2; Qname="SubmergedQuest1";  NameMon="Coral Pirate";         PosQ=CFrame.new(10778.875,-2087.72437,9265.18359,0.934615612,-9.33109447e-08,-0.355659455,9.17655143e-08,1,-2.12154276e-08,0.355659455,-1.28090019e-08,0.934615612); PosM=CFrame.new(10808.6006,-2030.36145,9364.2334)
        elseif I <= 2674 then Mon="Sea Chanter";          Qdata=1; Qname="SubmergedQuest2";  NameMon="Sea Chanter";          PosQ=CFrame.new(10880.6855,-2086.20044,10032.624,-0.321384728,9.87648434e-08,-0.946948707,7.13271007e-08,1,8.00902953e-08,0.946948707,-4.18033075e-08,-0.321384728); PosM=CFrame.new(10671.2715,-2057.59155,10047.2588)
        elseif I <= 2699 then Mon="Ocean Prophet";        Qdata=2; Qname="SubmergedQuest2";  NameMon="Ocean Prophet";        PosQ=CFrame.new(10880.6855,-2086.20044,10032.624,-0.321384728,9.87648434e-08,-0.946948707,7.13271007e-08,1,8.00902953e-08,0.946948707,-4.18033075e-08,-0.321384728); PosM=CFrame.new(11008.5195,-2007.72839,10223.0791)
        elseif I <= 2724 then Mon="High Disciple";        Qdata=1; Qname="SubmergedQuest3";  NameMon="High Disciple";        PosQ=CFrame.new(9640.08789,-1992.44507,9613.65234,-0.957327187,4.11991223e-08,0.289006323,1.5775445e-08,1,-9.02985846e-08,-0.289006323,-8.18860855e-08,-0.957327187); PosM=CFrame.new(9750.41602,-1966.93884,9753.36035)
        else                Mon="Grand Devotee";          Qdata=2; Qname="SubmergedQuest3";  NameMon="Grand Devotee";        PosQ=CFrame.new(9640.08789,-1992.44507,9613.65234,-0.957327187,4.11991223e-08,0.289006323,1.5775445e-08,1,-9.02985846e-08,-0.289006323,-8.18860855e-08,-0.957327187); PosM=CFrame.new(9611.70508,-1993.47119,9882.68848)
        end
    end

    local altData = nil
    if Qdata == 2 and Qname and DualQuestPairings[Qname] then
        altData = DualQuestPairings[Qname]
    end
    return Mon, Qdata, Qname, NameMon, PosM, PosQ, altData
end

--// ================= SUBMERGED =================
local function TeleportToSubmerged()
    if World3 and player.Data.Level.Value >= 2600 then
        TweenToPos(CFrame.new(-16269.7041, 25.2288494, 1373.65955), 350)
        task.wait(2)
        pcall(function()
            ReplicatedStorage.Modules.Net:FindFirstChild("RF/SubmarineWorkerSpeak"):InvokeServer("TravelToSubmergedIsland")
        end)
        task.wait(3)
    end
end

--// ================= MATERIAL FARM LOGIC =================
local function MaterialMon()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local function shouldRequestEntrance(pos, dist)
        if (root.Position - pos).Magnitude >= dist then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", pos)
        end
    end
    if World1 then
        if     getgenv().SelectMaterial == "Angel Wings"           then MMon={"Shanda","Royal Squad","Royal Soldier","Wysper","Thunder God"}; MPos=CFrame.new(-7656,5619,-1033); shouldRequestEntrance(Vector3.new(-4607.8,872.5,-1667.5),10000)
        elseif getgenv().SelectMaterial == "Leather + Scrap Metal" then MMon={"Brute","Pirate"}; MPos=CFrame.new(-1145,15,4350)
        elseif getgenv().SelectMaterial == "Magma Ore"             then MMon={"Military Soldier","Military Spy","Magma Admiral"}; MPos=CFrame.new(-5815,84,8820)
        elseif getgenv().SelectMaterial == "Fish Tail"             then MMon={"Fishman Warrior","Fishman Commando","Fishman Lord"}; MPos=CFrame.new(61123,19,1569); shouldRequestEntrance(Vector3.new(61163.8,5.3,1819.7),17000)
        end
    elseif World2 then
        if     getgenv().SelectMaterial == "Leather + Scrap Metal" then MMon={"Marine Captain"}; MPos=CFrame.new(-2010.5,73,-3326.6)
        elseif getgenv().SelectMaterial == "Magma Ore"             then MMon={"Magma Ninja","Lava Pirate"}; MPos=CFrame.new(-5428,78,-5959)
        elseif getgenv().SelectMaterial == "Ectoplasm"             then MMon={"Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer"}; MPos=CFrame.new(911.3,125.9,33159.5); shouldRequestEntrance(Vector3.new(61163.8,5.3,1819.7),18000)
        elseif getgenv().SelectMaterial == "Mystic Droplet"        then MMon={"Water Fighter"}; MPos=CFrame.new(-3385,239,-10542)
        elseif getgenv().SelectMaterial == "Radioactive Material"  then MMon={"Factory Staff"}; MPos=CFrame.new(295,73,-56)
        elseif getgenv().SelectMaterial == "Vampire Fang"          then MMon={"Vampire"}; MPos=CFrame.new(-6033,7,-1317)
        end
    elseif World3 then
        if     getgenv().SelectMaterial == "Scrap Metal"    then MMon={"Jungle Pirate","Forest Pirate"}; MPos=CFrame.new(-11975.7,331.7,-10620)
        elseif getgenv().SelectMaterial == "Fish Tail"      then MMon={"Fishman Raider","Fishman Captain"}; MPos=CFrame.new(-10993,332,-8940)
        elseif getgenv().SelectMaterial == "Conjured Cocoa" then MMon={"Chocolate Bar Battler","Cocoa Warrior"}; MPos=CFrame.new(620.6,78.9,-12581.3)
        elseif getgenv().SelectMaterial == "Dragon Scale"   then MMon={"Dragon Crew Archer","Dragon Crew Warrior"}; MPos=CFrame.new(6594,383,139)
        elseif getgenv().SelectMaterial == "Gunpowder"      then MMon={"Pistol Billionaire"}; MPos=CFrame.new(-84.8,85.6,6132)
        elseif getgenv().SelectMaterial == "Mini Tusk"      then MMon={"Mythological Pirate"}; MPos=CFrame.new(-13545,470,-6917)
        elseif getgenv().SelectMaterial == "Demonic Wisp"   then MMon={"Demonic Soul"}; MPos=CFrame.new(-9495.6,453.5,5977.3)
        end
    end
end

--// ================= LEVEL FARM =================
local levelFarmConn

function startLevelFarm()
    if levelFarmConn then levelFarmConn:Disconnect() end
    if not getgenv().DualQuestNext then getgenv().DualQuestNext = {} end

    local prevQuestVisible = false
    local prevQname        = nil
    local _patrolPoints    = nil
    local _patrolIndex     = 1
    local _patrolLastTime  = 0
    local _patrolLastPosM  = nil

    local function buildPatrolPoints(mainPosM, altPosM)
        local pts = {}
        table.insert(pts, mainPosM)
        if altPosM then table.insert(pts, altPosM) end
        local base = mainPosM.Position
        table.insert(pts, CFrame.new(base + Vector3.new( 150,0,   0)))
        table.insert(pts, CFrame.new(base + Vector3.new(-150,0,   0)))
        table.insert(pts, CFrame.new(base + Vector3.new(   0,0, 150)))
        table.insert(pts, CFrame.new(base + Vector3.new(   0,0,-150)))
        table.insert(pts, CFrame.new(base + Vector3.new( 150,0,  50)))
        table.insert(pts, CFrame.new(base + Vector3.new(-150,0, -50)))
        return pts
    end

    levelFarmConn = RunService.Heartbeat:Connect(function(dt)
        if not getgenv().FarmLevel then return end
        pcall(function()
            local root = getRoot()
            if not root then return end
            local Mon, Qdata, Qname, NameMon, PosM, PosQ, altData = QuestNeta()
            if not Mon then return end
            local questUI      = player.PlayerGui.Main.Quest
            local questVisible = questUI.Visible
            if altData and prevQuestVisible and not questVisible and prevQname == Qname then
                local cur = getgenv().DualQuestNext[Qname]
                getgenv().DualQuestNext[Qname] = (cur == 1) and 2 or 1
            end
            prevQuestVisible = questVisible
            prevQname        = Qname
            if World3 and player.Data.Level.Value >= 2600 and (PosQ.Position - root.Position).Magnitude > 10000 then
                TeleportToSubmerged(); return
            end
            if not questVisible then
                TweenToPos(PosQ, getgenv().FlySpeed)
                if (root.Position - PosQ.Position).Magnitude <= 20 then
                    local qdataToAccept = Qdata
                    if altData then
                        local nextTarget = getgenv().DualQuestNext[Qname]
                        if nextTarget == 1 then qdataToAccept = altData.Qdata end
                    end
                    pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", Qname, qdataToAccept) end)
                    task.wait(0.5)
                end
                return
            end
            local QuestTitle    = questUI.Container.QuestTitle.Title.Text
            local activeMon     = Mon
            local activeNameMon = NameMon
            local activePosM    = PosM
            if altData and string.find(QuestTitle, altData.NameMon) then
                activeMon = altData.Mon; activeNameMon = altData.NameMon; activePosM = altData.PosM
            elseif not string.find(QuestTitle, NameMon) then
                if not (altData and string.find(QuestTitle, altData.NameMon)) then
                    pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest") end)
                    task.wait(0.5); return
                end
            end
            local enemy = GetNearestEnemy(activeMon)
            getgenv().CurrentTargetMob = enemy
            if enemy then
                if enemy:FindFirstChild("HumanoidRootPart") then
                    local targetCF = GetFarmCFrame(enemy)
                    if targetCF then TweenToPos(targetCF, getgenv().FlySpeed) end
                    AttackEnemy(enemy)
                end
            elseif activePosM then
                getgenv().CurrentTargetMob = nil
                if _patrolLastPosM ~= activePosM then
                    _patrolLastPosM = activePosM
                    _patrolPoints   = buildPatrolPoints(activePosM, altData and altData.PosM)
                    _patrolIndex    = 1; _patrolLastTime = 0
                end
                if tick() - _patrolLastTime >= 0.3 then
                    _patrolIndex    = (_patrolIndex % #_patrolPoints) + 1
                    _patrolLastTime = tick()
                end
                TweenToPos(_patrolPoints[_patrolIndex], getgenv().FlySpeed)
            end
        end)
    end)
end

function stopLevelFarm()
    if levelFarmConn then levelFarmConn:Disconnect(); levelFarmConn = nil end
    getgenv().CurrentTargetMob = nil
end

--// ================= BONE FARM =================
local boneFarmConn
local BoneQuestPos = CFrame.new(-9516.99316, 172.017181, 6078.46533)
local BoneFarmPos  = CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)
local BonesTable   = {"Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy"}

function startBoneFarm()
    if boneFarmConn then boneFarmConn:Disconnect() end
    if not World3 then return end
    boneFarmConn = RunService.Heartbeat:Connect(function(dt)
        if not getgenv().FarmBone then return end
        local root = getRoot(); if not root then return end
        local questUI = player.PlayerGui.Main.Quest
        local bone = GetNearestEnemy(BonesTable)
        getgenv().CurrentTargetMob = bone
        if bone then
            if getgenv().AcceptQuestC and not questUI.Visible then
                TweenToFixedPos(root, BoneQuestPos, getgenv().FlySpeed)
                if (root.Position - BoneQuestPos.Position).Magnitude > 50 then return end
                local randomQuest = math.random(1,4)
                local questData = {
                    {[1]="StartQuest",[2]="HauntedQuest2",[3]=2},
                    {[1]="StartQuest",[2]="HauntedQuest2",[3]=1},
                    {[1]="StartQuest",[2]="HauntedQuest1",[3]=1},
                    {[1]="StartQuest",[2]="HauntedQuest1",[3]=2}
                }
                pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer(table.unpack(questData[randomQuest])) end)
                task.wait(1)
            end
            if bone:FindFirstChild("HumanoidRootPart") then
                local targetCF = GetFarmCFrame(bone)
                if targetCF then TweenObject(root, targetCF, getgenv().FlySpeed) end
                AttackEnemy(bone)
            end
        else
            getgenv().CurrentTargetMob = nil
            TweenToFixedPos(root, BoneFarmPos, getgenv().FlySpeed)
        end
    end)
end

function stopBoneFarm()
    if boneFarmConn then boneFarmConn:Disconnect(); boneFarmConn = nil end
    getgenv().CurrentTargetMob = nil
end

--// ================= KATA FARM =================
local kataFarmConn
local CakeQuestPos     = CFrame.new(-1927.92, 37.8, -12842.54)
local CakeTeleportPos  = CFrame.new(-2077, 252, -12373)
local CakeMirrorPos    = CFrame.new(-2151.82, 149.32, -12404.91)
local CakePrinceTable  = {"Cookie Crafter","Cake Guard","Baking Staff","Head Baker"}

function startKataFarm()
    if kataFarmConn then kataFarmConn:Disconnect() end
    if not World3 then return end
    local mirrorTweenDone = false
    local mirrorTweenTime = 0

    kataFarmConn = RunService.Heartbeat:Connect(function(dt)
        if not getgenv().FarmKata then return end
        local root = getRoot(); if not root then return end
        local questUI = player.PlayerGui.Main.Quest
        local cakeMap = workspace.Map:FindFirstChild("CakeLoaf")
        local bigMirror = cakeMap and cakeMap:FindFirstChild("BigMirror")
        if not bigMirror or not bigMirror:FindFirstChild("Other") then
            getgenv().CurrentTargetMob = nil; mirrorTweenDone = false
            TweenToFixedPos(root, CakeTeleportPos, getgenv().FlySpeed); return
        end
        if bigMirror.Other.Transparency == 0 or workspace.Enemies:FindFirstChild("Cake Prince") then
            local cakePrince = GetNearestEnemy("Cake Prince")
            getgenv().CurrentTargetMob = cakePrince
            if cakePrince then
                mirrorTweenDone = false
                local targetCF = GetFarmCFrame(cakePrince)
                if targetCF then TweenObject(root, targetCF, getgenv().FlySpeed) end
                AttackEnemy(cakePrince)
            else
                if bigMirror.Other.Transparency == 0 then
                    getgenv().CurrentTargetMob = nil
                    if not mirrorTweenDone then
                        mirrorTweenDone = true; mirrorTweenTime = tick()
                        TweenToFixedPos(root, CakeMirrorPos, getgenv().FlySpeed)
                    elseif tick() - mirrorTweenTime < 0.8 then return end
                end
            end
        else
            local cakeMob = GetNearestEnemy(CakePrinceTable)
            getgenv().CurrentTargetMob = cakeMob
            if cakeMob then
                if getgenv().AcceptQuestC and not questUI.Visible then
                    TweenToFixedPos(root, CakeQuestPos, getgenv().FlySpeed)
                    if (root.Position - CakeQuestPos.Position).Magnitude > 50 then return end
                    local rq = math.random(1,4)
                    local qd = {{[1]="StartQuest",[2]="CakeQuest2",[3]=2},{[1]="StartQuest",[2]="CakeQuest2",[3]=1},{[1]="StartQuest",[2]="CakeQuest1",[3]=1},{[1]="StartQuest",[2]="CakeQuest1",[3]=2}}
                    pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer(table.unpack(qd[rq])) end)
                    task.wait(1)
                end
                local targetCF = GetFarmCFrame(cakeMob)
                if targetCF then TweenObject(root, targetCF, getgenv().FlySpeed) end
                AttackEnemy(cakeMob)
            else
                getgenv().CurrentTargetMob = nil
                TweenToFixedPos(root, CakeTeleportPos, getgenv().FlySpeed)
            end
        end
    end)
end

function stopKataFarm()
    if kataFarmConn then kataFarmConn:Disconnect(); kataFarmConn = nil end
    getgenv().CurrentTargetMob = nil
end

--// ================= AURA FARM =================
local auraFarmConn

function startAuraFarm()
    if auraFarmConn then auraFarmConn:Disconnect() end
    auraFarmConn = RunService.Heartbeat:Connect(function(dt)
        if not getgenv().FarmAura then return end
        local root = getRoot(); if not root then return end
        local enemy = GetAnyEnemy()
        getgenv().CurrentTargetMob = enemy
        if enemy then
            if enemy:FindFirstChild("HumanoidRootPart") then
                local targetCF = GetFarmCFrame(enemy)
                if targetCF then TweenObject(root, targetCF, getgenv().FlySpeed) end
                AttackEnemy(enemy)
            end
        else
            getgenv().CurrentTargetMob = nil
            TweenToFixedPos(root, CFrame.new(-5000,100,5000), getgenv().FlySpeed)
        end
    end)
end

function stopAuraFarm()
    if auraFarmConn then auraFarmConn:Disconnect(); auraFarmConn = nil end
    getgenv().CurrentTargetMob = nil
end

--// ================= TYRANT + BREAK POTS =================
local tyrantFarmConn
local TyrantBossPos = Vector3.new(-16268.287, 152.616, 1390.773)
local TyrantMobList = {"Serpent Hunter","Skull Slayer","Isle Champion","Sun-kissed Warrior"}

local phaBinhFarmConn
local PhaBinhPoints = {
    CFrame.new(-16332.5263671875, 158.07200622558594, 1440.324951171875),
    CFrame.new(-16288.609375, 158.16700744628906, 1470.3680419921875),
    CFrame.new(-16245.412109375, 158.43699645996094, 1463.365966796875),
    CFrame.new(-16212.46875, 158.16700744628906, 1466.343994140625),
    CFrame.new(-16211.9462890625, 158.07200622558594, 1322.39794921875),
    CFrame.new(-16260.921875, 154.92100524902344, 1323.615966796875),
    CFrame.new(-16297.0595703125, 159.322998046875, 1317.2239990234375),
    CFrame.new(-16335.0966796875, 159.33399963378906, 1324.885986328125),
}
local currentPointIndex = 1

function startPhaBinhFarm()
    if phaBinhFarmConn then phaBinhFarmConn:Disconnect() end
    if not World3 then return end
    phaBinhFarmConn = RunService.Heartbeat:Connect(function()
        if not getgenv().FarmPhaBinh then return end
        pcall(function()
            local root = getRoot(); if not root then return end
            local boss = workspace.Enemies:FindFirstChild("Tyrant of the Skies")
            if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                getgenv().FarmPhaBinh = false; getgenv().FarmTyrant = true
                stopPhaBinhFarm(); startTyrantFarm(); return
            end
            local targetCF = PhaBinhPoints[currentPointIndex]
            local dist = (root.Position - targetCF.Position).Magnitude
            if dist > 5 then TweenObject(root, targetCF, getgenv().FlySpeed); return end
            if not player.Character:FindFirstChild("HasBuso") and not player.Character:FindFirstChild("Buso") then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
            end
            equipAndUseSkills("Melee"); equipAndUseSkills("Sword"); equipAndUseSkills("Gun")
            currentPointIndex = currentPointIndex + 1
            if currentPointIndex > #PhaBinhPoints then currentPointIndex = 1 end
            task.wait(0.5)
        end)
    end)
end

function stopPhaBinhFarm()
    if phaBinhFarmConn then phaBinhFarmConn:Disconnect(); phaBinhFarmConn = nil end
    currentPointIndex = 1
end

function startTyrantFarm()
    if tyrantFarmConn then tyrantFarmConn:Disconnect() end
    if not World3 then return end
    tyrantFarmConn = RunService.Heartbeat:Connect(function(dt)
        if not getgenv().FarmTyrant then return end
        pcall(function()
            local root = getRoot(); if not root then return end
            if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("TikiOutpost") then
                local eyes = {
                    workspace.Map.TikiOutpost.IslandModel:FindFirstChild("Eye1"),
                    workspace.Map.TikiOutpost.IslandModel:FindFirstChild("Eye2"),
                    workspace.Map.TikiOutpost.IslandModel:FindFirstChild("Eye3"),
                    workspace.Map.TikiOutpost.IslandModel:FindFirstChild("Eye4")
                }
                local count = 0
                for _, eye in ipairs(eyes) do
                    if eye and eye:IsA("BasePart") and eye.Transparency == 0 then count = count + 1 end
                end
                if count == 4 and not getgenv().FarmPhaBinh then
                    getgenv().FarmTyrant = false; getgenv().FarmPhaBinh = true
                    getgenv().CurrentTargetMob = nil; stopTyrantFarm(); startPhaBinhFarm(); return
                end
            end
            local boss = workspace.Enemies:FindFirstChild("Tyrant of the Skies")
            if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                getgenv().CurrentTargetMob = boss
                if (root.Position - TyrantBossPos).Magnitude > 10 then
                    TweenToFixedPos(root, CFrame.new(TyrantBossPos), getgenv().FlySpeed); return
                end
                selectWeapon(); AttackEnemy(boss); return
            end
            local targetMob = nil
            for _, mobName in ipairs(TyrantMobList) do
                targetMob = GetNearestEnemy(mobName)
                if targetMob then break end
            end
            getgenv().CurrentTargetMob = targetMob
            if targetMob then
                local targetCF = GetFarmCFrame(targetMob)
                if targetCF and (root.Position - targetCF.Position).Magnitude > 20 then
                    TweenObject(root, targetCF, getgenv().FlySpeed)
                end
                selectWeapon(); AttackEnemy(targetMob)
            else
                getgenv().CurrentTargetMob = nil
                if (root.Position - TyrantBossPos).Magnitude > 10 then
                    TweenToFixedPos(root, CFrame.new(TyrantBossPos), getgenv().FlySpeed)
                end
            end
        end)
    end)
end

function stopTyrantFarm()
    if tyrantFarmConn then tyrantFarmConn:Disconnect(); tyrantFarmConn = nil end
    getgenv().CurrentTargetMob = nil
end

--// ================= DUNGEON FARM =================
local dungeonFarmConn

local function IsShadowMob(mobName)
    return string.find(mobName, "'s Shadow") or string.find(mobName, "Shadow")
end

local function FindShrine()
    for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
        if enemy.Name == "Shrine" and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
            if enemy.Humanoid.Health > 0 then return enemy end
        end
    end
    return nil
end

local function GetCurrentZone()
    local root = getRoot(); if not root then return nil end
    local nearestZone, minDistance = nil, math.huge
    local dungeonFolder = workspace.Map and workspace.Map:FindFirstChild("Dungeon")
    if not dungeonFolder then return nil end
    for _, zone in ipairs(dungeonFolder:GetChildren()) do
        local zoneRoot = zone:FindFirstChild("Root")
        if zoneRoot and zone:FindFirstChild("ExitTeleporter") then
            local dist = (zoneRoot.Position - root.Position).Magnitude
            if dist < minDistance then minDistance = dist; nearestZone = zone end
        end
    end
    return nearestZone
end

function startDungeonFarm()
    if dungeonFarmConn then dungeonFarmConn:Disconnect() end
    if game.PlaceId ~= DungeonPlaceId then
        Window:Notify({Title="Wrong Place", Text="Dungeon farm only works inside the Dungeon!", Duration=5})
        return
    end
    dungeonFarmConn = RunService.Heartbeat:Connect(function(dt)
        if not getgenv().FarmDungeon then return end
        pcall(function()
            local root = getRoot(); if not root then return end
            local currentZone = GetCurrentZone(); if not currentZone then return end
            local exitTeleporter = currentZone:FindFirstChild("ExitTeleporter"); if not exitTeleporter then return end
            local exitRoot = exitTeleporter:FindFirstChild("Root"); if not exitRoot then return end
            if exitRoot:FindFirstChild("BBG") then
                TweenObject(root, exitRoot.CFrame, getgenv().FlySpeed); task.wait(1); return
            end
            local shrine = FindShrine()
            if shrine then
                getgenv().CurrentTargetMob = shrine
                local targetCF = GetFarmCFrame(shrine)
                if targetCF then TweenObject(root, targetCF, getgenv().FlySpeed) end
                selectWeapon(); AttackEnemy(shrine); return
            end
            local enemies = {}
            for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
                if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
                    if enemy.Humanoid.Health > 0 and not IsShadowMob(enemy.Name) then
                        table.insert(enemies, enemy)
                    end
                end
            end
            if #enemies > 0 then
                for _, enemy in ipairs(enemies) do
                    if not getgenv().FarmDungeon then break end
                    if enemy.Humanoid.Health > 0 then
                        getgenv().CurrentTargetMob = enemy
                        local targetCF = GetFarmCFrame(enemy)
                        if targetCF then TweenObject(root, targetCF, getgenv().FlySpeed) end
                        selectWeapon(); AttackEnemy(enemy); break
                    end
                end
            else
                getgenv().CurrentTargetMob = nil
                if exitRoot then TweenObject(root, exitRoot.CFrame, getgenv().FlySpeed) end
            end
        end)
    end)
end

function stopDungeonFarm()
    if dungeonFarmConn then dungeonFarmConn:Disconnect(); dungeonFarmConn = nil end
    getgenv().CurrentTargetMob = nil
end

--// ================= FAST ATTACK =================
local Net            = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local RegisterAttack = Net:WaitForChild("RE/RegisterAttack")
local RegisterHit    = Net:WaitForChild("RE/RegisterHit")
local FastAttackConfig = {RANGE=90, ATTACKS_PER_FRAME=10, HITS_PER_FRAME=10, FRUIT_SPAM=10}
local FruitArmed = false
local LastTool   = nil

local function IsAlive(m) local h=m:FindFirstChild("Humanoid"); return h and h.Health>0 end
local function GetTargets()
    local char=player.Character; if not char then return {} end
    local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return {} end
    local list={}
    local function Scan(folder)
        for _,v in pairs(folder:GetChildren()) do
            if v~=char and v:FindFirstChild("HumanoidRootPart") and IsAlive(v) then
                if (hrp.Position-v.HumanoidRootPart.Position).Magnitude<=FastAttackConfig.RANGE then
                    table.insert(list,v)
                end
            end
        end
    end
    if Workspace:FindFirstChild("Enemies")    then Scan(Workspace.Enemies)    end
    if Workspace:FindFirstChild("Characters") then Scan(Workspace.Characters) end
    return list
end

local function ArmFruit()
    VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
    task.wait()
    VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
end

RunService.Heartbeat:Connect(function()
    local shouldAttack = getgenv().FastAttack or getgenv().IsFarming or getgenv().AutoMaterial
    if not shouldAttack then return end
    if getgenv().BuddhaTransforming then return end
    local char = player.Character; if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool ~= LastTool then FruitArmed=false; LastTool=tool end
    local targets = GetTargets(); if #targets==0 then return end
    if tool and (tool.ToolTip=="Melee" or tool.ToolTip=="Sword") then
        for _=1,FastAttackConfig.ATTACKS_PER_FRAME do RegisterAttack:FireServer(0) end
        local args={[1]=targets[1].HumanoidRootPart,[2]={}}
        for i,v in ipairs(targets) do args[2][i]={v, v.HumanoidRootPart} end
        for _=1,FastAttackConfig.HITS_PER_FRAME do RegisterHit:FireServer(table.unpack(args)) end
    elseif tool and tool.ToolTip=="Blox Fruit" then
        local remote=tool:FindFirstChild("LeftClickRemote"); if not remote or not targets[1] then return end
        if not FruitArmed then ArmFruit(); FruitArmed=true; return end
        local hrp=char.HumanoidRootPart
        local dir=(targets[1].HumanoidRootPart.Position-hrp.Position).Unit
        for _=1,FastAttackConfig.FRUIT_SPAM do remote:FireServer(dir,1) end
    end
end)

--// ================= MATERIAL FARM LOOP =================
local DragonScalePatrolPositions = {CFrame.new(6793,535,454), CFrame.new(6945,106,-807)}
local _dragonPatrolIdx = 1

spawn(function()
    while task.wait() do
        if getgenv().AutoMaterial and getgenv().SelectMaterial then
            pcall(function()
                MaterialMon()
                local target = GetNearestEnemy(MMon)
                local root   = getRoot()
                getgenv().CurrentTargetMob = target
                if target and target:FindFirstChild("HumanoidRootPart") then
                    _dragonPatrolIdx = 1
                    local targetCF = GetFarmCFrame(target)
                    if targetCF then TweenObject(root, targetCF, getgenv().FlySpeed) end
                    AttackEnemy(target)
                elseif getgenv().SelectMaterial == "Dragon Scale" then
                    getgenv().CurrentTargetMob = nil
                    local patrolCF = DragonScalePatrolPositions[_dragonPatrolIdx]
                    TweenToFixedPos(root, patrolCF, getgenv().FlySpeed)
                    local deadline = tick() + 4
                    repeat task.wait(0.15) until
                        not getgenv().AutoMaterial
                        or (getRoot() and (getRoot().Position - patrolCF.Position).Magnitude < 80)
                        or tick() > deadline
                    if getgenv().AutoMaterial and getgenv().SelectMaterial == "Dragon Scale" then
                        task.wait(0.5)
                        _dragonPatrolIdx = (_dragonPatrolIdx % #DragonScalePatrolPositions) + 1
                    end
                else
                    getgenv().CurrentTargetMob = nil
                    if MPos then TweenToFixedPos(root, MPos, getgenv().FlySpeed) end
                end
            end)
        end
    end
end)

--// ================= ELITE HUNT =================
local EliteNames = {"Diablo","Urban","Deandre"}
local function IsEliteName(name)
    for _,n in pairs(EliteNames) do if string.find(name,n) then return true end end
    return false
end
local function GetNearestEliteEnemy()
    local root=getRoot(); if not root then return nil end
    local nearest,dist=nil,math.huge
    for _,mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health>0 then
            if IsEliteName(mob.Name) then
                local mag=(mob.HumanoidRootPart.Position-root.Position).Magnitude
                if mag<dist then dist=mag; nearest=mob end
            end
        end
    end
    return nearest
end
local function GetEliteReplicatedPart()
    for _,v in pairs(ReplicatedStorage:GetChildren()) do
        if IsEliteName(v.Name) and v:FindFirstChild("HumanoidRootPart") then return v end
    end
    return nil
end
local function IsEliteAvailable()
    if GetEliteReplicatedPart() then return true end
    local questUI=player.PlayerGui:FindFirstChild("Main")
    if questUI then
        local qp=questUI:FindFirstChild("Quest")
        if qp and qp.Visible then
            pcall(function()
                local t=qp.Container.QuestTitle.Title.Text
                if IsEliteName(t) then return true end
            end)
        end
    end
    return false
end

local eliteHuntConn, eliteWatchConn

local function PauseNormalFarm()
    if getgenv().NormalPaused then return end
    getgenv().NormalPaused = true
    stopLevelFarm(); stopBoneFarm(); stopKataFarm(); stopAuraFarm(); stopTyrantFarm(); stopPhaBinhFarm()
end

local SelectedFarm = "Farm Level"

local function ResumeNormalFarm()
    if not getgenv().NormalPaused then return end
    getgenv().NormalPaused = false
    if     getgenv().FarmLevel  and SelectedFarm == "Farm Level"          then startLevelFarm()
    elseif getgenv().FarmBone   and SelectedFarm == "Farm Bone"           then startBoneFarm()
    elseif getgenv().FarmKata   and SelectedFarm == "Farm Kata"           then startKataFarm()
    elseif getgenv().FarmAura   and SelectedFarm == "Farm Aura"           then startAuraFarm()
    elseif getgenv().FarmTyrant and SelectedFarm == "Tyrant of the Skie"  then startTyrantFarm()
    end
end

local function startEliteHunt()
    if eliteHuntConn then eliteHuntConn:Disconnect() end
    getgenv().EliteActive = true
    eliteHuntConn = RunService.Heartbeat:Connect(function(dt)
        if not getgenv().FarmEliteHunt then return end
        pcall(function()
            local root=getRoot(); if not root then return end
            local questUI=player.PlayerGui:FindFirstChild("Main"); if not questUI then return end
            local questPanel=questUI:FindFirstChild("Quest"); if not questPanel then return end
            if questPanel.Visible then
                local titleText=""
                pcall(function() titleText=questPanel.Container.QuestTitle.Title.Text end)
                if IsEliteName(titleText) then
                    local repPart=GetEliteReplicatedPart()
                    if repPart then
                        local repPos=repPart.HumanoidRootPart.Position
                        if (root.Position-repPos).Magnitude>500 then
                            TweenToPos(repPart.HumanoidRootPart.CFrame, getgenv().FlySpeed)
                        end
                    end
                    local enemy=GetNearestEliteEnemy()
                    getgenv().CurrentTargetMob=enemy
                    if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                        local targetCF=GetFarmCFrame(enemy)
                        if targetCF then TweenToPos(targetCF, getgenv().FlySpeed) end
                        AttackEnemy(enemy)
                    end
                else
                    pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest") end)
                    task.wait(0.5)
                end
            else
                local repPart=GetEliteReplicatedPart()
                if repPart then
                    getgenv().CurrentTargetMob=nil
                    pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("EliteHunter") end)
                    task.wait(1)
                else
                    if eliteHuntConn then eliteHuntConn:Disconnect(); eliteHuntConn=nil end
                    getgenv().EliteActive=false; getgenv().CurrentTargetMob=nil
                    local anyNormalFarm=getgenv().FarmLevel or getgenv().FarmBone or getgenv().FarmKata
                        or getgenv().FarmAura or getgenv().FarmTyrant or getgenv().AutoMaterial or getgenv().FarmDungeon
                    if not anyNormalFarm then
                        getgenv().IsFarming=false; getgenv().Noclip=false; getgenv().AutoBusoLoop=false; stopFly()
                    else
                        ResumeNormalFarm()
                    end
                end
            end
        end)
    end)
end

local function stopEliteHunt()
    if eliteHuntConn then eliteHuntConn:Disconnect(); eliteHuntConn=nil end
    if eliteWatchConn then eliteWatchConn:Disconnect(); eliteWatchConn=nil end
    getgenv().EliteActive=false; getgenv().CurrentTargetMob=nil
    ResumeNormalFarm()
end

local function startEliteWatcher()
    if eliteWatchConn then eliteWatchConn:Disconnect() end
    eliteWatchConn = RunService.Heartbeat:Connect(function()
        if not getgenv().FarmEliteHunt then return end
        if getgenv().EliteActive then return end
        pcall(function()
            if IsEliteAvailable() then
                local anyNormalFarm=getgenv().FarmLevel or getgenv().FarmBone or getgenv().FarmKata
                    or getgenv().FarmAura or getgenv().FarmTyrant
                if anyNormalFarm then PauseNormalFarm() end
                if not getgenv().IsFarming then
                    getgenv().IsFarming=true; getgenv().Noclip=true; getgenv().AutoBusoLoop=true; startFly()
                end
                startEliteHunt()
            end
        end)
    end)
end

--// ================= GUI: SETTINGS =================
Tabs.Settings:AddSection("Settings / Configure")

Tabs.Settings:AddDropdown({
    Name="Weapon", Options={"Melee","Sword","Blox Fruit","Gun"}, Default="Melee",
    Callback=function(v) _G.ChooseWP=v end
})

Tabs.Settings:AddSlider({
    Name="Fly Speed", Min=150, Max=350, Default=300,
    Callback=function(v) getgenv().FlySpeed=v end
})

Tabs.Settings:AddToggle({
    Name="Auto Attack", Default=false,
    Callback=function(v) getgenv().FastAttack=v end
})

Tabs.Settings:AddToggle({
    Name="Bring Mob", Default=true,
    Callback=function(v) getgenv().BringMob=v end
})

Tabs.Settings:AddToggle({
    Name="Buddha Farm", Default=false,
    Callback=function(v) getgenv().BuddhaFarm=v end
})

Tabs.Settings:AddToggle({
    Name="Auto Race V3", Default=false,
    Callback=function(v) _G.AutoRaceV3=v end
})
spawn(function()
    while task.wait() do
        pcall(function()
            if _G.AutoRaceV3 then
                game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility")
            end
        end)
    end
end)

Tabs.Settings:AddToggle({
    Name="Auto Race V4", Default=false,
    Callback=function(v) _G.AutoRaceV4=v end
})
spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if _G.AutoRaceV4 then
                local raceEnergy=player.Character and player.Character:FindFirstChild("RaceEnergy")
                if raceEnergy and raceEnergy.Value==1 then
                    VirtualInputManager:SendKeyEvent(true,"Y",false,game)
                    task.wait()
                    VirtualInputManager:SendKeyEvent(false,"Y",false,game)
                end
            end
        end)
    end
end)

--// ================= GUI: MAIN (FARMING) =================
Tabs.Main:AddSection("Level Farm")

Tabs.Main:AddDropdown({
    Name="Farm Type",
    Options={"Farm Level","Farm Bone","Farm Kata","Farm Aura","Tyrant of the Skie"},
    Default="Farm Level",
    Callback=function(v)
        SelectedFarm=v
        if getgenv().IsFarming then
            stopLevelFarm(); stopBoneFarm(); stopKataFarm(); stopAuraFarm()
            stopTyrantFarm(); stopPhaBinhFarm(); stopFly()
            if (v=="Farm Bone" or v=="Farm Kata" or v=="Tyrant of the Skie") and not World3 then
                getgenv().IsFarming=false
                Window:Notify({Title="Wrong World", Text="World 3 only!", Duration=4})
                return
            end
            getgenv().FarmLevel=false; getgenv().FarmBone=false; getgenv().FarmKata=false
            getgenv().FarmAura=false; getgenv().FarmTyrant=false
            startFly()
            if     v=="Farm Level"         then getgenv().FarmLevel=true;  startLevelFarm()
            elseif v=="Farm Bone"          then getgenv().FarmBone=true;   startBoneFarm()
            elseif v=="Farm Kata"          then getgenv().FarmKata=true;   startKataFarm()
            elseif v=="Farm Aura"          then getgenv().FarmAura=true;   startAuraFarm()
            elseif v=="Tyrant of the Skie" then getgenv().FarmTyrant=true; startTyrantFarm()
            end
        end
    end
})

Tabs.Main:AddToggle({
    Name="Auto Farm",
    Default=false,
    Callback=function(v)
        getgenv().FarmLevel=false; getgenv().FarmBone=false; getgenv().FarmKata=false
        getgenv().FarmAura=false; getgenv().FarmTyrant=false; getgenv().FarmPhaBinh=false
        getgenv().AutoMaterial=false
        getgenv().Noclip=v; getgenv().IsFarming=v; getgenv().AutoBusoLoop=v
        if v and (SelectedFarm=="Farm Bone" or SelectedFarm=="Farm Kata" or SelectedFarm=="Tyrant of the Skie") and not World3 then
            getgenv().IsFarming=false
            Window:Notify({Title="Wrong World", Text="World 3 only!", Duration=4})
            return
        end
        if SelectedFarm=="Farm Level"          then getgenv().FarmLevel=v
        elseif SelectedFarm=="Farm Bone"       then getgenv().FarmBone=v
        elseif SelectedFarm=="Farm Kata"       then getgenv().FarmKata=v
        elseif SelectedFarm=="Farm Aura"       then getgenv().FarmAura=v
        elseif SelectedFarm=="Tyrant of the Skie" then getgenv().FarmTyrant=v
        end
        if v then
            startFly()
            if SelectedFarm=="Farm Level"          then startLevelFarm()
            elseif SelectedFarm=="Farm Bone"       then startBoneFarm()
            elseif SelectedFarm=="Farm Kata"       then startKataFarm()
            elseif SelectedFarm=="Farm Aura"       then startAuraFarm()
            elseif SelectedFarm=="Tyrant of the Skie" then startTyrantFarm()
            end
        else
            stopFly(); stopLevelFarm(); stopBoneFarm(); stopKataFarm()
            stopAuraFarm(); stopTyrantFarm(); stopPhaBinhFarm()
        end
    end
})

Tabs.Main:AddToggle({
    Name="Accept Quest", Default=false,
    Callback=function(v) getgenv().AcceptQuestC=v end
})

Tabs.Main:AddSection("Material Farm")

Tabs.Main:AddDropdown({
    Name="Select Material",
    Options=MaterialList,
    Default=MaterialList[1] or "None",
    Callback=function(v) getgenv().SelectMaterial=v end
})

Tabs.Main:AddToggle({
    Name="Auto Material",
    Default=false,
    Callback=function(v)
        getgenv().AutoMaterial=v; getgenv().IsFarming=v; getgenv().Noclip=v; getgenv().AutoBusoLoop=v
        if v then getgenv().FarmLevel=false; stopLevelFarm(); startFly()
        else stopFly() end
    end
})

--// ================= GUI: QUESTS =================
Tabs.Quests:AddSection("Elite Hunt")

Tabs.Quests:AddToggle({
    Name="Auto Elite Quest", Default=false,
    Callback=function(v)
        getgenv().FarmEliteHunt=v
        if v then
            local anyNormal=getgenv().FarmLevel or getgenv().FarmBone or getgenv().FarmKata
                or getgenv().FarmAura or getgenv().FarmTyrant or getgenv().AutoMaterial or getgenv().FarmDungeon
            if anyNormal and not getgenv().IsFarming then
                getgenv().IsFarming=true; getgenv().Noclip=true; getgenv().AutoBusoLoop=true; startFly()
            end
            if IsEliteAvailable() then
                local hasNormal=getgenv().FarmLevel or getgenv().FarmBone or getgenv().FarmKata
                    or getgenv().FarmAura or getgenv().FarmTyrant
                if hasNormal then PauseNormalFarm() end
                if not getgenv().IsFarming then
                    getgenv().IsFarming=true; getgenv().Noclip=true; getgenv().AutoBusoLoop=true; startFly()
                end
                startEliteHunt()
            end
            startEliteWatcher()
        else
            stopEliteHunt()
            local anyFarmActive=getgenv().FarmLevel or getgenv().FarmBone or getgenv().FarmKata
                or getgenv().FarmAura or getgenv().FarmTyrant or getgenv().AutoMaterial or getgenv().FarmDungeon
            if not anyFarmActive then
                getgenv().IsFarming=false; getgenv().Noclip=false; getgenv().AutoBusoLoop=false; stopFly()
            end
        end
    end
})

Tabs.Quests:AddSection("Sea Travel")

Tabs.Quests:AddToggle({
    Name="Auto Sea 2", Default=false,
    Callback=function(v)
        getgenv().TravelDres=v
        if v then getgenv().IsFarming=true; getgenv().Noclip=true; startFly()
        else
            local anyFarm=getgenv().FarmLevel or getgenv().FarmBone or getgenv().FarmKata
                or getgenv().FarmAura or getgenv().FarmTyrant or getgenv().AutoMaterial
                or getgenv().FarmDungeon or getgenv().AutoZou or getgenv().FarmEliteHunt
            if not anyFarm then getgenv().IsFarming=false; getgenv().Noclip=false; stopFly() end
        end
    end
})

spawn(function()
    while task.wait(Sec) do
        pcall(function()
            if not getgenv().TravelDres then return end
            if player.Data.Level.Value < 700 then return end
            local CommF=ReplicatedStorage.Remotes.CommF_
            local root=getRoot(); if not root then return end
            local map=workspace:FindFirstChild("Map")
            local ice=map and map:FindFirstChild("Ice")
            local door=ice and ice:FindFirstChild("Door")
            if not door then return end
            if door.CanCollide==true and door.Transparency==0 then
                CommF:InvokeServer("DressrosaQuestProgress","Detective")
                local keyTool=player.Backpack:FindFirstChild("Key")
                if keyTool and player.Character then player.Character.Humanoid:EquipTool(keyTool) end
                TweenToPos(CFrame.new(1347.7124,37.3751602,-1325.6488), getgenv().FlySpeed)
            elseif door.CanCollide==false and door.Transparency==1 then
                local admiral=GetNearestEnemy("Ice Admiral")
                if admiral and admiral:FindFirstChild("Humanoid") and admiral.Humanoid.Health>0 then
                    getgenv().CurrentTargetMob=admiral
                    local targetCF=GetFarmCFrame(admiral)
                    if targetCF then TweenToPos(targetCF, getgenv().FlySpeed) end
                    AttackEnemy(admiral)
                    if admiral.Humanoid.Health<=0 then task.wait(0.5); CommF:InvokeServer("TravelDressrosa") end
                else
                    getgenv().CurrentTargetMob=nil; CommF:InvokeServer("TravelDressrosa")
                end
            else
                CommF:InvokeServer("TravelDressrosa")
            end
        end)
    end
end)

Tabs.Quests:AddToggle({
    Name="Auto Sea 3", Default=false,
    Callback=function(v)
        getgenv().AutoZou=v
        if v then getgenv().IsFarming=true; getgenv().Noclip=true; startFly()
        else
            local anyFarm=getgenv().FarmLevel or getgenv().FarmBone or getgenv().FarmKata
                or getgenv().FarmAura or getgenv().FarmTyrant or getgenv().AutoMaterial
                or getgenv().FarmDungeon or getgenv().TravelDres or getgenv().FarmEliteHunt
            if not anyFarm then getgenv().IsFarming=false; getgenv().Noclip=false; stopFly() end
        end
    end
})

spawn(function()
    while task.wait(Sec) do
        pcall(function()
            if not getgenv().AutoZou then return end
            if player.Data.Level.Value < 1500 then return end
            local CommF=ReplicatedStorage.Remotes.CommF_
            local root=getRoot(); if not root then return end
            local bartiloProgress=CommF:InvokeServer("BartiloQuestProgress","Bartilo")
            if bartiloProgress==3 then
                local unlockables=CommF:InvokeServer("GetUnlockables")
                if unlockables and unlockables.FlamingoAccess~=nil then
                    CommF:InvokeServer("F_","TravelZou")
                else
                    CommF:InvokeServer("F_","TalkTrevor","1")
                    CommF:InvokeServer("F_","TalkTrevor","2")
                    CommF:InvokeServer("F_","TalkTrevor","3")
                end
            elseif bartiloProgress==0 then
                local swanPirate=GetNearestEnemy("Swan Pirate")
                if swanPirate and swanPirate:FindFirstChild("Humanoid") and swanPirate.Humanoid.Health>0 then
                    getgenv().CurrentTargetMob=swanPirate
                    local targetCF=GetFarmCFrame(swanPirate)
                    if targetCF then TweenToPos(targetCF, getgenv().FlySpeed) end
                    AttackEnemy(swanPirate)
                else
                    getgenv().CurrentTargetMob=nil
                    TweenToPos(CFrame.new(1057.92761,137.614319,1242.08069), getgenv().FlySpeed)
                end
            elseif bartiloProgress==1 then
                local jeremy=GetNearestEnemy("Jeremy")
                if jeremy and jeremy:FindFirstChild("Humanoid") and jeremy.Humanoid.Health>0 then
                    getgenv().CurrentTargetMob=jeremy
                    local targetCF=GetFarmCFrame(jeremy)
                    if targetCF then TweenToPos(targetCF, getgenv().FlySpeed) end
                    AttackEnemy(jeremy)
                else
                    getgenv().CurrentTargetMob=nil
                    TweenToPos(CFrame.new(2099.88159,448.931,648.997375), getgenv().FlySpeed)
                end
            elseif bartiloProgress==2 then
                getgenv().CurrentTargetMob=nil
                TweenToPos(CFrame.new(-1836,11,1714), getgenv().FlySpeed)
                task.wait(0.3)
                local checkpoints={
                    CFrame.new(-1850.49329,13.1789551,1750.89685),
                    CFrame.new(-1858.87305,19.3777466,1712.01807),
                    CFrame.new(-1803.94324,16.5789185,1750.89685),
                    CFrame.new(-1858.55835,16.8604317,1724.79541),
                    CFrame.new(-1869.54224,15.987854,1681.00659),
                    CFrame.new(-1800.0979,16.4978027,1684.52368),
                    CFrame.new(-1819.26343,14.795166,1717.90625),
                    CFrame.new(-1813.51843,14.8604736,1724.79541),
                }
                for _,cp in ipairs(checkpoints) do
                    if not getgenv().AutoZou then break end
                    local r=getRoot(); if r then r.CFrame=cp end
                    task.wait(0.12)
                end
            end
        end)
    end
end)

--// ================= GUI: STATS =================
Tabs.Stats:AddSection("Stats Upgrade")

Tabs.Stats:AddSlider({
    Name="Stats Value", Min=0, Max=1000, Default=1,
    Callback=function(v) getgenv().pSats=v end
})

local statTypes = {
    {Name="Auto Melee",       flag="Auto_Melee",      statKey="Melee"},
    {Name="Auto Sword",       flag="Auto_Sword",      statKey="Sword"},
    {Name="Auto Gun",         flag="Auto_Gun",        statKey="Gun"},
    {Name="Auto Blox Fruit",  flag="Auto_DevilFruit", statKey="Devil"},
    {Name="Auto Defense",     flag="Auto_Defense",    statKey="Defense"},
}
for _, s in ipairs(statTypes) do
    local statKey = s.statKey
    local flagKey = s.flag
    Tabs.Stats:AddToggle({
        Name=s.Name, Default=false,
        Callback=function(v) getgenv()[flagKey]=v end
    })
    spawn(function()
        while task.wait(0.1) do
            pcall(function()
                if getgenv()[flagKey] then
                    local pontos = player.Data.Points.Value
                    if pontos > 0 then
                        local points = getgenv().pSats or 1
                        local toAdd = math.min(points, pontos)
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", statKey, toAdd)
                    end
                end
            end)
        end
    end)
end

--// ================= GUI: DUNGEON =================
Tabs.FruitRaid:AddSection("Dungeon Farm")
Tabs.FruitRaid:AddToggle({
    Name="Auto Dungeon Farm", Default=false,
    Callback=function(v)
        getgenv().FarmDungeon=v; getgenv().Noclip=v; getgenv().AutoBusoLoop=v
        if v then
            if game.PlaceId~=DungeonPlaceId then
                Window:Notify({Title="Wrong PlaceId", Text="Dungeon only!", Duration=5})
                getgenv().FarmDungeon=false; getgenv().Noclip=false; getgenv().AutoBusoLoop=false; return
            end
            getgenv().IsFarming=true; startFly(); startDungeonFarm()
        else
            stopDungeonFarm()
            local anyFarmActive=getgenv().FarmLevel or getgenv().FarmBone or getgenv().FarmKata
                or getgenv().FarmAura or getgenv().FarmTyrant or getgenv().FarmEliteHunt or getgenv().AutoMaterial
            if not anyFarmActive then
                getgenv().IsFarming=false; getgenv().Noclip=false; getgenv().AutoBusoLoop=false; stopFly()
            end
        end
    end
})

-- Raid Section
local function GetBP(itemName)
    for _,v in pairs(player.Backpack:GetChildren()) do if v.Name==itemName then return true end end
    for _,v in pairs(player.Character and player.Character:GetChildren() or {}) do if v.Name==itemName then return true end end
    return false
end
local function _tp(cf) local root=getRoot(); if root then root.CFrame=cf end end
local function IsInRaid()
    local ok,result=pcall(function() return player.PlayerGui.Main.TopHUDList.RaidTimer.Visible end)
    return ok and result==true
end
local function IsIslandRaid(cu)
    local ok,locs=pcall(function() return workspace["_WorldOrigin"].Locations end)
    if not ok or not locs then return nil end
    local best,bestDist=nil,math.huge
    for _,v in ipairs(locs:GetChildren()) do
        if v.Name=="Island "..cu then
            local root=getRoot()
            if root then
                local dist=(v.Position-root.Position).Magnitude
                if dist<bestDist then bestDist=dist; best=v end
            end
        end
    end
    if best and bestDist<=4500 then return best end
    return nil
end
local function getNextRaidIsland()
    for _,id in ipairs({5,4,3,2,1}) do
        local island=IsIslandRaid(id); if island then return island end
    end
    return nil
end

Tabs.FruitRaid:AddSection("Raiding")
Tabs.FruitRaid:AddDropdown({
    Name="Select Chip",
    Options={"Flame","Ice","Quake","Light","Dark","String","Rumble","Magma","Human: Buddha","Sand","Bird: Phoenix","Dough"},
    Default="Ice",
    Callback=function(v) getgenv().SelectChip=v end
})

local raidFarmConn=nil
Tabs.FruitRaid:AddToggle({
    Name="Auto Raid", Default=false,
    Callback=function(v)
        getgenv().AutoRaid=v
        if not v then
            if raidFarmConn then raidFarmConn:Disconnect(); raidFarmConn=nil end
            getgenv().CurrentTargetMob=nil
            local anyFarmActive=getgenv().FarmLevel or getgenv().FarmBone or getgenv().FarmKata
                or getgenv().FarmAura or getgenv().FarmTyrant or getgenv().AutoMaterial or getgenv().FarmDungeon
            if not anyFarmActive then
                getgenv().IsFarming=false; getgenv().AutoBusoLoop=false; getgenv().Noclip=false; stopFly()
            end
            return
        end
        getgenv().IsFarming=true; getgenv().Noclip=true; getgenv().AutoBusoLoop=true; startFly()
        task.spawn(function()
            while getgenv().AutoRaid do
                pcall(function()
                    if not IsInRaid() and not GetBP("Special Microchip") then
                        pcall(function()
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNpc","Select",getgenv().SelectChip or "Ice")
                        end)
                        task.wait(0.5)
                    end
                    if not IsInRaid() and GetBP("Special Microchip") then
                        if World2 then
                            _tp(CFrame.new(-6438.73535,250.645355,-4501.50684)); task.wait(0.3)
                            pcall(function() fireclickdetector(workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector) end)
                        elseif World3 then
                            pcall(function()
                                ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-5097.93164,316.447021,-3142.66602))
                            end)
                            task.wait(0.3)
                            pcall(function() fireclickdetector(workspace.Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector) end)
                        end
                        local deadline=tick()+30
                        repeat task.wait(0.5) until IsInRaid() or tick()>deadline or not getgenv().AutoRaid
                        task.wait(1)
                    end
                    if IsInRaid() then
                        if raidFarmConn then raidFarmConn:Disconnect(); raidFarmConn=nil end
                        raidFarmConn=RunService.Heartbeat:Connect(function()
                            if not getgenv().AutoRaid then return end
                            if not IsInRaid() then
                                if raidFarmConn then raidFarmConn:Disconnect(); raidFarmConn=nil end
                                getgenv().CurrentTargetMob=nil; return
                            end
                            local root=getRoot(); if not root then return end
                            local nearest,nearestDist=nil,math.huge
                            for _,mob in pairs(workspace.Enemies:GetChildren()) do
                                if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health>0 then
                                    local dist=(mob.HumanoidRootPart.Position-root.Position).Magnitude
                                    if dist<=2000 and dist<nearestDist then nearestDist=dist; nearest=mob end
                                end
                            end
                            getgenv().CurrentTargetMob=nearest
                            if nearest then
                                local targetCF=GetFarmCFrame(nearest)
                                if targetCF then TweenObject(root,targetCF,getgenv().FlySpeed) end
                                AttackEnemy(nearest)
                            else
                                local nextIsland=getNextRaidIsland()
                                if nextIsland then TweenObject(root,nextIsland.CFrame*CFrame.new(0,50,0),getgenv().FlySpeed) end
                            end
                        end)
                        repeat task.wait(1) until not IsInRaid() or not getgenv().AutoRaid
                        if raidFarmConn then raidFarmConn:Disconnect(); raidFarmConn=nil end
                        getgenv().CurrentTargetMob=nil
                    end
                end)
                task.wait(1)
            end
        end)
    end
})

--// ================= GUI: TRAVEL =================
local IslandData = {
    world1 = {
        {name="Marine Start",    pos=Vector3.new(-2573.34,15.89,2047.00)},
        {name="Start Island",    pos=Vector3.new(1071.28,25.31,1426.87)},
        {name="Middle Town",     pos=Vector3.new(-655.82,15.89,1436.68)},
        {name="Jungle",          pos=Vector3.new(-1249.77,20.89,341.36)},
        {name="Pirate Village",  pos=Vector3.new(-1122.35,10.79,3855.92)},
        {name="Desert",          pos=Vector3.new(1094.15,15.47,4192.89)},
        {name="Frozen Village",  pos=Vector3.new(1198.01,35.01,-1211.73)},
        {name="MarineFord",      pos=Vector3.new(-4505.38,30.69,4260.56)},
        {name="Fountain City",   pos=Vector3.new(5132.71,10.54,4037.86)},
        {name="Colosseum",       pos=Vector3.new(-1428.35,15.39,-3014.37)},
        {name="Sky 1",           pos=Vector3.new(-4970.22,717.71,-2622.35)},
        {name="Sky 2",           pos=Vector3.new(-4607.82,872.58,-1667.56)},
        {name="Sky 3",           pos=Vector3.new(-7894.62,5545.49,-380.25)},
        {name="Magma Village",   pos=Vector3.new(-5231.76,15.62,8467.88)},
        {name="Prison",          pos=Vector3.new(4854.16,15.17,740.19)},
        {name="Underwater City", pos=Vector3.new(61163.85,5.34,1819.78)},
        {name="Whirlpool",       pos=Vector3.new(3864.69,5.41,-1926.21)},
    },
    world2 = {
        {name="Magma Side",       pos=Vector3.new(-5478.39,30.98,-5246.91)},
        {name="Ghost Island",     pos=Vector3.new(-5571.84,200.18,-795.43)},
        {name="Hot and Cold",     pos=Vector3.new(-6026.96,20.75,-5071.96)},
        {name="First Spot",       pos=Vector3.new(82.95,25.07,2834.99)},
        {name="Snow Mountain",    pos=Vector3.new(1384.68,470.57,-4990.10)},
        {name="Green Bit",        pos=Vector3.new(-2372.15,80.99,-3166.51)},
        {name="Cafe",             pos=Vector3.new(-385.25,80.05,297.39)},
        {name="Forgotten Island", pos=Vector3.new(-3043.32,250.88,-10191.58)},
        {name="Frosted Island",   pos=Vector3.new(5400.40,35.22,-6236.99)},
        {name="Ghost Ship",       pos=Vector3.new(923.21,135.98,32852.83)},
    },
    world3 = {
        {name="Hydar Island",     pos=Vector3.new(3567.22,51.38,1927.11)},
        {name="Peanut Island",    pos=Vector3.new(-1943.60,44.90,-10288.01)},
        {name="Ice Cream Island", pos=Vector3.new(-950.00,59.00,-10907.00)},
        {name="Tiki",             pos=Vector3.new(-16813.44,58.29,304.87)},
        {name="Haunted Castle",   pos=Vector3.new(-9387.11,141.36,5616.04)},
        {name="Mansion",          pos=Vector3.new(-12463.81,374.95,-7550.29)},
        {name="Port Town",        pos=Vector3.new(-306.00,20.65,5557.35)},
        {name="Great Tree",       pos=Vector3.new(2262.59,28.96,-6462.95)},
        {name="CakeLoaf",         pos=Vector3.new(-2106.07,45.10,-11908.52)},
        {name="Castle on the Sea",pos=Vector3.new(-5047.54,314.55,-3159.34)},
        {name="North Poles",      pos=Vector3.new(-986.51,26.67,-14087.59)},
        {name="Cacao Island",     pos=Vector3.new(471.13,42.35,-12212.00)},
        {name="Submerged Island", pos=Vector3.new(11520.80,-2154.99,9829.51), special=true},
    },
}

local currentWorldKey = World1 and "world1" or World2 and "world2" or "world3"
local currentIslandList = IslandData[currentWorldKey]
local currentIslandNames = {}
local islandMap = {}
for _, v in ipairs(currentIslandList) do
    table.insert(currentIslandNames, v.name)
    islandMap[v.name] = v
end

local NPCList = {}
task.wait(3)
pcall(function()
    for _, v in pairs(ReplicatedStorage.NPCs:GetChildren()) do table.insert(NPCList, v.Name) end
    table.sort(NPCList)
end)
if #NPCList == 0 then NPCList = {"(No NPC)"} end

local selectedIslandName = currentIslandNames[1] or ""
local selectedNPC        = NPCList[1] or ""

Tabs.Travel:AddSection("Travel - Worlds")
Tabs.Travel:AddButton({
    Name="Travel East Blue (World 1)",
    Callback=function() pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelMain") end) end
})
Tabs.Travel:AddButton({
    Name="Travel Dressrosa (World 2)",
    Callback=function() pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa") end) end
})
Tabs.Travel:AddButton({
    Name="Travel Zou (World 3)",
    Callback=function() pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou") end) end
})

Tabs.Travel:AddSection("Travel - Island")
Tabs.Travel:AddDropdown({
    Name="Select Island", Options=currentIslandNames, Default=currentIslandNames[1],
    Callback=function(v) selectedIslandName=v end
})

Tabs.Travel:AddToggle({
    Name="Fly to Island", Default=false,
    Callback=function(v)
        getgenv().TravelToIsland=v
        if not v then
            local anyFarmActive=getgenv().FarmLevel or getgenv().FarmBone or getgenv().FarmKata
                or getgenv().FarmAura or getgenv().FarmTyrant or getgenv().AutoMaterial or getgenv().FarmDungeon or getgenv().AutoRaid
            if not anyFarmActive then getgenv().IsFarming=false; stopFly() end
            return
        end
        local data=islandMap[selectedIslandName]; if not data then return end
        getgenv().IsFarming=true; startFly()
        task.spawn(function()
            pcall(function()
                if data.special then TeleportToSubmerged(); getgenv().TravelToIsland=false; return end
                local targetCF=CFrame.new(data.pos+Vector3.new(0,5,0))
                doIntermediateTeleport(data.pos)
                TweenToPos(targetCF, getgenv().FlySpeed or 300)
                local deadline=tick()+60
                repeat
                    task.wait(0.3)
                    local root=getRoot(); if not root then break end
                    if (root.Position-data.pos).Magnitude<=100 then break end
                until tick()>deadline or not getgenv().TravelToIsland
                getgenv().TravelToIsland=false
                local anyFarmActive=getgenv().FarmLevel or getgenv().FarmBone or getgenv().FarmKata
                    or getgenv().FarmAura or getgenv().FarmTyrant or getgenv().AutoMaterial or getgenv().FarmDungeon or getgenv().AutoRaid
                if not anyFarmActive then getgenv().IsFarming=false; stopFly() end
            end)
        end)
    end
})

Tabs.Travel:AddSection("Travel - NPC")
Tabs.Travel:AddDropdown({
    Name="Select NPC", Options=NPCList, Default=NPCList[1],
    Callback=function(v) selectedNPC=v end
})
Tabs.Travel:AddToggle({
    Name="Auto Tween to NPC", Default=false,
    Callback=function(v)
        getgenv().TPNpc=v
        if v then getgenv().IsFarming=true; startFly()
        else
            local anyFarmActive=getgenv().FarmLevel or getgenv().FarmBone or getgenv().FarmKata
                or getgenv().FarmAura or getgenv().FarmTyrant or getgenv().AutoMaterial or getgenv().FarmDungeon or getgenv().AutoRaid
            if not anyFarmActive then getgenv().IsFarming=false; stopFly() end
        end
    end
})
spawn(function()
    while task.wait(Sec) do
        if getgenv().TPNpc then
            pcall(function()
                for _, v in pairs(ReplicatedStorage.NPCs:GetChildren()) do
                    if v.Name == selectedNPC and v:FindFirstChild("HumanoidRootPart") then
                        doIntermediateTeleport(v.HumanoidRootPart.Position)
                        TweenToPos(v.HumanoidRootPart.CFrame, getgenv().FlySpeed or 300)
                        break
                    end
                end
            end)
        end
    end
end)

--// ================= GUI: SHOP =================
local FightingStyleData = {
    BlackLeg     = {world1=Vector3.new(-984,17,3990),     world2=Vector3.new(-4753,37,-4853),  world3=Vector3.new(-5050,374,-3183),  remote=function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyBlackLeg") end},
    Electro      = {world1=Vector3.new(-5383,17,-2149),   world2=Vector3.new(-4960,39,-4663),  world3=Vector3.new(-5000,317,-3201),  remote=function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyElectro") end},
    FishmanKarate= {world1=Vector3.new(61586,23,987),     world2=Vector3.new(-4870,37,-4769),  world3=Vector3.new(-5026,375,-3196),  remote=function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyFishmanKarate") end},
    DragonClaw   = {world1=nil, world2=Vector3.new(695,189,654),     world3=Vector3.new(-4983,374,-3213), remote=function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2") end},
    Superhuman   = {world1=nil, world2=Vector3.new(1380,250,-5188),  world3=Vector3.new(-5007,374,-3203), remote=function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySuperhuman") end},
    DeathStep    = {world1=nil, world2=Vector3.new(6352,300,-6762),  world3=Vector3.new(-5002,318,-3225), remote=function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyDeathStep") end},
    SharkmanKarate={world1=nil,world2=Vector3.new(-2604,242,-10318), world3=Vector3.new(-4969,317,-3226), remote=function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySharkmanKarate") end},
    ElectricClaw = {world1=nil, world2=nil, world3=Vector3.new(-10373,334,-10136), remote=function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyElectricClaw") end},
    DragonTalon  = {world1=nil, world2=nil, world3=Vector3.new(5659,1214,859),    remote=function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyDragonTalon") end},
    Godhuman     = {world1=nil, world2=nil, world3=Vector3.new(-13771,337,-9881), remote=function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyGodhuman") end},
    SanguineArt  = {world1=nil, world2=nil, world3=Vector3.new(-16517,26,-185),   remote=function() ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySanguineArt") end},
}

local function BuyFightingStyle(styleName, styleData)
    local targetPos = styleData[currentWorldKey]
    if not targetPos then
        Window:Notify({Title="No NPC", Text=styleName.." has no NPC in this world!", Duration=4})
        return
    end
    coroutine.wrap(function()
        pcall(function()
            getgenv().IsFarming=true; startFly()
            local targetCF=CFrame.new(targetPos+Vector3.new(0,3,0))
            TweenToPos(targetCF, getgenv().FlySpeed or 300)
            local deadline=tick()+30
            repeat
                task.wait(0.2)
                local r=getRoot(); if not r then break end
                if (r.Position-targetPos).Magnitude<=150 then break end
            until tick()>deadline
            local r=getRoot()
            if r and (r.Position-targetPos).Magnitude<=150 then
                task.wait(0.3); styleData.remote()
                Window:Notify({Title="Bought!", Text="Sent request for "..styleName, Duration=4})
            end
            local anyFarmActive=getgenv().FarmLevel or getgenv().FarmBone or getgenv().FarmKata
                or getgenv().FarmAura or getgenv().FarmTyrant or getgenv().AutoMaterial or getgenv().FarmDungeon
            if not anyFarmActive then getgenv().IsFarming=false; stopFly() end
        end)
    end)()
end

Tabs.Shop:AddSection("Fighting Style")
local shopStyles = {
    {key="BlackLeg",      name="Black Leg"},
    {key="Electro",       name="Electro"},
    {key="FishmanKarate", name="Fishman Karate"},
    {key="DragonClaw",    name="Dragon Claw"},
    {key="Superhuman",    name="Superhuman"},
    {key="DeathStep",     name="Death Step"},
    {key="SharkmanKarate",name="Sharkman Karate"},
    {key="ElectricClaw",  name="Electric Claw"},
    {key="DragonTalon",   name="Dragon Talon"},
    {key="Godhuman",      name="Godhuman"},
    {key="SanguineArt",   name="Sanguine Art"},
}
for _, s in ipairs(shopStyles) do
    if FightingStyleData[s.key] and FightingStyleData[s.key][currentWorldKey] then
        local styleData = FightingStyleData[s.key]
        local styleName = s.name
        Tabs.Shop:AddButton({
            Name="Buy "..styleName,
            Callback=function() BuyFightingStyle(styleName, styleData) end
        })
    end
end

--// ================= NOTIFY LOADED =================
Window:Notify({
    Title   = "Topi Hub",
    Text    = "Script loaded! All features ready.",
    Duration = 5
})
