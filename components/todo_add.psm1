
# TODO file path
$todo_path = "$PSScriptRoot\todo_data.txt"

function setup_module {

    # If TODO file does not exist, create it
    if ([System.IO.File]::Exists($todo_path) -eq $false) {
        "" | Out-File -FilePath $todo_path
    }
}

function Add-ToDo {
    param(
        [string] $ToDo, # Item value
        [switch] $Done  # Should this ToDo be marked as finished
    )

    # Check proper params sent
    if ([string]::IsNullOrWhiteSpace($todo)) {
        Throw "You must supply a non-empty value for -ToDo"
    }
    setup_module

    # Get TODOs
    $todo_list = [System.Collections.ArrayList][string[]](
        Get-Content -Path $todo_path
    )

    # Filter out empty values
    $todo_list = $todo_list.Where({
            [string]::IsNullOrWhiteSpace($_) -eq $false
        })

    # Prepare TODO for save
    $todo = $todo.Trim()
    $todo_undone = "TODO `"$todo`""
    $todo_done = "DONE `"$todo`""

    # Check if this TODO already exists
    if ($todo_list.Contains($todo_undone) -or $todo_list.Contains($todo_done)) {
    
        # Cannot add the same TODO twice
        Write-Host "Item `"$todo`" already exists. Consider removing it with 'Remove-ToDo' or changing the contents."
    }
    else {
        # Add the new TODO
        if ($Done -eq $false) {
            $todo_list.Add($todo_undone)
        }
        else {
            $todo_list.Add($todo_done)
        }
        
        # Update file
        Set-Content -Path $todo_path $todo_list
    
        # Show output
        Write-Host "`"$todo`" added."
    }

    # Show list
    Show-ToDo
}

Export-ModuleMember -Function Add-ToDo
