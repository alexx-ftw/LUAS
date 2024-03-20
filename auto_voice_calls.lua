-- This is a helper script for Team Fortress 2
-- It will voice out things such as:
-- - "Spy" when one is near
-- - "Medic" when low on health
-- It will use comments to explain the code and the logic behind it

-- Define the configuration
config = {
    scriptName = "Auto Voice Calls",
    verbose = false
}

-- Print the name of the script and the verbose setting
print("Loading " .. config.scriptName .. "...")
print("Verbose: " .. tostring(config.verbose))

-- Load the required libraries and throw an error if they are not found and exit the script
local localappdata = os.getenv("LOCALAPPDATA")
local alex_lib = require(localappdata .. "\\LUAS\\alex_lib")
if not alex_lib then
    error("alex_lib not found")
end

---Check if there is a spy near and voice out the message
---@param players table
local function spy_call(players)
    -- Loop through all the players
    local time_between_calls = 12
    local spy_distance = 100
    for _, player in pairs(players) do
        -- Check if the player is an enemy spy and is near.
        -- Make spy call only once every "time_between_calls" seconds
        if player:GetTeamNumber() ~= Me:GetTeamNumber() and player:GetPropInt("m_iClass") == alex_lib.TF2_CLASSES.SPY and alex_lib.distance(Me, player) < spy_distance and globals.CurTime() - Last_spy_call_time > time_between_calls and not Call_made then
            client.Command("voicemenu 1 1", true)
            Last_spy_call_time = globals.CurTime()
            Last_call_type = "Spy"
            Call_made = true
            alex_lib.printifv("Spy")
        end
    end
end

---Make a call to the medic if the player is low on health

local function medic_call()
    local time_between_calls = 6
    if Me:GetHealth() < Me:GetMaxHealth() and not Me:GetPropBool("m_bHealing") and globals.CurTime() - Last_medic_call_time > time_between_calls and not Call_made then
        client.Command("voicemenu 0 0", true)
        Last_medic_call_time = globals.CurTime()
        Last_call_type = "Medic"
        Call_made = true
        alex_lib.printifv("Medic")
    end
end

-- Define the function to voice out the message
Last_medic_call_time = 0
Last_spy_call_time = 0
Overall_last_call_time = 0
Call_made = false
-- Make a call once every second
local function onCreateMove()

    -- Get the local player
    local Me = entities.GetLocalPlayer()
    if not Me then return end

    -- Get all the players
    local players = alex_lib.getPlayers()

    -- Spy call
    spy_call(players)

    -- Medic call
    medic_call()
end

-- Add a callback to Draw
callbacks.Unregister("CreateMove", config.scriptName)
callbacks.Register("CreateMove", config.scriptName, onCreateMove)

print("Loaded " .. config.scriptName)
