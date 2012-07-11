local lujgl = require "lujgl"
local gl, glu, ffi = lujgl.gl, lujgl.glu, require "ffi"
require "soil"
require "res.FONT_SWC"

lujgl.initialize("cartographer", 800, 600)

fontdds = soil.loadTexture("res\\FONT_SWC.dds")

  gl.glShadeModel(gl.GL_SMOOTH)
  gl.glEnable(gl.GL_AUTO_NORMAL)
  gl.glEnable(gl.GL_LINE_SMOOTH)
  gl.glEnable(gl.GL_POINT_SMOOTH)
  
  gl.glHint(gl.GL_POLYGON_SMOOTH_HINT,gl.GL_NICEST)
  
  gl.glEnable(gl.GL_CULL_FACE)
  
  gl.glHint(gl.GL_PERSPECTIVE_CORRECTION_HINT,gl.GL_NICEST)
  gl.glViewport(0, 0, lujgl.width, lujgl.height)

  gl.glMatrixMode(gl.GL_PROJECTION)
  gl.glLoadIdentity()

glu.gluPerspective(60,lujgl.width / lujgl.height,0.01, 1000)
gl.glMatrixMode(gl.GL_MODELVIEW)
glu.gluLookAt(0,0,0,
              0,0,0,
              0,1,0)
	
gl.glEnable(gl.GL_DEPTH_TEST)
gl.glDepthFunc(gl.GL_LEQUAL)

gl.glEnable(gl.GL_COLOR_MATERIAL)

gl.glEnable(gl.GL_BLEND)
--gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_SRC_COLOR)--outlines
gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_CONSTANT_ALPHA)--vertex colored solid

gl.glEnable(gl.GL_LIGHTING)
gl.glEnable(gl.GL_LIGHT0)
lujgl.glLight(gl.GL_LIGHT0, gl.GL_AMBIENT, 0.2, 0.2, 0.2)

lujgl.setIdleCallback(function() end)
lujgl.setRenderCallback(
	function()
		gl.glClearColor(.3,.3,.32,1)
		gl.glClear(bit.bor(gl.GL_COLOR_BUFFER_BIT, gl.GL_DEPTH_BUFFER_BIT));
		--gl.glViewport( lujgl.width, lujgl.height, lujgl.width, lujgl.height );
		
		-- 2D stuff
		gl.glEnable(gl.GL_TEXTURE_2D)
		gl.glBindTexture(gl.GL_TEXTURE_2D,fontdds)
		

		gl.glMatrixMode(gl.GL_PROJECTION);
		gl.glLoadIdentity();

		quad = glu.gluNewQuadric()
		
		glu.gluQuadricTexture(quad, true)
		glu.gluQuadricOrientation(quad, glu.GLU_OUTSIDE)
		
		glu.gluSphere(
		  quad,
		  60,
		  50,
		  10
		);
		
		lujgl.begin2D()
		gl.glColor3d(0,1,0)
		mab.font:print("¡Hello world!",49,lujgl.height-300,1.4)
		lujgl.end2D()
		
		lujgl.checkError()
	end
	)
	
lujgl.setEventCallback(function() end)
lujgl.mainLoop()