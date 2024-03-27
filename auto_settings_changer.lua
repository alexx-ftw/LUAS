-- This is a helper script for Team Fortress 2
-- It will adjust LMAOBox settings based on the class you are playing

---@class script
local script = {
    scriptName = "Auto Settings Changer",
    verbose = false,
    version = "1.0.0",
    printifv = function(self, str)
        if self.verbose then
            print(str)
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

-- Define a table with functions for each class customization including a default settings function
ClassCustomizationFunctions = {
    default = function()
        script.printifv("Applying Default Global custom settings first...")
    end,
    [TF2_CLASSES.SCOUT] = function()
        -- Custom settings for Scout
        script.printifv("Applying Scout custom settings...")
        --
    end,
    [TF2_CLASSES.SNIPER] = function()
        -- Custom settings for Sniper
        script.printifv("Applying Sniper custom settings...")
    end,
    [TF2_CLASSES.SOLDIER] = function()
        -- Custom settings for Soldier
        script.printifv("Applying Soldier custom settings...")
        --
    end,
    [TF2_CLASSES.DEMOMAN] = function()
        -- Custom settings for Demoman
        script.printifv("Applying Demoman custom settings...")
        --
    end,
    [TF2_CLASSES.MEDIC] = function()
        -- Custom settings for Medic
        script.printifv("Applying Medic custom settings...")
    end,
    [TF2_CLASSES.HEAVY] = function()
        -- Custom settings for Heavy
        script.printifv("Applying Heavy custom settings...")
    end,
    [TF2_CLASSES.PYRO] = function()
        -- Custom settings for Pyro
        script.printifv("Applying Pyro custom settings...")
    end,
    [TF2_CLASSES.SPY] = function()
        -- Custom settings for Spy
        script.printifv("Applying Spy custom settings...")
    end,
    [TF2_CLASSES.ENGINEER] = function()
        -- Custom settings for Engineer
        script.printifv("Applying Engineer custom settings...")
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
