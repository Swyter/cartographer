mab=mab or {}
mab.msys=mab.msys or {}

local fmt = string.format

function mab.msys:getmodulefolder(file)
    --file="//res//msys"
    local file=cartographer.conf.msysparties:sub(1,-19).."/module_info.py"
    local gotcha=""
    print(file)
    if io.open(file,"r") then
    for line in io.lines(file) do
    
      local ltrim=line:match("%S.*") or "#"
      local index=ltrim:sub(1,1)
      if index ~= "#" then --not a comment
        ---print(fmt("not comm: %s",line))
        
        if ltrim:sub(1,10)=="export_dir" then
          ---print(fmt("bingo: %s",line))
          ---print(">"..ltrim:match("=[ \t]*[\"'](.*)[\"']%S*").."<")
          gotcha=ltrim:match("=[ \t]*[\"'](.*)[\"']%S*")
          if gotcha and
             gotcha:len()>1 and
             gotcha:sub(2,1)~=":" then--relative
            
            print(gotcha)
            gotcha=cartographer.conf.msysparties:sub(1,-19).."\\"..gotcha
            print(gotcha)
            gotcha=mab.msys:sanitizepath(gotcha)
            
          end
          break
        end
      else
        ---print(fmt("is comm: %s",line))
      end
    end
    end
    
    return gotcha
end


function mab.msys:sanitizepath(path)

  --reorient separators
  path=path:gsub("/", "\\")
  print(path)
  
  --add current dir
  path=mab.msys:currentdir().."\\"..path
  print(path)
  
  --remove relativeness
  path=path:gsub("\\[^\\]+\\%.%.", "")
  print(path)

  return path
end

function mab.msys:currentdir()
  return io.popen"cd":read'*l'
end