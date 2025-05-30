@echo pwsh fix-wsl

@REM powershell -Command "Start-Process netsh -ArgumentList winsock,reset -verb runAs ; Start-Process sc -ArgumentList stop, vmcompute -verb runAs; Start-Process sc -ArgumentList start,vmcompute -verb runAs"
@REM powershell -Command "Start-Process sc -ArgumentList stop, vmcompute -verb runAs; Start-Process sc -ArgumentList start,vmcompute -verb runAs"

@REM powershell -Command { Start-Process -verb runAs powershell "-Command Restart-Service vmcompute -Force" \}

powershell -Command "Start-Process -verb runAs sc -ArgumentList stop,vmcompute"
