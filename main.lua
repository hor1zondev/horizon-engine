local engine = require "engine"

Scene = nil

function love.load()
    local major, minor, revision = love.getVersion()
    print("Made with Horizon Engine v" .. EngineInfo.version .. " (LÖVE v" .. major .. "." .. minor .. "." .. revision .. ")")
    -- Loading the default scene (if it exists, otherwise it'll be just an empty scene)
    if GameInfo.defaultScene == nil then
        Scene = engine.scene.new()
    else
        Scene = engine.loadSceneFromPath(GameInfo.defaultScene)
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
