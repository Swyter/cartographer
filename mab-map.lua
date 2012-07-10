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


function mab.map:load()
end

function mab.map:save()
    print("Map saving not implemented... yet")
end