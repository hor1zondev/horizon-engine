local images = {
    sources = {}
}

function images.loadImage(id, filename, settings)
    -- NOTE might make this overwrite instead of ignore
    if images.sources[id] ~= nil then
        print("WARNING (engine.images.loadImage): The image with the id " + id + "already exists. Returning.")
        return
    end
    images.sources[id] = love.graphics.newImage(filename, settings)
end

function images.unloadImage(id)
    if images.sources[id] == nil then
        print("WARNING (engine.images.unloadImage): The image with id " + id + " already does not exist. Returning.")
        return
    end
    images.sources[id] = nil
end

function images.getImage(id)
    return images.sources[id]
end

return images