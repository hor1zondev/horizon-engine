
-- Process modes for objects and their uses:
PROCESS_MODE_ALWAYS = 0 -- object's script always runs.
PROCESS_MODE_PAUSED = 1 -- object's script only runs when Scene.paused is true.
PROCESS_MODE_UNPAUSED = 2 -- reverse of PROCESS_MODE_UNPAUSED.
PROCESS_MODE_INHERIT = 3 -- object's script runs if parent's script is running.
-- PROCESS_MODE_INHERIT is the default value for Object.processMode, and if the parent of an object is the scene itself
-- the process will run no matter what.

Scene = nil

function love.load()
    
end

function love.update(delta)
    
end

function love.draw()

end
