
# If this file opened in a text editor after system startup, please go to...
#   C:\Users\{USER}\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
# ... and set .ps1 file opening application to powershell.exe in order for
#     ToDoWriter module to work properly

# Reimport the newest version of ToDoWriter
if ([System.IO.File]::Exists("./ToDoWriter.psm1")) {
    Import-Module "./ToDoWriter.psm1" -Force
}
else {
    # Try to import from any module directory
    Import-Module ToDoWriter -Force
}

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

# Show list
Clear-Host
Show-ToDo

$keep_alive = $true

while ($keep_alive) {

    [string] $cmd = prompt_user_response

    if ($cmd -eq "s" -or $cmd -eq "show") {
        Clear-Host
        Show-ToDo
    }
    elseif ($cmd -eq "a" -or $cmd -eq "add") {

        $counter = 1
        while ($counter -gt 0) {
            Clear-Host
            $todo = Read-Host -Prompt "Enter item $counter"

            if ([string]::IsNullOrWhiteSpace($todo)) {
                $counter = -1
                Show-ToDo
            }
            else {
                [string] $done = Read-Host -Prompt "  Done (y/N)? "

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
        Clear-Host
        Set-ToDo
    }
    elseif ($cmd -eq "o" -or $cmd -eq "open") {
        Clear-Host
        Reset-ToDo
    }
    elseif ($cmd -eq "d" -or $cmd -eq "delete") {
        Clear-Host
        Remove-ToDo
    }
    elseif ($cmd -eq "q" -or $cmd -eq "") {
        $keep_alive = $false
    }
    else {
        Clear-Host
        Write-Host "Command '$cmd' not recognized."
    }
}
