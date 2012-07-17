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
    [(rt_mountain_forest)]  ={ .5,  .6,  .4  },
    [(rt_steppe_forest)]    ={ .4,  .5,  .4  },
    [(rt_forest)]           ={ .5,  .6,  .4  },
    [(rt_snow_forest)]      ={ .8,  .8,  .8  },
    [(rt_desert_forest)]    ={ .5,  .6,  .4  }
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


function mab.map:saveobj(file,reversed_mode)
  print("@--Exporting OBJ..."); local start=os.clock(); local lastmat=-1;
  io.output(io.open(file,"w"))
  io.write([[
  # Mount&Blade Map file
  # Exported by swyter's cartographer

]])
  
  for s=1,vtx do
    local curr=mab.map.vtx[s]; if reversed_mode then curr.y,curr.z=curr.z,(curr.y*-1); end
    io.write(
      string.format("v %g %g %g\n",curr.x,curr.y,curr.z) --floats
    )
  end
 
  for s=1,fcs do
    local curr=mab.map.fcs[s]
    
    if lastmat ~= tonumber(curr[11]) then --implemented material export
      io.write(string.format("usemtl %s\n",mat[tonumber(curr[11])])); lastmat=tonumber(curr[11])
    end
    
    io.write(
      string.format("f %d %d %d\n",curr[1],curr[2],curr[3]) --integers
    )
  end
  io.close()
  print("   done... "..(os.clock()-start).."s")
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
  print("@--Importing OBJ..."); local fs=0; local lastmat="plain"; local start=os.clock()
  mab.map.vtx,mab.map.fcs={},{}

  for line in io.lines(file) do
  
    local ltrim=line:match("%S.*") or "#"
    local index=ltrim:sub(1,1)
    if index ~= "#" then --not a comment
    
        local raw=Split(ltrim," ")
        
        --@vertex
        ---------------------------
        if     raw[1]=="v"      then
        
            if reversed_mode then raw[2],raw[3]=raw[3],raw[2]*-1; end
            mab.map.vtx[#mab.map.vtx+1]=vector.new(
                                        tonumber(raw[2]),
                                        tonumber(raw[3]),
                                        tonumber(raw[4])
                                        )
                                        
        --@material
        ---------------------------
        elseif raw[1]=="usemtl" then
        
            lastmat=raw[2]
        
        --@face
        ---------------------------
        elseif raw[1]=="f"      then
        
        fcount=(#mab.map.fcs+1)
        mab.map.fcs[fcount]={}
          
            for i=2,4 do --for every section do this
            
              local facesplit=Split(raw[i],'/');
              
              mab.map.fcs[fcount][i-1]=tonumber(facesplit[1])
  
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