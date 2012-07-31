local lujgl = require "lujgl"
local gl, glu, ffi = lujgl.gl, lujgl.glu, require "ffi"

local key,mouse,px,py,pz,rx,ry,rz, xrang,yrang={},{},0,0,-5,0,0,0, 0,0

mouse.x=0
mouse.y=0
mouse.xold=0
pickoffst={0,0}

objX=ffi.new("double[1]",1);
objY=ffi.new("double[1]",1);
objZ=ffi.new("double[1]",1);
    
--@ Load cooler dependencies
  require "mab-registry"
  reg=mab.registry:query()
  
  cartographer={}; dofile("_configureme.ini") --new easy peasy config file
  
  require "mab-msys"
  msys=mab.msys:getmsysfolder()
   mod=mab.msys:getmodulefolder()
  print(string.format("Msys folder at <%s>",msys))
  print(string.format("Module folder at <%s>",mod))
  
--@ init and stuff
  lujgl.initialize("cartographer", 800, 600)

--@ load our font
  require "soil"
  require "mab-font"
  mab.font:load(mod.."\\Data\\FONT_DATA.XML",
                mod.."\\textures\\FONT.dds")
                
 -- mab.font:load("R:\\Juegos\\swconquest\\modules\\swconquest\\Module Data\\FONT_DATA.XML",
 --               "R:\\Juegos\\swconquest\\modules\\swconquest\\Textures\\FONT_SWC.dds")

--@ load our map
  require "mab-map"
  mab.map:load(mod)--"R:\\Juegos\\swconquest\\modules\\swconquest")
  
--@ load our locations
  require "mab-parties"
  local filledp = mab.parties:load(msys.."\\module_parties.py")--"R:\\Juegos\\swconquest\\modules\\swconquest-msys\\module_parties.py")

  local uu=os.clock()
  local abs=math.abs
  for p,_ in pairs(mab.parties) do
  
  local currparty=mab.parties[p]
  if type(currparty)=="table" then
   
   local closerx,closery=2,2
   
   for i=1,#mab.map.fcs do
   
   --compute barycenter
   local tricenterx=(mab.map.vtx[mab.map.fcs[i][1]].x+
                     mab.map.vtx[mab.map.fcs[i][2]].x+
                     mab.map.vtx[mab.map.fcs[i][3]].x)/3
   local tricentery=(mab.map.vtx[mab.map.fcs[i][1]].z+
                     mab.map.vtx[mab.map.fcs[i][2]].z+
                     mab.map.vtx[mab.map.fcs[i][3]].z)/3
               
   --print("tric:"..tricenterx,tricentery)
   
   local compx=abs(tricenterx - currparty.pos[1])
   local compy=abs(tricentery - currparty.pos[2])

   --print("comp:"..compx,compy)
   --break
   
        if compx < closerx and
           compy < closery then --closest triangle to the point
           
           --print(mab.parties[p].name,closerx,closery)
           --print(compx,compy,"-->"..mab.map.vtx[mab.map.fcs[i][1]].y)
           closerx,closery=compx,compy
           
          -- mab.parties[p].pos[1] = mab.map.vtx[mab.map.fcs[i][1]].x
          -- mab.parties[p].pos[2] = mab.map.vtx[mab.map.fcs[i][1]].z
           mab.parties[p].pos[3] =(mab.map.vtx[mab.map.fcs[i][1]].y+
                                   mab.map.vtx[mab.map.fcs[i][2]].y+
                                   mab.map.vtx[mab.map.fcs[i][3]].y)/3
           --print("found "..mab.map.vtx[mab.map.fcs[i][1]].y.." for "..mab.parties[p].name)
           
           --filledp=filledp-1
           if closerx<1.8 and closery<1.5 then break end--aproximate just enough
        end
   end
     
     if not mab.parties[p].pos[3] then mab.parties[p].pos[3]=10 end
  end
  end
  
  print(string.format("   ground aligned in %gs, %d out",os.clock()-uu,filledp))
  
--@ opengl directives
  gl.glShadeModel(gl.GL_SMOOTH)
  gl.glEnable(gl.GL_AUTO_NORMAL)
  gl.glEnable(gl.GL_LINE_SMOOTH)
  gl.glEnable(gl.GL_POINT_SMOOTH)
  gl.glEnable(gl.GL_CULL_FACE)
  
  gl.glHint(gl.GL_POLYGON_SMOOTH_HINT, gl.GL_NICEST)
  gl.glHint(gl.GL_PERSPECTIVE_CORRECTION_HINT,gl.GL_NICEST)
  
  
  gl.glMatrixMode(gl.GL_MODELVIEW)

  glu.gluLookAt(0,0,-5,
                0,0,0,
                0,1,1)

  gl.glEnable(gl.GL_DEPTH_TEST)
  gl.glDepthFunc(gl.GL_LEQUAL)

  gl.glEnable(gl.GL_COLOR_MATERIAL)
  
  gl.glEnable(gl.GL_LIGHTING)
  gl.glEnable(gl.GL_LIGHT0)

