
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
        [string] $title,   # Title before printing the list out
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
        Write-Host "Found no TODOs. Consider adding one with Add-ToDo -ToDo `"...`""
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

function Add-ToDo {
    param(
        [string] $ToDo,  # Item value
        [switch] $Done,  # Should this ToDo be marked as finished
        [switch] $Many   # (Not implemented) If sent, then $ToDo contains
                         #           a list of TODOs, delimited by commas
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

function Set-ToDo {

    setup_module

    # Get TODOs
    $todo_list = [System.Collections.ArrayList][string[]](Get-Content -Path $todo_path)

    # Filter out empty values
    $todo_list = $todo_list.Where({ [string]::IsNullOrWhiteSpace($_) -eq $false })

    # Check if there are any TODOs
    if ($todo_list.Count -eq 0) {
        Write-Host "Found no TODOs. Consider adding one with Add-ToDo -ToDo `"...`""
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
    foreach($input_val in $user_input.Split().Where({$_})) {

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
    if ($update_idx_arr.Count -gt 0)
    {
        # Remove items from list
        foreach($update_idx in $update_idx_arr)
        {
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

function Reset-ToDo {

    setup_module

    # Get TODOs
    $todo_list = [System.Collections.ArrayList][string[]](Get-Content -Path $todo_path)

    # Filter out empty values
    $todo_list = $todo_list.Where({ [string]::IsNullOrWhiteSpace($_) -eq $false })

    # Check if there are any TODOs
    if ($todo_list.Count -eq 0) {
        Write-Host "Found no TODOs. Consider adding one with Add-ToDo -ToDo `"...`""
        return
    }

    # Show current list to user
    Show-ToDo

    # Prompt user to choose items for marking as not finished
    Write-Host "Which elements do you want to mark as TODO:" -ForegroundColor Blue -BackgroundColor White -NoNewline
    Write-Host " " -NoNewline
    [string] $user_input = Read-Host

    # Define container for items set for removal
    $update_idx_arr = [System.Collections.ArrayList]::new()

    # Iterate many input values
    foreach($input_val in $user_input.Split().Where({$_})) {

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
    if ($update_idx_arr.Count -gt 0)
    {
        # Remove items from list
        foreach($update_idx in $update_idx_arr)
        {
            # Update element at that index
            $todo_list[$update_idx] = "TODO" + $todo_list[$update_idx].Substring(4)

            # Give output
            Write-Host "Updated item $($update_idx + 1): $($todo_list[$update_idx])"
        }

        # Update file
        Set-Content -Path $todo_path $todo_list

        # Show current list to user
        Show-ToDo "TODO list after update:"
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
        Write-Host "Found no TODOs. Consider adding one with Add-ToDo -ToDo `"...`""
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
    foreach($input_val in $user_input.Split().Where({$_})) {

        # Parse index
        [int] $remove_idx = ([int] $input_val) - 1
        
        # If user entered valid element
        if ($remove_idx -ge 0 -and $remove_idx -lt $todo_list.Count) {
            
            $item = $todo_list[$remove_idx]
            $to_remove.Add($item)
        }
        else {
            Write-Host "Cannot find item $user_input. Please choose an item by its number."
        }
    }

    # If there are any items, process the deletion
    if ($to_remove.Count -gt 0)
    {
        # Remove items from list
        foreach($del_item in $to_remove)
        {
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

New-Alias -Name "atodo" Add-ToDo     # atodo - Add    TODO
New-Alias -Name "ltodo" Show-ToDo    # ltodo - List   TODOs
New-Alias -Name "stodo" Set-ToDo     # stodo - Set    TODO
New-Alias -Name "rtodo" Reset-ToDo   # rtodo - Reset  TODO
New-Alias -Name "dtodo" Remove-ToDo  # dtodo - Delete TODO

Export-ModuleMember -Function Show-ToDo, Add-ToDo, Set-ToDo, Reset-ToDo, Remove-ToDo -Alias atodo, ltodo, stodo, rtodo, dtodo
