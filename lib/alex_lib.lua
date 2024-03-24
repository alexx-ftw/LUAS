-- Author: Alex
-- Last Modified: 18/03/2024
-- Description: Library of functions for Team Fortress 2 scripts

-- TF2 Classes ints
local TF2_CLASSES = {
    SCOUT = 1,
    SOLDIER = 3,
    PYRO = 7,
    DEMOMAN = 4,
    HEAVY = 6,
    ENGINEER = 9,
    MEDIC = 5,
    SNIPER = 2,
    SPY = 8
}

---Get distance between two entities
---@param entity1 Entity
---@param entity2 Entity
local function distance(entity1, entity2)
    local pos1 = entity1:GetAbsOrigin()
    local pos2 = entity2:GetAbsOrigin()
    return (pos1 - pos2):Length()
end

-- Calculate angle between two points
local function positionAngles(source, dest)
    local M_RADPI = 180 / math.pi
    local delta = source - dest
    local pitch = math.atan(delta.z / delta:Length2D()) * M_RADPI
    local yaw = math.atan(delta.y / delta.x) * M_RADPI
    yaw = delta.x >= 0 and yaw + 180 or yaw
    return EulerAngles(pitch, yaw, 0)
end

-- Print if verbose is true
local function printifv(str)
    if config.verbose then
        print(str)
    end
end

local function getPlayers()
    local players = entities.FindByClass("CTFPlayer")
    return players
end

---Get the class of a player
---@param player Entity
---@return integer
local function get_player_class(player)
    return player:GetPropInt("m_iClass")
end
---Announce a message in chat
---@param script_name string
---@param msg string
local function announce(script_name, msg)
    client.ChatPrintf(string.format("\x073475c9[" .. script_name .. "] \x01%s", msg))
end

-- Return the library
return {
    TF2_CLASSES = TF2_CLASSES,
    distance = distance,
    positionAngles = positionAngles,
    printifv = printifv,
    getPlayers = getPlayers,
    get_player_class = get_player_class,
    announce = announce
}
