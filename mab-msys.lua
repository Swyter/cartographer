mab=mab or {}
mab.msys=mab.msys or {}

local fmt = string.format

function mab.msys:getmsysfolder()

  msysf=cartographer.conf.msysparties:sub(1,-19)

  if msysf:sub(2,2)~=":" then --msys relative to cartographer
    msysf=mab.msys:currentdir() --cartographer path
        .."\\"
        ..msysf
  end

  return mab.msys:sanitizepath(msysf)
end

function mab.msys:getmodulefolder()
    local  msysf = mab.msys:getmsysfolder()
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
             gotcha:sub(2,2)~=":" then --if relative, if not C:\, R:\ and company
            
            gotcha=msysf --relative to msys, but dirty
                .."\\"
                ..gotcha
                   
          end
          gotcha=mab.msys:sanitizepath(gotcha) --sanitize the general ugliness
          break
          
        end
      end
    end
    end

    return gotcha
end

  --
 -- Helper functions
--

function mab.msys:sanitizepath(path)

  --reorient separators
  path=path:gsub("/", "\\")
  
  --remove possible doubles
  path=path:gsub("\\\\", "\\")
  
  --remove relativeness
  local relatpattern = "\\[^\\..]+\\%.%."
  
  repeat
    path=path:gsub(relatpattern, "") --something like    R:\Repositories\swycartographer\res\msys\..\mod
  until                              --gets converted to R:\Repositories\swycartographer\res\mod
    not path:find(relatpattern)
    
  --remove trailing slash
  path=path:sub(-1,-1)=="\\" and path:sub(0,-2) or path

  return path
end

function mab.msys:currentdir()
  return io.popen"cd":read'*l'  --http://stackoverflow.com/a/6036884
end