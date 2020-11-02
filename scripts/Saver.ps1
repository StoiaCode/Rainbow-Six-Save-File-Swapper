param (
[Parameter(Mandatory=$false)][switch]$skinned
)

if ($skinned) {
    $selectFile = "skins"
} else {
    $selectFile = "nackt"
}

$continue = read-host -Prompt "Das wird deinen momentanen save: $selectFile ersetzen.`n[Y] Yes`n[N] No`nFortfahren?"

if ($continue -like "Y") {
    $saveFilePath = Get-Content -Path .\scripts\settings.txt
    $saveFileName = "$saveFilePath\1.save"

    Copy-Item "$saveFileName" -Destination "$PSScriptRoot\saves\$selectFile.save"
    Write-Output "$selectFile wurde gespeichert."
} else {
    Write-Output "Nothing Changed."
}