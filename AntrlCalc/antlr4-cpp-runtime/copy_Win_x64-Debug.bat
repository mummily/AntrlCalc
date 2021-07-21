
@echo off

REM lib拷贝
rd /s /q ..\Lib\
md ..\Lib\
copy .\Win_x64-Debug\lib\antlr4-runtime.lib ..\Lib\

REM dll拷贝
copy .\Win_x64-Debug\lib\antlr4-runtime.dll ..\x64\Debug\

@echo on
@pause