<# 
Hey there!
This script is Created by EstoyMejor#8008 on Discord.
The script is shared under the GPLv3 License http://www.gnu.org/licenses/gpl-3.0.html

    Copyright (C) 2021 Marvin Rathge

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
#>

$Version = 2.5

# Create saves Folder
if (!(Test-Path "$PSScriptRoot\data" -PathType Container)) {
    New-Item -ItemType Directory -Force -Path "$PSScriptRoot\data" | Out-Null
}

if (!(Test-Path "$PSScriptRoot\data\saves" -PathType Container)) {
    New-Item -ItemType Directory -Force -Path "$PSScriptRoot\data\saves" | Out-Null
}

# Open the Menu
function Open-Menu{

    # Options Menu
    do {
        $modus = Read-Host -Prompt "[1] Save Equipped`n[2] Save Empty`n[3] Load Equipped`n[4] Load Empty`n[0] Settings`nModus"
        $conditionMenu = ($modus -like 1 -or $modus -like 2 -or $modus -like 3 -or $modus -like 4 -or $modus -like 0)
        if (!$conditionMenu) {
            Write-Output "Please use a valid option!`n"
        }
    } until ($conditionMenu)

    # Work all options.
    switch ($modus) {                        
        1 { save-Saver -skinned }     # Save Skinned                   
        2 { save-Saver }              # Save Empty         
        3 { save-Swapper -skinned }   # Swap to Skinned
        4 { save-Swapper }            # Swap to Empty
        0 { Open-Settings }           # Settings                     
        Default { Write-Output "Error. Pls Dont do this. How did you do this? WTF?"; read-host "Press ENTER to exit..."; exit }  # Should NEVER TRIGGER.                       
    }
}

# Open the Settings Menu
function Open-Settings {

    # Settings Menu
    do {
        $settingsModus = Read-Host -Prompt "[1] Factory Reset`n[2] Backup`n[3] Restore`n[4] Show License`n[0] Back`nModus"
        $conditionSettings = ($settingsModus -like 1 -or $settingsModus -like 2 -or $settingsModus -like 3 -or $settingsModus -like 4 -or $settingsModus -like 0)
        if (!$conditionSettings) {
            Write-Output "Please use a valid option!`n"
        }
    } until ($conditionSettings)
   
    # Work all Settings.
    switch ($settingsModus) {
        # Factory Reset
        1 { FactoryReset }   # Factory Reset
        2 { New-Backup }     # Backup Creating
        3 { Restore-Backup } # Restore
        4 { Get-License; Open-Menu }    # Show License
        0 { Open-Menu }      # Back
        Default { Write-Output "Error. Pls Dont do this. How did you do this? WTF?"; read-host "Press ENTER to exit..."; exit } # Should NEVER TRIGGER.
    }
}

function FactoryReset ([switch]$backupReturn) {

    # Checking if we are just returning from a Backup, if we are we skip this question. 
    if (!$backupReturn) {
        $backup = read-host -Prompt "Do you want to create a Backup before?`n[Y] Yes`n[N] No`nCreate Backup?";

        if ($backup -like "Y") {
            New-Backup -inReset
        }
    }

    $continue = read-host -Prompt "This will delete EVERYTHING!`n[Y] Yes`n[N] No`nContinue?";

    if ($continue -like "Y") {
        Remove-Item "$PSScriptRoot\data\settings.txt" -erroraction 'silentlycontinue'
        Remove-Item "$PSScriptRoot\data\settings_old.txt" -erroraction 'silentlycontinue'
        Remove-Item "$PSScriptRoot\data\saves\empty.save" -erroraction 'silentlycontinue'
        Remove-Item "$PSScriptRoot\data\saves\equipped.save" -erroraction 'silentlycontinue'
        Remove-Item "$PSScriptRoot\data\saves\empty_old.save" -erroraction 'silentlycontinue'
        Remove-Item "$PSScriptRoot\data\saves\equipped_old.save" -erroraction 'silentlycontinue'
    }
    read-host "On ENTER the script will restart..."
    Invoke-Expression -Command ($PSCommandPath)
    exit
}

