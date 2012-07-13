local ffi=require"ffi"
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

mab = mab or {}
mab.map = mab.map or {}
mab.map.terrain = mab.map.terrain or {}

------------->  Color Table -- Red, Green, Blue
mab.map.terrain={
    [(rt_water)]            ={   0,   0,   1  },
    [(rt_mountain)]         ={  .5,  .6,  .4  },
    [(rt_steppe)]           ={   0,   1,  .5  },
    [(rt_plain)]            ={   0,   1,  .2  },
    [(rt_snow)]             ={   1,   1,   1  },
    [(rt_desert)]           ={   0,   0,  .8  },
    [(rt_bridge)]           ={   1,   0,   0  },
    [(rt_river)]            ={   0,   0,  .8  },
    [(rt_desert)]           ={  .7,  .8,  .6  },
    [(rt_mountain_forest)]  ={  .5,  .6,  .4  },
    [(rt_steppe_forest)]    ={  .5,  .6,  .4  },
    [(rt_forest)]           ={  .5,  .6,  .4  },
    [(rt_snow_forest)]      ={  .8,  .8,  .8  },
    [(rt_desert_forest)]    ={  .5,  .6,  .4  }
}


function mab.map:load(path)
  mab.map.path=path.."\\map.txt"
  mab.map.raw={}

  print("start parsing map"); s=0
  for line in io.lines(mab.map.path) do
    s=s+1
    mab.map.raw[s]={}
    for w in line:gmatch("%S+") do table.insert(mab.map.raw[s], w) end --simpler and surely faster
  end
  print("ended parsing map")
  
  mab.map.vtx={}
  mab.map.fcs={}
  
  vtx=tonumber(mab.map.raw[1][1])
  fcs=tonumber(mab.map.raw[vtx+2][1])
  print(string.format("%d vertex, %d faces",vtx,fcs))
  
  --@ vertex array
  s=0
  for i=2,vtx+1 do
     s=s+1
     local r=mab.map.raw[i]
     
     mab.map.vtx[s]=ffi.new("const float[3]",{tonumber(r[1]),tonumber(r[3]),tonumber(r[2])}) --reversed y/z
     --print(unpack(v))
  end
 
  
  --@faces array
  s=0
  for i=vtx+3,vtx+2+fcs do
     s=s+1
     local r=mab.map.raw[i]
     
     mab.map.fcs[s]={r[4]+1,r[5]+1,r[6]+1} --lua tables start at 1
     --print(unpack(v))
  end
  
  print"ended filling arrays"
  
end

function mab.map:save()
    print("Map saving not implemented... yet")
end