local testScript2 = {}

function testScript2:load()
    print(self.parent)
end

function testScript2:update(delta)
    print("another update call")
end

return testScript2