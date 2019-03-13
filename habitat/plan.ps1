$pkg_name="package"
$pkg_origin="MovieDB"
$pkg_version="master"
$pkg_maintainer="Hab Package Builder"
$pkg_source="package.zip"
$pkg_filename="${pkg_name}.zip"
$pkg_shasum="0c6c15b74d1b3b0b107bf8b874892be7ba72178d1eda9fa84a8e65337d6388a8"
$pkg_deps="core/dsc-core"

function Invoke-Download {
    Copy-Item "$PLAN_CONTEXT/$pkg_source" -Destination "$HAB_CACHE_SRC_PATH/$pkg_filename"
}

function Invoke-Install {
    Copy-Item $HAB_CACHE_SRC_PATH/${pkg_name}-${pkg_version}/ $pkg_prefix -Recurse
}