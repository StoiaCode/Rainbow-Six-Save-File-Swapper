# Rainbow Six Save File Swapper
This script will help you in maintaining Two different Rainbow Six Save files. One with _your_ skins equipped, and one without any skinns equipped.

## How to use:
First you need to determine where your Rainbow Six Siege save File is. The path will look something like this: 
C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\savegames\\[*random*]\\[*random*]\
The easiest way to determine what folder is the correct one to start Rainbow, close it back down, and then look for a folder that has been edited at the time you closed the game. Inside that folder there *must* be a file called "1.save".  

Now Clone or Download the repository into a folder. 
Right Click the R6_SaveFileSwap.ps1 and press "Run with powershell".

If you havent run a .ps1 script before Windows may ask you for permission to run those:
![It may look like this: ](https://4sysops.com/wp-content/uploads/2013/10/PowerShell-Execution-Policy.png)If you see this screen, to execute the script you have to enter "Y" to continue. 

After that you will now be asked to input the Folder location of your save File. Input the folder we determind before.
Note: You do NOT input the FILE, you only input the FOLDER! You will not be able to open the folder that cotains the "1.save" from within the script!

After that you will be greeted by an Options Menu, prompting you to Save an Empty save file, Save an Equipped save File, restore an Empty save file or restore an Equipped save File. 
