local ffi,vector=require"ffi",require"vectors"

--# swy.Cartographer Terrain Defines
rt_water                = 0
rt_mountain             = 1
rt_steppe               = 2
rt_plain                = 3
rt_snow                 = 4
rt_desert               = 5
rt_bridge               = 7
rt_river                = 8
rt_mountain_forest      = 9
rt_steppe_forest        = 10
rt_forest               = 11
rt_snow_forest          = 12
rt_desert_forest        = 13
rt_deep_water           = 15 --unofficial

mat={
[0]                ="water",
[1]             ="mountain",
[2]               ="steppe",
[3]                ="plain",
[4]                 ="snow",
[5]               ="desert",
[7]               ="bridge",
[8]                ="river",
[9]      ="mountain_forest",
[10]        ="steppe_forest",
[11]               ="forest",
[12]          ="snow_forest",
[13]        ="desert_forest",
[15]           ="deep_water" --unofficial
}

--[[ From the OBJ exporter <http://www.mbrepository.com/file.php?id=2220>
#define rt_ocean 0
#define rt_mountain 1
#define rt_steppe 2
#define rt_plain 3
#define rt_snow 4
#define rt_desert 5
#define rt_ford 7
#define rt_river 8
#define rt_mountain_forest 9
#define rt_steppe_forest 10
#define rt_forest 11
#define rt_snow_forest 12
#define rt_desert_forest 13
#define rt_water 15
]]

--#Aliases for clumsy exporters
rt_ocean=rt_water



mab = mab or {}
mab.map = mab.map or {}
mab.map.terrain = mab.map.terrain or {}

------------->  Color Table -- Red, Green, Blue
mab.map.terrain={
    [(rt_water)]            ={  0,   0,  .3  },
    [(rt_mountain)]         ={ .5,  .6,  .4  },
    [(rt_steppe)]           ={  0,   1,  .5  },
    [(rt_plain)]            ={  0,   1,  .2  },
    [(rt_snow)]             ={  1,   1,   1  },
    [(rt_desert)]           ={  1,  .3,  .2  },
    [(rt_bridge)]           ={  1,   0,   0  },
    [(rt_river)]            ={  0,   0,  .5  },
    [(rt_desert)]           ={ .7,  .8,  .6  },
    [(rt_mountain_forest)]  ={ .4,  .7,  .3  },
    [(rt_steppe_forest)]    ={ .4,  .5,  .4  },
    [(rt_forest)]           ={ .3,  .6,  .3  },
    [(rt_snow_forest)]      ={ .8,  .8,  .8  },
    [(rt_desert_forest)]    ={ .6,  .7,  .5  },
    [(rt_deep_water)]       ={  0,   0,  .2  }
}


function mab.map:load(path)
  mab.map.path=path.."\\map.txt"
  local raw={}
  local x = os.clock()

  print("@--start parsing map"); s=0
  for line in io.lines(mab.map.path) do
    s=s+1
    raw[s]={}
    for w in line:gmatch("%S+") do table.insert(raw[s], w) end --simpler and surely faster
  end
  print("   ended parsing "..(os.clock()-x).."s")
  
  mab.map.vtx={}
  mab.map.fcs={}
  
  vtx=tonumber(raw[1][1])
  fcs=tonumber(raw[vtx+2][1])
  print(string.format("%d vertex, %d faces",vtx,fcs))
  
  --@ vertex array
  s=0
  for i=2,vtx+1 do
     s=s+1
     local r=raw[i]
     mab.map.vtx[s]=vector.new(tonumber(r[1])*-1,tonumber(r[3]),tonumber(r[2])) --reversed y/z
  end
 
  
  --@faces array
  s=0
  for i=vtx+3,vtx+2+fcs do
     s=s+1
     local r=raw[i]
     
     mab.map.fcs[s]={r[4]+1,r[5]+1,r[6]+1} --lua tables start at 1
     mab.map.fcs[s][11]=r[1]
  end
  
  print("   ended filling arrays "..(os.clock()-x).."s")
  raw={}; collectgarbage("collect")--discard raw material, let the garbage collector do its job
  
  if mab.map:aretheaxisreversed() then
    for i=1,#mab.map.vtx do --go across all the faces in the map
      mab.map.vtx[i].y, mab.map.vtx[i].z = mab.map.vtx[i].z, mab.map.vtx[i].y*-1
    end
  end
end

