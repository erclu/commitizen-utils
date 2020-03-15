# TODO add tests

# # Load SuT
# $here = Split-Path -Parent $MyInvocation.MyCommand.Path
# $sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.ps1'

Describe "Conventional Commits Utilities" {

  It "always fails" {
    $true | Should -Be $false
  }
}
