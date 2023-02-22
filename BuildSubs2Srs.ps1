[CmdletBinding()]
$ErrorActionPreference = [Management.Automation.ActionPreference]::Stop
Set-StrictMode -Version Latest

Import-Module $PSScriptRoot\Utils.psm1

$uri = 'https://sourceforge.net/projects/subs2srs/files/subs2srs_source_code/subs2srs_v29.7/subs2srs_v29.7_source_code.7z/download'
$subs2SrsSrc = "$PSScriptRoot\subs2srs_v29.7_source_code.7z"
$sha512 = 'c5345176d98ae2c5a1a2070ca15f7820df290bef33da5f338ad410267c57798a77ee42502e5632d62a6b02616e3f153d875c6a7aa4f250245a8a7d660c296ab4'

Get-RemoteFile $uri $subs2SrsSrc $sha512
Invoke-CheckExitCode 7z.exe x $subs2SrsSrc "-o$PSScriptRoot\tmp" '-ir!subs2srs\subs2srs\*'
Move-Item $PSScriptRoot\tmp\subs2srs\subs2srs $PSScriptRoot\
Remove-Item -Recurse $PSScriptRoot\tmp

Copy-Item $PSScriptRoot\patches\subs2srs.manifest $PSScriptRoot\subs2srs\
Invoke-CheckExitCode git.exe apply --verbose --ignore-whitespace `
                             $PSScriptRoot\patches\subs2srs.csproj.patch

Install-Package -Force TagLibSharp -Destination $PSScriptRoot\TagLibSharp
Invoke-MsBuild -CsprojPath $PSScriptRoot\subs2srs\subs2srs.csproj `
               -ReferencePath $PSScriptRoot\TagLibSharp\*\lib\net4*\
