--------------------------------------------------------------------------------
--// 1️⃣  LOAD LIBRARIES
--------------------------------------------------------------------------------
local MrLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/YT-MrXT/lab/refs/heads/main/cat/libary/mrxtlibz"))()

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

local function stopKataFarm()
    if farmLoops.kata then farmLoops.kata:Disconnect(); farmLoops.kata = nil end
end

