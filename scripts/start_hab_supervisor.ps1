<#
.SYNOPSIS
  Start the Habitat supervisor for the application
.DESCRIPTION
  Script that is called by the Windows Scheduled tasks to start the hab supervisor
  The script contains a cutdown version of the Write-Log function
  The inspiartion for this comes from https://github.com/poshchef/logging
#>
[CmdletBinding()]
param (
  [string]
  # Path to the directory containing the HART file and results environment
  $path = "results",
  [string]
  # Set the origin that the supervisor should run under
  $origin = "",
  [string]
  # Specify the path to the keys that should be used for the supervisor
  # If not set this will be derived from the current user
  $keys_path = [System.IO.Path]::Combine($env:USERPROFILE, ".hab", "cache", "keys"),
  [string]
  # Path tot he log / transcript file that is to be generated
  $log_file = "c:\Windows\temp\start_hab_supervisor.log"
)
<#
.SYNOPSIS
  Function to assist with logging to a file
.DESCRIPTION
  As the script is being invoked from Windows scheduled tasks it is not that easy
  to redirect output to a file. This function will perform this function
#>
function Write-Log {
  param (
    [string]
    # Message to be output
    $message,
    [string]
    # Set the path to the log file
    $log_file
  )
  # Configure the splat of arguments
  $splat = @{
    path = $log_file
    value = $message
  }
  # If the log fiole exists, append information, if not create it
  if (Test-Path -Path $log_file) {
    Add-Content @splat
  } else {
    Set-Content @splat
  }
  # Output the information to the screen as well
  Write-Output $message
}
# Define an array to hold all the errors
$param_errors = @()
# Ensure that the path to the hart file exists
if (!(Test-Path -Path $path)) {
  $param_errors += "Specified path does not exist: {0}" -f $path
}
# Check that the origin has been set
if ([String]::IsNullOrEmpty($origin)) {
  $param_errors += "A Habitat origin must be specified. Use -origin to set"
}
# Ensure that the keys paths exists
if (!(Test-Path -Path $keys_path)) {
  $param_errors += "The Habitat keys path does not exist: {0}" -f $keys_path
}
# Write out a message and exit if there are param errors
if ($param_errors.Length -gt 0) {
  Write-Log -message ($param_errors -join "`n") -log_file $log_file
} else {
  # Determine if an existing hab-launch process already exists
  # This is not very clean as it destorys the hab-luanch process, however
  # the `hab sup term` does not work
  $process = Get-Process -Name "hab-launch"
  if (![String]::IsNullOrEmpty($process)) {
    Write-Log -Mesage "Stopping old hab process" -log_file $log_file
    Stop-Process $process
  }
  # Habitat will start if there is an existing lock file
  # Delete this file if it exists
  $lock_path = "C:\hab\sup\default\LOCK"
  if (Test-Path -Path $lock_path) {
    Write-Log -message  $("Removing existing lock file: {0}" -f $lock_path)  -log_file $log_file
  }
  Write-Log -message  "Setting environment variables" -log_file $log_file
  # Set the necessary environment variables for the supervisor
  $env:HAB_ORIGIN = $origin
  $env:HAB_CACHE_KEY_PATH = $keys_path
  # Move into the result directory
  pushd $path
  # Source the results file
  Write-Log -message $("Sourcing results file: {0}" -f $path)  log_file $log_file
  . .\last_build.ps1
  # Start the supervsisor with the HART file
  Write-Log -message "Starting Hab supervisor"  -log_file $log_file
  hab sup run $pkg_artifact >> $log_file
  popd
}

