<# 
Hey there!
This script is Created by EstoyMejor#8008 on Discord.
The script is shared under the GPLv3 License http://www.gnu.org/licenses/gpl-3.0.html

    Copyright (C) 2020 Marvin Rathge

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>. 

If you encounter any bugs, or have any ideas on how to improve this script hit me up at support@estoymejor.de
Version: 1.1
#>

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
$uploadFileName = "$saveFileName.upload"

Copy-Item "$PSScriptRoot\saves\$selectFile.save" -Destination $saveFileName
Copy-Item "$PSScriptRoot\saves\$selectFile.save" -Destination $uploadFileName

$saveFile = (Get-Item $saveFileName)
$uploadFile = (Get-Item $uploadFileName)

$saveFile.creationtime=$(Get-Date); $saveFile.lastwritetime=$(Get-Date)
$uploadFile.creationtime=$(Get-Date); $uploadFile.lastwritetime=$(Get-Date)

Write-Output "Save Switched. $selectFile is now Active. "