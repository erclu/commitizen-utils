function Write-CommitSummaries {
  [CmdletBinding()]
  [OutputType([string[]])]
  param (
    # Root folder of a repository
    [Parameter(ValueFromPipeline)]
    [System.IO.DirectoryInfo]
    $repoRoot = (Get-Item ".")
  )

  begin {
  }

  process {
    $gitDir = Get-ChildItem -Directory -Force -LiteralPath $repoRoot -Filter ".git"

    git.exe --git-dir $gitDir log --all --format="%s"
  }

  end {
  }
}
