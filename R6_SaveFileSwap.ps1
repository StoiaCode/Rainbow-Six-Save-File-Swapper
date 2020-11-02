# Hey there!
# This script is Created by EstoyMejor#8008 on Discord. The script is shared under the GPLv3 License http://www.gnu.org/licenses/gpl-3.0.html
# So feel free to use this script to your liking.
# If you encounter any bugs, or have any ideas on how to improve this script hit me up at support@estoymejor.de
#
# Version: 1.0


if (Test-Path "$PSScriptRoot\scripts\settings.txt" -PathType leaf) {
    $folderSave = Get-Content -Path .\scripts\settings.txt
}
Else {

    Add-Type -AssemblyName System.Windows.Forms
    $FileBrowser = New-Object System.Windows.Forms.FolderBrowserDialog

    if (Test-Path "$PSScriptRoot\Backup.Zip" -PathType leaf) {
        do {
            $haveBackup = read-host -Prompt "`nYou appear to have a Backup, do you want to import that?`n[Y] Yes [N] No"
            if (!($haveBackup -like "Y" -or $haveBackup -like "N")) {
                Write-Output "Bitte gültige Option wählen!`n"
            }
        } until (($haveBackup -like "Y" -or $haveBackup -like "N"))
        if ($haveBackup -like "Y") {
            Expand-Archive -Path "$PSScriptRoot\Backup.Zip" -DestinationPath "$PSScriptRoot\scripts\"
        }
        else {
            Write-Output "Sorry, du musst das Backup.zip manuell löschen und den script neu starten!"
            read-host "Press ENTER to exit..."
            exit
        }
    }
    else {
        Write-Output "Save File ordner auswählen."
        Write-Output "Sieht normalerweise in etwa so aus: "
        Write-Output "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\savegames\cab1dbc6-ff8f-4071-80fa-be72c91ff7f3\635\1.save"
        Write-Output "Wobei die zahlen beliebig sein können. Ein R6 Save heißt jedoch immer 1.save"
        Write-Output "Angegeben wird hier jedoch nur der _ordner_ nicht die Datei direkt!"
        read-host "Press ENTER to continue..."

        $ShowDialog = $FileBrowser.ShowDialog()
        $folderSave = $FileBrowser.SelectedPath

        $bool = [string]::IsNullOrEmpty($folderSave)

        if ($bool) {
            Write-Output "Kein Ordner gewählt, Script implodiert! Wubbel!"
            read-host "Press ENTER to exit..."
            exit
        }

        Set-Content -Path .\scripts\settings.txt -Value $folderSave
    }
}
do {
    $modus = Read-Host -Prompt "[1] Speichere Ausgerüsteten Save`n[2] Speichere Leeren Save`n[3] Lade Ausgerüsteten Save`n[4] Lade Leeren Save`n[0] Settings`nModus"
    if (!($modus -like 1 -or $modus -like 2 -or $modus -like 3 -or $modus -like 4 -or $modus -like 0)) {
        Write-Output "Bitte gültige Option wählen!`n"
    }
} until (($modus -like 1 -or $modus -like 2 -or $modus -like 3 -or $modus -like 4 -or $modus -like 0))

switch ($modus)                         
    {                        
        1 {Invoke-Expression "&'$PSScriptRoot\scripts\Saver.ps1' -skinned"}                        
        2 {Invoke-Expression "&'$PSScriptRoot\scripts\Saver.ps1'"}                        
        3 {Invoke-Expression "&'$PSScriptRoot\scripts\SkinSwapper.ps1' -skinned"}
        4 {Invoke-Expression "&'$PSScriptRoot\scripts\SkinSwapper.ps1'"}#
        # Settings
        0 {
            # Ask for what Settings
            do {$settingsModus = Read-Host -Prompt "[1] Werkseinstellungen`n[2] Backup Speichern`n[3] Backup Laden`nModus"
                    if (!($settingsModus -like 1 -or $settingsModus -like 2 -or $settingsModus -like 3)) {
                    Write-Output "Bitte gültige Option wählen!`n"
                    }
            } until (($settingsModus -like 1 -or $settingsModus -like 2 -or $settingsModus -like 3))
            
            switch ($settingsModus)
                {   # Werkseinstellungen
                    1 { $continue = read-host -Prompt "Das wird alle saves löschen!`n[Y] Yes`n[N] No`nFortfahren?";
                        if ($continue -like "Y") {
                            Remove-Item "$PSScriptRoot\scripts\settings.txt"
                            Remove-Item "$PSScriptRoot\scripts\saves\nackt.save"
                            Remove-Item "$PSScriptRoot\scripts\saves\skins.save"
                        }
                        read-host "Press ENTER to exit..."
                        exit
                      }
                    # Backup Creating
                    2 {
                        # Check if Backup exists.
                        if (Test-Path "$PSScriptRoot\Backup.Zip" -PathType leaf) {
                            $continue = read-host -Prompt "Das wird dein momentanes Backup ersetzen!`n[Y] Yes`n[N] No`nFortfahren?"
                        }
                        # If none exists, just create one.
                        else {
                            $compress = @{
                                Path = "$PSScriptRoot\scripts\settings.txt", "$PSScriptRoot\scripts\saves\"
                                CompressionLevel = "NoCompression"
                                DestinationPath = "$PSScriptRoot\Backup.Zip"
                            }
                            Compress-Archive @compress
                        }
                        
                        # If one exists, then we update it!
                        if ($continue  -like "Y") {
                            Compress-Archive -Path "$PSScriptRoot\scripts\settings.txt", "$PSScriptRoot\scripts\saves\" -Update -DestinationPath "$PSScriptRoot\Backup.Zip"
                        }
                        read-host "Press ENTER to exit..."
                        exit
                      }
                    # Backup Einspielen
                    3 {
                        if (Test-Path "$PSScriptRoot\Backup.Zip" -PathType leaf) {
                            $continue = read-host -Prompt "Das wird alle saves ersetzen!`n[Y] Yes`n[N] No`nFortfahren?"
                            if ($continue -like "Y") {
                                Remove-Item "$PSScriptRoot\scripts\settings.txt"
                                Remove-Item "$PSScriptRoot\scripts\saves\nackt.save"
                                Remove-Item "$PSScriptRoot\scripts\saves\skins.save"
                                Expand-Archive -Path "$PSScriptRoot\Backup.Zip" -DestinationPath "$PSScriptRoot\scripts\"
                            }
                        }
                        else {
                            Write-Output "Kein Backup gefunden."
                        }
                        read-host "Press ENTER to exit..."
                        exit
                      }
                    Default {Write-Output "Error. Pls Dont do this. How did you do this? WTF?"; read-host "Press ENTER to exit..."; exit}
                }
            
            }                          
        Default {Write-Output "Error. Pls Dont do this. How did you do this? WTF?"; read-host "Press ENTER to exit..."; exit}                        
    }
read-host "Nicht vergessen beim spielstart lokaler save aus zu wählen!`nEnter to exit"