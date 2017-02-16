### Generated by Winemaker 0.8.4
###
### Invocation command line was
### /usr/bin/winemaker --wine32 . --nosource-fix --dll -Isteam


SRCDIR                = .
SUBDIRS               =
DLLS                  = steam_api.dll
LIBS                  =
EXES                  =



### Common settings
CEXTRA                = -mno-cygwin \
			-m32
CXXEXTRA              = -m32 -fpermissive
RCEXTRA               =
DEFINES               =  \
			-D__WINESRC__ \
			-DVERSION_SAFE_STEAM_API_INTERFACES \
			-DUSE_BREAKPAD_HANDLER
INCLUDE_PATH          = -Isteam \
			-I.
DLL_PATH              =
DLL_IMPORTS           =
LIBRARY_PATH          = -L.
LIBRARIES             = -lsteam_api


### steam_api.dll sources and settings

steam_api_dll_MODULE  = steam_api.dll
steam_api_dll_C_SRCS  =
steam_api_dll_CXX_SRCS= steam_api.cpp callbacks.cpp
steam_api_dll_RC_SRCS =
steam_api_dll_LDFLAGS = -shared \
			steam_api.auto.spec \
			-mno-cygwin \
			-m32
steam_api_dll_ARFLAGS =
steam_api_dll_DLL_PATH=
steam_api_dll_DLLS    = odbc32 \
			ole32 \
			oleaut32 \
			winspool \
			odbccp32
steam_api_dll_LIBRARY_PATH=
steam_api_dll_LIBRARIES= uuid

steam_api_dll_OBJS    = $(steam_api_dll_C_SRCS:.c=.o) \
			$(steam_api_dll_CXX_SRCS:.cpp=.o) \
			$(steam_api_dll_RC_SRCS:.rc=.res)
PROTOFILES = steam_api_dll.h steam_api_main.cpp
WRAPPER_CPPS = $(wildcard autoclass/*.cpp)
WRAPPERS = $(WRAPPER_CPPS:.cpp=.o)

### Global source lists

C_SRCS                = $(steam_api_dll_C_SRCS)
CXX_SRCS              = $(steam_api_dll_CXX_SRCS)
RC_SRCS               = $(steam_api_dll_RC_SRCS)

### Tools

CC = winegcc
CXX = wineg++
RC = wrc
AR = ar


### Generic targets

all: $(SUBDIRS) $(WRAPPERS) $(DLLS:%=%.so) $(LIBS) $(EXES)
### Build rules

.PHONY: all clean dummy

$(SUBDIRS): dummy
	@cd $@ && $(MAKE)

# Implicit rules

.SUFFIXES: .h.proto .cpp.proto .h .cpp .cxx .rc .res
DEFINCL = $(INCLUDE_PATH) $(DEFINES) $(OPTIONS)

#.h.proto.h:
#	./fixit < $< > $@
#
#.cpp.proto.cpp:
#	./fixit < $< > $@

.c.o:
	$(CC) -c $(CFLAGS) $(CEXTRA) $(DEFINCL) -o $@ $<

.cpp.o:
	$(CXX) -c $(CXXFLAGS) $(CXXEXTRA) $(DEFINCL) -o $@ $<

.cxx.o:# protos
	$(CXX) -c $(CXXFLAGS) $(CXXEXTRA) $(DEFINCL) -o $@ $<

.rc.res:
	$(RC) $(RCFLAGS) $(RCEXTRA) $(DEFINCL) -fo$@ $<

# Rules for cleaning

CLEAN_FILES     = y.tab.c y.tab.h lex.yy.c core *.orig *.rej \
                  \\\#*\\\# *~ *% .\\\#*

clean:: $(SUBDIRS:%=%/__clean__) $(EXTRASUBDIRS:%=%/__clean__)
	$(RM) $(CLEAN_FILES) $(RC_SRCS:.rc=.res) $(C_SRCS:.c=.o) $(CXX_SRCS:.cpp=.o)
	$(RM) $(DLLS:%=%.so) $(LIBS) $(EXES) $(EXES:%=%.so)
#	$(RM) $(PROTOFILES)

$(SUBDIRS:%=%/__clean__): dummy
	cd `dirname $@` && $(MAKE) clean

$(EXTRASUBDIRS:%=%/__clean__): dummy
	-cd `dirname $@` && $(RM) $(CLEAN_FILES)

### Target specific build rules
DEFLIB = $(LIBRARY_PATH) $(LIBRARIES) $(DLL_PATH) $(DLL_IMPORTS:%=-l%)

$(steam_api_dll_MODULE).so: $(steam_api_dll_OBJS) steam_api.auto.spec
	$(CXX) $(steam_api_dll_LDFLAGS) -o $@ $(WRAPPERS) $(steam_api_dll_OBJS) $(steam_api_dll_LIBRARY_PATH) $(steam_api_dll_DLL_PATH) $(DEFLIB) $(steam_api_dll_DLLS:%=-l%) $(steam_api_dll_LIBRARIES:%=-l%)


