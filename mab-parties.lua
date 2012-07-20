mab = mab or {}
mab.parties = mab.parties or {}

mab.parties = {
      "taris"={name="Taris",    pos={15.66,90.63}, rot=135},
  "coruscant"={name="Coruscant",pos={-30.5,34},    rot=135},
}

function mab.parties:load(filename)
  print"not implemented yet"
  
  if not "#" and not "pf_disabled" then --avoid comments and filler entries
    thingie=split("\((.+)\)\,")--isolate tuple somehow
    tuple=split(thingie,",")
    
    mab.parties[tuple[1]]={
      name=tuple[2], pos={tuple[10][1],tuple[10][2]}, rot=tuple[12] or 0
    }
    
  end
end

function mab.parties:save(filename)
  print"not implemented yet"
end