function Get-License {
    Read-Host "`nThe script is shared under the GPLv3 License http://www.gnu.org/licenses/gpl-3.0.html

    Copyright (C) 2021 Marvin Rathge

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
    `nPress Enter to continue"
    return
}

# Create New Backup or Update the old One
function New-Backup ([switch]$inReset) {

    $compress = @{
        Path             = "$PSScriptRoot\data\settings.txt", "$PSScriptRoot\data\saves\"
        CompressionLevel = "NoCompression"
        DestinationPath  = "$PSScriptRoot\Backup.zip"
    }

    # Check if Backup exists.
    if (Test-Path "$PSScriptRoot\Backup.Zip" -PathType leaf) {
        $continue = read-host -Prompt "This will replace your active backup!`n[Y] Yes`n[N] No`nContinue?"
    }

    # If not, create one.
    else {
        Compress-Archive @compress
    }
            
    # If yes, update it!
    if ($continue -like "Y") {
        Compress-Archive @compress -Update
    }

    # Checking if we are called during a Factory reset, if we are we go back to the Factory reset, skipping the Backup step this time. 
    if ($inReset) {
        FactoryReset -backupReturn
    }

    Open-Menu
}

# Restore a Backup if it exists!
function Restore-Backup ([switch]$firstStart) {
    # Check if Backup Exist, ask for Confirm.
    if (Test-Path "$PSScriptRoot\Backup.Zip" -PathType leaf) {
        $continue = read-host -Prompt "This will import a Backup, should you have any userfiles they will be renamed to <name>_old!`n[Y] Yes`n[N] No`nContinue?"
        if ($continue -like "Y") {
            Rename-Item "$PSScriptRoot\data\settings.txt" -NewName "settings_old.txt" -Force -erroraction 'silentlycontinue'
            Rename-Item "$PSScriptRoot\data\saves\empty.save" -NewName "empty_old.save" -Force -erroraction 'silentlycontinue'
            Rename-Item "$PSScriptRoot\data\saves\equipped.save" -NewName "equipped_old.save" -Force -erroraction 'silentlycontinue'
            Expand-Archive -Path "$PSScriptRoot\Backup.Zip" -DestinationPath "$PSScriptRoot\data\" -Force
        }
    }
    # Do nothing if no backup was found.
    else {
        Write-Output "No Backup found."
        read-host "Press ENTER to exit..."
        exit
    }

    if ($firstStart) {
        return $continue
    } else {
        Invoke-Expression -Command ($PSCommandPath)
        exit
    }
}

# Function to save our Save game
function save-Saver ([switch]$skinned) {
    if ($skinned) {
        $selectFile = "equipped"
    }
    else {
        $selectFile = "empty"
    }
    
    $saveFileName = "$folderSave\1.save"
    $continue = "Y"
    
    if (Test-Path "$PSScriptRoot\saves\$selectFile.save" -PathType Leaf) {
        $continue = read-host -Prompt "This will replace the current save: $selectFile.`n[Y] Yes`n[N] No`nContinue?"
    }
    
    if ($continue -like "Y") {
        Copy-Item "$saveFileName" -Destination "$PSScriptRoot\data\saves\$selectFile.save"
        Write-Output "$selectFile was saved.`n"
    }
    else {
        Write-Output "Nothing Changed.`n"
    }

    Open-Menu
}

# Function to swap our Save File
function save-Swapper ([switch]$skinned) {
    if ($skinned) {
        $selectFile = "equipped"
    }
    else {
        $selectFile = "empty"
    }
    
    $saveFileName = "$folderSave\1.save"
    $uploadFileName = "$saveFileName.upload"
    
    Copy-Item "$PSScriptRoot\data\saves\$selectFile.save" -Destination $saveFileName
    Copy-Item "$PSScriptRoot\data\saves\$selectFile.save" -Destination $uploadFileName
    
    $saveFile = (Get-Item $saveFileName)
    $uploadFile = (Get-Item $uploadFileName)
    
    $saveFile.creationtime = $(Get-Date); $saveFile.lastwritetime = $(Get-Date)
    $uploadFile.creationtime = $(Get-Date); $uploadFile.lastwritetime = $(Get-Date)
    
    Write-Output "Save Switched. $selectFile is now Active."
    read-host "Dont forget to use the LOCAL SAVE next time you start the game!`n"

    Open-Menu
}

