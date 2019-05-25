SET SourceDir=%~dp0
SET DestDir=%~dp0
SET Filename=cff_clf_export.zip
SET MSFilename=cff_clf_import.ms
SET OutputFolder=Build
SET ZipArchver=C:\Program Files\7-Zip

call "join_import_files.bat"

CD /D "%ZipArchver%"
7z.exe a -tzip "%SourceDir%%OutputFolder%\%Filename%" "%DestDir%%OutputFolder%\%MSFilename%"