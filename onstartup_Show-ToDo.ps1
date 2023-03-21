
# If this file opened in a text editor after system startup, please go to...
#   C:\Users\{USER}\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
# ... and set .ps1 file opening application to powershell.exe in order for
#     ToDoWriter module to work properly

# Reimport the newest version of ToDoWriter
Import-Module ToDoWriter -Force

# Show list
Show-ToDo

Write-Host "Do you wish to open a new PowerShell session? (y/N) " -NoNewline
$response = (Read-Host).ToLower().Trim()

if ($response.Length -gt 0 -and $response[0] -eq 'y')
{
    Start PowerShell
}
