
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

# Prompt user to choose items for deletion
[string] $user_input = Read-Host -Prompt 'Which element do you want to delete'

# Split by spaces to get many elements
# Use "Where" to filter out empty inputs (2 spaces in a row being split)
$input_values = $user_input.Split().Where({$_})

# Define container for items set for removal
$to_remove = [System.Collections.ArrayList]::new()

foreach($input_val in $input_values) {

    [int] $remove_idx = ([int] $input_val) - 1
    
    # If user entered valid element
    if ($remove_idx -ge 0 -and $remove_idx -lt $todo_list.Count) {
    
        $item = $todo_list[$remove_idx]
        $to_remove.Add($item)
    }
    else {
        Write-Output "Cannot find item $user_input. Please choose an item by its number."
    }
}

# If there are any items, process the deletion
if ($to_remove.Count -gt 0)
{
    # Remove items from list
    foreach($del_item in $to_remove)
    {
        $todo_list.Remove($del_item)
        
        # Give output
        Write-Output "Removed item: $del_item"
    }
    
    # Update file
    Set-Content -Path $todo_path $todo_list
}
