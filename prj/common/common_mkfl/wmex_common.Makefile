#
# file:			windows.Makefile (to create DOOCSapi.version.dll + DOOCSapi.lib)
# created on:	2020 Mar 28
# created by:	D. Kalantaryan (davit.kalantaryan@desy.de)
#
# purpose:		To build DOOCS client library without EPICS
# Examples of calling:
#		>nmake /f windows.Makefile /e Platform=x64
#		>nmake /f windows.Makefile /e Platform=x86
#		>nmake /f windows.Makefile 
#
# Please specify any platform target from following list
# arm
# arm64
# x64 
# x86
# Platform				= x64  # default
# PlatformTarget	# will be specified automatically
#
# below is the variables, that should be specified by parent Makefile, before including this
# TargetName				= DOOCSapi # this s defined by final makefile
# CallerMakeFilePath		= XXX  # this one you can provide $(MAKEDIR)\makeFileName
#
# here are default values - will be set if parent Makefile does not specify them'
# Platform				= x64  # default
# ObjectsDirBase		= $(CallerMakeFileDir)\.objects
# SourcesRootDir		= $(CallerMakeFileDir)
#


# better ideas to calculate this?
InitCurDir				= $(MAKEDIR)

TargetExtension			= dummy
TargetFileName			= $(TargetName).$(TargetExtension)

CC						= cl 
CPPC           			= cl -Zc:__cplusplus
LINKER        			= link
DEFINES       			= $(DEFINES) /D "DLL_EXPORT_SYM=__declspec(dllexport)" 
INCLUDE_PATHS			= $(INCLUDE_PATHS) /I"$(MatDevRootDir)\include"
#CFLAGS					= $(CFLAGS) $(INCLUDE_PATHS) $(DEFINES) /nologo /MDd
CFLAGS					= $(CFLAGS) $(INCLUDE_PATHS) $(DEFINES) /MDd
CXXFLAGS				= $(CXXFLAGS) $(CFLAGS)  /EHsc 
LIBS					= $(LIBS) libmx.lib libmex.lib
LIBPATHS				= $(LIBPATHS) /LIBPATH:"$(MatDevRootDir)\sys\win_$(Platform)\lib"

ObjectsDir				= $(MAKEDIR)\.objects


.cc.obj:
	@if not exist $(ObjectsDir)\$(@D) mkdir $(ObjectsDir)\$(@D)
	@$(CPPC) /c $(CXXFLAGS) /Fo$(ObjectsDir)\$(@D)\ $*.cc

.cpp.obj:
	@echo 3. !!!!!!!!!!!!!! INCLUDE_PATHS=$(INCLUDE_PATHS)
	@if not exist $(ObjectsDir)\$(@D) mkdir $(ObjectsDir)\$(@D)
	@$(CPPC) /c $(CXXFLAGS) /Fo$(ObjectsDir)\$(@D)\ $*.cpp

.c.obj:
	@if not exist $(ObjectsDir)\$(@D) mkdir $(ObjectsDir)\$(@D)
	@$(CC) /c $(CFLAGS) /Fo$(ObjectsDir)\$(@D)\ $*.c

includeFirstBuild: includeBuild

includeBuildRaw: $(Objects)
	@cd $(ObjectsDir)
	$(LINKER) $(LFLAGS) $(Objects) $(LIBS) /DLL $(LIBPATHS) /SUBSYSTEM:CONSOLE libmx.lib libmex.lib /OUT:$(TargetName).$(TargetExtension)
	@cd $(MAKEDIR)
	@::echo !!!!!!!  $(ObjectsDir)\$(TargetName).$(TargetExtension)
	@copy /y $(ObjectsDir)\$(TargetName).$(TargetExtension) .

clean:
	@if exist $(ObjectsDir) rmdir /q /s $(ObjectsDir)
	@if exist $(TargetName).mexw64 del $(TargetName).mexw64
	@if exist $(TargetName).mexw32 del $(TargetName).mexw32
	@if exist *.ilk del /s /q *.ilk
	@if exist *.pdb del /s /q *.pdb
	@echo "clean done!"


includeBuild:
	@echo !!!!!!!!!!!!!!!!! MAKEDIR=$(MAKEDIR)
	@<<build.bat
		@echo off
		setlocal EnableDelayedExpansion enableextensions
		::set /p doocsVersionMakefileRawRaw= < $(MAKEDIR)\LIBNO
		::for /f "delims=" %%i in ('@echo %doocsVersionMakefileRawRaw:~8,20%') do set doocsVersionMakefileRaw=%%i
		::set doocsVersionMakefile=!doocsVersionMakefileRaw!

		set buildShouldBeDoneHere=true

		if  "$(CallerMakeFilePath)"=="" (
			if "$(Objects)"=="" (
				echo !!!!!!!!! error !!!!!!!
				echo Before calling makeInclude 'wmex_common.Makefile' ^
					you should specify variable 'CallerMakeFilePath' or
				echo variable with name Objects, specifying objects will be build here
				echo The caller Makefile can be specified like this  [CallerMakeFilePath = \$(MAKEDIR)/makeFileName]
				exit /b 1
			)
			set buildShouldBeDoneHere=true
			set CallerMakeFilePath=$(MAKEDIR)
		) else (
			set CallerMakeFilePath=$(CallerMakeFilePath)
			::set buildShouldBeDoneHere=false
			if "$(ReplyTarget)"=="" (
				if "!ReplyTarget!"=="" (
					set ReplyTarget=build
				)
			) else (
				set ReplyTarget=$(ReplyTarget)
			)
		)

		call :file_name_from_path SourcesRootDirRaw !CallerMakeFilePath!
		set ObjectsDir=!SourcesRootDirRaw!.objects
		
		if "$(SourcesRootDir)"=="" (
			::echo SourcesRootDir is not defined.	Defaulted to !SourcesRootDirRaw!
			set SourcesRootDir=!SourcesRootDirRaw!
		) else (
			set SourcesRootDir=!SourcesRootDir!
		)
		::cd !SourcesRootDir!

		if "$(Platform)"=="" (
			echo Platform is not defined.	Defaulted to x64
			set Platform=x64
		) else (
			set Platform=$(Platform)
		)
		
		if /i "!Platform!"=="x64" (
			set PlatformTarget=amd64
			set TargetExtension=mexw64
		) else (
			set PlatformTarget=!Platform!
			set TargetExtension=mexw32
		)

		call VsDevCmd -arch=!PlatformTarget!

		if "!buildShouldBeDoneHere!"=="true" (
			echo "Builds here"
			cd !SourcesRootDir!
			$(MAKE) /f $(CallerMakeFilePath) includeBuildRaw  ^
				/e TargetExtension=!TargetExtension! ^
				/e Platform=!Platform! ^
				/e ObjectsDir=!ObjectsDir! ^
				/e SourcesRootDir=!SourcesRootDir!
		) else (
			echo "Builds there"
			$(MAKE) /f $(CallerMakeFilePath) /e TargetExtension=!TargetExtension! !ReplyTarget! /e Platform=!Platform!
		)

		exit /b 0

		:file_name_from_path  <resultDir> <pathVar>
			set "%~1=%~dp1"
			exit /b 0
			
		endlocal
<<NOKEEP