function Select-Folder {
    Write-Output "Select save File folder`n"
    Write-Output "Usually it looks something like this:"
    Write-Output "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\savegames\cab1dbc6-ff8f-4071-80fa-be72c91ff7f3\635\1.save"
    Write-Output "The numbers can be any random combination, but the file inside always looks like this: 1.save"
    Write-Output "We only select the FOLDER. You will NOT be able to select the file itself!"
    read-host "Press ENTER to continue..."

    $FileBrowser.ShowDialog()
    $folderSave = $FileBrowser.SelectedPath

    # Check if the Folder is right.
    If (Test-Path "$folderSave\1.save" -PathType leaf) {
        Write-Output "File found, well done!`n"
    }
    else {
        Write-Output "You didnt select the right folder! Wubbel! Script now implodes!"
        read-host "Press ENTER to exit..."
        exit
    }

    # Save folder path for later.
    Set-Content -Path "$PSScriptRoot\data\settings.txt" -Value $folderSave

    # Restarting the Script, because Powershell is stupid else and forgets the correct value for $folderSave
    Invoke-Expression -Command ($PSCommandPath)
    exit
}

# Check if we already have a folder selected, and load it.
if (Test-Path "$PSScriptRoot\data\settings.txt" -PathType leaf) {
    $folderSave = Get-Content -Path "$PSScriptRoot\data\settings.txt" -TotalCount 1
    $savedFiles = Get-ChildItem -Path "$PSScriptRoot\data\saves\" -Name
    Write-Output  "Currently available saves:" $savedFiles `n
}

# If not, ask for the Folder or import a Backup.
Else {
    # File Browser Dialog stuffs
    Add-Type -AssemblyName System.Windows.Forms
    $FileBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $FileBrowser.SelectedPath = "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\savegames\"
    $FileBrowser.Description = "Select save File folder.`nWe only select the FOLDER. You will NOT be able to select the file itself!"

    # Check for backup and import if available and wanted.
    if (Test-Path "$PSScriptRoot\Backup.zip" -PathType leaf) {
        $continueReturn = Restore-Backup -firstStart
        if (!($continueReturn -like "Y")) {
            Rename-Item "$PSScriptRoot\Backup.zip" -NewName "Backup_old.zip" -Force -erroraction 'silentlycontinue'
            read-host "Backup renamed to <Backup_old>, ENTER to continue"
            Select-Folder
        }
    }
    # If no Backup is available, ask the User for the folder. 
    else {
        Get-License
        Select-Folder
    }
}

function Update-Script {
    $checkVersion = "https://api.github.com/repos/EstoyMejor/Rainbow-Six-Save-File-Swapper/releases/latest"

    $HREF = Invoke-WebRequest -UseBasicParsing -Uri $checkVersion
    $content = $HREF.Content
    $versionzipballLink = $content.Substring($content.IndexOf("zipball_url") + 14,81)
    $versionName = $content.Substring($content.IndexOf("tag_name") + 11,3)
    $regex = 'https:\/\/api\.github\.com\/repos\/EstoyMejor\/Rainbow-Six-Save-File-Swapper\/zipball\/[0-9]+\.[0-9]+(\.[0-9])*'
    $validLink = $false

    if ($versionzipballLink -match $regex -and $versionName -notmatch $Version) {
        $validLink = $true
        Write-Output "New version found!"
    }
    
    if ($validLink) {
        if (Test-Path "$PSScriptRoot\R6_SaveFileSwap.ps1" -PathType Leaf) {
            Rename-Item -Path "$PSScriptRoot\R6_SaveFileSwap.ps1" -NewName "R6_SaveFileSwap_$Version.ps1" -Force
            Write-Output "Renamed currently running version.`nFile name is R6_SaveFileSwap_$Version.ps1, feel free to delete at your digression. "
        }

        Write-Output "Downloading update..."
        Invoke-WebRequest -Uri $versionzipballLink -OutFile "$PSScriptRoot\update.zip"
        Expand-Archive -Path "$PSScriptRoot\update.zip" -DestinationPath "$PSScriptRoot" -Force
        Remove-Item -Path "$PSScriptRoot\update.zip"
        $GetUpdatePathFile = Get-ChildItem $PSScriptRoot -Filter R6_SaveFileSwap.ps1 -Recurse | ForEach-Object { $_.FullName }
        $GetUpdatePathFolder = $GetUpdatePathFile -replace "\\R6_SaveFileSwap.ps1"
        Move-Item -Path $GetUpdatePathFile -Destination $PSScriptRoot
        Remove-Item -Path $GetUpdatePathFolder -Recurse
        Read-Host "Done.`n`nPress enter to exit. Restart the script Manually please"
        exit
    } else {
        Write-Output "No new version found, or error on fetching new Version.`nIf you want to make sure, check the repo manually:`nhttps://github.com/EstoyMejor/Rainbow-Six-Save-File-Swapper/releases/latest"
    }
}

# Open the Menu
Update-Script
Open-Menu