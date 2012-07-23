local lujgl = require "lujgl"

local gl = lujgl.gl
local glu = lujgl.glu

mab = mab or {}
mab.font = mab.font or {}

  --
 -- Loading functions
--

function mab.font:load(filename,filenamedds)
print("@--start loading font xml")
start=os.clock()

local strmatch=string.match
local _xmlblock=function(l,pattern)
  return tonumber(strmatch(l, pattern.."=\"(.-)\"") or 0) --non-greedy match
end

  for l in io.lines(filename) do
 
    if string.find(l,"<FontData") then  --pseudoparser!, fingers crossed in case it doesn't use a standard format
    
      mab.font["width" ] =_xmlblock(l,"width")
      mab.font["height"] =_xmlblock(l,"height")
      mab.font["padding"]=(_xmlblock(l,"padding") or 0)/2 --we are going to apply it to every corner, so 5/5 and 5/5 in case its <10>
      
      print("    width:"..mab.font["width"],
               "height:"..mab.font["height"],
              "padding:"..mab.font["padding"])
    
    elseif string.find(l,"<character") then
      ccode=_xmlblock(l,"code")
      mab.font[ccode]={}
     
      mab.font[ccode].u=_xmlblock(l,"u")
      mab.font[ccode].v=_xmlblock(l,"v")
      mab.font[ccode].w=_xmlblock(l,"w")
      mab.font[ccode].h=_xmlblock(l,"h")
      mab.font[ccode].preshift = _xmlblock(l,"preshift")
      mab.font[ccode].yadjust  = _xmlblock(l,"yadjust")
      mab.font[ccode].postshift= _xmlblock(l,"postshift")
    end
  end
  
  print(string.format("   font loaded in %gs",os.clock()-start))
  
  
  
  print("@--start loading font dds")
  fontdds = soil.loadTexture(filenamedds)
  
end


  --
 -- Helper functions
--

function mab.font:print(phrase,x,y,s)
  gl.glEnable(gl.GL_TEXTURE_2D)
  gl.glBindTexture(gl.GL_TEXTURE_2D,fontdds)
  
  gl.glEnable(gl.GL_BLEND)
--gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_SRC_COLOR)--outlines
--gl.glBlendFunc(gl.GL_SRC_ALPHA, gl.GL_ONE_MINUS_CONSTANT_ALPHA)--vertex colored solid

  local x=x or 50
  local y=y or 40
  local s=s or 1--130
  phrase:gsub(".",
    function(c)
      ls = mab.font:char(c,x,y,s)
      x = x + ls
    end)

  gl.glDisable(gl.GL_TEXTURE_2D)
end

function mab.font:char(c,x,y,s)
  c=string.byte(c)

  gl.glBegin(gl.GL_QUADS)
  
  local u=    (mab.font[c].u-mab.font.padding)/mab.font.width
  local v= 1-((mab.font[c].v-mab.font.padding)/mab.font.height)
  local w=    (mab.font[c].w-mab.font.padding)/mab.font.width
  local h= 1-((mab.font[c].h-mab.font.padding)/mab.font.height)

  --derivate the correct aspect ratio
  local sx, sy = mab.font[c].w-mab.font[c].u, mab.font[c].h-mab.font[c].v --width
  
  --horizontal adjustments
  local x = x+(mab.font[c].preshift*s)
  --vertical adjustments
  local yadj = mab.font[c].yadjust-sy
  
  --1
    gl.glTexCoord2d(u,h)--(0,0)
    gl.glVertex2i(x, (0+yadj*s)+y)
  --2
    gl.glTexCoord2d(w,h)--(1,0)
    gl.glVertex2i((sx*s)+x, (0+yadj*s)+y)
  --3
    gl.glTexCoord2d(w,v)--(1,1)
    gl.glVertex2i((sx*s)+x, ((sy+yadj)*s)+y)
  --4
    gl.glTexCoord2d(u,v)--(0,1)
    gl.glVertex2i(x, ((sy+yadj)*s)+y)
  --    v
  --   4|      3
  -- u--+-----+
  --    |     |
  --    |     |
  --    +-----+--w
  --   1      |2
  --          h
  gl.glEnd()
  sx=sx*s
  return sx-(sx-(mab.font[c].postshift*s))
end