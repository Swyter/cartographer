local vector = require "vectors"
local lujgl  = require "lujgl"
local ffi    = require "ffi"

local gl, glu = lujgl.gl, lujgl.glu


local key, mouse,  px, py, pz,   rx, ry, rz,   xrang, yrang=
       {},    {}, -31,-43,-14,   38, 80, 90,     242,    32

mouse.x=0
mouse.y=0
mouse.xold=0
pickoffst={0,0}

objX=ffi.new("double[1]");
objY=ffi.new("double[1]");
objZ=ffi.new("double[1]");

-- swy: redirect the debug prints to the actual 3D screen into a simulated kill log
printbufpos=1; movetxt=0; new_unprinted_lines=0
printbufmax=20; printbuf={}; orig_print=print
function print(line, ...) local arg={...}
  orig_print(line, ...) -- swy: call the original function so that it still prints to the console
  printbufpos = (printbufpos+1) % printbufmax -- swy: advance the ring buffer position, with wraparound

  for k,v in ipairs(arg) do         -- swy: if there is more than one argument, append the extra variables
      line=line.. " "..tostring(v)  --      (could be a number/bool that needs conversion) to the line
  end
  if new_unprinted_lines < printbufmax/3 then -- swy: this is used to scroll down a notch for every line, don't allow 
    new_unprinted_lines=new_unprinted_lines+1 --      scrolling too many of them at once or all of them will move below the screen
  end
  printbuf[printbufpos]=line -- swy: paste it into the current ring buffer position for printing
end
    
--@ Load cooler dependencies
  require "winapi"
  
  require "mab-registry"
  reg=mab.registry:query()
  
  cartographer={}; dofile("cartographer.conf.ini") --new easy peasy config file
  
  require "mab-msys"
  msys=mab.msys:getmsysfolder()
   mod=mab.msys:getmodulefolder()
  print(string.format("Msys folder at <%s>",msys))
  print(string.format("Module folder at <%s>",mod))
  
--@ init and stuff
  lujgl.initialize("cartographer", 800, 600)
  handle=winapi:GetHandle("","GLFW27")

--@ load our font
  require "soil"
  require "mab-font"
  
  function check(f)
    if not io.open(f,"r") then return false else io.close() return f end
  end
  
  mab.font:load(check(mod.."\\Data\\FONT_DATA.XML") or mod.."\\..\\..\\Data\\FONT_DATA.XML",
                check(mod.."\\textures\\FONT.dds")  or mod.."\\..\\..\\textures\\FONT.dds")
                
 -- mab.font:load("R:\\Juegos\\swconquest\\modules\\swconquest\\Module Data\\FONT_DATA.XML",
 --               "R:\\Juegos\\swconquest\\modules\\swconquest\\Textures\\FONT_SWC.dds")

--@ load our map
  require "mab-map"
  mab.map:load(mod)--"R:\\Juegos\\swconquest\\modules\\swconquest")
  
--@ load our locations
  require "mab-parties"
  mab.parties:load(msys.."\\module_parties.py")--"R:\\Juegos\\swconquest\\modules\\swconquest-msys\\module_parties.py")
  mab.parties:groundalign()
  
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
  gl.glDepthFunc(gl.GL_LESS)

  gl.glEnable(gl.GL_COLOR_MATERIAL)
  
  gl.glEnable(gl.GL_LIGHTING)
  gl.glEnable(gl.GL_LIGHT0)

