local object = {}

function object.new(parent)
    -- Object table definition
    local newObject = {
        parent = parent;
        position = {0, 0};
        rotation = 0;
        scale = {1, 1};
        script = nil;
        processMode = PROCESS_MODE_INHERIT;
    }

    -- Functions
    function newObject:_checkForInheritedProcess()
        local processAllowed = false
        local upperObject = self.parent
        while true do
            if upperObject.processMode == PROCESS_MODE_INHERIT then
                
            end
        end
        return processAllowed
    end

    function newObject:_load()
        
    end

    function newObject:_update(delta)
        -- Check if object has a script attached and script process is allowed
        if self.script == nil then return end
        if self.processMode == PROCESS_MODE_INHERIT then
            
        end
        -- Call script's update function
    end

    function newObject:_draw()
        
    end

    return newObject
end

return object