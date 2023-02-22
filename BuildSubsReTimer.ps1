[CmdletBinding()]
$ErrorActionPreference = [Management.Automation.ActionPreference]::Stop
Set-StrictMode -Version Latest

Import-Module $PSScriptRoot\Utils.psm1

Invoke-CheckExitCode git.exe clone --depth=1 https://github.com/siemens/sourcegrid.git
Invoke-MsBuild $PSScriptRoot\sourcegrid\Src\SourceGrid.csproj


$uri = 'https://sourceforge.net/projects/subs2srs/files/subs2srs_source_code/subs2srs_v27.0/subs2srs_v27.0_Source_Code.7z/download'
$subsReTimerSrc = "$PSScriptRoot\subs2srs_v27.0_Source_Code.7z"
$sha512 = '1a7e1c9b8d153dab91a5eed075fec370f9b2380043f9f06f4df3af3337a11eb68aae2f81837a48e2aed894717b0b30e01d48bb60542d53e162202c4ea47de7a5'

Get-RemoteFile $uri $subsReTimerSrc $sha512
Invoke-CheckExitCode `
    7z.exe x $subsReTimerSrc "-o$PSScriptRoot\tmp" '-ir!subs2srs\SubsReTimer\SubsReTimer\*'
Move-Item $PSScriptRoot\tmp\subs2srs\SubsReTimer\SubsReTimer $PSScriptRoot\
Remove-Item -Recurse $PSScriptRoot\tmp

Copy-Item $PSScriptRoot\patches\SubsReTimer.manifest $PSScriptRoot\SubsReTimer
Invoke-CheckExitCode git.exe apply --verbose --ignore-whitespace `
                             $PSScriptRoot\patches\SubsReTimer.csproj.patch

Invoke-MsBuild -CsprojPath $PSScriptRoot\SubsReTimer\SubsReTimer.csproj `
               -ReferencePath $PSScriptRoot\sourcegrid\Out\Win32\msvs2013_NET35\Release\
