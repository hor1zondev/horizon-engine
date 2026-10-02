local json = require "lib.json"

local engine = {}

engine.scene = require "engine.scene"
engine.object = require "engine.object"
engine.images = require "engine.images"

ENGINE_COMPONENTS = {"imageComponent"}
-- Process modes for objects and their uses:
PROCESS_MODE_ALWAYS = 0 -- object's script always runs.
PROCESS_MODE_PAUSED = 1 -- object's script only runs when Scene.paused is true.
PROCESS_MODE_UNPAUSED = 2 -- reverse of PROCESS_MODE_UNPAUSED.
PROCESS_MODE_INHERIT = 3 -- object's script runs if parent's script is running.
PROCESS_MODE_DISABLED = 4 -- never runs.
-- PROCESS_MODE_INHERIT is the default value for Object.processMode, and if the parent of an object is the scene itself
-- the process will run no matter what.

-- Some useful functions
function engine.tableHasValue(table, value)
    for _, v in pairs(table) do
        if v == value then return true end
    end
    return false
end

-- Engine's functions
function engine.loadSceneFromPath(path)
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
        --Cycle through components data
        if objData.components ~= nil then
            for _, compData in pairs(objData.components) do
                -- Check if the engine has a component with that name
                if not engine.tableHasValue(ENGINE_COMPONENTS, compData) then
                    error("No engine component with name " .. compData .. " exists.")
                end
                local engineComponent = dofile("engine/" .. compData .. ".lua")--engine.components[compData]
                local newComponent = engineComponent.new(newObj)
                newObj:addComponent(newComponent)
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
    -- Load assets (TODO: also add unload assets here, left from the previous scene)
    if sceneData.assets ~= nil then
        --Load images
        if sceneData.assets.images ~= nil then
            for id, filename in pairs(sceneData.assets.images) do
                engine.images.loadImage(id, filename)
                -- NOTE might add a verbose print here later and to other places
            end
        end
    end
    -- Load children objects
    if sceneData.children ~= nil then
        for _, childData in pairs(sceneData.children) do
            local newObj = newObjectFromData(childData, newScene)
            newObj:_load()
            newScene:addChild(newObj)
        end
    end
    -- If no Camera object was given in the json file, load a default camera object
    if not newScene:hasChild("Camera") then
        local camera = engine.object.new(newScene)
        camera.name = "Camera"
        newScene:addChild(camera)
    end
    return newScene
end

return engine