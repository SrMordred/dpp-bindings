rem Make basic folders

mkdir bin
mkdir lib
mkdir inc

rem Download Raylib Release files
set VERSION=3.0.0
set FOLDER=raylib-3.0.0-Win64-msvc15

curl -L https://github.com/raysan5/raylib/releases/download/%VERSION%/%FOLDER%.zip --output raylib.zip
tar -xf raylib.zip
cp %FOLDER%/lib/raylib.lib lib/raylib.lib
cp %FOLDER%/bin/raylib.dll bin/raylib.dll

rem gitclone raygui
git clone https://github.com/raysan5/raygui

cd raygui
git pull
cd ..

rem compile, generate dll and lib files of raygui
clang -c -o raygui.o raygui.c -I%FOLDER%/include -Iraygui/src -O3
llvm-ar rc lib/raygui.lib raygui.o
clang -shared -o raygui.dll -Llib -lraylib raygui.o 

rem copy dlls libs and header files
cp *.dll bin/
cp *.lib lib/
cp %FOLDER%/include/raylib.h inc/raylib.h
cp raygui/src/raygui.h inc/raygui.h

rem generate D bidings with DPP

d++ --preprocess-only --include-path inc raylib.dpp

