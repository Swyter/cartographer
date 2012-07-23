mab = mab or {}
mab.parties = mab.parties or {}
--[[
mab.parties = {
      "taris"={name="Taris",    pos={15.66,90.63}, rot=135},
  "coruscant"={name="Coruscant",pos={-30.5,34},    rot=135}
}
]]


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

             mab.parties[tuple[1]]={
               name=tuple[2]:gsub("_", " "),
               pos={
                    tonumber(tuple[10])*-1, --invert X coordinates
                    tonumber(tuple[11])
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
  
  if io.output(io.open("_partysave.py","w")) then
  for i=1,#tline do 

        local ltrim=tline[i]:match("%S.*") or "#"
        local index=ltrim:sub(1,1)

        if index ~= "#" and index=="(" then --avoid comments and filler entries
          
            for pid in pairs(mab.parties) do        
              if type(mab.parties[pid])=="table" and not
                 mab.parties[pid].isbeenmod      and  --itirerate over all the avaliable, modified parties
                 tline[i]:find(pid.."[\"']")     then --if matches in the line, bingo! try to replace coordinates by the new ones
              
                  print("found ref:"..pid--,
                        --tline[i]:match("%((%S?%d[%.[%d]+]?)%S?,")
                       )
                  
                  tline[i]=string.gsub(tline[i], mab.parties[pid].pos[1]*-1, "XX")
                  tline[i]=string.gsub(tline[i], mab.parties[pid].pos[2], "YY")
                  
                  tline[i]=string.format("%s #[swycartographr] prev. coords: (%g, %g)",
                           tline[i]..string.rep(" ",(200-tline[i]:len())),
                           mab.parties[pid].pos[1],
                           mab.parties[pid].pos[2]
                           )
              end
            end
            
        end
        
        io.write(tline[i].."\n") --drop the line
  end
  end
  
  print("   done...")
end