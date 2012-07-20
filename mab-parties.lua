mab = mab or {}
mab.parties = mab.parties or {}
--[[
mab.parties = {
      "taris"={name="Taris",    pos={15.66,90.63}, rot=135},
  "coruscant"={name="Coruscant",pos={-30.5,34},    rot=135}
}
]]

function mab.parties:load(filename)
  print("@--start parsing parties"); s=0
  for line in io.lines(filename) do
  
        local ltrim=line:match("%S.*") or "#"
        local index=ltrim:sub(1,1)

        if index ~= "#" then
          if not line:find("pf_disabled") then --avoid comments and filler entries
            --print(line)
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