REM powershell -Command "Start-Process netsh -ArgumentList winsock,reset -verb runAs ; Start-Process sc -ArgumentList stop, vmcompute -verb runAs; Start-Process sc -ArgumentList start,vmcompute -verb runAs"
powershell -Command "Start-Process sc -ArgumentList stop, vmcompute -verb runAs; Start-Process sc -ArgumentList start,vmcompute -verb runAs"