--gl.glEnable(gl.GL_BLEND)
--gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_SRC_COLOR)--outlines
--gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_CONSTANT_ALPHA)--vertex colored solid
  
  local rotx, roty, rotz = 1/math.sqrt(2), 1/math.sqrt(2), 0
  local boxx, boxy, boxz = -0.5,-0.5,2

--@ we like callbacks
lujgl.setIdleCallback(function()

  --manage non-blocking input
    if key["w"] or key[283] then pz=pz+3 end
    if key["a"] or key[285] then px=px+3 end --reversed
    if key["s"] or key[284] then pz=pz-3 end
    if key["d"] or key[286] then px=px-3 end --reversed
    
    
    if key[265] then mab.map:saveobj(cartographer.conf.mapobj) end --f8
    if key[264] then mab.map:loadobj(cartographer.conf.mapobjout);
                     gl.glDeleteLists(mapmesh,1);mapmesh=nil end --refresh cached map end --f7
                     
    if key[262] then mab.map:save(mod.."\\map_out.txt",true) end --f5 
    if key[263] then mab.map:load(mod);
                     gl.glDeleteLists(mapmesh,1);mapmesh=nil end --refresh cached map end --f6
                     
    if key[266] then mab.parties:save(msys.."\\module_parties.py") end --f9
    --if key[267] then mab.parties:load("res") end --f10
    
    
    if mouse.rclick then print("pickingmode!!");
    
      mab.parties[picked].isbeenmod=true
      
      if not mab.parties[picked].oldpos then --save if for good measure
        mab.parties[picked].oldpos = mab.parties[picked].pos
      end
      
      mab.parties[picked].pos={objX[0],objZ[0],objY[0]}

    end
    
    if mouse.lclick then xrang=xrang+(mouse.xold-mouse.x)/2; rx=1; end
    if mouse.lclick then yrang=yrang+(mouse.yold-mouse.y)/2; ry=1; end
    if yrang<-90 then yrang=-90 end
    
    mouse.xold=mouse.x
    mouse.yold=mouse.y
    
        if yrang > 360 then yrang=0
    elseif yrang < 0   then yrang=360 end --clamp between 0<>360 deg
    
        if xrang > 360 then xrang=0
    elseif xrang < 0   then xrang=360 end --clamp between 0<>360 deg
    
 end)
 
