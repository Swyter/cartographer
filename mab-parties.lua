mab = mab or {}
mab.parties = mab.parties or {}

local ffi,vector=require"ffi",require"vectors"

  --
 -- Helper functions
--

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
function Round(num, idp) --from <http://lua-users.org/wiki/SimpleRound> #Function: Igor Skoric (i.skoric@student.tugraz.at)
    local mult = 10^(idp or 0)
    if num >= 0 then return math.floor(num * mult + 0.5) / mult
    else return math.ceil(num * mult - 0.5) / mult end
end

  --
 -- M&B Party methods
--

function mab.parties:load(filename)
  print("@--start parsing parties"); s=0; tt=os.clock()
  for line in io.lines(filename) do
  
        local ltrim=line:match("%S.*") or "#"
        local index=ltrim:sub(1,1)

        if index ~= "#" then
          if index=="(" and not line:find("pf_disabled") then --avoid comments and filler entries
             
             tuple=ltrim:gsub(",%s*#.+", "") --remove possible comments from the right side
             tuple=tuple:gsub(" ", ""):gsub("\"", ""):gsub("%(", ""):gsub("%)", "") --remove all the: "()
             
             if tuple:find("pf_town") then kind=1 else kind=2 end

             tuple = Split(tuple,",")
             s=s+1

             mab.parties[s]={
                id=tuple[1] or "<error>",
              name=tuple[2] and tuple[2]:gsub("_", " ") or "<error>",
               pos=vector.new(
                    (tonumber(tuple[10])*-1) or 0, --invert X coordinates
                     tonumber(tuple[11])     or 0
                   ),
               rot=tonumber(tuple[13]) or 0,
              kind=kind
             }
             
            print("rot:"..mab.parties[s].rot,tuple[13])
          end
        end
  end
  
  print(string.format("   %d parties loaded... %gs",s,os.clock()-tt))
  return s
end

function mab.parties:save(filename)
  print("@--saving modified parties"); tt=os.clock()
  
  local tline={}
  
  for line in io.lines(filename) do --read everything
    tline[#tline+1]=line
  end
  
  if io.output(io.open(filename,"w")) then
  for i=1,#tline do 

        local ltrim=tline[i]:match("%S.*") or "#"
        local index=ltrim:sub(1,1)

        if index ~= "#" and index=="(" then --avoid comments and filler entries
          
            for pid=1,#mab.parties do        
              if mab.parties[pid].isbeenmod                            and  --itirerate over all the avaliable, modified parties
                 tline[i]:find("[\"']"..mab.parties[pid].id.."[\"']")  then --if matches in the line, bingo! try to replace coordinates by the new ones
              
                  print( mab.parties[pid].name.." has been modified  -->  ",
                         mab.parties[pid].pos.x*-1,mab.parties[pid].pos.y)
                 
                  tline[i]=string.gsub(tline[i], "%([ \t]*"..(mab.parties[pid].oldpos.x*-1).."[ \t]*,",    -- (NN,
                  function(pickedbit)
                    return pickedbit:gsub(mab.parties[pid].oldpos.x*-1,Round(mab.parties[pid].pos.x, 2)*-1)
                  end,1) --XX
                  
                  tline[i]=string.gsub(tline[i], ",[ \t]*".. mab.parties[pid].oldpos.y    .."[ \t]*%)",    -- ,NN)
                  function(pickedbit)
                    return pickedbit:gsub(mab.parties[pid].oldpos.y,Round(mab.parties[pid].pos.y, 2))
                  end,1) --YY
                  
                if mab.parties[pid].oldrot then
                --round up to integer first, this is important
                mab.parties[pid].rot=math.ceil(mab.parties[pid].rot)
                
                print("oldrot:"..mab.parties[pid].oldrot,"rot:"..mab.parties[pid].rot)
                  tline[i]=string.gsub(tline[i], "%],[ \t]*".. mab.parties[pid].oldrot    .."[ \t]*%),",   -- ],NN),
                  function(pickedbit)
                    print(pickedbit)
                    return pickedbit:gsub(mab.parties[pid].oldrot, mab.parties[pid].rot)
                  end,1) --ROT

                end
                  
                  tline[i]=string.format("%s #[swycartographr] prev. coords: (%g, %g)%s",
                           tline[i]..string.rep(" ",(140-tline[i]:len())),
                           mab.parties[pid].oldpos.x*-1,
                           mab.parties[pid].oldpos.y,
                           (mab.parties[pid].oldrot==nil and "" or " rot: "..mab.parties[pid].oldrot)
                           )
                           
                  mab.parties[pid].isbeenmod=false
                  mab.parties[pid].oldrot=nil
                  break
              end
            end
            
        end
        
        io.write(tline[i].."\n") --drop the line
  end   io.close()
  end
  
  print("   done...")
end

function mab.map.heightforpoint(triangle, point)
     local v1,v2,v3=
     mab.map.vtx[triangle[1]],
     mab.map.vtx[triangle[2]],
     mab.map.vtx[triangle[3]]
    
     local x,z=point.x,point.z

     local q = (v2.x - v1.x) * (v3.z - v1.z) - (v3.x - v1.x) * (v2.z - v1.z);
     if (q == 0) then return v1.y; end
     local q = 1.0 / q;
     local u = q * ((v2.x - x) * (v3.z - z) - (v3.x - x) * (v2.z - z));
     local v = q * ((v3.x - x) * (v1.z - z) - (v1.x - x) * (v3.z - z));
     local w = q * ((v1.x - x) * (v2.z - z) - (v2.x - x) * (v1.z - z));
     return (u * v1.y) + (v * v2.y) + (w * v3.y);
end

ffi.cdef("struct kd_elem{ uint8_t tri; double x,y; }")

function mab.parties:groundalign()
   local abs,uu=math.abs, os.clock()
   local vtx,fcs=mab.map.vtx, mab.map.fcs
   
   local ffi,kd,kdtree=require("ffi"), require("kdtree"), {}
  
   --build the kdtree
   for i=1,#fcs do
   
     --compute barycenter
     local tricenterx=(vtx[fcs[i][1]].x+
                       vtx[fcs[i][2]].x+
                       vtx[fcs[i][3]].x)/3
     local tricentery=(vtx[fcs[i][1]].z+
                       vtx[fcs[i][2]].z+
                       vtx[fcs[i][3]].z)/3
     table.insert(kdtree, ffi.new("struct kd_elem",{tri=i,x=tricenterx,y=tricentery}))
  end
  
  --here is where the magic happens
  kd.tree_create(kdtree,0)

  --itinerate across all the existing settlements
  for p,_ in pairs(mab.parties) do
    if type(mab.parties[p]) == "table" then
    --find the closest triangle
    local tri=kd.tree_find(kdtree, mab.parties[p].pos)
    local hei=mab.map.heightforpoint(fcs[tri], mab.parties[p].pos) or 100
    
    --set the height
    mab.parties[p].pos.z=hei
    end
  end
  
  print(string.format("   ground aligned in %gs",os.clock()-uu))
end