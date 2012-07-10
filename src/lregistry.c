#include <lua.h>
#include <lauxlib.h>
#include <Windows.h>

// some undefined constants in TinyCC's headers
#define KEY_WOW64_64KEY 0x0100
#define KEY_WOW64_32KEY 0x0200
#define REG_QWORD 0x0000000B

// using mingw
// gcc -shared -oregistry.dll -Ilua/include lua51.dll lregistry.c

#ifdef WIN32
#define LUA_API __declspec(dllexport)
#else
#define LUA_API
#endif

// basically just a bitwise or function
static int Lmakeflag(lua_State *l){
	int n = lua_gettop(l);
	int acc = 0, i;
	for (i=1;i<=n;i++){
		acc |= luaL_checkint(l, i);
	}
	lua_pushinteger(l, acc);
	return 1;
}

#define default_key(i) (HKEY)luaL_optint(l, i, (int)HKEY_CURRENT_USER)
#define default_rights(i) (REGSAM)luaL_optint(l, i, (int)KEY_ALL_ACCESS)

#define TOTALBYTES    8192
#define BYTEINCREMENT 4096

// get the value of a key
static int Lgetkey(lua_State *l){
	const char* path=luaL_checkstring(l,1);
	const char* value = luaL_optstring(l, 2, "");
	HKEY key = default_key(3);
	REGSAM rights = default_rights(4);
	HKEY handle;
	if (RegOpenKeyEx(key, TEXT(path), 0, rights, &handle) != ERROR_SUCCESS){
		lua_pushnil(l);
		lua_pushstring(l, "Path does not exist");
		return 2;
	}

	DWORD type, bsize = TOTALBYTES, size = TOTALBYTES, ret;
	void* data = (void*)malloc(bsize);

	// return the value of the key
	ret = RegQueryValueEx(handle, TEXT(value), NULL, &type, (LPBYTE)data, &size);
	while (ret==ERROR_MORE_DATA){
		bsize += BYTEINCREMENT;
		data = (void*)realloc(data,bsize);
		size = bsize;
		ret = RegQueryValueEx(handle, TEXT(value), NULL, &type, (LPBYTE)data, &size);
	}

	if (ret != ERROR_SUCCESS){
		lua_pushnil(l);
		lua_pushstring(l, "Value does not exist");
		return 2;
	}

	switch (type){
	case REG_QWORD:
		lua_pushinteger(l, *(long long*)data);
		break;
	case REG_DWORD:
		lua_pushinteger(l, *(int*)data);
		break;
	case REG_DWORD_BIG_ENDIAN:{
		char* i = (char*)data;
		char a = i[3],b = i[2],c = i[1],d = i[0];
		i[0] = a; i[1] = b; i[2] = c; i[3] = d;
		lua_pushinteger(l, *(int*)(i));
		break;
	}
	//case REG_LINK:
	case REG_BINARY:
		lua_pushlstring(l, (char*)data, bsize);
		break;
	case REG_EXPAND_SZ:{
		char* buffer = (char*)malloc(TOTALBYTES);
		int ret = ExpandEnvironmentStrings((char*)data, buffer, TOTALBYTES), bsize = TOTALBYTES;
		while (ret == bsize){
			bsize += BYTEINCREMENT;
			buffer = (char*)realloc(buffer, bsize);
			ret = ExpandEnvironmentStrings((char*)data, buffer, bsize);
		}
		if (!ret){
			lua_pushnil(l);
			lua_pushstring(l, "ExpandEnvironmentStrings failed");
			lua_pushstring(l, (char*)data);
			return 3;
		}

		lua_pushstring(l, buffer);
		break;
	}
	case REG_MULTI_SZ:{
		char* buf = (char*)data;
		int i = 0, n = strlen(buf);
		while (n){
			i++;
			lua_pushstring(l, buf);
			buf += n+1;
			n = strlen(buf);
		}
		return i;
	}
	case REG_SZ:
		lua_pushstring(l, (char*)data);
		break;
	case REG_NONE:
		lua_pushnil(l);
		break;
	case REG_LINK:
		lua_pushnil(l);
		lua_pushstring(l, "Cannot access unicode data");
		return 2;
	}

	return 1;
}

static const luaL_Reg R[] = {
	{ "flag",	Lmakeflag },
	{ "getkey", Lgetkey },
	{ NULL,		NULL }
};

LUALIB_API int luaopen_registry(lua_State *L){
	luaL_register(L,"registry",R);

	//constants for the third optional parameter (location)
	lua_pushnumber(L, (int)HKEY_CLASSES_ROOT);
	lua_setfield(L,-2,"HKEY_CLASSES_ROOT");
	lua_pushinteger(L, (int)HKEY_CURRENT_CONFIG);
	lua_setfield(L,-2,"HKEY_CURRENT_CONFIG");
	lua_pushinteger(L, (int)HKEY_CURRENT_USER);
	lua_setfield(L,-2,"HKEY_CURRENT_USER");
	lua_pushinteger(L, (int)HKEY_LOCAL_MACHINE);
	lua_setfield(L,-2,"HKEY_LOCAL_MACHINE");
	lua_pushinteger(L, (int)HKEY_USERS);
	lua_setfield(L,-2,"HKEY_USERS");

	//constants for the fourth optional parameter (rights+flags)
	lua_pushinteger(L, (int)KEY_ALL_ACCESS );
	lua_setfield(L,-2,"KEY_ALL_ACCESS");
	lua_pushinteger(L, (int)KEY_CREATE_LINK );
	lua_setfield(L,-2,"KEY_CREATE_LINK");
	lua_pushinteger(L, (int)KEY_CREATE_SUB_KEY );
	lua_setfield(L,-2,"KEY_CREATE_SUB_KEY");
	lua_pushinteger(L, (int)KEY_ENUMERATE_SUB_KEYS );
	lua_setfield(L,-2,"KEY_ENUMERATE_SUB_KEYS");
	lua_pushinteger(L, (int)KEY_EXECUTE );
	lua_setfield(L,-2,"KEY_EXECUTE");
	lua_pushinteger(L, (int)KEY_NOTIFY);
	lua_setfield(L,-2,"KEY_NOTIFY");
	lua_pushinteger(L, (int)KEY_QUERY_VALUE);
	lua_setfield(L,-2,"KEY_QUERY_VALUE");
	lua_pushinteger(L, (int)KEY_READ);
	lua_setfield(L,-2,"KEY_READ");
	lua_pushinteger(L, (int)KEY_SET_VALUE);
	lua_setfield(L,-2,"KEY_SET_VALUE");
	lua_pushinteger(L, (int)KEY_WOW64_32KEY);
	lua_setfield(L,-2,"KEY_WOW64_32KEY");
	lua_pushinteger(L, (int)KEY_WOW64_64KEY);
	lua_setfield(L,-2,"KEY_WOW64_64KEY");
	lua_pushinteger(L, (int)KEY_WRITE);
	lua_setfield(L,-2,"KEY_WRITE");

	return 1;
}