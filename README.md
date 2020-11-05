# Rainbow Six Save File Swapper
This script will help you in maintaining Two different Rainbow Six Save files. One with _your_ skins equipped, and one without any skinns equipped.

## How to use:
First you need to determine where your Rainbow Six Siege save File is. The path will look something like this: 
C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\savegames\\[*random*]\\[*random*]\
The easiest way to determine what folder is the correct one is to start Rainbow, close it back down, and then look for a folder that has been edited at the time you closed the game. Inside that folder there *must* be a file called "1.save".  

Now Clone or Download the repository into a folder. 
Right Click the R6_SaveFileSwap.ps1 and press "Run with powershell".

If you havent run a .ps1 script before Windows may ask you for permission to run those:
![It may look like this: ](https://4sysops.com/wp-content/uploads/2013/10/PowerShell-Execution-Policy.png)If you see this screen, to execute the script you have to enter "Y" to continue. 

After that you will now be asked to input the Folder location of your save File. Input the folder we determind before.
Note: You do NOT input the FILE, you only input the **FOLDER**! You will not be able to open the folder that cotains the "1.save" from within the script!

After that you will be greeted by an Options Menu, prompting you to Save an Empty save file, Save an Equipped save File, restore an Empty save file or restore an Equipped save File. 

After Swapping the Save file, the next time you start the game it will prompt you if you want to use the Cloud Save or the Local Save. You have to select "Local Save" here! 

## Note:
This Script **_will not_** create any save files for you, or give you any skins you did not previously have! You will have to manually unequip all skins, then close Rainbow, run the Script and save the Empty skin file. Same for the Equipped save file.
Its also adviced to not use this script with save files Inbetween patches. Should a new patch come out, _especially new Seasons_, please manually renew your save files. 


### Contact: 
If you have any Bugreports, Ideas or anything else really feel free to text me either on discord: EstoyMejor#8008 or send me an email to [support@estoymejor.de](mailto:support@estoymejor.de)
