#######################################################################
# Makefile for MatlabCPP
#
#######################################################################

# MATLAB directory -- this may need to change depending on where you have MATLAB installed
MATDIR = C:\\Program Files\\MATLAB\\R2008a

INCDIR = /I "." /I "../../src" -I "$(MATDIR)/extern/include" -I"../Libs/"
CPP = cl
CPPFLAGS = /c /Zp8 /GR /W3 /EHs /D_CRT_SECURE_NO_DEPRECATE /DWIN32 \
	/D_SCL_SECURE_NO_DEPRECATE /D_SECURE_SCL=0 /DMATLAB_MEX_FILE /nologo
LINK = link


LINKFLAGS = /dll /export:mexFunction /MAP /LIBPATH:"$(MATDIR)\extern\lib\win32\microsoft" \
	libmx.lib libmex.lib libmat.lib \
	/MACHINE:X86 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib \
	advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib \
	ws2_32.lib

INSTDIR = ./../../
#DEBUGBUILD = 1

!IF DEFINED(DEBUGBUILD)
OUTDIR = Debug/
CPPFLAGS = $(CPPFLAGS)  /Fo"$(OUTDIR)" /DDEBUG
LINKFLAGS = $(LINKFLAGS) /INCREMENTAL /DEBUG

!ELSE
OUTDIR = Release/
CPPFLAGS = $(CPPFLAGS) /Oy- /O2 /Fo"$(OUTDIR)" /DNDEBUG 
#CPPFLAGS = $(CPPFLAGS) /MD /O2 /Oy- /Fo"$(OUTDIR)" /DNDEBUG 
!ENDIF

.SILENT :

# Rules for making the targets
TARGETS = $(OUTDIR)msaccept.mexw32 \
	$(OUTDIR)msclose.mexw32 \
	$(OUTDIR)msconnect.mexw32 \
	$(OUTDIR)mslisten.mexw32 \
	$(OUTDIR)msrecv.mexw32 \
	$(OUTDIR)msrecvraw.mexw32 \
	$(OUTDIR)mssend.mexw32 \
	$(OUTDIR)mssendraw.mexw32


all: $(TARGETS)
	@copy $(OUTDIR:/=\)*.mexw32 $(INSTDIR:/=\)
	@echo Files Built Successfully

clean: 
	@echo Cleaning output filder
	@del $(OUTDIR:/=\)*.mexw32
	@del $(OUTDIR:/=\)*.lib
	@del $(OUTDIR:/=\)*.exp
	@del $(OUTDIR:/=\)*.obj
	@del $(OUTDIR:/=\)*.manifest
	@del $(OUTDIR:/=\)*.map
	@del $(INSTDIR:/=\)*.mexw32
	
rebuild: clean all

.SUFFIXES : mexw32
#.SILENT :

{$(OUTDIR)}.mexw32{$(OUTDIR)}.obj:
	$(LINK) $(OUTDIR)$< $(LINKFLAGS) /OUT:$(OUTDIR)$<.mexw32

{./../../src/}.c{$(OUTDIR)}.obj:
    $(CPP) $(CPPFLAGS) $(INCDIR) $<

{./../../src/}.cpp{$(OUTDIR)}.obj:
    $(CPP) $(CPPFLAGS) $(INCDIR) $<


$(OUTDIR)msaccept.mexw32 : $(OUTDIR)msaccept.obj
	$(LINK) $(OUTDIR)msaccept.obj $(LINKFLAGS) \
	/PDB:"$(OUTDIR)msaccept.pdb" \
	/OUT:"$(OUTDIR)msaccept.mexw32"
	
$(OUTDIR)msclose.mexw32 : $(OUTDIR)msclose.obj
	$(LINK) $(OUTDIR)msclose.obj $(LINKFLAGS) \
	/PDB:"$(OUTDIR)msclose.pdb" \
	/OUT:"$(OUTDIR)msclose.mexw32"
	
$(OUTDIR)msconnect.mexw32 : $(OUTDIR)msconnect.obj
	$(LINK) $(OUTDIR)msconnect.obj $(LINKFLAGS) \
	/PDB:"$(OUTDIR)msconnect.pdb" \
	/OUT:"$(OUTDIR)msconnect.mexw32"
	
$(OUTDIR)mslisten.mexw32 : $(OUTDIR)mslisten.obj
	$(LINK) $(OUTDIR)mslisten.obj $(LINKFLAGS) \
	/PDB:"$(OUTDIR)mslisten.pdb" \
	/OUT:"$(OUTDIR)mslisten.mexw32"

$(OUTDIR)mssendraw.mexw32 : $(OUTDIR)mssendraw.obj
	$(LINK) $(OUTDIR)mssendraw.obj $(LINKFLAGS) \
	/PDB:"$(OUTDIR)mssendraw.pdb" \
	/OUT:"$(OUTDIR)mssendraw.mexw32"

$(OUTDIR)msrecvraw.mexw32 : $(OUTDIR)msrecvraw.obj
	$(LINK) $(OUTDIR)msrecvraw.obj $(LINKFLAGS) \
	/PDB:"$(OUTDIR)msrecvraw.pdb" \
	/OUT:"$(OUTDIR)msrecvraw.mexw32"

$(OUTDIR)mssend.mexw32 : $(OUTDIR)mssend.obj $(OUTDIR)matvar.obj
	$(LINK) $(OUTDIR)mssend.obj $(OUTDIR)matvar.obj $(LINKFLAGS) \
	/PDB:"$(OUTDIR)mssend.pdb" \
	/OUT:"$(OUTDIR)mssend.mexw32"

$(OUTDIR)msrecv.mexw32 : $(OUTDIR)msrecv.obj $(OUTDIR)matvar.obj
	$(LINK) $(OUTDIR)msrecv.obj $(OUTDIR)matvar.obj $(LINKFLAGS) \
	/PDB:"$(OUTDIR)msrecv.pdb" \
	/OUT:"$(OUTDIR)msrecv.mexw32"
