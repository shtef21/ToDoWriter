
# Import modules
Import-Module ./components/todo_show.psm1 -Force
Import-Module ./components/todo_add.psm1 -Force
Import-Module ./components/todo_remove.psm1 -Force
Import-Module ./components/todo_set.psm1 -Force
Import-Module ./components/todo_reset.psm1 -Force

function Start-ToDoClient {
    . ./client.ps1
}

function Get-ToDoClientStartupManual {
    # Set ToDoWriter client to run on startup
    
    $path = "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
    Write-Host ""
    Write-Host "To enable client startup:"
    Write-Host "  1. Open `"$path`""
    Write-Host "  2. Create a shortcut to `"$PSScriptRoot\client.ps1`""
    Write-Host "  3. Set PowerShell as the default application for .ps1 files"
    Write-Host "  4. Enable running PowerShell scripts on your system with `"Set-ExecutionPolicy RemoteSigned`""
    Write-Host ""
}

# Export TODO functions
Export-ModuleMember -Function Show-ToDo, Add-ToDo, Set-ToDo, Reset-ToDo, Remove-ToDo

# Export management functions
Export-ModuleMember -Function Start-ToDoClient, Get-ToDoClientStartupManual

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
