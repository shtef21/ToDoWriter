
# Import modules
Import-Module ./components/todo_show.psm1
Import-Module ./components/todo_add.psm1
Import-Module ./components/todo_remove.psm1
Import-Module ./components/todo_set.psm1
Import-Module ./components/todo_reset.psm1

function Start-ToDoClient {
    . ./client.ps1
}

function Set-ToDoClientStartup {
    # Set ToDoWriter client to run on startup

    # Check if script has admin privileges
    if ([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544") -eq $false) {
        Write-Host "Cannot set client startup. Please run script as admin."
        return
    }
    
    Write-Host "Determining startup directory path..."
    $path = "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
    
    Write-Host "To enable client startup, please go to..."
    Write-Host "  $path"
    Write-Host "and create a shortcut to..."
    Write-Host "  $path\client.ps1"
}

# Export TODO functions
Export-ModuleMember -Function Show-ToDo, Add-ToDo, Set-ToDo, Reset-ToDo, Remove-ToDo

# Export management functions
Export-ModuleMember -Function Start-ToDoClient, Set-ToDoClientStartup

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
