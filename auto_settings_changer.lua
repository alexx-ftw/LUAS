-- This is a helper script for Team Fortress 2
-- It will adjust LMAOBox settings based on the class you are playing

-- Define the configuration
config = {
    scriptName = "Auto Settings Changer",
    verbose = false
}

-- Print the name of the script and the verbose setting
print("Loading " .. config.scriptName .. "...")

-- Load the required libraries and throw an error if they are not found and exit the script
local localappdata = os.getenv("LOCALAPPDATA")
local al = require(localappdata .. "\\LUAS\\lib\\alex_lib")
if not al then
    error("alex_lib not found")
end

-- Define a table with functions for each class customization including a default settings function
ClassCustomizationFunctions = {
    default = function()
        al.printifv("Applying Default Global custom settings first...")
    end,
    [al.TF2_CLASSES.SCOUT] = function()
        -- Custom settings for Scout
        al.printifv("Applying Scout custom settings...")
        --
    end,
    [al.TF2_CLASSES.SNIPER] = function()
        -- Custom settings for Sniper
        al.printifv("Applying Sniper custom settings...")
    end,
    [al.TF2_CLASSES.SOLDIER] = function()
        -- Custom settings for Soldier
        al.printifv("Applying Soldier custom settings...")
        --
    end,
    [al.TF2_CLASSES.DEMOMAN] = function()
        -- Custom settings for Demoman
        al.printifv("Applying Demoman custom settings...")
        --
    end,
    [al.TF2_CLASSES.MEDIC] = function()
        -- Custom settings for Medic
        al.printifv("Applying Medic custom settings...")
    end,
    [al.TF2_CLASSES.HEAVY] = function()
        -- Custom settings for Heavy
        al.printifv("Applying Heavy custom settings...")
    end,
    [al.TF2_CLASSES.PYRO] = function()
        -- Custom settings for Pyro
        al.printifv("Applying Pyro custom settings...")
    end,
    [al.TF2_CLASSES.SPY] = function()
        -- Custom settings for Spy
        al.printifv("Applying Spy custom settings...")
    end,
    [al.TF2_CLASSES.ENGINEER] = function()
        -- Custom settings for Engineer
        al.printifv("Applying Engineer custom settings...")
        --
    end,
}

-- Define the function to handle the game event
---@param event any
local function onFireGameEvent(event)
    if event:GetName() == "player_spawn" then
        local eventUserId = event:GetInt("userid")
        local localPlayerIndex = client.GetLocalPlayerIndex()
        local playerInfo = client.GetPlayerInfo(localPlayerIndex)

        if playerInfo and eventUserId == playerInfo.UserID then
            local eventClassIndex = event:GetInt("class")

            ClassCustomizationFunctions.default() -- Apply global default settings first

            if ClassCustomizationFunctions[eventClassIndex] then
                ClassCustomizationFunctions[eventClassIndex]()
            end
        end
    end
end

-- Registers the callback for handling game events
callbacks.Register("FireGameEvent", onFireGameEvent)
