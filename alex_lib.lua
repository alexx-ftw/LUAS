---@meta
-- Library of functions for Team Fortress 2 scripts

-- TF2 Classes ints
---@type table
TF2_CLASSES = {
    SCOUT = 1,
    SNIPER = 2,
    SOLDIER = 3,
    DEMOMAN = 4,
    MEDIC = 5,
    HEAVY = 6,
    PYRO = 7,
    SPY = 8,
    ENGINEER = 9
}

---Get distance between two entities
---@param entity1 Entity
---@param entity2 Entity
---@return number
function distance(entity1, entity2)
    local pos1 = entity1:GetAbsOrigin()
    local pos2 = entity2:GetAbsOrigin()
    return (pos1 - pos2):Length()
end

---Get the angles between two positions
---@param source Vector3
---@param dest Vector3
---@return EulerAngles
function positionAngles(source, dest)
    local M_RADPI = 180 / math.pi
    local delta = source - dest
    local pitch = math.atan(delta.z / delta:Length2D()) * M_RADPI
    local yaw = math.atan(delta.y / delta.x) * M_RADPI
    yaw = delta.x >= 0 and yaw + 180 or yaw
    return EulerAngles(pitch, yaw, 0)
end

---Get all players in the game
---@return table
function getPlayers()
    local players = entities.FindByClass("CTFPlayer")
    return players
end

---Get the class of a player
---@param player Entity
---@return integer
function get_player_class(player)
    return player:GetPropInt("m_iClass")
end

---Announce a message in chat
---@param script_name string
---@param msg string
function announce(script_name, msg)
    client.ChatPrintf(string.format("\x0700ff00[" .. script_name .. "] %s", msg))
end

return {
    TF2_CLASSES = TF2_CLASSES,
    distance = distance,
    positionAngles = positionAngles,
    getPlayers = getPlayers,
    get_player_class = get_player_class,
    announce = announce
}
