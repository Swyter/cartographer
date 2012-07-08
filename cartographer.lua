local lujgl = require "lujgl"
lujgl.initialize("cartographer", 800, 600)

lujgl.setIdleCallback(function() print("idle") end)
lujgl.setRenderCallback(function() print("render") end)
lujgl.setEventCallback(function() print("event") end)
lujgl.mainLoop()