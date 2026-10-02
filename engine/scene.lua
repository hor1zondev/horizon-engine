local scene = {}

function scene.new()
    local newScene = {
        name = "Scene"; -- not sure if this will be of any use
        children = {};
        paused = false;
        -- NOTE: I need to handle these assets carefully otherwise memory leak will occur.
        -- Make sure that all assets get freed from memory (somehow) when a scene change occurs.
        -- The current idea I have for loading assets is two ways:
        -- 1) assets can be specified to load in the scene json file, which will be loaded when the scene is
        -- being set up for the first time.
        -- 2) The other way could be to give the user a loadImage/Font/Sound function which will also check
        -- if the specified asset is already loaded.
        assets = {
            images = {};
            fonts = {};
            sounds = {};
        }
    }

    function newScene:_load()
        
    end

    function newScene:_update(delta)
        for _, object in ipairs(self.children) do
            object:_update(delta)
        end
    end

    function newScene:_draw()
        for _, object in ipairs(self.children) do
            object:_draw()
        end
    end

    function newScene:addChild(childObject)
        self.children[#self.children+1] = childObject
    end

    function newScene:getChild(childName)
        -- This might not be the best performant implementation of this function but I'll try a better method
        -- later.
        for _, child in pairs(self.children) do
            if child.name == childName then return child end
        end
        print("WARNING: Child with name " .. childName .. " was not found in object " .. self.name .. ". Returning nil.")
        return nil
    end

    function newScene:hasChild(childName)
        for _, child in pairs(self.children) do
            if child.name == childName then return true end
        end
        return false
    end

    return newScene
end

return scene