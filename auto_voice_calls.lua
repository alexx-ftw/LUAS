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
local alex_lib = require("LUAS\\alex_lib")
if not alex_lib then
    error("alex_lib not found")
end


-- Define the function to voice out the message
Last_medic_call_time = 0
Last_spy_call_time = 0
Overall_last_call_time = 0
-- Make a call once every second
local function onCreateMove()
    local call_made = false
    -- Get the local player
    local Me = entities.GetLocalPlayer()
    if not Me then return end

    -- Get all the players
    local players = alex_lib.getPlayers()
    local time_between_calls = 10

    -- Loop through all the players
    time_between_calls = 12
    local spy_distance = 800
    for _, player in pairs(players) do
        -- Check if the player is an enemy spy and is near.
        -- Make spy call only once every "time_between_calls" seconds
        if player:GetTeamNumber() ~= Me:GetTeamNumber() and player:GetPropInt("m_iClass") == alex_lib.TF2_CLASSES.SPY and alex_lib.distance(Me, player) < spy_distance and globals.CurTime() - Last_spy_call_time > time_between_calls and not call_made then
            client.Command("voicemenu 1 1", true)
            Last_spy_call_time = globals.CurTime()
            Last_call_type = "Spy"
            call_made = true
            alex_lib.printifv("Spy")
        end
    end

    -- Check if the local player is low on health
    -- Make medic call only once every "time_between_calls" seconds and only if not being healed
    time_between_calls = 6
    if Me:GetHealth() < Me:GetMaxHealth() and not Me:GetPropBool("m_bHealing") and globals.CurTime() - Last_medic_call_time > time_between_calls and not call_made then
        client.Command("voicemenu 0 0", true)
        Last_medic_call_time = globals.CurTime()
        Last_call_type = "Medic"
        call_made = true
        alex_lib.printifv("Medic")
    end
end

-- Add a callback to Draw
callbacks.Unregister("CreateMove", config.scriptName)
callbacks.Register("CreateMove", config.scriptName, onCreateMove)

print("Loaded " .. config.scriptName)