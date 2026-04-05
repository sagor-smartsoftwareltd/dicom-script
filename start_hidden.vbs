Set WshShell = CreateObject("WScript.Shell")
WshShell.Run chr(34) & "C:\DICOM\scripts\runner.bat" & Chr(34), 0
Set WshShell = Nothing
