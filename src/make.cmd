::Originally from https://gist.github.com/1100904
::Ported from GCC to TinyCC <http://tinycc.org> by swyter

@echo off && title compiling lregistry
@set lua51_headers=R:\Repositories\luajit\src

tcc -v -shared -oregistry.dll -I%lua51_headers% lua51.def lregistry.c advapi32.def && echo. && echo done! :)

@pause>nul
:: P.S. You'll need Lua/JIT 5.1 headers for this... The .def makes a lua51.dll linker target unneccessary