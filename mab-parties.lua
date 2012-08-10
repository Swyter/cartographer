mab = mab or {}
mab.parties = mab.parties or {}

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
          if index=="(" and not line:find("pf_disabled") and not line:find("pf_no_label") then --avoid comments and filler entries
             
             tuple=ltrim:sub(2,ltrim:find("%).*")) --remove possible comments from the right side
             tuple=tuple:gsub(" ", ""):gsub("\"", ""):gsub("%(", ""):gsub("%)", "") --remove all the: "()
             
             if tuple:find("pf_town") then kind=1 else kind=2 end

             tuple = Split(tuple,",")
             s=s+1

             mab.parties[s]={
                id=tuple[1] or "<error>",
              name=tuple[2] and tuple[2]:gsub("_", " ") or "<error>",
               pos={
                    (tonumber(tuple[10])*-1) or 0, --invert X coordinates
                     tonumber(tuple[11])     or 0
                   },
               rot=tonumber(tuple[15]) or 0,
              kind=kind
             }
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
              if mab.parties[pid].isbeenmod                   and  --itirerate over all the avaliable, modified parties
                 tline[i]:find("[\"']"..mab.parties[pid].id.."[\"']")  then --if matches in the line, bingo! try to replace coordinates by the new ones
              
                  print( mab.parties[pid].name.." has been modified  -->  ",
                         mab.parties[pid].pos[1]*-1,mab.parties[pid].pos[2])
                 
                  tline[i]=string.gsub(tline[i], "%([ \t]*"..(mab.parties[pid].oldpos[1]*-1).."[ \t]*,",  
                  function(pickedbit)
                    return pickedbit:gsub(mab.parties[pid].oldpos[1]*-1,Round(mab.parties[pid].pos[1], 2)*-1)
                  end,1) --XX
                  
                  tline[i]=string.gsub(tline[i], ",[ \t]*".. mab.parties[pid].oldpos[2]    .."[ \t]*%)", 
                  function(pickedbit)
                    return pickedbit:gsub(mab.parties[pid].oldpos[2],Round(mab.parties[pid].pos[2], 2))
                  end,1) --YY
                  
                  tline[i]=string.format("%s #[swycartographr] prev. coords: (%g, %g)",
                           tline[i]..string.rep(" ",(140-tline[i]:len())),
                           mab.parties[pid].oldpos[1]*-1,
                           mab.parties[pid].oldpos[2]
                           )
                           
                  mab.parties[pid].isbeenmod=false
                  break
              end
            end
            
        end
        
        io.write(tline[i].."\n") --drop the line
  end   io.close()
  end
  
  print("   done...")
end

function mab.parties:groundalign()
  local abs,uu=math.abs,os.clock()
  for p,_ in pairs(mab.parties) do
  
  local currparty=mab.parties[p]
  if type(currparty)=="table" then
   
   local closerx,closery=2,2
   
   for i=1,#mab.map.fcs do
   
     --compute barycenter
     local tricenterx=(mab.map.vtx[mab.map.fcs[i][1]].x+
                       mab.map.vtx[mab.map.fcs[i][2]].x+
                       mab.map.vtx[mab.map.fcs[i][3]].x)/3
     local tricentery=(mab.map.vtx[mab.map.fcs[i][1]].z+
                       mab.map.vtx[mab.map.fcs[i][2]].z+
                       mab.map.vtx[mab.map.fcs[i][3]].z)/3
     
     local compx=abs(tricenterx - currparty.pos[1])
     local compy=abs(tricentery - currparty.pos[2])

     
          if compx < closerx and
             compy < closery then --closest triangle to the point
             
             closerx,closery=compx,compy
             mab.parties[p].pos[3] =(mab.map.vtx[mab.map.fcs[i][1]].y+
                                     mab.map.vtx[mab.map.fcs[i][2]].y+
                                     mab.map.vtx[mab.map.fcs[i][3]].y)/3

             if closerx<1.8 and closery<1.5 then break end--aproximate just enough
          end
   end
     
      if not mab.parties[p].pos[3] then mab.parties[p].pos[3]=10 end
  end
  end
  
  print(string.format("   ground aligned in %gs",os.clock()-uu))
end