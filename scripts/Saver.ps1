param (
[Parameter(Mandatory=$false)][switch]$skinned
)

if ($skinned) {
    $selectFile = "equipped"
} else {
    $selectFile = "empty"
}

$saveFilePath = Get-Content -Path .\scripts\settings.txt
$saveFileName = "$saveFilePath\1.save"
$continue = "Y"

if (Test-Path "$PSScriptRoot\saves\$selectFile.save" -PathType Leaf) {
    $continue = read-host -Prompt "This will replace the current save: $selectFile.`n[Y] Yes`n[N] No`nContinue?"
}

if ($continue -like "Y") {
    Copy-Item "$saveFileName" -Destination "$PSScriptRoot\saves\$selectFile.save"
    Write-Output "$selectFile was saved."
} else {
    Write-Output "Nothing Changed."
}