
param(
    [string] $ToDo,  # Item value
    [switch] $Done,  # Mark as checked initially
    [switch] $Many   # If sent, then there are many comma-separated TODOs (NOT IMPLEMENTED YET)
)

# Check proper params sent
if (-not($todo)) {
    Throw "You must supply a value for -ToDo"
}

# TODO file path
$todo_path = "$PSScriptRoot\todo_data.txt"

# If TODO file does not exist, create it
if ([System.IO.File]::Exists($todo_path) -eq $false) {
    "" | Out-File -FilePath $todo_path
}

# Get TODOs
$todo_list = [System.Collections.ArrayList][string[]](Get-Content -Path $todo_path)

# Filter out empty values
$todo_list = $todo_list.Where({ [string]::IsNullOrWhiteSpace($_) -eq $false })

# Prepare TODO for save
$todo_undone = "TODO `"$todo`""
$todo_done = "DONE `"$todo`""

if ($todo_list.Contains($todo_undone) -or $todo_list.Contains($todo_done)) {
    
    # Cannot add the same TODO twice
    Write-Output "Item `"$todo`" already exists. Consider removing it with 'Remove-ToDo' or changing the contents."
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
    Write-Output "`"$todo`" added."
}

# Give info about the current list
Write-Output "Current TODO list:"
for ($i = 1; $i -le $todo_list.Count; $i++) {

    $item = $todo_list[$i - 1]
    Write-Output " $i. $item"
}
