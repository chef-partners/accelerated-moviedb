# Rebuild the habitat package
if (Test-Path -Path ".\habitat")
{
  # Build package
  hab pkg build habitat

  # Move into the results dir and install and run the package
  pushd results
  . .\last_build.ps1
  hab pkg install $pkg_artifact
  hab svc load $pkg_ident
  popd

} else {
  Write-Output "Unable to find habitat directory"
}
