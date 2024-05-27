@echo off

rem Allow local variables to be created
setlocal ENABLEDELAYEDEXPANSION

rem Globally enable or disable display of commands that are run at compile time
set echo_stat=off


rem Create variables
set CurDir=%CD%
set CurDir2=%CurDir:\=/%
set CurDir3=%CurDir2: =\ %
set GCC_FOLDER_NAME=mingw64

rem Move into the Backend folder, where all the magic happens
cd Backend

rem Cleanup, it rebuild later
if exist objects.list del objects.list
if exist bootmgfw.efi del bootmgfw.efi
if exist output.map del output.map
if exist bootmgfw.d del bootmgfw.d
if exist bootmgfw.o del bootmgfw.o
if exist bootmgfw.out del bootmgfw.out

rem Also Need to tell GCC where to find as and ld
set PATH=%CD%\%GCC_FOLDER_NAME%\bin;%PATH%

rem Create the HFILES variable, which contains the massive set of includes (-I) needed by GCC.
set HFILES="%CurDir%\inc\"

rem Loop through the h_files.txt file and turn each include directory into -I strings
FOR /F "tokens=*" %%h IN ('type "%CurDir%\Backend\h_files.txt"') DO set HFILES=!HFILES! -I"%%h"

rem Converts backslashes into forward slashes on Windows.
set HFILES=%HFILES:\=/%

rem Loop through and compile the backend .c files, which are listed in c_files_windows.txt
@echo %echo_stat%
FOR /F "tokens=*" %%f IN ('type "%CurDir%\Backend\c_files_windows.txt"') DO "%GCC_FOLDER_NAME%\bin\gcc.exe" -ffreestanding -fshort-wchar -fno-stack-protector -fno-stack-check -fno-strict-aliasing -mno-stack-arg-probe -fno-merge-all-constants -m64 -mno-red-zone -DGNU_EFI_USE_MS_ABI -maccumulate-outgoing-args --std=c11 -I!HFILES! -Og -g3 -Wall -Wextra -Wdouble-promotion -fmessage-length=0 -c -MMD -MP -Wa,-adhln="%%~df%%~pf%%~nf.out" -MF"%%~df%%~pf%%~nf.d" -MT"%%~df%%~pf%%~nf.o" -o "%%~df%%~pf%%~nf.o" "%%~ff"
@echo off

rem Compile user .c files
@echo on
"%GCC_FOLDER_NAME%\bin\gcc.exe" -ffreestanding -fshort-wchar -fno-stack-protector -fno-stack-check -fno-strict-aliasing -fno-merge-all-constants -mno-stack-arg-probe -m64 -mno-red-zone -DGNU_EFI_USE_MS_ABI -maccumulate-outgoing-args --std=c11 -I!HFILES! -Og -g3 -Wall -Wextra -Wdouble-promotion -fmessage-length=0 -c -MMD -MP -Wa,-adhln="%CurDir2%\Backend\bootmgfw.out" -MF"%CurDir2%\Backend\bootmgfw.d" -MT"%CurDir2%\Backend\bootmgfw.o" -o "%CurDir2%\Backend\bootmgfw.o" "%CurDir2%\bootmgfw.c"
@echo off

rem Create OBJECTS variable, whose sole purpose is to allow conversion of backslashes into forward slashes in Windows
set OBJECTS=

rem Create the objects.list file, which contains properly-formatted
FOR /F "tokens=*" %%f IN ('type "%CurDir%\Backend\c_files_windows.txt"') DO (set OBJECTS="%%~df%%~pf%%~nf.o" & set OBJECTS=!OBJECTS:\=/! & set OBJECTS=!OBJECTS: =\ ! & set OBJECTS=!OBJECTS:"\ \ ="! & echo !OBJECTS! >> objects.list)

rem Add compiled user .o files to objects.list
FOR %%f IN ("%CurDir2%/Backend/*.o") DO echo "%CurDir3%/Backend/%%~nxf" >> objects.list

rem Link the object files using all the objects in objects.list to generate the output binary, which is called "bootmgfw.efi"
@echo on
"%GCC_FOLDER_NAME%\bin\gcc.exe" -nostdlib -Wl,--warn-common -Wl,--no-undefined -Wl,-dll -s -shared -Wl,--subsystem,10 -e efi_main -Wl,-Map=output.map -o "bootmgfw.efi" @"objects.list"
@echo off

rem "%GCC_FOLDER_NAME%\bin\objcopy.exe" -O binary "program.exe" "program.bin"
"%GCC_FOLDER_NAME%\bin\size.exe" "bootmgfw.efi"
echo.

timeout /t 30 /nobreak >nul
endlocal