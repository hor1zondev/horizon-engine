local engine = require "engine"

local imageComponent = {}

function imageComponent.new(parent)
    local newComponent = {
        parent = parent;
        enabled = true;
        source = nil;
        color = {1, 1, 1, 1};
        -- Should I add scale here?
    }

    function imageComponent:_draw()
        print("draw function called")
    end

    return newComponent
end

return imageComponent