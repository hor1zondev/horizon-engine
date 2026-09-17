local json = require "lib/json"

EngineInfo = nil

function love.conf(t)
    --Check if engine/info.json exists
    if love.filesystem.getInfo("engine/info.json") == nil then
        error("Could not find engine/info.json file in project directory.")
    end
    --Read engine/info.json and define it as a global variable
    EngineInfo = json.decode(love.filesystem.read("engine/info.json"))
    local gameInfoPath = EngineInfo.gameDirectory .. "/info.json"
    --Check if gameDirectory/info.json exists
    if love.filesystem.getInfo(gameInfoPath) == nil then
        error("Could not find " .. gameInfoPath .. " file in project directory.")
    end
    --Having found the gameDirectory, read gameDirectory/info.json
    GameInfo = json.decode(love.filesystem.read(gameInfoPath))

    -- Set the config values from game info file
    t.version = EngineInfo.loveVersion
    t.window.width = GameInfo.defaultWindowWidth; t.window.height = GameInfo.defaultWindowHeight;
    t.window.title = GameInfo.windowTitle
    t.window.icon = GameInfo.iconPath
end