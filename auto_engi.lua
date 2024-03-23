-- This is a helper script for TF2 Engineer class
-- It will try to keep any building at reach at full health

config = {
    scriptName = "Engineer Auto-Fix Buildings",
    verbose = false
}
print("Loading " .. config.scriptName .. "...")

-- Load the required libraries and throw an error if they are not found and exit the script
local localappdata = os.getenv("LOCALAPPDATA")
local al = require(localappdata .. "\\LUAS\\alex_lib")
if not al then
    error("alex_lib not found")
end

-- Filter for entities whose Class has "Sentry" in it
local function getSentryguns()
    local sentryguns = entities.FindByClass("CObjectSentrygun")
    local sentryguns_list = {}
    for _, sentrygun in pairs(sentryguns) do
        table.insert(sentryguns_list, sentrygun)
    end
    return sentryguns_list
end

-- Filter for entities whose Class has "Dispenser" in it
local function getDispensers()
    local dispensers = entities.FindByClass("CObjectDispenser")
    local dispensers_list = {}
    for _, dispenser in pairs(dispensers) do
        table.insert(dispensers_list, dispenser)
    end
    return dispensers_list
end

-- Filter for entities whose Class has "Teleporter" in it
local function getTeleporters()
    local teleporters = entities.FindByClass("CObjectTeleporter")
    local teleporters_list = {}
    for _, teleporter in pairs(teleporters) do
        table.insert(teleporters_list, teleporter)
    end
    return teleporters_list
end

Engineer_Melee_Weapons_List = {
    "CTFWrench",
    "CTFRobotArm"
}
---If there is a sentrygun closer than Melee range, attack it
---@param cmd any
---@param building Entity
local function repairBuilding(cmd, building)
    -- Check if the sentrygun is within melee range
    -- Use the Alex's Library function to get the distance between the player and the building
    if Me and al.distance(Me, building) <= 105 then
        -- Get equipped weapon
        local weapon = Me:GetPropEntity("m_hActiveWeapon")
        al.printifv("Equipped weapon: " .. weapon:GetClass())
        -- Check if the weapon is in the list of melee weapons
        local weapon_is_melee = false
        for _, melee_weapon in pairs(Engineer_Melee_Weapons_List) do
            if weapon:GetClass() == melee_weapon then
                weapon_is_melee = true
                break
            end
        end
        -- If the weapon is not a melee weapon, skip
        if not weapon_is_melee then
            al.printifv("Equipped weapon is not a melee weapon")
            return
        end
        -- Set the view angles to the building
        local angles = al.positionAngles(Me:GetAbsOrigin(), building:GetAbsOrigin())
        cmd:SetViewAngles(angles:Unpack())
        -- Attack the building
        cmd:SetButtons(cmd:GetButtons() | 1) -- Attack
    end
end

local function onCreateMove(cmd)
    -- Get ticks per second
    local tickrate = 1 / globals.TickInterval() --66

    -- Get the local player
    Me = entities.GetLocalPlayer()

    -- Check if the player is valid and is alive and if right click is not pressed
    if Me and Me:IsAlive() and not cmd:KeyDown(2) then
        -- Check if the player is an engineer
        if al.get_player_class(Me) ~= al.TF2_CLASSES.ENGINEER then
            al.printifv("You are not an Engineer")
            return
        end
        Buildings = {}
        -- Get all sentryguns
        local sentryguns = getSentryguns()
        local dispensers = getDispensers()
        local teleporters = getTeleporters()
        -- Add buildings to the list
        for _, sentrygun in pairs(sentryguns) do
            table.insert(Buildings, sentrygun)
        end
        for _, dispenser in pairs(dispensers) do
            table.insert(Buildings, dispenser)
        end
        for _, teleporter in pairs(teleporters) do
            table.insert(Buildings, teleporter)
        end
        al.printifv("Found " .. #Buildings .. " buildings")
        -- Get local player
        -- Get the player's team
        local friend_team = Me:GetTeamNumber()

        -- Get buildings at reach
        local buildingsAtReach = {}
        for _, building in pairs(Buildings) do
            if al.distance(Me, building) <= 105 then
                table.insert(buildingsAtReach, building)
            end
        end
        al.printifv("Of wich " .. #buildingsAtReach .. " are at reach")

        -- Identify the building with the lowest health
        local lowestHealth = 9999
        local lowestHealthBuilding = nil
        for _, building in pairs(buildingsAtReach) do
            local building_health = building:GetHealth()
            if building_health < lowestHealth then
                lowestHealth = building_health
                lowestHealthBuilding = building
            end
        end

        -- Repair the building with the lowest health
        -- Check if the player is on the same team as the building
        if lowestHealthBuilding and lowestHealthBuilding:GetTeamNumber() == friend_team then
            -- If the building is damaged or needs ammo, or is below level 3, repair it
            local building_health = lowestHealthBuilding:GetHealth()
            local building_max_health = lowestHealthBuilding:GetMaxHealth()
            al.printifv("Building health: " .. building_health .. "/" .. building_max_health)

            local building_level = lowestHealthBuilding:GetPropInt("m_iUpgradeLevel")
            al.printifv("Building level: " .. building_level)

            -- If is a sentrygun, check ammo
            local building_ammo = 200
            if lowestHealthBuilding:GetClass():find("Sentry") then
                building_ammo = lowestHealthBuilding:GetPropInt("m_iAmmoShells")
                al.printifv("Building ammo: " .. building_ammo)
            end

            if building_health < building_max_health or building_ammo < 200 or building_level < 3 then
                -- Skip if the building is being carried or is about to be built
                if lowestHealthBuilding:GetPropBool("m_bCarried") then
                    al.printifv("Building is being carried")
                else
                    -- If the building is at max health and ammo, and player has less than 50 metal, skip
                    local ammoTable = Me:GetPropDataTableInt("localdata", "m_iAmmo")
                    local metal = ammoTable[4]
                    al.printifv("Player metal: " .. metal)
                    if building_health == building_max_health and building_ammo > 100 and metal <= 50 then
                        al.printifv("Player has less than 50 metal")
                    else
                        al.printifv("Repairing building " .. lowestHealthBuilding:GetClass())
                        repairBuilding(cmd, lowestHealthBuilding)
                    end
                end
            end
        end
    end
end
-- Add a callback to Draw
callbacks.Unregister("CreateMove", "Engineer Auto-Fix Buildings")
callbacks.Register("CreateMove", "Engineer Auto-Fix Buildings", onCreateMove)

print("Loaded " .. config.scriptName)
