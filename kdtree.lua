local kd = {}


function print_r (t, indent) -- alt version, abuse to http://richard.warburton.it
  local indent=indent or ''
  for key,value in pairs(t) do
    io.write(indent,'[',tostring(key),']') 
    if type(value)=="table" then io.write(':\n') print_r(value,indent..'\t')
    else io.write(' = ',tostring(value),'\n') end
  end
end


function kd.tree_create(points, depth)
   if #points == 0 or depth>5 then return end
   table.sort(points, function(a,b) return a.x<b.x end)
   
   kd.tree_create(points, depth+1)
end


function kd.tree_find(kdtree, target)
    return 1
end

return kd