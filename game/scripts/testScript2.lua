local testScript2 = {}

function testScript2:load()
    self.parent:getComponent("imageComponent").source = "placeholder"
    self.parent.position = {480, 270}
end

function testScript2:update(delta)
    
end

return testScript2