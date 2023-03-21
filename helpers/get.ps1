
# Define data path
$todo_path = "$PSScriptRoot\todo_data.txt"

# Create if does not exist
if ([System.IO.File]::Exists($todo_path) -eq $false) {
    "" | Out-File -FilePath $todo_path
}

# Get TODOs
$todo_list = [System.Collections.ArrayList][string[]](Get-Content -Path $todo_path)

# Filter out empty values
$todo_list = $todo_list.Where({ [string]::IsNullOrWhiteSpace($_) -eq $false })

if ($todo_list.Count -eq 0) {
    Write-Output "Found no TODOs. Consider adding one with Add-ToDo -ToDo `"...`""
}
else {
    Write-Output "Current TODO list:"
    for ($i = 1; $i -le $todo_list.Count; $i++) {
    
        $item = $todo_list[$i - 1]
        Write-Output " $i. $item"
    }
}
