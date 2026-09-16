
-- Process modes for objects and their uses:
PROCESS_MODE_ALWAYS = 0 -- object's script always runs.
PROCESS_MODE_PAUSED = 1 -- object's script only runs when Scene.paused is true.
PROCESS_MODE_UNPAUSED = 2 -- reverse of PROCESS_MODE_UNPAUSED.
PROCESS_MODE_INHERIT = 3 -- object's script runs if parent's script is running.
PROCESS_MODE_DISABLED = 4 -- never runs.
-- PROCESS_MODE_INHERIT is the default value for Object.processMode, and if the parent of an object is the scene itself
-- the process will run no matter what.

Scene = nil

local scene = require "engine.scene"
local object = require "engine.object"

function love.load()
    Scene = scene.new()
    local testObj = object.new(Scene)
    Scene:addChild(testObj)
    local testObj2 = object.new(testObj)
    testObj:addChild(testObj2)
end

function love.update(delta)
    if Scene == nil then return end
    Scene:_update(delta)
end

function love.draw()
    if Scene == nil then return end
    Scene:_draw()
end
