
# TODO file path
$todo_path = "$PSScriptRoot\todo_data.txt"

function setup_module {

    # If TODO file does not exist, create it
    if ([System.IO.File]::Exists($todo_path) -eq $false) {
        "" | Out-File -FilePath $todo_path
    }
}


function Show-ToDo {
    param (
        [string] $title, # Title before printing the list out
        [switch] $Concise  # If sent, does not show DONE tasks
    )
    
    setup_module

    if (-not($title)) {
        $title = "Current TODO list:"
    }

    # Get TODOs
    $todo_list = [System.Collections.ArrayList][string[]](
        Get-Content -Path $todo_path
    )

    # Filter out empty values
    $todo_list = $todo_list.Where({
            [string]::IsNullOrWhiteSpace($_) -eq $false
        })

    # No TODOs found
    if ($todo_list.Count -eq 0) {
        Write-Host ""
        Write-Host "Found no TODOs. Consider adding one with Add-ToDo -ToDo `"...`""
        Write-Host ""
    }
    else {
        # Format TODOs in a list 
        Write-Host ""
        Write-Host $title -ForegroundColor Green
        for ($i = 1; $i -le $todo_list.Count; $i++) {
        
            $item = $todo_list[$i - 1]
            
            if ($item.StartsWith("TODO")) {
                Write-Host " $i. $item" -ForegroundColor Red
            }
            elseif ($item.StartsWith("DONE") -and -not($Concise)) {
                Write-Host " $i. $item"
            }
        }
        Write-Host ""
    }
}

Export-ModuleMember -Function Show-ToDo
