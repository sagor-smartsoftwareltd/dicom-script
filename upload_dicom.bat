@echo off
powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File "%~dp0watch.ps1"
@echo off
setlocal enabledelayedexpansion

REM --- CONFIGURATION ---
SET "ROOT_DIR=C:\DICOM\data"
SET "APP_URL=https://test.mentor-bd.com/api/dicom/upload?hospital=SquareH"
SET "LOG_FILE=C:\DICOM\scripts\upload_log.txt"
REM --- END CONFIGURATION ---

echo ============================ >> "%LOG_FILE%"
echo Upload started at %DATE% %TIME% >> "%LOG_FILE%"
echo Root directory: %ROOT_DIR% >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

REM Loop through each study folder
FOR /D %%S IN ("%ROOT_DIR%\*") DO (

    SET "FOLDER_NAME=%%~nxS"

    REM Ignore specific folders
    IF /I NOT "!FOLDER_NAME!"=="dbase" IF /I NOT "!FOLDER_NAME!"=="incoming" IF /I NOT "!FOLDER_NAME!"=="printer_files" (

        echo --- New Study: %%~nxS --- >> "%LOG_FILE%"

        REM Loop through files inside the study folder
        FOR %%F IN ("%%S\*") DO (

            SET "FILE_PATH=%%~fF"
            SET "FILE_NAME=%%~nxF"

            REM Check if file was already uploaded
            findstr /C:"UPLOADED_FILE=!FILE_PATH!" "%LOG_FILE%" >nul 2>&1

            IF ERRORLEVEL 1 (
                echo Uploading: !FILE_NAME! >> "%LOG_FILE%"

                curl.exe -sS --fail ^
                    -X POST ^
                    -F "file=@%%F" ^
                    "%APP_URL%" >> "%LOG_FILE%" 2>&1

                IF ERRORLEVEL 1 (
                    echo ERROR uploading !FILE_NAME! >> "%LOG_FILE%"
                ) ELSE (
                    echo UPLOADED_FILE=!FILE_PATH! >> "%LOG_FILE%"
                )
            ) ELSE (
                echo Skipping already uploaded: !FILE_NAME! >> "%LOG_FILE%"
            )
        )

        echo Finished study %%~nxS >> "%LOG_FILE%"
        echo. >> "%LOG_FILE%"
    ) ELSE (
        echo Skipping folder: %%~nxS >> "%LOG_FILE%"
    )
)

echo Upload finished at %DATE% %TIME% >> "%LOG_FILE%"
echo ============================ >> "%LOG_FILE%"
