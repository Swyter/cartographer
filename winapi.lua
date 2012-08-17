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
  ffi.cdef[[
  static const int MB_ICONQUESTION         = 32;
  static const int MB_OK                   = 0;
  static const int MB_ABORTRETRYIGNORE     = 2;
  static const int MB_APPLMODAL            = 0;
  static const int MB_DEFAULT_DESKTOP_ONLY = 0x20000;
  static const int MB_HELP                 = 0x4000;
  static const int MB_RIGHT                = 0x80000;
  static const int MB_RTLREADING           = 0x100000;
  static const int MB_TOPMOST              = 0x40000;
  static const int MB_DEFBUTTON1           = 0;
  static const int MB_DEFBUTTON2           = 256;
  static const int MB_DEFBUTTON3           = 512;
  static const int MB_DEFBUTTON4           = 0x300;
  static const int MB_ICONINFORMATION      = 64;
  static const int MB_ICONSTOP             = 16;
  static const int MB_OKCANCEL             = 1;
  static const int MB_RETRYCANCEL          = 5;


  static const int MB_YESNO                = 4;


  static const int IDABORT                 = 3;
  static const int IDCANCEL                = 2;
  static const int IDCLOSE                 = 8;
  static const int IDHELP                  = 9;
  static const int IDIGNORE                = 5;
  static const int IDNO                    = 7;
  static const int IDOK                    = 1;
  static const int IDRETRY                 = 4;
  static const int IDYES                   = 6;
  
  typedef unsigned int UINT;
  int MessageBoxA(HWND,LPCSTR,LPCSTR,UINT);
  ]]
  --user=ffi.load("user32")
function winapi:messagebox(text)
  local gg=user.MessageBoxA(handle,
                            "Are you really sure you want to reload the map file?\r\nAll the unsaved changes will be lost, forever.",
                            "Oops!",
                            bit.bor(user.MB_TOPMOST, user.MB_ICONQUESTION, user.MB_YESNO, user.MB_DEFBUTTON2, user.MB_APPLMODAL)
                           )
  --print("=>>>>>>>>>>>>>>>>> "..gg)
  
  if gg == user.IDYES then
   return true
  else
   return false
  end
end