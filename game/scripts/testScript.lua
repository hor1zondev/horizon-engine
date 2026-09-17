local testScript = {}

function testScript:load()
    print(self.parent)
end

function testScript:update(delta)
    print(delta)
end

return testScript