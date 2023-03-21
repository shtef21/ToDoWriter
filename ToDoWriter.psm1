
# Import modules
Import-Module ./components/todo_show.psm1
Import-Module ./components/todo_add.psm1
Import-Module ./components/todo_remove.psm1
Import-Module ./components/todo_set.psm1
Import-Module ./components/todo_reset.psm1

function Start-ToDoClient {
    . ./client.ps1
}

# Export functions
Export-ModuleMember -Function Start-ToDoClient, Show-ToDo, Add-ToDo, Set-ToDo, Reset-ToDo, Remove-ToDo 

# Set aliases if not exist
if ((Test-Path alias:*todo) -eq $false) {
    New-Alias -Name "atodo" Add-ToDo     # atodo - Add    TODO
    New-Alias -Name "ltodo" Show-ToDo    # ltodo - List   TODOs
    New-Alias -Name "stodo" Set-ToDo     # stodo - Set    TODO
    New-Alias -Name "rtodo" Reset-ToDo   # rtodo - Reset  TODO
    New-Alias -Name "dtodo" Remove-ToDo  # dtodo - Delete TODO

    # Export them
    Export-ModuleMember -Alias atodo, ltodo, stodo, rtodo, dtodo
}
