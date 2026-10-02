local engine = require "engine"
local imageComponent = {}

function imageComponent.new(parent)
    local newComponent = {
        name = "imageComponent";
        parent = parent;
        enabled = true;
        source = nil;
        color = {1, 1, 1, 1};
        -- NOTE should I add scale here?
    }

    function newComponent:_draw()
        if not self.enabled or self.source == nil or self.color[4] <= 0 then return end
        local image = engine.images.getImage(self.source)
        -- Check if image exists
        if image == nil then
            print("WARNING (imageComponent._draw): No image with id " + self.source + " was found in engine.images.sources. Returning.")
            return
        end
        love.graphics.push()
            -- TODO add camera
            love.graphics.draw(
                image, self.parent.position[1], self.parent.position[2], self.parent.rotation,
                self.parent.scale[1], self.parent.scale[2], image:getWidth()/2, image:getHeight()/2
            )
        love.graphics.pop()
    end

    return newComponent
end

return imageComponent