@echo off
cls
echo ==================================================
echo   x64-PortInsight Auto-Compile Script (NASM + GCC)
echo ==================================================

:: Clean old binaries
if exist main.obj del main.obj
if exist scan.exe del scan.exe

echo [i] Assembling main.asm...
nasm -f win64 main.asm -o main.obj
if %errorlevel% neq 0 (
    echo [X] Assembly failed!
    pause
    exit /b %errorlevel%
)

echo [i] Linking with GCC and SetupAPI...
gcc main.obj -o scan.exe -lsetupapi -lkernel32
if %errorlevel% neq 0 (
    echo [X] Linking failed!
    pause
    exit /b %errorlevel%
)

echo [+] Build Successful!
echo ==================================================
echo '.\scan.exe' or typing 'explorer.exe $pwd' and double click 'scan.exe'
echo ==================================================
pause