local ffi = require"ffi"
local bit = require"bit"

winapi= winapi or {}

ffi.cdef[[
  static const int OFN_FILEMUSTEXIST             = 0x1000;
  static const int OFN_NOCHANGEDIR               = 8;
  static const int OFN_PATHMUSTEXIST             = 0x800;

  typedef bool BOOL;
  typedef char CHAR;

  typedef uint16_t       WORD; 
  typedef unsigned long DWORD;

  typedef void *PVOID;
  typedef void *LPVOID;
  typedef void *LPOFNHOOKPROC;

  typedef unsigned long HANDLE;
  typedef HANDLE HWND;
  typedef HANDLE HINSTANCE;

  typedef const char *LPCSTR;
  typedef const char *LPCTSTR;

  typedef char *LPSTR;
  typedef char *LPTSTR;

  typedef unsigned long LPARAM;

  typedef struct {
    DWORD         lStructSize;
    HWND          hwndOwner;
    HINSTANCE     hInstance;
    LPCTSTR       lpstrFilter;
    LPTSTR        lpstrCustomFilter;
    DWORD         nMaxCustFilter;
    DWORD         nFilterIndex;
    LPTSTR        lpstrFile;
    DWORD         nMaxFile;
    LPTSTR        lpstrFileTitle;
    DWORD         nMaxFileTitle;
    LPCTSTR       lpstrInitialDir;
    LPCTSTR       lpstrTitle;
    DWORD         flags;
    WORD          nFileOffset;
    WORD          nFileExtension;
    LPCTSTR       lpstrDefExt;
    LPARAM        lCustData;
    LPOFNHOOKPROC lpfnHook;
    LPCTSTR       lpTemplateName;
    
    LPVOID        pvReserved;
    DWORD         dwReserved;
    DWORD         flagsEx;
    
  }OPENFILENAME;
  BOOL GetSaveFileNameA( OPENFILENAME *lpofn );
  BOOL GetOpenFileNameA( OPENFILENAME *lpofn );
]]
com=ffi.load("comdlg32")

ffi.cdef([[
  DWORD GetLastError(void);
]])
krnl=ffi.load("kernel32")

function winapi:OpenDialog(handle)
  Ofn=ffi.new("OPENFILENAME")
  ffi.fill(Ofn,ffi.sizeof(Ofn)) --zero fill the structure
  
  local szFile        = ffi.new("char[260]","\0")
  local szFilename    = ffi.new("char[100]","\0")
  local hwnd          = ffi.new("HWND",handle or 0)
 
  Ofn.lStructSize     = ffi.sizeof(Ofn)
  Ofn.hwndOwner       = hwnd
  
  Ofn.lpstrFile       = szFile
  Ofn.nMaxFile        = 260
  
  Ofn.lpstrFilter     = "All kind of thingies -- *.*\0*.*\0"..
                        "Wavefront OBJ -- *.obj\0*.obj\0"
  Ofn.nFilterIndex    = 2
  
  Ofn.lpstrFileTitle  = szFilename
  Ofn.nMaxFileTitle   = 100
  
  Ofn.lpstrInitialDir = nil
  Ofn.flags           = bit.bor(com.OFN_PATHMUSTEXIST, com.OFN_FILEMUSTEXIST, com.OFN_NOCHANGEDIR)
  
  if com.GetOpenFileNameA(Ofn) then --luajit converts bool automatically
    return ffi.string(Ofn.lpstrFile),0
  end
  
  return false,krnl.GetLastError()
end

function winapi:SaveDialog(handle)
  Ofn=ffi.new("OPENFILENAME")
  ffi.fill(Ofn,ffi.sizeof(Ofn)) --zero fill the structure
  
  local szFile        = ffi.new("char[260]","\0")
  local szFilename    = ffi.new("char[100]","\0")
  local hwnd          = ffi.new("HWND",handle or 0)
 
  Ofn.lStructSize     = ffi.sizeof(Ofn)
  Ofn.hwndOwner       = hwnd
  
  Ofn.lpstrFile       = szFile
  Ofn.nMaxFile        = 260
  
  Ofn.lpstrFilter     = "All kind of thingies -- *.*\0*.*\0"..
                        "Wavefront OBJ -- *.obj\0*.obj\0"
  Ofn.nFilterIndex    = 2
  
  Ofn.lpstrFileTitle  = szFilename
  Ofn.nMaxFileTitle   = 100
  
  Ofn.lpstrInitialDir = nil
  Ofn.flags           = bit.bor(com.OFN_PATHMUSTEXIST, com.OFN_FILEMUSTEXIST, com.OFN_NOCHANGEDIR)
  
  if com.GetSaveFileNameA(Ofn) then --luajit converts bool automatically
    return ffi.string(Ofn.lpstrFile),0
  end
  
  return false,krnl.GetLastError()
end

function winapi:GetHandle(title,class)
  ffi.cdef([[
  HWND FindWindowExA(
    HWND hwndParent,
    HWND hwndChildAfter,
    LPCTSTR lpszClass,
    LPCTSTR lpszWindow
  );
  ]])
  user=ffi.load("user32")

  lpszClass  = (title=="" and ffi.cast("char *", class) or nil)
  lpszWindow = (class=="" and ffi.cast("char *", title) or nil)
  
  
  return user.FindWindowExA(0,0,
                            lpszClass,
                            lpszWindow)

end