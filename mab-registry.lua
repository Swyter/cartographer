require "registry"
mab = mab or {}

-- Use Wow6432Node?

mab.registry = {
	 mab = "HKLM\\Software\\Mount&Blade",
	  wb = "HKLM\\Software\\Mount&Blade Warband",
	wfas = "HKLM\\Software\\Mount&Blade With Fire and Sword"
}

mab.registry.keys = {"","Install_Path"} --steam saves path in another value :(
                                        --there's another "Version", universal that i don't need

function mab.registry:query()
    local regout,flags = {}, registry.flag(    --OR operation
                             registry.KEY_READ,
                             registry.KEY_WOW64_32KEY
                             )
    
    for alias,regkey in pairs(mab.registry) do
           
        for _,regvalue in pairs(mab.registry.keys) do
        
            if type(regkey)~="string" then break end --respect the functions and subtables, don't pass over them :)
            
            out,err=registry.getkey(regkey:sub(6), regvalue,
                                    registry.HKEY_LOCAL_MACHINE, flags)

            if out then
                regout[alias]=out  --make an array with the found values, using the alias as key
            end
        end
    end
    
    return regout or nil, err
end