$ErrorActionPreference = [Management.Automation.ActionPreference]::Stop
Set-StrictMode -Version Latest

function Get-RemoteFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Uri,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $OutFile,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Sha512
    )

    Invoke-WebRequest -UserAgent wget -Uri $Uri -OutFile $OutFile
    Unblock-File $OutFile
    if ((Get-FileHash -Algorithm SHA512 $OutFile).Hash -ine $Sha512) {
        throw [Exception]::new("${OutFile}: incorrect SHA512")
    }
}

function Invoke-CheckExitCode {
    # [CmdletBinding()] and [Parameter()] are omitted to make sure
    # "-i" is not interpreted as "-InformationAction" etc.
    $command, $arguments = $args
    # Scope $ErrorActionPreference change.
    & {
        # PowerShell throws on any stderr output if $ErrorActionPreference is set.
        $ErrorActionPreference = [Management.Automation.ActionPreference]::Continue
        & $command $arguments
    }
    if ($LASTEXITCODE) {
        throw [Exception]::new("$command exited with code $LASTEXITCODE")
    }
}

function Invoke-MsBuild {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $CsprojPath,

        [string] $ReferencePath
    )

    $props = (
        '/p:Configuration=Release', '/p:Platform=AnyCPU', '/p:TargetFrameworkVersion=4.8',
        '/p:DebugType=None', '/p:DebugSymbols=False', '/p:DefineConstants='
    )
    if ($ReferencePath) {
        $props += "/p:ReferencePath=$(Resolve-Path $ReferencePath)"
    }
    Invoke-CheckExitCode MSBuild.exe $CsprojPath /m /t:Rebuild @props
}
