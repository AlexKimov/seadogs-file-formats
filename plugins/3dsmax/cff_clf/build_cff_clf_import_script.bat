SET SourceDir=%~dp0
SET DestDir=%~dp0
SET Filename=cff_clf_import.zip
SET MSFilename=cff_clf_import.ms
SET Inifile=cff.ini
SET OutputFolder=Build
SET ZipArchver=C:\Program Files\7-Zip

call "join_import_files.bat"

CD /D "%ZipArchver%"
7z.exe a -tzip "%SourceDir%%OutputFolder%\%Filename%" "%DestDir%%OutputFolder%\%MSFilename%" "%SourceDir%\%Inifile%"