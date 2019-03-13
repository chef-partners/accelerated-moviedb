#
# Script which will register the Hab Supervisor start as a scheduled task
# This will be set to run at boot
#
# An option can be passed to the script to execute the task after it has been
# created. This is so that it can be registered and then run immediately
# without affecting the boot trigger or using a timer trigger.
[CmdletBinding()]
param (
  [switch]
  # State of the task should be run after creation
  $runtask,
  [string]
  # Powershell script that should be run by the scheduler
  $script_path = "scripts\start_hab_supervisor.ps1",
  [string]
  # Habitat origin that the supervisor should run under
  $origin = "",
  [string]
  # Path to the results directory
  $path,
  [string]
  # User that the task should run under
  $username = $env:USERNAME,
  [string]
  # Password for the specified user
  $password,
  [string]
  # Set the name of the task
  $task_name = "Habitat Supervisor"
)
# Ensure that the scheduled task module exists on the machine
$exists = Get-Module -ListAvailable -Name PSScheduledJob
if (![String]::IsNullOrEmpty($exists)) {
  Write-Output "Importing Module: PSScheduledJob"
  Import-Module PSScheduledJob
} else {
  Write-Output "Module does not exist on machine: PSScheduledJob"
  exit 1
}
# Ensure that the script_path exists
if (Test-Path -Path $script_path) {
  $script_path = (Resolve-Path -Path $script_path).Path
} else {
  Write-Output "Specified script cannot be found: {0}" -f $script_path
}
# Create the necessary triggers
$triggers = @()
# Startup trigger
Write-Output "Setting trigger: AtStartup"
$triggers += New-JobTrigger -AtStartup
# Create the action that needs to be executed
$splat = @{
  Execute = "powershell.exe"
  Argument = '-NoProfile -WindowStyle Hidden -File "{0}" -path {1} -origin {2}' -f $script_path, $path, $origin
}
$action = New-ScheduledTaskAction @splat
# Finally register the task
$splat = @{
  Action = $action
  Trigger = $triggers
  TaskName = $task_name
  Description = "Start Habitat Supervisor at machine startup"
  User = $username
  Password = $password
  RunLevel = "Highest"
}
Register-ScheduledTask @splat
# If the option has been set, execute the task
if ($runtask) {
  Start-ScheduledTask -TaskName $task_name
}