lujgl.setRenderCallback(function()
  --let's fix aspect ratio
    gl.glViewport(0, 0, lujgl.width, lujgl.height)
    gl.glMatrixMode(gl.GL_PROJECTION_MATRIX)
    gl.glLoadIdentity()
    glu.gluPerspective(60,lujgl.width / lujgl.height, 0.01, 1000)
    gl.glMatrixMode(gl.GL_MODELVIEW)
    
    gl.glTranslatef(px,py,pz)
    gl.glRotatef(yrang,ry, 0, 0)
    gl.glRotatef(xrang, 0,rx, 0)


    lujgl.glLight(gl.GL_LIGHT0, gl.GL_AMBIENT, 0.2, 0.2, 0.2)
    lujgl.glLight(gl.GL_LIGHT0, gl.GL_POSITION, 135, 135, 135, 135)
  
  --light gray and clean the screen
    gl.glClearColor(.18,.18,.22,1)-- probably this looks better
    gl.glClear(bit.bor(gl.GL_COLOR_BUFFER_BIT, gl.GL_DEPTH_BUFFER_BIT))
  
  --Subtle fog
    gl.glFogi(gl.GL_FOG_MODE, gl.GL_LINEAR)
    gl.glFogfv(gl.GL_FOG_COLOR, ffi.new("const float[4]", {.36*2,.3*2,.32*2,.6}))
    gl.glFogf(gl.GL_FOG_DENSITY, 0.35)
    gl.glHint(gl.GL_FOG_HINT, gl.GL_DONT_CARE)
    gl.glFogf(gl.GL_FOG_START, 100)
    gl.glFogf(gl.GL_FOG_END, 1000)
    gl.glEnable(gl.GL_FOG)
    
  --draw the map
    gl.glDisable(gl.GL_BLEND)
    gl.glEnable(gl.GL_LIGHT0)
    gl.glPushMatrix()

    if not mapmesh or not gl.glIsList(mapmesh) then
    print"(i)no cache avaliable, rebuilding displaylist"; local start=os.clock()
    
       mapmesh=gl.glGenLists(1)
       gl.glNewList(mapmesh, gl.GL_COMPILE)
      
        for i=1,#mab.map.fcs do
          gl.glBegin(gl.GL_TRIANGLE_STRIP)
          
          nm=mab.map:computenrm(mab.map.fcs[i])
          gl.glNormal3d(nm.x,nm.y,nm.z)
          
          x=tonumber(mab.map.fcs[i][11])
          gl.glColor3f(unpack(mab.map.terrain[x] or {1,0,1}))
          
          for j=1,3 do
            local vt=mab.map.vtx[mab.map.fcs[i][j]]
            gl.glVertex3d(vt.x,vt.y,vt.z)
          end
          gl.glEnd()
        end
        
       gl.glEndList()
       print("generated displaylist "..(os.clock()-start).."s")
       --mab.map=nil --garbage collector, do your work!
    
    else
       gl.glCallList(mapmesh)
    end
    gl.glPopMatrix()
 
    --@2D unprojection
    local winX=ffi.new("float[1]",              mouse.x -pickoffst[1]);
    local winY=ffi.new("float[1]",(lujgl.height-mouse.y)-pickoffst[2]);
    local winZ=ffi.new("float[1]",1);
    
    gl.glReadPixels( winX[0], winY[0], 1,1, gl.GL_DEPTH_COMPONENT, gl.GL_FLOAT, winZ );
    

    local modelview=ffi.new("double[16]",1);
    gl.glGetDoublev( gl.GL_MODELVIEW_MATRIX, modelview );
    
    local projection=ffi.new("double[16]",1);
	  gl.glGetDoublev( gl.GL_PROJECTION_MATRIX, projection );
    
    local viewport=ffi.new("int[4]",1);
	  gl.glGetIntegerv( gl.GL_VIEWPORT, viewport );
    
    glu.gluUnProject (winX[0], winY[0], winZ[0], modelview, projection, viewport, objX, objY, objZ) 
    --print(objX[0],objY[0],objZ[0])
    
    
    --@draw the markers
    
    for p=1,#mab.parties do
          gl.glPolygonMode( gl.GL_FRONT_AND_BACK, gl.GL_LINE )
          gl.glPushMatrix()
          gl.glTranslated(mab.parties[p].pos[1],mab.parties[p].pos[3],
                          mab.parties[p].pos[2])
          
          quad = glu.gluNewQuadric()
          glu.gluQuadricOrientation(quad, glu.GLU_OUTSIDE)
          
          glu.gluSphere(
            quad,
            1,
            4,
            4
          );
          gl.glPopMatrix()
          
          local scrX=ffi.new("double[1]",1);
          local scrY=ffi.new("double[1]",1);
          local scrZ=ffi.new("double[1]",1);
          
          local modelview=ffi.new("double[16]",1);
          gl.glGetDoublev( gl.GL_MODELVIEW_MATRIX, modelview );
          
          local projection=ffi.new("double[16]",1);
          gl.glGetDoublev( gl.GL_PROJECTION_MATRIX, projection );
          
          local viewport=ffi.new("int[4]",1);
          gl.glGetIntegerv( gl.GL_VIEWPORT, viewport );
          glu.gluProject(mab.parties[p].pos[1], mab.parties[p].pos[3], mab.parties[p].pos[2], modelview, projection, viewport, scrX, scrY, scrZ);

          if scrZ[0]<.9999 then
              gl.glPolygonMode( gl.GL_FRONT_AND_BACK, gl.GL_FILL )
              gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_SRC_COLOR)--outlines
              gl.glColor4d(1,1,1,1)
              
              lujgl.begin2D()
              
                if mab.parties[p].kind==1 then
                    scal=.66
                elseif mab.parties[p].kind==2 then
                    scal=.33
                end
                
                mab.font:print( ( (key[287] or key[288]) and mab.parties[p].id or mab.parties[p].name), --switch between party name and id by pressing the shift keys...
                               scrX[0],scrY[0],scal)

              lujgl.end2D()
          end
     -- end
    end

  
  --draw 2d
    gl.glPolygonMode( gl.GL_FRONT_AND_BACK, gl.GL_FILL )
    
    lujgl.begin2D()
      gl.glColor4d(1,.9,1,.7)
      gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_CONSTANT_ALPHA)--vertex colored solid
      mab.font:print(string.format("%d--%d",mouse.x, lujgl.height-mouse.y),
                     49,lujgl.height/2-110,.6)
                     
      mab.font:print(string.format("x:%g y:%g z:%g",-objX[0],objZ[0],objY[0]),
                     49,lujgl.height/2-60,.7)
      
      mab.font:print("The house at the end of the street is red.",
                     1,10,.2)
    lujgl.end2D()
    
  --bugs ahoy?
    --lujgl.checkError()
  end
  )
  
