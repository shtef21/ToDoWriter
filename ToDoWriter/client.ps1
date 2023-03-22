
# If this file opened in a text editor after system startup, please go to...
#   C:\Users\{USER}\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
# ... and set .ps1 file opening application to powershell.exe in order for
#     ToDoWriter client to work properly

# Reimport the newest version of ToDoWriter
if ([System.IO.File]::Exists("$PSScriptRoot\ToDoWriter.psm1")) {
    Import-Module "$PSScriptRoot\ToDoWriter.psm1" -Force
}
else {
    # Try to import from any module directory
    Import-Module ToDoWriter -Force
}

# Check if module imported properly (by calling Show-ToDo)
if (-not(Get-Command Show-ToDo -errorAction SilentlyContinue)) {
    Write-Host "Cannot import module ToDoWriter. Please fix the issue and try again."
    return
}

# User command dialog
function prompt_user_response {

    # Show available commands
    Write-Host "Available commands: " -NoNewline
    Write-host "(s)how" -NoNewline -ForegroundColor Blue -BackgroundColor White
    Write-host ", " -NoNewline
    Write-host "(a)dd" -NoNewline -ForegroundColor Blue -BackgroundColor White
    Write-host ", " -NoNewline
    Write-host "(f)inish" -NoNewline -ForegroundColor Blue -BackgroundColor White
    Write-host ", " -NoNewline
    Write-host "(o)pen" -NoNewline -ForegroundColor Blue -BackgroundColor White
    Write-host ", " -NoNewline
    Write-host "(d)elete" -ForegroundColor Blue -BackgroundColor White

    # Ask for entry
    Write-Host "Write command or " -NoNewline
    Write-host "(q)uit" -NoNewline -ForegroundColor Blue -BackgroundColor White
    Write-Host ": " -NoNewline

    # Read, format and return entry
    $cmd = (Read-Host).ToLower().Trim()
    return $cmd
}

# Show list initially
Clear-Host
Show-ToDo

# Setup CMD loop
$keep_alive = $true
while ($keep_alive) {

    # Prompt for command
    [string] $cmd = prompt_user_response

    if ($cmd -eq "s" -or $cmd -eq "show") {
        # Show TODOs

        Clear-Host
        Show-ToDo
    }
    elseif ($cmd -eq "a" -or $cmd -eq "add") {
        # Add 1 or more TODOs

        $counter = 1
        while ($counter -gt 0) {
            Clear-Host
            $todo = Read-Host -Prompt "Enter item $counter (or ENTER to stop)"

            if ([string]::IsNullOrWhiteSpace($todo)) {
                # Stop input and show list

                $counter = -1
                Show-ToDo
            }
            else {
                # Should inserted TODO be marked as DONE?

                [string] $done = Read-Host -Prompt "  Done (y/N)? "

                # Add TODO
                if ($done.ToLower().StartsWith("y")) {
                    Add-ToDo -ToDo $todo -Done
                }
                else {
                    Add-ToDo -ToDo $todo
                }
                $counter++
            }
        }
    }
    elseif ($cmd -eq "f" -or $cmd -eq "finish") {
        # Set one or more TODOs as DONE

        Clear-Host
        Set-ToDo
    }
    elseif ($cmd -eq "o" -or $cmd -eq "open") {
        # Set one or more TODOs as opened

        Clear-Host
        Reset-ToDo
    }
    elseif ($cmd -eq "d" -or $cmd -eq "delete") {
        # Delete one or more TODOs

        Clear-Host
        Remove-ToDo
    }
    elseif ($cmd -eq "q" -or $cmd -eq "") {
        # Quit client

        $keep_alive = $false
    }
    else {
        # Unknown command

        Clear-Host
        Write-Host "Command '$cmd' not recognized."
    }
}
