local testScript2 = {}

function testScript2:load()
    self.parent:getComponent("imageComponent").source = "placeholder"
    self.parent.position = {480, 270}
end

function testScript2:update(delta)
    local camera = Scene:getChild("Camera")
    --camera.position[1] = camera.position[1] + 5*delta
    if love.keyboard.isDown("w") then
        camera.scale[1] = camera.scale[1] + 8*delta
        camera.scale[2] = camera.scale[2] + 8*delta
    end
    if love.keyboard.isDown("s") then
        camera.scale[1] = camera.scale[1] - 8*delta
        camera.scale[2] = camera.scale[2] - 8*delta
    end
end

return testScript2