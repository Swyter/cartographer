mab = mab or {}
mab.parties = mab.parties or {}

local ffi,vector=require"ffi",require"vectors"

  --
 -- Helper functions
--
function all_trim(s)
  return s:match( "^%s*(.-)%s*$" )
end




ctx_idx = 1
context = {}
context_data = {}
function pushcontext(name)
  context[ctx_idx] = name
  ctx_idx = ctx_idx + 1
end

function popcontext()
  table.remove(context, ctx_idx - 1)
  ctx_idx = ctx_idx - 1
end

function isctx(name)
  return context[ctx_idx-1] == name
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

    function poptuple()
      thing=all_trim(str:sub(getctxdata().last+1, lastPos-1))
      if getctxdata()["child_data"] then
        thing=getctxdata()["child_data"]
        getctxdata()["child_data"]=nil 
      end
      --print("poppedtuple", thing)
      if thing == "" then
        --print("empty after comma")
      else
        table.insert(getctxdata().data, thing)
      end
      getctxdata().last=lastPos
    end

    str=str:gsub(".", function(c)
        lastPos = lastPos + 1

        if c == '"' or c == "'" then -- swy: support two kinds of quote styles
            --print()
            if not isctx('str') then
              pushcontext('str')
              setctxdata({c, lastPos})
            elseif isctx('str') and getctxdata()[1] == c and not (getctxdata()["laststrchar"] == "\\" and getctxdata()["lastlaststrchar"] ~= getctxdata()["laststrchar"]) then
              child_data=all_trim(str:sub(getctxdata()[2]+1, lastPos-1))
              --print("poppedstr", child_data)
              popcontext()
              getctxdata()["child_data"]=child_data
            end
        elseif c == '[' then
          pushcontext('array')
          setctxdata({data={}, last=lastPos})
        elseif c == ']' and isctx('array') then
          poptuple()
          --dump(getctxdata().data)
          child_data=getctxdata().data
          popcontext()
          getctxdata()["child_data"]=child_data
        elseif c == '(' then
          pushcontext('tuple')
          setctxdata({data={}, last=lastPos})
        elseif c == ')'  and isctx('tuple') then
          poptuple()
          --dump(getctxdata().data)
          child_data=getctxdata().data
          popcontext()
          getctxdata()["child_data"]=child_data
        elseif  c == ',' and (isctx('tuple') or isctx('array')) then
          poptuple()
          --print("comma")
        elseif  c == '=' and isctx('root') then
          --print("assign")
          pushcontext('assignment')
          setctxdata({all_trim(str:sub(first, lastPos-1)), lastPos+1})
        end

        if isctx('str') then
          getctxdata()["lastlaststrchar"]=getctxdata()["laststrchar"]
          getctxdata()["laststrchar"]=c
        end

        --print(c, table.concat(context, ">"), getctxdata())
    end)

    if isctx('assignment') then
      parse[getctxdata()[1]] = getctxdata()["child_data"] and getctxdata()["child_data"] or all_trim(str:sub(getctxdata()[2], lastPos))
      --print("crap", parse[getctxdata()[1]] )
      popcontext()
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

  pushcontext('root')

  for line in io.lines(filename) do
        local ltrim=line:match("%S.*") or "#"
        local index=ltrim:sub(1,1)

             tuple=line:gsub("#.+", ""):gsub("%s*(.+)%s*", "%1") --remove possible comments from the right side
             --print("<" .. (tuple) .. ">")
             tuple = splitpartylines(tuple,",")
             

  end

  --print("parse", dump(parse['parties']))

  for key, tuple in ipairs(parse['parties']) do
    s=s+1

    if tuple[3]:find("pf_town") then kind=1 else kind=2 end

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
              
                  print(string.format("%s has been modified  -->  %.2f, %.2f (%uº)", mab.parties[pid].name, mab.parties[pid].pos.x*-1,mab.parties[pid].pos.y, math.ceil(mab.parties[pid].rot)))
                 
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