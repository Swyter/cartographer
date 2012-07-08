local lujgl = require "lujgl"
local gl, glu = lujgl.gl, lujgl.glu

lujgl.initialize("cartographer", 800, 600)

gl.glMatrixMode(gl.GL_PROJECTION)
glu.gluPerspective(60,lujgl.width / lujgl.height,0.01, 1000)
gl.glMatrixMode(gl.GL_MODELVIEW)
glu.gluLookAt(0,0,5,
	0,0,0,
	0,1,0)

gl.glEnable(gl.GL_DEPTH_TEST)
gl.glEnable(gl.GL_COLOR_MATERIAL)

gl.glEnable(gl.GL_LIGHTING)
gl.glEnable(gl.GL_LIGHT0)
lujgl.glLight(gl.GL_LIGHT0, gl.GL_AMBIENT, 0.2, 0.2, 0.2)

lujgl.setIdleCallback(function() print("idle") end)
lujgl.setRenderCallback(
	function()
		gl.glClearColor(.3,.3,.32,1)
		gl.glClear(bit.bor(gl.GL_COLOR_BUFFER_BIT, gl.GL_DEPTH_BUFFER_BIT));
		glu.gluPerspective(60,lujgl.width / lujgl.height,0.01, 1000)

	end
	)
	
lujgl.setEventCallback(function() print("event") end)
lujgl.mainLoop()