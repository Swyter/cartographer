local lujgl = require "lujgl"
local gl, glu, ffi = lujgl.gl, lujgl.glu, require "ffi"
require "soil"

lujgl.initialize("cartographer", 800, 600)

fontdds = soil.loadTexture("res\\FONT_SWC.dds")

gl.glMatrixMode(gl.GL_PROJECTION)
glu.gluPerspective(60,lujgl.width / lujgl.height,0.01, 1000)
gl.glMatrixMode(gl.GL_MODELVIEW)
glu.gluLookAt(0,0,5,
	0,0,0,
	0,1,0)
	 
	font = {
		w=2048,
		h=1024
	}
	
	font.a = {
		 code=97,
		 page=0,
		 u=787/font.w,
		 v=1-(205/font.h),
		 w=845/font.w,
		 h=1-(258/font.h),
		 preshift=-5,
		 yadjust=50,
		 postshift=47
	}
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

		-- 2D stuff
		gl.glEnable(gl.GL_TEXTURE_2D)
		gl.glBindTexture(gl.GL_TEXTURE_2D,fontdds)
		lujgl.begin2D()
		gl.glBegin(gl.GL_QUADS)
		
			--1
			gl.glColor3d(1,0,0)
			gl.glTexCoord2d(font.a.u,font.a.h)--(0,0)
			gl.glVertex2i(  0,   0)
			
			--2
			gl.glColor3d(0,1,0)
			gl.glTexCoord2d(font.a.w,font.a.h)--(1,0)
			gl.glVertex2i(550,   0)
			
			--3
			gl.glColor3d(0,0,1)
			gl.glTexCoord2d(font.a.w,font.a.v)--(1,1)
			gl.glVertex2i(550, 550)
			
			--4
			gl.glColor3d(0,0,0)
			gl.glTexCoord2d(font.a.u,font.a.v)--(0,1)
			gl.glVertex2i(  0, 550)
			
	--    v
	--   4|      3
	-- u--+-----+
	--	  |     |
	--	  |     |
	--    +-----+--w
	--   1      |2
	--          h
		gl.glEnd()
		lujgl.end2D()
		
		lujgl.checkError()
		end
	)
	
lujgl.setEventCallback(function() print("event") end)
lujgl.mainLoop()