--@ we like callbacks
lujgl.setIdleCallback(function()

  --manage non-blocking input
    sin,cos,rad,abs=math.sin,math.cos,math.rad,math.abs
    
    --x3 speed multiplier when CTRL is pressed together with the arrow keys
    --there's an additional boost when the camera is high over the terrain
    local multiplier = (key[289] and 3 or 1) * (abs(py)/20); if multiplier==0 then multiplier=1 end
    
    --rebuild the direction vector from the /yaw/ angle (in degrees) using trigonometry
    if key["w"] or key[283] then pz=pz+cos(rad(xrang)) * multiplier
                                 px=px-sin(rad(xrang)) * multiplier end
    if key["s"] or key[284] then pz=pz-cos(rad(xrang)) * multiplier
                                 px=px+sin(rad(xrang)) * multiplier end
                                 
    if key["a"] or key[285] then pz=pz+cos(rad(xrang-90)) * multiplier
                                 px=px-sin(rad(xrang-90)) * multiplier end --reversed
    if key["d"] or key[286] then pz=pz-cos(rad(xrang-90)) * multiplier
                                 px=px+sin(rad(xrang-90)) * multiplier end --reversed
                                 
    if key[265] then local objpath=winapi:SaveDialog(handle) --f8
                        if objpath then
                          print(string.format("saving OBJ to <%s>",objpath))
                          mab.map:saveobj(objpath)
                        end
                     end
    if key[264] then local objpath=winapi:OpenDialog(handle) --refresh cached map end --f7
                      if objpath then
                        print(string.format("loading OBJ from <%s>",objpath))
                        mab.map:loadobj(objpath,false)
                        
                        gl.glDeleteLists(mapmesh,1);mapmesh=nil
                        mab.parties:groundalign()
                      end
                     end 
                     
    if key[262] then mab.map:save(mod.."\\map.txt",true) end --f5
    if key[263] then if winapi:messagebox() then --f6
                       mab.map:load(mod);
                       gl.glDeleteLists(mapmesh,1);mapmesh=nil
                     end
                    end--refresh cached map end
                     
    if key[266] then mab.parties:save(msys.."\\module_parties.py") end --f9
    if key[267] then mab.parties:load(msys.."\\module_parties.py")     --f10
                     mab.parties:groundalign() end
    
    
    if mab.parties[picked] then
      --rotate mode
      if key['r'] then
      
        mab.parties[picked].isbeenmod=true
        
        if not mab.parties[picked].oldpos then --save position for good measure
          mab.parties[picked].oldpos = mab.parties[picked].pos
        end
      
        if not mab.parties[picked].oldrot then --save rotation for good measure
          mab.parties[picked].oldrot = mab.parties[picked].rot
        end

        mab.parties[picked].rot = mab.parties[picked].rot + (mouse.xold-mouse.x)/2
        
        if mab.parties[picked].rot > 360 then mab.parties[picked].rot=0
    elseif mab.parties[picked].rot < 0   then mab.parties[picked].rot=360 end --clamp between 0<>360 deg

      --drag mode
      elseif key['g'] then
      
        mab.parties[picked].isbeenmod=true
        
        if not mab.parties[picked].oldpos then --save it for good measure
          mab.parties[picked].oldpos = mab.parties[picked].pos
        end
        
        --fill the new value so it will be drawn in the next frame
        mab.parties[picked].pos=vector.new(objX[0],objZ[0],objY[0])

      end
    end
    
    if mouse.lclick then xrang=xrang+(mouse.xold-mouse.x)/2; rx=1
                         yrang=yrang+(mouse.yold-mouse.y)/2; ry=1; end
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
    gl.glMatrixMode(gl.GL_PROJECTION)
    gl.glLoadIdentity()
    
    glu.gluPerspective(60,lujgl.width / lujgl.height, 0.01, 1000)
    gl.glMatrixMode(gl.GL_MODELVIEW)
    gl.glLoadIdentity()
    
  --/pitch/ rotation -> /yaw/ rotation -> translation
    gl.glRotatef(yrang,ry, 0, 0)
    gl.glRotatef(xrang, 0,rx, 0)
    gl.glTranslatef(px,py,pz)
    
    lujgl.glLight(gl.GL_LIGHT0, gl.GL_AMBIENT, 0.1, 0.12, 0.19)
    lujgl.glLight(gl.GL_LIGHT0, gl.GL_POSITION, 10, 1, 1, 0)   

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

    if not mapmesh or not gl.glIsList(mapmesh) then
    print"(i)no cache available, rebuilding displaylist"; local start=os.clock()
    mab.map:softnormal()
    
       mapmesh=gl.glGenLists(1)
       gl.glNewList(mapmesh, gl.GL_COMPILE)
       gl.glBegin(gl.GL_TRIANGLES)
       
        for i=1,#mab.map.fcs do
          x=tonumber(mab.map.fcs[i][11])
          gl.glColor3f(unpack(mab.map.terrain[x] or {1,0,1}))
          
          for j=1,3 do
            local nm=faceted and mab.map.fcn[i]
                              or mab.map.vtn[mab.map.fcs[i][j]]
            gl.glNormal3d(nm.x,nm.y,nm.z)
            local vt=mab.map.vtx[mab.map.fcs[i][j]]
            gl.glVertex3d(vt.x,vt.y,vt.z)
          end
        end
       gl.glEnd()
       gl.glEndList()
       print("generated displaylist "..(os.clock()-start).."s")
       --mab.map=nil --garbage collector, do your work!
    
    else
       gl.glCallList(mapmesh)
    end

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
    
    --@draw the markers
    gl.glEnable(gl.GL_BLEND)
    gl.glDisable(gl.GL_FOG)
    for p=1,#mab.parties do
          gl.glPolygonMode( gl.GL_FRONT_AND_BACK, gl.GL_LINE )
          gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE)--vertex colored solid
          
          gl.glPushMatrix()
          gl.glTranslated(mab.parties[p].pos.x, mab.parties[p].pos.z,
                          mab.parties[p].pos.y)
          gl.glRotatef(mab.parties[p].rot, 0, 1, 0)
          
          gl.glColor4d(.8,.8,.8,.8)
          gl.glDisable(gl.GL_LIGHTING)
          --cross marker and yellow tinting when selected
          if picked==p then
              gl.glColor4d(.6,.2,0,.7)  --subtly orangey
              gl.glBegin(gl.GL_LINES)
                gl.glVertex3d(0, 1,0)   --vertical
                gl.glVertex3d(0,-1,0)
                
                gl.glVertex3d( 1,0,0)   --x
                gl.glVertex3d(-1,0,0)
                
                gl.glVertex3d(0,0, 1.2) --y (pointing to the north a bit)
                gl.glVertex3d(0,0,-1)   

              gl.glEnd()
              
              
              gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_ZERO)--vertex colored solid
              gl.glColor4d(1,.1,0,1)   --shockingly hot red
          
              gl.glBegin(gl.GL_LINES)                
                gl.glVertex3d(0,1, 1.2) --y (pointing to the north a bit)
                gl.glVertex3d(0,1, 0.0)
              gl.glEnd()
              
              
              gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE)--vertex colored solid
              gl.glColor4d(1,.6,0,1)   --hot yellow

          end
          gl.glEnable(gl.GL_LIGHTING)
          
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
          glu.gluProject(mab.parties[p].pos.x, mab.parties[p].pos.z, mab.parties[p].pos.y, modelview, projection, viewport, scrX, scrY, scrZ);

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
      local highlight=.7 and (key['g'] or key['r']) or .3
      gl.glColor4d(1,.9,1,highlight)
      gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_CONSTANT_ALPHA)--vertex colored solid
      mab.font:print(string.format("%d--%d",mouse.x, lujgl.height-mouse.y),
                     49,lujgl.height/2-110,.6)
                     
      mab.font:print(string.format("x:%g y:%g z:%g",-objX[0],objZ[0],objY[0]),
                     49,lujgl.height/2-60,.7)
                     
      if mab.parties[picked] then
       mab.font:print(string.format("%s (%g�)", mab.parties[picked].id, mab.parties[picked].rot),
                     49,lujgl.height/2-0,.7)
      end
      
      gl.glColor4d(.3,1,1,((lujgl.height-(mouse.y-60))/lujgl.height)*2) --cool fadeoff when cursor is close :)
      mab.font:print((mab.parties[picked] and
                        "{G} Drag party  "..
                        "{R} Rotate party  |  \n" or "")..
                     "{F5} Saves map.txt  "..
                     "{F6} Reloads map.txt   "..
                     "{F7} Imports Obj  "..
                     "{F8} Exports Obj  |  "..
                     "{F9} Saves edited parties  "..
                     "{F10} Reloads module_parties.py - Hold: "..
                     "{Shift} Show party IDs  "..
                     "{Ctrl} Move fast  |  "..
                     "{Tab} Sharp triangles"
                     ,
                     1,10,.3)
                     

      -- swy: a real m&b map editor clearly needs its own (animated) kill log
      if new_unprinted_lines > 0 then
        movetxt = movetxt + (20 * new_unprinted_lines) -- swy: reset it down a notch by a line height size every time a new line arrives
        new_unprinted_lines = 0
      end
      
      if movetxt > 0 then
        movetxt = movetxt - 1 -- swy: slowly animate the lines moving them up until reaching the base position
      end

      for i=1, printbufmax do -- swy: do the actual printing here
        gl.glColor4d(1,.9,.4, (printbufmax-i)/printbufmax) -- swy: the more the lines go up, the fainter they look
        mab.font:print(printbuf[(printbufpos + printbufmax - i) % printbufmax], 20, 45 - movetxt + (20 * i), .3) -- print the oldest line first and go down, the newest is the last one
      end
      
    lujgl.end2D()
    
    --bugs ahoy?
    lujgl.checkError()
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
      or k==266 or k==267      --f9 & f10
      or k==289                --Ctrl
      or k=="r" or k=="g" then --R for rotation and G for ground
      
      key[k]=down end
      
      --tab switchs between faceted display modes
      if k==293 and down then faceted = not faceted; print("faceted is",faceted); mapmesh=nil end
      
    elseif ev=="motion" then -- mouse movement
      mouse.x=arg[1]
      mouse.y=arg[2]
    
    elseif ev=="mouse" then  -- mouse clicks
      local k,down,x,y=arg[1],arg[2],arg[3],arg[4]
      
      if k==1 and down then
            local winX=ffi.new("float[1]",mouse.x);
            local winY=ffi.new("float[1]",lujgl.height-mouse.y);
            local pickId=ffi.new("GLubyte[4]",1);
            
            
            --@draw the color coded marker
            gl.glClearColor(0,0,0,0)
            gl.glClear(bit.bor(gl.GL_COLOR_BUFFER_BIT, gl.GL_DEPTH_BUFFER_BIT))
            gl.glDisable(gl.GL_AUTO_NORMAL)
            gl.glDisable(gl.GL_LIGHTING)
            gl.glDisable(gl.GL_LIGHT0)
            gl.glDisable(gl.GL_BLEND)
            gl.glDisable(gl.GL_FOG)
            
            for p=1,#mab.parties do
                
                gl.glPushMatrix()
                gl.glTranslated(mab.parties[p].pos.x,
                                mab.parties[p].pos.z,
                                mab.parties[p].pos.y)
                gl.glRotatef(mab.parties[p].rot, 0, 1, 0)
                                
                local bit=require "bit";
                --encode the party id as follows
                --(p & 0xff000000 >> 24,
                -- p & 0xff0000   >> 16,
                -- p & 0xff00     >>  8,
                -- p & 0xff)
                
                --p= p*7000000
                gl.glColor4ub(bit.rshift(bit.band(p,0xff000000),8*3),
                              bit.rshift(bit.band(p,0x00ff0000),8*2),
                              bit.rshift(bit.band(p,0x0000ff00),8),
                                         bit.band(p,0x000000ff));
                
                quad = glu.gluNewQuadric()
                
                glu.gluSphere(
                  quad,
                  1,
                  4,
                  4
                );
                gl.glPopMatrix()
            end
            gl.glReadPixels( winX[0], winY[0], 1,1, gl.GL_RGBA, gl.GL_UNSIGNED_BYTE, pickId );
            --print(pickId[0],pickId[1],pickId[2],pickId[3])
            
            pickId_dec=bit.bor(bit.lshift(pickId[0],8*3),
                               bit.lshift(pickId[1],8*2),
                               bit.lshift(pickId[2],8),
                                          pickId[3]);
            --print(pickId_dec)
            
            pickId=pickId_dec
            
            gl.glEnable(gl.GL_LIGHTING)
            gl.glEnable(gl.GL_FOG)
            gl.glVertex2s(1,1); -- /gDEBugger GL/ backbuffer breakpoint, if you're wondering :)
            if mab.parties[pickId] then
              tty=mab.parties[pickId].name
             
              picked=pickId
              mouse.rclick=true
              
              --@ Avoid bumpy picks
              local scrX=ffi.new("double[1]");
              local scrY=ffi.new("double[1]")
              local scrZ=ffi.new("double[1]");
              
              local modelview=ffi.new("double[16]");
              gl.glGetDoublev( gl.GL_MODELVIEW_MATRIX, modelview );
              
              local projection=ffi.new("double[16]");
              gl.glGetDoublev( gl.GL_PROJECTION_MATRIX, projection );
              
              local viewport=ffi.new("int[4]");
              gl.glGetIntegerv( gl.GL_VIEWPORT, viewport );
              glu.gluProject(mab.parties[picked].pos.x,
                             mab.parties[picked].pos.z,
                             mab.parties[picked].pos.y, modelview, projection, viewport, scrX, scrY, scrZ);
              
              pickoffst={
                                mouse.x -scrX[0],
                  (lujgl.height-mouse.y)-scrY[0]
              }
              
              --lujgl.glfw.glfwSwapBuffers()
              
            else
              tty="unknown"
              picked=0
            end
            print("dragging "..tty)
      elseif k==1 and picked ~= 0 then
            print("dropped "..(tty or "bug"))
            mouse.rclick=false
            pickoffst={0,0}
      end
      if k==0 then mouse.lclick=down end
      if k==2 then mouse.mclick=down end
      
      mouse.x=x
      mouse.y=y
    
    elseif ev=="wheel" then  -- wheel movement
     
      mouse.wheel_locl=arg[1]
      mouse.wheel_absl=arg[2]
      
      if mouse.wheel_absl then --mab scroll like effect
       py=py+mouse.wheel_locl * math.max(abs(py)/30, 0.1) * (key[289] and 3 or 1) -- swy: make zoom-in-out scroll movement x3 faster when Ctrl is held, also, scale up the scroll wheel effect as we get far higher and higher over the map; reduce medical bills. with the max(.01) we ensure that we never get stuck at zero
       --rx=rx+mouse.wheel_locl
       --rang=mouse.wheel_absl
      end
      
    elseif ev=="close" then --closing down
      gl.glDeleteTextures(1,ffi.new("const unsigned int[1]",fontdds)) -- get rid of the bitmap font and unload the 
      gl.glDeleteLists(mapmesh,1)                                     -- map mesh. that fixes those ugly GPU memory leaks
    end

  end
  )

--@ start the loop already
lujgl.mainLoop()