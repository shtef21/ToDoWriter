# ToDoWriter module
ToDo application written in powershell

## Description
A PowerShell TODO app which enables its user to add TODO items, mark them as done / open and remove them.

It also provides a ToDoWriter client which provides a basic UI and a session in which user may
add and manage many items at once.

Another useful behaviour regarding the module is putting the client script in the startup folder. That way,
each time the user starts the pc, they will see the TODO list. To enable this behaviour, you may check out
the instructions provided by the Set-ToDoClientStartup CMDLET.


## Module CMDLETs
 - List TODOs (alias ltodo) - `Show-ToDo`
 - Add a TODO (alias atodo) - `Add-ToDo -ToDo <string> [-Done]`
 - Mark one or more TODO items as done (alias stodo) - `Set-ToDo`
 - Mark one or more TODO items as open (alias rtodo) - `Reset-ToDo`
 - Remove one or more TODO items (alias dtodo) - `Remove-ToDo`
 - Start the client - `Start-ToDoClient`
 - Get instructions for starting the client on system startup - `Get-ToDoClientStartupManual`


## Example CMDLET usage
```powershell
Show-ToDo
Add-ToDo -ToDo "Make supper"
Add-ToDo "Finish the powershell script"    # Implicit -ToDo
Add-ToDo "Create a manual" -Done

Set-ToDo           # This opens up a dialog for marking TODOs as Done
Reset-ToDo         # This opens up a dialog for marking TODOs as Open
Remove-ToDo        # This opens up a dialog for deleting TODOs
Show-ToDo

Start-ToDoClient
```
