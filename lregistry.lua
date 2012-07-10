require "registry"

flags = registry.flag(
        registry.KEY_READ,
        registry.KEY_WOW64_32KEY
        )

test,err=registry.getkey("Software\\Mount&Blade Warband","Version",
                          registry.HKEY_LOCAL_MACHINE, flags)
print(test)
print(err)