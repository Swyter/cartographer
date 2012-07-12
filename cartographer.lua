local lujgl = require "lujgl"
local gl, glu, ffi = lujgl.gl, lujgl.glu, require "ffi"

local key={}

--@ Load cooler dependencies
require "soil"
require "mab-map"
require "mab-registry"

--@debug functions
function d(...)
print (unpack(arg))
end

d("hola","que","tal")

local CubeVerticies = {}
CubeVerticies.v = ffi.new("const float[8][3]", {
	{0,0,1}, {0,0,0}, {0,1,0}, {0,1,1},
	{1,0,1}, {1,0,0}, {1,1,0}, {1,1,1}
})

CubeVerticies.n = ffi.new("const float[6][3]", {
	{-1.0, 0.0, 0.0}, {0.0, 1.0, 0.0}, {1.0, 0.0, 0.0},
	{0.0, -1.0, 0.0}, {0.0, 0.0, -1.0}, {0.0, 0.0, 1.0}
})

CubeVerticies.f = ffi.new("const float[6][4]", { 
	{0, 1, 2, 3}, {3, 2, 6, 7}, {7, 6, 5, 4},
	{4, 5, 1, 0}, {5, 6, 2, 1}, {7, 4, 0, 3}
})

--@ init and stuff
lujgl.initialize("cartographer", 800, 600)

--@ load our font
require "res.FONT_SWC"
fontdds = soil.loadTexture("res\\FONT_SWC.dds")

--@ opengl directives
  gl.glShadeModel(gl.GL_SMOOTH)
  gl.glEnable(gl.GL_AUTO_NORMAL)
  gl.glEnable(gl.GL_LINE_SMOOTH)
  gl.glEnable(gl.GL_POINT_SMOOTH)
  
  gl.glHint(gl.GL_POLYGON_SMOOTH_HINT, gl.GL_NICEST)

  gl.glEnable(gl.GL_CULL_FACE)
  gl.glEnable(gl.GL_NORMALIZE)
  
  gl.glHint(gl.GL_PERSPECTIVE_CORRECTION_HINT,gl.GL_NICEST)
  gl.glViewport(0, 0, lujgl.width, lujgl.height)

  gl.glMatrixMode(gl.GL_PROJECTION_MATRIX)
  gl.glLoadIdentity()

glu.gluPerspective(60,lujgl.width / lujgl.height, 0.01, 1000)
gl.glMatrixMode(gl.GL_MODELVIEW)

glu.gluLookAt(0,0,5,
	0,0,0,
	0,1,1)
  
gl.glEnable(gl.GL_DEPTH_TEST)
gl.glDepthFunc(gl.GL_LEQUAL)

gl.glEnable(gl.GL_COLOR_MATERIAL)

--gl.glEnable(gl.GL_BLEND)
--gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_SRC_COLOR)--outlines
--gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_CONSTANT_ALPHA)--vertex colored solid

gl.glEnable(gl.GL_LIGHTING)
gl.glEnable(gl.GL_LIGHT0)
lujgl.glLight(gl.GL_LIGHT0, gl.GL_AMBIENT, 1,1,1)--0.8, 0.2, 0.2)

local rotx, roty, rotz = 1/math.sqrt(2), 1/math.sqrt(2), 0
local boxx, boxy, boxz = -0.5,-0.5,2

-- we like callbacks

lujgl.setIdleCallback(function() end)
lujgl.setRenderCallback(
	function()
  
  --let's fix aspect ratio
    gl.glViewport(0, 0, lujgl.width, lujgl.height)
    gl.glMatrixMode(gl.GL_PROJECTION_MATRIX)
    gl.glLoadIdentity()
    glu.gluPerspective(60,lujgl.width / lujgl.height, 0.01, 1000)
    gl.glMatrixMode(gl.GL_MODELVIEW)
  
  --light gray and clean the screen
		gl.glClearColor(.3,.3,.32,1)
		gl.glClear(bit.bor(gl.GL_COLOR_BUFFER_BIT, gl.GL_DEPTH_BUFFER_BIT))


  --draw the map
    gl.glDisable(gl.GL_BLEND)
    gl.glPolygonMode( gl.GL_FRONT_AND_BACK, gl.GL_LINE )
  
	  gl.glPushMatrix()
	  gl.glTranslated(boxx, boxy, boxz)
	  gl.glRotated(lujgl.getTime()*10, rotx, roty, rotz)
    gl.glColor3d(1,1,0)
    for i=0,5 do
      gl.glBegin(gl.GL_QUADS)
      gl.glNormal3fv(CubeVerticies.n[i])
      for j=0,3 do
        gl.glVertex3fv(CubeVerticies.v[CubeVerticies.f[i][j]])
      end
      gl.glEnd()
    end
    gl.glPopMatrix()
  
    gl.glPushMatrix()
    quad = glu.gluNewQuadric()
    
    glu.gluQuadricTexture(quad, true)
    glu.gluQuadricOrientation(quad, glu.GLU_OUTSIDE)
    
    glu.gluSphere(
      quad,
      3,
      50,
      10
    );
    gl.glPopMatrix()
  
  --draw the markers
  
  
  
  --draw 2d
    gl.glPolygonMode( gl.GL_FRONT_AND_BACK, gl.GL_FILL )
    
    gl.glEnable(gl.GL_BLEND)
    gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_SRC_COLOR)--outlines
   
    gl.glEnable(gl.GL_TEXTURE_2D)
    gl.glBindTexture(gl.GL_TEXTURE_2D,fontdds)
    
    lujgl.begin2D()
      gl.glColor4d(1,1,1,1)
      mab.font:print("¡Hello world!",49,lujgl.height/2,1.4)
    lujgl.end2D()
    
    gl.glDisable(gl.GL_TEXTURE_2D)
    
  --bugs ahoy?
    --lujgl.checkError()
	end
	)
	
lujgl.setEventCallback(function(ev,...) local arg={...}
    print("Event", ev, ...)
    
        if ev=="key"   then -- keyboard presses

    elseif ev=="motion"then -- mouse movement
    
    elseif ev=="mouse" then -- mouse clicks
    
    elseif ev=="wheel" then -- wheel movement
      wheel_locl,wheel_absl =arg[1],arg[2]
      
    end

  end
  )

-- start the loop already
lujgl.mainLoop()