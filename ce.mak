!INCLUDE <wcedefs.mak>

CFLAGS=/MT /W3 /Ox /O2 /Ob2 /GF /Gy /Zl /nologo $(WCETARGETDEFS) /DUNICODE /D_UNICODE /DWIN32 /D_USE_32BIT_TIME_T /DWIN32_LEAN_AND_MEAN /Iinclude /D_WINDLL /D_DLL /Foobj/ /I../openssl/inc32 -I../luace/src -Isrc -DNO_SYS_TYPES_H -D_CRT_SECURE_NO_DEPRECATE -DWITH_LUASOCKET=1 -DBUFSIZ=2048

!IF "$(WCEPLATFORM)"=="MS_POCKET_PC_2000"
CFLAGS=$(CFLAGS) /DWIN32_PLATFORM_PSPC
!ENDIF

!IFDEF DEBUG
CFLAGS=$(CFLAGS) /Zi /DDEBUG /D_DEBUG
!ELSE
CFLAGS=$(CFLAGS) /Zi /DNDEBUG
!ENDIF

!IF "$(MSVS)"=="2008"
CFLAGS=$(CFLAGS) /Zc:wchar_t-,forScope- /GS-
LFLAGS=/DEF:"src\ssl.def" /DLL /MACHINE:$(WCELDMACHINE) /SUBSYSTEM:WINDOWSCE,$(WCELDVERSION) /NODEFAULTLIB /DYNAMICBASE /NXCOMPAT
!ELSE
LFLAGS=/DEF:"src\ssl.def" /DLL /MACHINE:$(WCELDMACHINE) /SUBSYSTEM:WINDOWSCE,$(WCELDVERSION) /NODEFAULTLIB
!ENDIF

CORELIBS=coredll.lib corelibc.lib ole32.lib oleaut32.lib uuid.lib commctrl.lib ws2.lib \
		     ../openssl/out32dll_ARMV4I/libeay32.lib \
		     ../openssl/out32dll_ARMV4I/ssleay32.lib \
		     ../luace/lib/lua51.lib \
		     ../luasocket/lib/socket.lib \
		     ../wcecompat/lib/wcecompat.lib

SRC = \
 src/x509.c \
 src/context.c \
 src/ssl.c 

SRC2 = 

#SRC2 = \
# src/luasocket/io.c \
# src/luasocket/buffer.c \
# src/luasocket/timeout.c \
# src/luasocket/wsocket.c

OBJS = $(SRC:src=obj)
OBJS = $(OBJS:.cpp=.obj)
OBJS = $(OBJS:.c=.obj)

OBJS2 = $(SRC2:src/luasocket=obj)
OBJS2 = $(OBJS2:.cpp=.obj)
OBJS2 = $(OBJS2:.c=.obj)

{src}.c{obj}.obj:
	$(CC) $(CFLAGS) -c $<

{src/luasocket}.c{obj}.obj:
	$(CC) $(CFLAGS) -c $<

{src}.cpp{obj}.obj:
	$(CC) $(CFLAGS) -c $<

all: lib lib\luasec.lib
#	echo $(OBJS)

obj:
	@md obj 2> NUL

lib:
	@md lib 2> NUL

$(OBJS): ce.mak obj

# $(OBJS2): ce.mak obj


clean:
	@echo Deleting target libraries...
	@del lib\*.lib
	@echo Deleting object files...
	@del obj\*.obj

lib\ssl.lib: lib $(OBJS) $(OBJS2) makefile
	link /nologo /out:lib/ssl.dll $(LFLAGS) $(OBJS) $(OBJS2) $(CORELIBS)

lib\luasec.lib: lib $(OBJS) ce.mak
	lib /nologo /out:lib\luasec.lib $(OBJS) $(MIME_OBJS)


