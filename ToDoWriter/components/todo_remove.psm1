
# TODO file path
$todo_path = "$PSScriptRoot\todo_data.txt"

function setup_module {

    # If TODO file does not exist, create it
    if ([System.IO.File]::Exists($todo_path) -eq $false) {
        "" | Out-File -FilePath $todo_path
    }
}


function Remove-ToDo {

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
    Write-Host "Which elements do you want to delete:" -ForegroundColor Blue -BackgroundColor White -NoNewline
    Write-Host " " -NoNewline
    [string] $user_input = Read-Host

    # Define container for items set for removal
    $to_remove = [System.Collections.ArrayList]::new()

    # Iterate many input values
    foreach ($input_val in $user_input.Split().Where({ $_ })) {

        # Parse index
        [int] $remove_idx = ([int] $input_val) - 1

        # If user entered valid element
        if ($remove_idx -ge 0 -and $remove_idx -lt $todo_list.Count) {
            
            $item = $todo_list[$remove_idx]
            $to_remove.Add($item)
        }
        else {
            Write-Host "Cannot find item $input_val. Please choose an item by its number."
        }
    }

    # If there are any items, process the deletion
    if ($to_remove.Count -gt 0) {
        # Remove items from list
        foreach ($del_item in $to_remove) {
            $todo_list.Remove($del_item)

            # Show which item has been deleted
            Write-Host "Removed item: " -NoNewline
            Write-Host $del_item -ForegroundColor Red
        }

        # Update file
        Set-Content -Path $todo_path $todo_list

        # Show current list to user
        Show-ToDo "TODO list after update:"
    }

}

Export-ModuleMember -Function Remove-ToDo
