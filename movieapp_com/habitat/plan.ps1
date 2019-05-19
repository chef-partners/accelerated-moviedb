$pkg_name="movieapp_com"
$pkg_origin="EAS"
$pkg_version="master"
$pkg_maintainer="Package Author <author@mycompany.org>"
$pkg_deps=@("core/dsc-core", "core/dotnet-35sp1-runtime", "core/iis-webserverrole")

function Invoke-Build {
  Copy-Item "$PLAN_CONTEXT/../publish/" -Destination "$HAB_CACHE_SRC_PATH/${pkg_name}-${pkg_version}" -Recurse
}

function Invoke-Install {
  Copy-Item $HAB_CACHE_SRC_PATH/${pkg_name}-${pkg_version}/ $pkg_prefix -Recurse
}