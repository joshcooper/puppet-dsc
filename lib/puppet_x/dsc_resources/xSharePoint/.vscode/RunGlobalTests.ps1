Import-Module (Join-Path $PSScriptRoot "..\Tests\xSharePoint.TestHarness.psm1")

$DscTestsPath = Join-Path $PSScriptRoot "..\Modules\xSharePoint\DscResource.Tests"
if ((Test-Path $DscTestsPath) -eq $false) {
    throw "Unable to locate DscResource.Tests repo at '$DscTestsPath', common DSC resource tests will not be executed"
}
Import-Module (Join-Path $PSScriptRoot "..\Modules\xSharePoint\DscResource.Tests\TestHelper.psm1")

cd (Join-Path $PSScriptRoot "..\Modules\xSharePoint\DscResource.Tests")
Invoke-Pester 
