
# Data path
$todo_path = "$PSScriptRoot\todo_data.txt"

# If file does not exist, create it
if ([System.IO.File]::Exists($todo_path) -eq $false) {
    "" | Out-File -FilePath $todo_path
}

# Get TODOs
$todo_list = [System.Collections.ArrayList][string[]](Get-Content -Path $todo_path)

# Filter out empty values
$todo_list = $todo_list.Where({ [string]::IsNullOrWhiteSpace($_) -eq $false })

# Check if there are any TODOs
if ($todo_list.Count -eq 0) {
    Write-Output "Found no TODOs. Consider adding one with Add-ToDo -ToDo `"...`""
    return
}

# Show current list to user
Write-Output "Current TODO list:"
for ($i = 1; $i -le $todo_list.Count; $i++) {
    
    $item = $todo_list[$i - 1]
    Write-Output " $i. $item"
}

# Prompt user to choose items for marking as finished
[string] $user_input = Read-Host -Prompt 'Which element do you want to finish'

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
        Write-Output "Cannot find item $user_input. Please choose an item by its number."
    }
}

# If there are any items, process the deletion
if ($update_idx_arr.Count -gt 0)
{
    # Remove items from list
    foreach($update_idx in $update_idx_arr)
    {
        # Update element at that index
        $todo_list[$update_idx] = "DONE" + $todo_list[$update_idx].Substring(4)

        # Give output
        Write-Output "Updated item $($update_idx + 1): $($todo_list[$update_idx])"
    }

    # Show current list to user
    Write-Output "TODO list after update:"
    for ($i = 1; $i -le $todo_list.Count; $i++) {
        
        $item = $todo_list[$i - 1]
        Write-Output " $i. $item"
    }
    
    # Update file
    Set-Content -Path $todo_path $todo_list
}