function mab.map:save(file,reversed_mode)
  print("@--Saving Map..."); local start=os.clock(); local lastmat=-1;
  io.output(io.open(file,"w"))
  
  io.write(string.format("%d\n",vtx))
  for s=1,vtx do
    local curr=mab.map.vtx[s]
    if reversed_mode then curr.x,curr.y,curr.z=curr.x*-1,curr.z,curr.y; end
    
    io.write(
      string.format("%g %g %g\n",curr.x,curr.y,curr.z) --floats
    )
  end
  
  io.write(string.format("%d\n",fcs))
  for s=1,fcs do
    local curr=mab.map.fcs[s]
 
    io.write(
      string.format("%d 0 3 %d %d %d\n",curr[11],curr[1]-1,curr[2]-1,curr[3]-1) --integers
    )
  end
  io.close()
  print("   done... "..(os.clock()-start).."s")
end

function mab.map:computenrm(triangle)
     local a,b,c=
     mab.map.vtx[triangle[1]],
     mab.map.vtx[triangle[2]],
     mab.map.vtx[triangle[3]]
    
    
     local U=vector.new(
     b.x-a.x,
     b.y-a.y,
     b.z-a.z
     )
     local V=vector.new(
     c.x-a.x,
     c.y-a.y,
     c.z-a.z
     )

     return U:cross(V):normalized()
end

--Pretty much everything here has been converted to lua using Martijn's math snippets, if you are reading this; thanks!
--http://www.bytehazard.com/code/math.html
function mab.map:computearea(triangle)
     local a,b,c=
     mab.map.vtx[triangle[1]],
     mab.map.vtx[triangle[2]],
     mab.map.vtx[triangle[3]]
     
     local sqrt=math.sqrt
    
     local D1=(a-b):len() --magnitudes
     local D2=(b-c):len()
     local D3=(c-a):len()
     
     local H = (D1 + D2 + D3) * 0.5
     return sqrt(H * (H - D1) * (H - D2) * (H - D3))
end

function mab.map:saveobj(file,reversed_mode)
  print("@--Exporting OBJ..."); local start=os.clock(); local lastmat=-1;
  if io.output(io.open(file,"w")) then
    io.write([[
  # Mount&Blade Map file
  # Exported by swyter's cartographer

mtllib swycartographer.mtl
o strategicmap

]])
    
    for s=1,vtx do
      local curr=mab.map.vtx[s]; if reversed_mode then curr.y,curr.z=curr.z,(curr.y*-1); end
      io.write(
        string.format("v %g %g %g\n",curr.x,curr.y,curr.z) --floats
      )
    end
   
    for s=1,fcs do
      local curr=mab.map.fcs[s]
      local cmat=tonumber(curr[11])
      
      --sanitize input, check for weird things
      assert(mat[cmat],"[!] Uh oh, undefined material: "..cmat)
      
      if lastmat ~= cmat then --implemented material export
        io.write(
          string.format("g %s\nusemtl %s\n",mat[cmat],mat[cmat])
        ); lastmat=cmat
      end
      
      io.write(
        string.format("f %d %d %d\n",curr[1],curr[2],curr[3]) --integers
      )
    end
    io.close()
    mab.map:savemtl(file)
    print("   done... "..(os.clock()-start).."s")
  end
end

function mab.map:savemtl(file)
  file=file:gsub("\\[^\\]+$", "\\swycartographer.mtl")
  print(file)
  
  if io.output(io.open(file,"w")) then
  
    for s,_ in pairs(mab.map.terrain) do
    if mat[s] then
      local r,g,b=unpack(mab.map.terrain[s])
      
      io.write(
        string.format("newmtl %s\n"
       ..'Ns 100.0\n'
       ..'d 1.0\n'
       ..'illum 2\n'
       ..'Kd %g %g %g\n'
       ..'Ka 0.5 0.5 0.5\n'
       ..'Ks 0.3 0.3 0.5\n'
       ..'Ke 0.0 0.0 0.0\n'
       ..'\n'
        ,mat[s],r,g,b) --floats
      )
    end
    end
    io.close()
    
  end
end


