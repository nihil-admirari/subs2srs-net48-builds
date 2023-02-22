[CmdletBinding()]
$ErrorActionPreference = [Management.Automation.ActionPreference]::Stop
Set-StrictMode -Version Latest

Import-Module $PSScriptRoot\Utils.psm1

$uri = 'https://sourceforge.net/projects/subs2srs/files/subs2srs/subs2srs_v29.7/subs2srs_v29.7.zip/download'
$subs2SrsDistr = "$PSScriptRoot\subs2srs_v29.7.zip"
$sha512 = '50a7348940d08102b44622c1f8e2519f38102cee76efea5a92d769599a47c5eb87e7fd0823a546841f5ff2351b2b0d85742f3a934740602bef91b1675630a097'

Get-RemoteFile $uri $subs2SrsDistr $sha512
Expand-Archive $subs2SrsDistr

Push-Location $PSScriptRoot\subs2srs_v29.7\subs2srs
try {
    Remove-Item taglib-sharp.dll
    'ffmpeg', 'mkvtoolnix', 'mp3gain' | % {
        Remove-Item ".\Utils\$_\*.exe", ".\Utils\$_\*.txt"
    }
    Rename-Item .\Utils\taglib-sharp TagLibSharp

    'subs2srs.exe', 'TagLibSharp.dll' | % {
        Copy-Item -Force $PSScriptRoot\subs2srs\bin\Release\$_ .\
    }

    'SubsReTimer.exe', 'SourceGrid.dll' | % {
        Copy-Item -Force $PSScriptRoot\SubsReTimer\bin\Release\$_ .\Utils\SubsReTimer\
    }
} finally {
    Pop-Location
}

New-Item -ItemType Directory $PSScriptRoot\artefacts
$artefact = "$PSScriptRoot\artefacts\subs2srs_v29.7.zip"
Compress-Archive $PSScriptRoot\subs2srs_v29.7\subs2srs $artefact
"$((Get-FileHash -Algorithm SHA512 $artefact).Hash)  $(Split-Path -Leaf $artefact)" `
    | Out-File -Encoding ascii -NoNewline $PSScriptRoot\artefacts\SHA2-512SUMS
