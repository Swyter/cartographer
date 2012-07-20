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
  print("@--start parsing parties"); s=0
  for line in io.lines(filename) do
  
        local ltrim=line:match("%S.*") or "#"
        local index=ltrim:sub(1,1)

        if index ~= "#" then
          if index=="(" and not line:find("pf_disabled") then --avoid comments and filler entries
             
             tuple=ltrim:sub(2,ltrim:find("%).*")) --remove possible comments from the right side
             tuple = tuple:gsub("\"", ""):gsub("%(", ""):gsub("%)", "") --remove all the: "()

             tuple = Split(tuple,",")
              print(tuple[2]:gsub("_", " "))
              s=s+1
              
              
         -- thingie=split("\((.+)\)\,")--isolate tuple somehow
         -- tuple=split(thingie,",")
          
         -- mab.parties[tuple[1]]={
         -- name=tuple[2], pos={tuple[10][1],tuple[10][2]}, rot=tuple[12] or 0
         -- }
          end
        end
  end
  
  print(string.format("   %d parties loaded...",s))
end

mab.parties:load("R:\\Juegos\\swconquest\\modules\\swconquest-msys\\module_parties.py")

function mab.parties:save(filename)
  print"not implemented yet"
end