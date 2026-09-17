local scene = {}

function scene.new()
    local newScene = {
        name = "Scene"; -- not sure if this will be of any use
        children = {};
        paused = false;
    }

    function newScene:_load()
        
    end

    function newScene:_update(delta)
        for _, object in ipairs(self.children) do
            object:_update(delta)
        end
    end

    function newScene:_draw()
        
    end

    function newScene:addChild(childObject)
        self.children[#self.children+1] = childObject
    end

    function newScene:getChild(childName)
        -- This might not be the best performant implementation of this function but I'll try a better method
        -- later.
        for child in ipairs(self.children) do
            if child.name == childName then return child end
        end
        print("WARNING: Child with name " .. childName .. " was not found in object " .. self.name .. ". Returning nil.")
        return nil
    end

    return newScene
end

return scene