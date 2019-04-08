try {
  $modulePath = Join-Path -Path $env:ProgramFiles -ChildPath "WindowsPowerShell\Modules"
  $targetDir = Join-Path -Path $modulePath -ChildPath Kubectx
  $toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  $psModuleFile = Join-Path $toolsDir "kubectx.psm1"
  New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
  Copy-Item $psModuleFile $targetDir -Force

  $modulePaths = $($env:PSModulePath -split ";")
  if ($modulePaths -notcontains $modulePath) {
    $modulePaths += $modulePath
    [Environment]::SetEnvironmentVariable('PSModulePath', $($modulePath -join ";"), 'Machine')
    $env:PSModulePath += ";$modulePath"
  }
} catch {
  Write-Verbose "kubectx install error details: $($_ | Format-List * -Force | Out-String)"
}
