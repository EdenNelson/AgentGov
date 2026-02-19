# Sample PowerShell script for testing PSScriptAnalyzer integration
# This script follows AgentGov PowerShell standards

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$Path = "."
)

function Get-FileInformation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )
    
    Write-Verbose -Message "Processing file: $FilePath"
    
    if (Test-Path -Path $FilePath) {
        $fileInfo = Get-Item -Path $FilePath
        Write-Verbose -Message "File size: $($fileInfo.Length) bytes"
        return $fileInfo
    }
    else {
        Write-Warning -Message "File not found: $FilePath"
        return $null
    }
}

# Main execution
Write-Verbose -Message "Starting file analysis..."

$targetPath = Join-Path -Path $Path -ChildPath "README.md"
$result = Get-FileInformation -FilePath $targetPath

if ($null -ne $result) {
    Write-Verbose -Message "Analysis complete"
    exit 0
}
else {
    Write-Error -Message "Analysis failed"
    exit 1
}
