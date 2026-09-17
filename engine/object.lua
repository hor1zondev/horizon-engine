local object = {}

function object.new(parent)
    -- Object table definition
    local newObject = {
        -- NOTE: another good idea could be to count the total objects created throughout the whole game session
        -- and name objects originally that way.
        name = "Object" .. tostring(math.random(1048576));
        parent = parent;
        children = {};
        components = {};
        position = {0, 0};
        rotation = 0;
        scale = {1, 1};
        script = nil;
        processMode = PROCESS_MODE_INHERIT;
    }

    -- Functions
    function newObject:_checkForAllowedProcess()
        -- Firstly check if any of these cases are true
        if self.processMode == PROCESS_MODE_DISABLED then return false end
        if self.processMode == PROCESS_MODE_ALWAYS then return true end
        if self.processMode == PROCESS_MODE_PAUSED then return Scene.paused end
        if self.processMode == PROCESS_MODE_UNPAUSED then return not Scene.paused end
        if self.processMode == PROCESS_MODE_INHERIT and self.parent == Scene then return true end
        -- Now, start checking for inherited processes
        return self.parent:_checkForAllowedProcess()
        -- NOTE: Not sure if this works, try it one scene and objects are implemented properly
        -- Seems to be working right now.
    end

    function newObject:_load()
        if self.script ~= nil and self.script.load ~= nil then
            self.script:load()
        end
    end

    function newObject:_update(delta)
        -- Check if object has a script attached and script process is allowed
        --if self.script == nil then return end
        if not self:_checkForAllowedProcess() then return end
        -- Call script's update function (if it even exists obviously)
        if self.script ~= nil and self.script.update ~= nil then
            self.script:update(delta)
        end
        -- Call update functions of children
        for _, child in ipairs(self.children) do
            child:_update(delta)
        end
        -- Call update functions of components
        for _, component in ipairs(self.components) do
            if component._update ~= nil then component:_update(delta) end
        end
    end

    function newObject:_draw()
        -- unsure about if this function should be dependent on processMode
        -- Call draw functions of components
        for _, component in ipairs(self.components) do
            if component._draw ~= nil then component:_draw() end
        end
    end

    function newObject:addChild(childObject)
        self.children[#self.children+1] = childObject
    end

    function newObject:addComponent(component)
        self.components[#self.components+1] = component
    end

    function newObject:getChild(childName)
        -- This might not be the best performant implementation of this function but I'll try a better method
        -- later.
        for child in ipairs(self.children) do
            if child.name == childName then return child end
        end

        print("WARNING: Child with name " .. childName .. " was not found in object " .. self.name .. ". Returning nil.")
        return nil
    end

    function newObject:getComponent(compName)
        -- This might not be the best performant implementation of this function but I'll try a better method
        -- later.
        for component in ipairs(self.components) do
            if component.name == compName then return component end
        end

        print("WARNING: Component with name " .. compName .. " was not found in object " .. self.name .. ". Returning nil.")
        return nil
    end

    return newObject
end

return object