SET SourceDir=%~dp0
SET DestDir=%~dp0
SET Filename=ani_import.zip
SET MSFilename=ani_import.ms
SET OutputFolder=Build
SET Inifile=ani.ini
SET ZipArchver=C:\Program Files\7-Zip

call "join_ani_import_files.bat"

CD /D "%ZipArchver%"
7z.exe a -tzip "%SourceDir%%OutputFolder%\%Filename%" "%DestDir%%OutputFolder%\%MSFilename%" "%SourceDir%\%Inifile%"