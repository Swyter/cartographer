    __________________________________________________________
   / __  ___  ___ ____ ___  ___  ___  ___  __        ___  ___ \
  / /   /_ / /__/  /  /  / / _  /__/ /__/ /__/ /__/ /__  /__/ /
 / /__ /  / / \   /  /__/ /__/ / \  /  / /    /  / /__  / \  /
 \__________________________________________________________/

  [your mount&blade strategic map editor of choice]
  
  
  About this appl.
  ----------------
  
  Currently in early stage, this program allows to position world parties/cities
  in real-time. Originally created for the Star Wars Conquest mod <http://getconquest.net>
  
  The instructions
  ----------------
  
  {Shift} Switchs labeling between ids and names
    {Tab} Switchs visually between faceted and smooth terrain
     {F5} Saves map.txt
     {F6} Reloads map.txt
     {F7} Imports Obj
     {F8} Exports Obj
     {F9} Saves edited parties
     
  Think of it as west: map
                 east: obj
           outer keys: save
           inner keys: load
  
  Acknowledgements
  ----------------
  
  It's written in Lua <http://lua.org/> and uses LuaJit as runtime. Providing a
  great speed enhancement that equals native C/C++ code.
  
  Loads common image/texture types though a tiny lib called SOIL <http://lonesock.net/soil.html>,
  based on stb_image <http://nothings.org/> but with DDS/DXT1-3-5 support.
  
  OpenGL and GLFW FFI bindings are provided by LuJGL <https://github.com/ColonelThirtyTwo/LuJGL>
  
  That's it.