function Read-CommitizenFriendlySummaries {
  [CmdletBinding()]
  param (
    # commit summary as obtained by git pretty-format '%s' specifier
    [Parameter(Mandatory, ValueFromPipeline)]
    [string[]]
    $summaries
  )

  # TODO ignore merge commits
  begin {
    # there's a non capturing group around the optional scope.
    $summaryRegex = "(?<type>.*?)(?:\((?<scope>.*)\))?: (?<description>.*)"

    $failedMatches = 0
    $successfulMatches = 0
  }

  process {
    foreach ($summary in $summaries) {
      if ($summary -match $summaryRegex) {
        $successfulMatches++

        return [PSCustomObject]@{
          Type        = $Matches["type"]
          Scope       = $Matches["scope"]
          Description = $Matches["description"]
        }
      }
      else {
        $failedMatches++
      }
    }
  }

  end {
    Write-Verbose "parsed correctly $successfulMatches commit messages."

    # FIXME this does not work as I expected
    if ($failedMatches) {
      Write-Error "could not match $failedMatches commit messages."
    }
  }
}
