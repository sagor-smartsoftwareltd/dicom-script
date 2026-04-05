$BatchScript = "C:\DICOM\scripts\upload_dicom.bat"
$LogFile = "C:\DICOM\scripts\watch_log.txt"

Add-Content $LogFile "Watcher started at $(Get-Date)"

while ($true) {
    Add-Content $LogFile "Running batch at $(Get-Date)"

    Start-Process `
        -FilePath "cmd.exe" `
        -ArgumentList "/c `"$BatchScript`"" `
        -WindowStyle Hidden `
        -Wait

    Start-Sleep -Seconds 60
}
