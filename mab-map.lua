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

function mab.map:save()
    print("Map saving not implemented... yet")
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


function string:split(sep) --from <http://lua-users.org/wiki/SplitJoin> #Method: Using only string.gsub -> Fix
        local sep, fields = sep or "/", {}
        local pattern = string.format("([^%s]+)", sep)
        self:gsub(pattern, function(c) fields[#fields+1] = c end)
        return fields
end

function mab.map:loadobj(file,reversed_mode)
  print("@--Importing OBJ..."); local fs=0; local lastmat="plain"; local start=os.clock()
  mab.map.vtx,mab.map.fcs={},{}

  for line in io.lines(file) do
  
    ltrim=line:match("%S.*") or "#"
    index=ltrim:sub(1,2)
    if index ~= "# " then --not a comment
      local raw=line:sub(3,-1) --skip the index/letter part plus one space
      if index == "v " then --@vertex
        local tmp={}; for w in raw:gmatch("%S+") do table.insert(tmp, tonumber(w)) end
        if reversed_mode then tmp[2],tmp[3]=tmp[3],tmp[2]*-1; end
        mab.map.vtx[#mab.map.vtx+1]=vector.new(tmp[1],tmp[2],tmp[3])
        
      elseif index == "us" then --usemtl forest -- last material found
        lastmat=line:sub(8,-1)
      elseif index == "f " then --@face
      fs=fs+1;
      --if string.find(raw, "/") == -1 then --line comes with normals && texcoords?
          mab.map.fcs[fs]={}; for w in raw:gmatch("%S+") do
          table.insert(mab.map.fcs[fs], tonumber(w)) end --This saves a lot of time recursively parsing stuff, redundancy is slow... branching is good
       --[[ else
          local nmc=3
          mab.map.fcs[fs]={};
          
          for w in raw:gmatch("%S+") do
          wsplit=w:split();nmc=nmc+1;
          table.insert(mab.map.fcs[fs], tonumber(wsplit[1]));end
        end]]
        --print(_G["rt_"..lastmat])
        --print("rt_"..lastmat)
        mab.map.fcs[fs][11]=_G["rt_"..lastmat] --@FIXME hack, no material as of yet :(
      end
    end
  end
  print("   finished... "..(os.clock()-start).."s") vtx=#mab.map.vtx; fcs=#mab.map.fcs; print(string.format("%d vertex, %d faces",vtx,fcs))
end