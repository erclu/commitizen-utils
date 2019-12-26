#Get public and private function definition files.
$Files = @{
  Classes = @( Get-ChildItem -Recurse -Path $PSScriptRoot\Classes\*.ps1 -ErrorAction SilentlyContinue )
  Private = @( Get-ChildItem -Recurse -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
  Public  = @( Get-ChildItem -Recurse -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
}

foreach ($classFile in $Files.Classes)
{
  try
  {
    . $classFile
  }
  catch
  {
    Write-Error -Message "failed to import class $($classFile.FullName): $_"
  }
}

Foreach ($import in @($Files.Public + $Files.Private))
{
  Try
  {
    . $import.FullName
  }
  Catch
  {
    Write-Error -Message "Failed to import function $($import.FullName): $_"
  }
}

Export-ModuleMember -Function $Files.Public.Basename
