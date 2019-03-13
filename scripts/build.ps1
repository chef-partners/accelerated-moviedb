# Write out the keys to the filesystem for the current user
$keys_path = "{0}\.hab\cache\keys" -f $env:USERPROFILE
if (!(Test-Path -Path $keys_path)) {
   New-Item -Type Directory -Path $keys_path
}

$pub_key = "{0}\{1}-{2}.pub" -f $keys_path, $env:HAB_ORIGIN, $env:HAB_REVISION
$sign_key = "{0}\{1}-{2}.sig.key" -f $keys_path, $env:HAB_ORIGIN, $env:HAB_REVISION

# Convert base64 encoded strings back to text
$hab_pub_key_bytes = [System.Convert]::FromBase64String($env:PUB_KEY)
$hab_pub_key = [System.Text.Encoding]::UTF8.GetString($hab_pub_key_bytes)

$hab_sign_key_bytes = [System.Convert]::FromBase64String($env:SIGNING_KEY)
$hab_sign_key = [System.Text.Encoding]::UTF8.GetString($hab_sign_key_bytes)

Set-Content -Path $pub_key -Value $hab_pub_key
Set-Content -Path $sign_key -Value $hab_sign_key

$env:HAB_CACHE_KEY_PATH = "{0}\.hab\cache\keys" -f $env:USERPROFILE

dir env:

# Build the habitat plan
hab pkg build habitat
