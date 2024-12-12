mab = mab or {}
mab.parties = mab.parties or {}

local ffi,vector=require"ffi",require"vectors"

  --
 -- Helper functions
--
function all_trim(s)
  return s:match( "^%s*(.-)%s*$" )
end

-- swy: funky stack-like data structure to store the hierarchy of parsed syntax elements as we dig into the recursive fields
ctx_idx = 0; context = {}; context_data = {}
function pushcontext(name)
  ctx_idx = ctx_idx + 1
  context[ctx_idx] = name
end

function popcontext()
  table.remove(context,      ctx_idx)
  table.remove(context_data, ctx_idx)
  ctx_idx = ctx_idx - 1
end

function isctx(name)
  return context[ctx_idx] == name
end

function setctxdata(data)
  context_data[ctx_idx] = data
end

function getctxdata()
  return context_data[ctx_idx]
end

parse = {} child_data=nil

function splitpartylines(str, delim, maxNb) --from <http://lua-users.org/wiki/SplitJoin> #Function: Split a string with a pattern, Take Three
    local result = {}; first=1; lastPos=0; nb=0; strsize=#str; in_string_block=nil

    function poptuple() -- swy: this gets called when we reach the last character of a tuple or element, and we insert it as a new entry
      begin_offset = getctxdata().last and getctxdata().last+1 or 0; end_offset = lastPos-1 --; print("bo", begin_offset, end_offset)
      thing=getctxdata()["prevlines"] .. all_trim(str:sub(begin_offset, end_offset))
      getctxdata()["prevlines"]=""
      if getctxdata()["child_data"] then -- swy: if the tuple element has had processing (the entry was an array/tuple/string) then use that instead of the raw unprocessed string (which is used for things like pf_ flags) and anything else
        thing=getctxdata()["child_data"]
        getctxdata()["child_data"]=nil
      end
      --print("poppedtuple", thing)
      if thing == "" then -- swy: many lines have a trailing comma after the last real element, there's nothing there, so don't add an empty thing
        --print("empty after comma")
      else
        table.insert(getctxdata().data, thing)
        --dump(getctxdata())
      end
      getctxdata().last=lastPos
    end

    str=str:gsub(".", function(c) -- swy: for every single character in the line
        lastPos = lastPos + 1

        if c == '"' or c == "'" then -- swy: support two kinds of quote styles
            --print()
            if not isctx('str') then
              pushcontext('str')
              setctxdata({c, lastPos})
            elseif isctx('str') and getctxdata()[1] == c and not (getctxdata()["laststrchar"] == "\\" and getctxdata()["lastlaststrchar"] ~= getctxdata()["laststrchar"]) then
              child_data=all_trim(str:sub(getctxdata()[2]+1, lastPos-1)) -- swy: save the string data for insertion in the parent element, e.g. as a tuple entry
              --print("poppedstr", child_data)
              popcontext()
              getctxdata()["child_data"]=child_data
            end
        end

        if isctx('str') then
          getctxdata()["lastlaststrchar"]=getctxdata()["laststrchar"]
          getctxdata()["laststrchar"]=c
        else
          if c == '[' then -- swy: a new array begins
            pushcontext('array')
            setctxdata({data={}, last=lastPos, prevlines=''})
          elseif c == ']' and isctx('array') then
            poptuple()
            --dump(getctxdata().data)
            child_data=getctxdata().data
            popcontext()
            getctxdata()["child_data"]=child_data
          elseif c == '(' then -- swy: a new tuple begins
            pushcontext('tuple')
            setctxdata({data={}, last=lastPos, prevlines=''})
          elseif c == ')' and isctx('tuple') then
            poptuple()
            --dump(getctxdata().data)
            child_data=getctxdata().data
            popcontext()
            getctxdata()["child_data"]=child_data
          elseif  c == ',' and (isctx('tuple') or isctx('array')) then -- swy: insert every single element when there's a separator for a next entry. commas at the end in the ,) or ),] style are also common, empty stuff will not get inserted
            poptuple()
            --print("comma")
          elseif  c == '=' and isctx('root') then
            --print("assign")
            pushcontext('assignment')
            setctxdata({all_trim(str:sub(first, lastPos-1)), lastPos+1}) -- swy; store the name of the variable to be used later (after processing the line or the array/tuple)
          end
        end
        
        --print(c, table.concat(context, ">"), getctxdata())
    end)

    if isctx('assignment') then -- swy: we've returned to the = context and we now have either the processed array/tuple or just a raw string, assign it to the stored variable name
      parse[getctxdata()[1]] = getctxdata()["child_data"] and getctxdata()["child_data"] or all_trim(str:sub(getctxdata()[2], lastPos))
      --print("crap", parse[getctxdata()[1]] )
      popcontext()
    end

    if (isctx('tuple') or isctx('array')) then -- swy: for tuple text data spanning multiple lines, save the previous stuff and append it when changing lines if it hasn't been used yet
      begin_offset = getctxdata().last and getctxdata().last+1 or 0; end_offset = lastPos
      getctxdata()["prevlines"] = getctxdata()["prevlines"] .. all_trim(str:sub(begin_offset, end_offset))
      getctxdata().last=0
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

  pushcontext('root'); setctxdata({data={}}) --swy: make sure even the root context has a defined data table set, as the other contexts expect that, even when out of order like root>tuple like a modmerge(var_set) call at the end

  for line in io.lines(filename) do
             tuple=line:gsub("#.+", ""):gsub("%s*(.+)%s*", "%1") --remove possible comments from the right side
             --print("<" .. (tuple) .. ">")
             tuple = splitpartylines(tuple,",")
             --print("\n")
  end
  --print("parse", dump(parse))

  for key, tuple in ipairs(parse['parties']) do 
    --print(tuple[1],dump(tuple))--, table.concat(tuple, ">"))
    
    for flag_key, flag_data in pairs(parse) do
      if flag_key:sub(1, 3) == "pf_" then
        tuple[3]=tuple[3]:gsub("%f[%a]"..flag_key.."%f[%A]", flag_data) -- swy: expand the aliases like pf_town but not pf_townn with http://lua-users.org/wiki/FrontierPattern
      end
    end

    if tuple[3]:find("pf_label_large") then kind=1 else kind=2 end
    if not tuple[3]:find("pf_disabled") or cartographer.conf.showdisabled~=false then --avoid comments and filler entries
      --print(tuple[1],dump(tuple))--, table.concat(tuple, ">"))
      s=s+1
      mab.parties[s]={
          id=tuple[1] or "<error>",
        name=tuple[2] and tuple[2]:gsub("_", " ") or "<error>",
         pos=vector.new(
              (tonumber(tuple[10][1])*-1) or 0, --invert X coordinates
               tonumber(tuple[10][2])     or 0
             ),
         rot=tonumber(tuple[12]) or 0,
        kind=kind
      }
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
              
                  print(string.format("%s has been modified  -->  %.2f, %.2f (%u\xBA)", mab.parties[pid].name, mab.parties[pid].pos.x*-1,mab.parties[pid].pos.y, math.ceil(mab.parties[pid].rot))) -- swy: 0xBA is º without using UTF-8 encoding, so that it shows up fine with the bitmap font
                 
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
                  
                  tline[i]=string.gsub(tline[i], "%],[ \t]*".. mab.parties[pid].oldrot    .."[ \t]*%),",   -- ],NN),
                  function(pickedbit)
                    return pickedbit:gsub(mab.parties[pid].oldrot, mab.parties[pid].rot)
                  end,1) --ROT

                end

                  tline[i]=cartographer.conf.sprevcoords~=false and --only show/print if the config says so! :-)
                           string.format("%s #[swycartographr] prev. coords: (%g, %g)%s",
                                tline[i]..string.rep(" ",(140-tline[i]:len())),
                                mab.parties[pid].oldpos.x*-1,
                                mab.parties[pid].oldpos.y,
                               (mab.parties[pid].oldrot==nil and "" or " rot: "..mab.parties[pid].oldrot)
                           ) or tline[i];
                           
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
     
     local compx=abs(tricenterx - currparty.pos.x)
     local compy=abs(tricentery - currparty.pos.y)

     
          if compx < closerx and
             compy < closery then --closest triangle to the point
             
             closerx,closery=compx,compy
             mab.parties[p].pos.z = (mab.map.vtx[mab.map.fcs[i][1]].y+
                                     mab.map.vtx[mab.map.fcs[i][2]].y+
                                     mab.map.vtx[mab.map.fcs[i][3]].y)/3

             if closerx<1.8 and closery<1.5 then break end--aproximate just enough
          end
   end
     
      if not mab.parties[p].pos.z then mab.parties[p].pos.z=10 end
  end
  end
  
  print(string.format("   ground aligned in %gs",os.clock()-uu))
end
