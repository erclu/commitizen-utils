function Read-GitLog {
  [CmdletBinding()]
  [OutputType('PSConventionalCommitsUtils.Automation.Object.ConventionalCommitSummary')]
  param (
    # Root folder of a repository
    [Parameter(Position = 0, ValueFromPipeline)]
    [System.IO.DirectoryInfo]
    $repoRoot = (Get-Item "."),
    # Range of refs to print log of
    [Parameter(Position = 1)]
    [string]
    $RefsRange,
    # Root directory for the document
    [Parameter(Position = 2)]
    [System.IO.FileInfo]
    $FilterLocation,
    # Max log items to get
    [Parameter()]
    [int]
    $MaxCount
  )

  begin {
    if ($MaxCount) {
      throw "NOT IMPLEMENTED"
    }

    if (-not (Test-Path -LiteralPath "$repoRoot/.git" )) {
      throw "Not a valid git repository"
    }

    $gitDir = Get-Item -Force "$repoRoot/.git"

    $separator = "|||"
    $escapedSeparator = [regex]::Escape($separator)

    $placeholders = @{
      authorNameWithMailmap = "%aN"
      date                  = "%ad"
      timestamp             = "%at"
      summary               = "%s"
    }

    $format = @(
      $placeholders.authorNameWithMailmap
      $placeholders.date
      $placeholders.summary
    ) -join $separator
  }

  process {
    $gitLogArgs = @(
      "--git-dir"
      "$gitDir"
      "log"
      "--oneline"
      "--use-mailmap"
      "--all"
      # or branches + pattern?
      # "--branches"
      "--date=short"
      "--format=$format"
      if ($RefsRange) {
        $RefsRange
      }
      if ($FilterLocation) {
        "--"
        # FIXME does not work when invoked from outside repo
        "$FilterLocation"
      }
    )

    git @gitLogArgs | ForEach-Object {
      $rawOut = $_ -split $escapedSeparator
      $summary = $rawOut[2] | Read-CommitizenFriendlySummaries

      [PSCustomObject]@{
        PSTypeName  = "ConventionalCommitSummary"
        Author      = $rawOut[0]
        Date        = $rawOut[1]
        Type        = $summary.Type
        Scope       = $summary.Scope
        Description = $summary.Description
      }
    }

    ## EXAMPLE GROUPING
    # Read-GitLog |
    #   Group-Object Date, Author |
    #   Sort-Object Date, Author -Descending |
    #   Format-Table -AutoSize -Wrap
  }

  end {
  }
}
