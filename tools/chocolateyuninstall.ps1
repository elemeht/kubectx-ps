try {
  $modulePath = Join-Path -Path $env:ProgramFiles -ChildPath "WindowsPowerShell\Modules"
  $targetDir = Join-Path -Path $modulePath -ChildPath Kubectx
  
  Remove-Item -Path $targetDir -Recurse

} catch {
  Write-Verbose "kubectx uninstall error details: $($_ | Format-List * -Force | Out-String)"
}