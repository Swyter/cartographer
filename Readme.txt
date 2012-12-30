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
  
  Keep pressing the left mouse button while moving to rotate the camera first-person style,
  drag and select settlements with the right mouse button.
  
  Adjust your vertical distance from the terrain with the help of your mouse wheel.
  
  Use /R/ to rotate a previously selected settlement, alternatively you can also use /G/
  to move it directly to the current cursor position for better accuracy.
  
  {Shift} Switchs labeling between ids and names
   {Ctrl} x3 Speed multiplier when using the direction keys
    {Tab} Switchs visually between faceted and smooth terrain
    
     {F5} Saves map.txt
     {F6} Reloads map.txt
     {F7} Imports Obj
     {F8} Exports Obj
     
     {F9} Saves edited parties
    {F10} Reloads module_parties.py
     
  Think of it as west: map
                  mid: obj
                 east: parties
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