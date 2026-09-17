local json = require "lib.json"

local engine = {}

engine.scene = require "engine.scene"
engine.object = require "engine.object"
engine.components = {
    imageComponent = require "engine.imageComponent";
}

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
                local engineComponent = engine.components[compData]
                if engineComponent == nil then
                    error("No component with name " .. compData .. " exists in engine.components.")
                end
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
    -- Load children objects
    if sceneData.children == nil then return end
    for _, childData in pairs(sceneData.children) do
        local newObj = newObjectFromData(childData, newScene)
        newObj:_load()
        newScene:addChild(newObj)
    end
    return newScene
end

return engine