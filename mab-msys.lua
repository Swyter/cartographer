mab=mab or {}
mab.msys=mab.msys or {}

local fmt = string.format

function mab.msys:getmodulefolder(file)
    local  msysf = cartographer.conf.msysparties:sub(1,-19)
    local   file = msysf.."/module_info.py"
    local gotcha = ""
    
    if io.open(file,"r") then
    for line in io.lines(file) do
    
      local ltrim=line:match("%S.*") or "#"
      local index=ltrim:sub(1,1)
      if index ~= "#" then --not a comment
        
        if ltrim:sub(1,10)=="export_dir" then
          gotcha=ltrim:match("=[ \t]*[\"'](.*)[\"']%S*") --can be translated in regex like this: =_"<path>"_
          if gotcha and
             gotcha:len()>1 and
             gotcha:sub(2,1)~=":" then --if relative, if not C:\, R:\ and company
            
            gotcha=mab.msys:currentdir() --cartographer path
                   .."\\"
                   ..msysf --relative to us, but dirty
                   .."\\"
                   ..gotcha
            
            print(gotcha,".............")

          end
          
          gotcha=mab.msys:sanitizepath(gotcha) --sanitize the general ugliness
          break
        end
      end
    end
    end
    
    print (gotcha)
    return gotcha
end


function mab.msys:sanitizepath(path)

  --reorient separators
  path=path:gsub("/", "\\")
  print(path)
  
  --remove possible doubles
  path=path:gsub("\\\\", "\\")
  print(path)
  
  --remove relativeness
  local relatpattern = "\\[^\\..]+\\%.%."
  
  repeat
    path=path:gsub(relatpattern, "") --something like    R:\Repositories\swycartographer\res\msys\..\mod
    print(path)                      --gets converted to R:\Repositories\swycartographer\res\mod
  until
    not path:find(relatpattern)
  
  return path
end

function mab.msys:currentdir()
  return io.popen"cd":read'*l'  --http://stackoverflow.com/a/6036884
end