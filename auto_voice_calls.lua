-- This is a helper script for Team Fortress 2
-- It will voice out things such as:
-- - "Spy" when one is near
-- - "Medic" when low on health
-- It will use comments to explain the code and the logic behind it


local script = {
    scriptName = "Auto Voice Calls",
    verbose = true,
    version = "1.0.0",
    printifv = function(self, message)
        if self.verbose then
            print(message)
        end
    end
}




-- Print the name of the script and the verbose setting
print("Loading " .. script.scriptName .. "...")

-- Load the required libraries and throw an error if they are not found and exit the script
require ".\\LUAS\\alex_lib"
-- Check if the library was loaded and throw an error if it wasn't
if not TF2_CLASSES then
    error("The library is not loaded. Please load the library first.")
end

-- Script variables
local Me = nil
local Players = {}
local Last_call_time = 0
local Min_time_between_calls = 1
local call_made = false

---Check if there is any spy nearby and voice out the message
local function spy_call()
    -- Loop through all the players
    local time_between_calls = 12
    local spy_distance = 400
    for _, Player in pairs(Players) do
        -- Check if the player is an enemy spy and is near.
        if Me and Player:GetTeamNumber() ~= Me:GetTeamNumber()
            and get_player_class(Player) == TF2_CLASSES.SPY
            and distance(Me, Player) < spy_distance
            and globals.CurTime() - Last_call_time > time_between_calls
            and not call_made then
            client.Command("voicemenu 1 1", true)
            Last_call_time = globals.CurTime()
            call_made = true
            script.printifv("Spy")
        end
    end
end

---Check if the player is low on health and voice out the message
local function medic_call()
    script.printifv("Checking for Medic")
    local time_between_calls = 4
    if Me and Me:GetHealth() < (Me:GetMaxHealth() * 0.9)
        and globals.CurTime() - Last_call_time > time_between_calls
        and not call_made and get_player_class(Me) ~= TF2_CLASSES.Medic
    then
        client.Command("voicemenu 0 0", true)
        announce(script.scriptName, "Calling for a Medic")
        Last_call_time = globals.CurTime()
        call_made = true
        script.printifv("Calling for a Medic")
    end
end

local function onCreateMove(cmd)
    -- Reset flags
    call_made = false

    -- Get the local player
    Me = entities.GetLocalPlayer()

    -- Exit early
    if not Me or not Me:IsAlive() or globals.CurTime() - Last_call_time < Min_time_between_calls then
        script.printifv("Exiting early")
        return
    end

    -- Get all the players
    Players = getPlayers()

    -- Spy call
    spy_call()

    -- Medic call
    medic_call()
end

-- Add a callback to Draw
callbacks.Unregister("CreateMove", script.scriptName)
callbacks.Register("CreateMove", script.scriptName, onCreateMove)

print("Loaded " .. script.scriptName)
