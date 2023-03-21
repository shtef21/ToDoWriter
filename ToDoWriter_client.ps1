
# If this file opened in a text editor after system startup, please go to...
#   C:\Users\{USER}\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
# ... and set .ps1 file opening application to powershell.exe in order for
#     ToDoWriter module to work properly

# Reimport the newest version of ToDoWriter
Import-Module ToDoWriter -Force

function prompt_user_response {

    # Show available commands
    Write-Host "Available commands: " -NoNewline
    Write-Host "(s)how, (a)dd, (f)inish, (o)pen, (d)elete" -ForegroundColor Blue -BackgroundColor White

    # Ask for entry
    Write-Host "Write command or " -NoNewline
    Write-Host "(q)uit" -ForegroundColor Blue -BackgroundColor White -NoNewline
    Write-Host ": " -NoNewline

    # Read, format and return entry
    $cmd = (Read-Host).ToLower().Trim()
    return $cmd
}

# Show list
Show-ToDo

$keep_alive = $true

while ($keep_alive) {

    [string] $cmd = prompt_user_response

    if ($cmd.StartsWith("s")) {
    }
    elseif ($cmd.StartsWith("a")) {
    }
    elseif ($cmd.StartsWith("f")) {
    }
    elseif ($cmd.StartsWith("o")) {
    }
    elseif ($cmd.StartsWith("d")) {
    }
    elseif ($cmd.StartsWith("q")) {
    }
    else {
        Clear-Host
        Write-Host "Command `"" + $cmd + "`" not recognized."
    }
}

Write-Host "Do you wish to open a new PowerShell session? (y/N) " -NoNewline
$response = (Read-Host).ToLower().Trim()

if ($response.Length -gt 0 -and $response[0] -eq 'y') {
    Start PowerShell
}
