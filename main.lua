local json = require "lib.json"
local engine = require "engine"

-- Process modes for objects and their uses:
PROCESS_MODE_ALWAYS = 0 -- object's script always runs.
PROCESS_MODE_PAUSED = 1 -- object's script only runs when Scene.paused is true.
PROCESS_MODE_UNPAUSED = 2 -- reverse of PROCESS_MODE_UNPAUSED.
PROCESS_MODE_INHERIT = 3 -- object's script runs if parent's script is running.
PROCESS_MODE_DISABLED = 4 -- never runs.
-- PROCESS_MODE_INHERIT is the default value for Object.processMode, and if the parent of an object is the scene itself
-- the process will run no matter what.

Scene = nil

local function loadSceneFromPath(path)
    local function newObjectFromData(objData, parent)
        local newObj = engine.object.new(parent)
        -- this may need error checking for invalid types
        if objData.name ~= nil then newObj.name = objData.name end
        if objData.processMode ~= nil then newObj.processMode = _G[objData.processMode] end
        if objData.position ~= nil then newObj.position = objData.position end
        if objData.rotation ~= nil then newObj.rotation = objData.rotation end
        -- Load script if a path is given
        if objData.script ~= nil then
            local newScript = dofile(objData.script)
            newScript.parent = newObj
            newObj.script = newScript
        end
        -- Cycle through children data
        if objData.children ~= nil then
            for _, childData in pairs(objData.children) do
                local newChild = newObjectFromData(childData, newObj)
                newObj:addChild(newChild)
            end
        end
        return newObj
    end

    local newScene = engine.scene.new()
    -- Check if the scene file exists at given path
    if love.filesystem.getInfo(path) == nil then
        error("No scene file found in " .. path)
    end
    -- Read and decode the JSON file
    local sceneData = json.decode(love.filesystem.read(path))
    -- Set scene name
    if sceneData.name == nil then newScene.name = "Scene" else newScene.name = sceneData.name end
    -- Load children objects
    if sceneData.children == nil then return end
    for _, childData in pairs(sceneData.children) do
        local newObj = newObjectFromData(childData, newScene)
        newObj:_load()
        newScene:addChild(newObj)
    end
    return newScene
end

function love.load()
    local major, minor, revision = love.getVersion()
    print("Made with Horizon Engine v" .. EngineInfo.version .. " (LÖVE v" .. major .. "." .. minor .. "." .. revision .. ")")
    -- Loading the default scene (if it exists, otherwise it'll be just an empty scene)
    if GameInfo.defaultScene == nil then
        Scene = engine.scene.new()
    else
        Scene = loadSceneFromPath(GameInfo.defaultScene)
    end
end

function love.update(delta)
    if Scene == nil then return end
    Scene:_update(delta)
end

function love.draw()
    if Scene == nil then return end
    Scene:_draw()
end
