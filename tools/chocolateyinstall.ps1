$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$moduleName = "kubectx"


if ($PSVersionTable.PSVersion.Major -lt 3) {
  throw "$moduleName) module requires a minimum of PowerShell v3."
}

Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue

$modulePath = Join-Path -Path $env:ProgramFiles -ChildPath "WindowsPowerShell\Modules\$moduleName"

if ($PSVersionTable.PSVersion.Major -ge 5) {
    $modulePath = Join-Path -Path $modulePath -ChildPath $env:ChocolateyPackageVersion
}

Write-Verbose "Creating destination directory '$modulePath' for module."
New-Item -Path $modulePath -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

Write-Verbose "Copying files to $modulePath"
Get-ChildItem -Path $toolsDir -Filter "*$moduleName*" | ForEach-Object{ Copy-Item $_.FullName $modulePath -Force }

if ($PSVersionTable.PSVersion.Major -lt 4) {
  $modulePaths = $($env:PSModulePath -split ";")
  if ($modulePaths -notcontains $modulePath) {
    $modulePaths += $modulePath
    [Environment]::SetEnvironmentVariable('PSModulePath', $($modulePath -join ";"), 'Machine')
    $env:PSModulePath += ";$modulePath"
  }
}