function Split(str, delim, maxNb) --from <http://lua-users.org/wiki/SplitJoin> #Function: Split a string with a pattern, Take Three
    -- Eliminate bad cases...
    if string.find(str, delim) == nil then
        return { str }
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0    -- No limit
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gfind(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end

function mab.map:loadobj(file,reversed_mode)
  print("@--Importing OBJ..."); local lastmat="plain"; local start=os.clock(); local lSplit=Split local tonum=tonumber
  mab.map.vtx,mab.map.fcs={},{}

  if io.open(file,"r") then
    for line in io.lines(file) do
    
      local ltrim=line:match("%S.*") or "#"
      local index=ltrim:sub(1,1)
      if index ~= "#" then --not a comment
      
          local raw=lSplit(ltrim," ")
          
          --@vertex
          ---------------------------
          if raw[1]=="v" then
          
              --if reversed_mode then raw[2],raw[3]=raw[3],raw[2]*-1; end
              mab.map.vtx[#mab.map.vtx+1]=vector.new(
                                          tonum(raw[2]),
                                          tonum(raw[3]),
                                          tonum(raw[4])
                                          )
                                          
          --@material
          ---------------------------
          elseif raw[1]=="usemtl" then
          
              lastmat=raw[2]
          
          --@face
          ---------------------------
          elseif raw[1]=="f" then
          
              fcount=(#mab.map.fcs+1)
              mab.map.fcs[fcount]={}
              
                for i=2,4 do --for every section do this
                
                  local facesplit=lSplit(raw[i],'/');
                  
                  mab.map.fcs[fcount][i-1]=tonum(facesplit[1])
      
                end
                
              mab.map.fcs[fcount][11]=_G["rt_"..lastmat] or 3 --@FIXME hack, no material as of yet :(

          end
      end
    end
  
  vtx=#mab.map.vtx;fcs=#mab.map.fcs; --refresh with latest info
  
  print(string.format(
  [[%d vertex, %d faces
   finished... in %gs]],
   vtx,
   fcs,
   (os.clock()-start)
   ))
  end
  
  if mab.map:aretheaxisreversed() then
    for i=1,#mab.map.vtx do --go across all the faces in the map
      mab.map.vtx[i].y, mab.map.vtx[i].z = mab.map.vtx[i].z, mab.map.vtx[i].y*-1
    end
  end
end

function mab.map:softnormal()
  local vtxi={}
  mab.map.fcn,mab.map.cfa,mab.map.vtn={},{},{}
  
  for i=1,fcs do --get a list of triangle membership for any vertex
    local vta,vtb,vtc=mab.map.fcs[i][1],mab.map.fcs[i][2],mab.map.fcs[i][3]

    vtxi[vta]=vtxi[vta] or {}
    vtxi[vtb]=vtxi[vtb] or {}
    vtxi[vtc]=vtxi[vtc] or {}
    
    vtxi[vta][#vtxi[vta]+1]=i
    vtxi[vtb][#vtxi[vtb]+1]=i
    vtxi[vtc][#vtxi[vtc]+1]=i
    
    --compute per-face normals using cross-product, don't ask me why putting this in its own loop halves the processing time, cool optimizations!
    mab.map.fcn[i]=mab.map:computenrm(mab.map.fcs[i])
    --compute area of this triangle/face, so we can average proportionally depending on sizes <http://www.bytehazard.com/code/vertnorm.html>
    mab.map.cfa[i]=mab.map:computearea(mab.map.fcs[i])
    
  end
  
  for i=1,#vtxi do --average between all the per-face normals to get a smooth aproximation
    if vtxi[i] and #vtxi[i] > 0 then
    local thingie=vector.new(0,0,0)
      for u=1, #vtxi[i] do
          local currface=vtxi[i][u]
          thingie=thingie+mab.map.fcn[currface]*mab.map.cfa[currface] --small polygons will have little influence, large polygons have large influence
      end
      mab.map.vtn[i]=(thingie/#vtxi[i]):normalized()
    end
  end
end


function mab.map:aretheaxisreversed()
  if mab.map.vtx and mab.map.fcs then --if we have map
  local max=math.max
  local abs=math.abs
  local ly,lz=0,0
  
    for i=1,#mab.map.fcs do --go across all the faces in the map and compare y/z of the second vertex
      ly=max(ly,abs(mab.map.vtx[mab.map.fcs[i][2]].y))
      lz=max(lz,abs(mab.map.vtx[mab.map.fcs[i][2]].z))
    end
    
    --if lz wins then the imported model has less height(ly) than width(lz), and probably, if we're dealing with
    --a non-weirdo map that means the axis are inverted because of different y/z handeness, at least in my head.
    print("ly:"..ly,"lz:"..lz,(ly>lz and "ly" or "lz").." wins!", (ly>lz and "reversing y/z coordinates" or "keeping coordinate system"))
    return (ly>lz and true or false) --ly is evil! >:(
  end
end