lujgl.setEventCallback(function(ev,...) local arg={...}
    --print("Event", ev, ...)
    
    if ev=="key" then        -- keyboard presses
      local down,k=arg[1],arg[2]
      
      if k=="w" or k==283
      or k=="a" or k==285
      or k=="s" or k==284
      or k=="d" or k==286
      
      or k==287 or k==288

      or k==265 or k==264      --f8 & f7
      or k==262 or k==263      --f5 & f6
      or k==266 or k==267 then --f9 & f10
      
      key[k]=down end

    elseif ev=="motion" then -- mouse movement
      mouse.x=arg[1]
      mouse.y=arg[2]
    
    elseif ev=="mouse" then  -- mouse clicks
      local k,down,x,y=arg[1],arg[2],arg[3],arg[4]
    
      if k==1 then

      
      if down then
            local winX=ffi.new("float[1]",mouse.x);
            local winY=ffi.new("float[1]",lujgl.height-mouse.y);
            local pickId=ffi.new("int[1]",1);
            
            
            --@draw the color coded marker
            gl.glClearColor(0,0,0,1)
            gl.glClear(bit.bor(gl.GL_COLOR_BUFFER_BIT, gl.GL_DEPTH_BUFFER_BIT))
            gl.glDisable(gl.GL_LIGHTING)
            gl.glDisable(gl.GL_FOG)
            
            for p=1,#mab.parties do
                
                gl.glPushMatrix()
                gl.glTranslated(mab.parties[p].pos[1],mab.parties[p].pos[3],
                                mab.parties[p].pos[2])
                                
                gl.glColor3ub(p,255,255);
                
                quad = glu.gluNewQuadric()
                glu.gluQuadricOrientation(quad, glu.GLU_OUTSIDE)
                
                glu.gluSphere(
                  quad,
                  1,
                  4,
                  4
                );
                gl.glPopMatrix()
            end
            gl.glReadPixels( winX[0], winY[0], 1,1, gl.GL_RED, gl.GL_UNSIGNED_BYTE, pickId );
            gl.glEnable(gl.GL_LIGHTING)
            gl.glEnable(gl.GL_FOG)
            
            if mab.parties[pickId[0]] then
              tty=mab.parties[pickId[0]].name
             
              picked=pickId[0]
              mouse.rclick=true
              
              --@ Avoid bumpy picks
              local scrX=ffi.new("double[1]",1);
              local scrY=ffi.new("double[1]",1);
              local scrZ=ffi.new("double[1]",1);
              
              local modelview=ffi.new("double[16]",1);
              gl.glGetDoublev( gl.GL_MODELVIEW_MATRIX, modelview );
              
              local projection=ffi.new("double[16]",1);
              gl.glGetDoublev( gl.GL_PROJECTION_MATRIX, projection );
              
              local viewport=ffi.new("int[4]",1);
              gl.glGetIntegerv( gl.GL_VIEWPORT, viewport );
              glu.gluProject(mab.parties[pickId[0]].pos[1], mab.parties[pickId[0]].pos[3], mab.parties[pickId[0]].pos[2], modelview, projection, viewport, scrX, scrY, scrZ);
              
              pickoffst={
                                mouse.x -scrX[0],
                  (lujgl.height-mouse.y)-scrY[0]
              }
              
            else
              tty="unknown"
              picked=0
            end
            print("dragging "..tty)
      elseif picked ~= 0 then
            print("dropped "..tty)
            mouse.rclick=false
            pickoffst={0,0}
      end

      end
      if k==0 then mouse.lclick=down end
      if k==2 then mouse.mclick=down end
      
      mouse.x=x
      mouse.y=y
    
    elseif ev=="wheel" then  -- wheel movement
     
      mouse.wheel_locl=arg[1]
      mouse.wheel_absl=arg[2]
      
      if mouse.wheel_absl then --mab scroll like effect
       py=py+mouse.wheel_locl
       --rx=rx+mouse.wheel_locl
       --rang=mouse.wheel_absl
      end
      
    end

  end
  )

--@ start the loop already
lujgl.mainLoop()