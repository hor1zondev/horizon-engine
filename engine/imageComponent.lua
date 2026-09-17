local imageComponent = {}

function imageComponent.new(parent)
    local newComponent = {
        parent = parent;
        enabled = true;
        source = nil;
        color = {1, 1, 1, 1};
        -- Should I add scale here?
    }

    function newComponent:_draw()
        if not self.enabled or self.source == nil or self.color[4] <= 0 then return end
    end

    return newComponent
end

return imageComponent