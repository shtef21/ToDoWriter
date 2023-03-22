
# TODO file path
$todo_path = "$PSScriptRoot\todo_data.txt"

function setup_module {

    # If TODO file does not exist, create it
    if ([System.IO.File]::Exists($todo_path) -eq $false) {
        "" | Out-File -FilePath $todo_path
    }
}


function Set-ToDo {

    setup_module

    # Get TODOs
    $todo_list = [System.Collections.ArrayList][string[]](Get-Content -Path $todo_path)

    # Filter out empty values
    $todo_list = $todo_list.Where({ [string]::IsNullOrWhiteSpace($_) -eq $false })

    # Check if there are any TODOs
    if ($todo_list.Count -eq 0) {
        Write-Host ""
        Write-Host "Found no TODOs. Consider adding one with Add-ToDo -ToDo `"...`""
        Write-Host ""
        return
    }

    # Show current list to user
    Show-ToDo

    # Prompt user to choose items for marking as finished
    Write-Host "Which elements do you want to mark as DONE:" -ForegroundColor Blue -BackgroundColor White -NoNewline
    Write-Host " " -NoNewline
    [string] $user_input = Read-Host

    # Define container for items set for removal
    $update_idx_arr = [System.Collections.ArrayList]::new()

    # Iterate many input values
    foreach ($input_val in $user_input.Split().Where({ $_ })) {

        # Parse index
        [int] $update_idx = ([int] $input_val) - 1
        
        # If user entered valid element
        if ($update_idx -ge 0 -and $update_idx -lt $todo_list.Count) {
            $update_idx_arr.Add($update_idx)
        }
        else {
            Write-Host "Cannot find item $user_input. Please choose an item by its number."
        }
    }

    # If there are any items, process the update
    if ($update_idx_arr.Count -gt 0) {
        # Remove items from list
        foreach ($update_idx in $update_idx_arr) {
            # Update element at that index
            $todo_list[$update_idx] = "DONE" + $todo_list[$update_idx].Substring(4)

            # Give output
            Write-Host "Updated item $($update_idx + 1): $($todo_list[$update_idx])"
        }

        # Update file
        Set-Content -Path $todo_path $todo_list

        # Show current list to user
        Show-ToDo "TODO list after update:"
    }
}

Export-ModuleMember -Function Set-ToDo
