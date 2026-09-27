@echo off
setlocal

set "PROJECT_DIR=%~dp0"
set "PYTHON_EXE=%~dp0venv\Scripts\python.exe"

if not exist "%PYTHON_EXE%" (
    echo FitBuddy virtual environment was not found at:
    echo %PYTHON_EXE%
    pause
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "$url = 'http://127.0.0.1:8001/'; try { Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 1 | Out-Null } catch { Start-Process -FilePath '%PYTHON_EXE%' -ArgumentList '-m uvicorn app.main:app --host 127.0.0.1 --port 8001' -WorkingDirectory '%PROJECT_DIR%' }; for ($attempt = 0; $attempt -lt 30; $attempt++) { try { $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 1; if ($response.StatusCode -eq 200) { Start-Process $url; exit 0 } } catch {}; Start-Sleep -Milliseconds 500 }; Write-Error 'FitBuddy did not start at http://127.0.0.1:8001/'; exit 1"

if errorlevel 1 pause
endlocal