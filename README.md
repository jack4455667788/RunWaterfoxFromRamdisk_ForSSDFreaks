# RunWaterfoxFromRamdisk_ForSSDFreaks

For SSD Freaks that would rather shift burden to RAM for caching than waste SSD cycles.

PROBLEM:
* Using HWiNFO64 I monitored that waterfox was wasting ssd cycles like they ain't no thang (for me it was on the order of 10's of gig's a day/week, measure for yourself!)
* SSD cycles are finite, writing should be kept to an absolute minimum to prolong the lifetime of the device and for effecient reading/writing on some devices.

SCRIPT SOLUTION BENEFITS:
* Speed is improved! (Feels "snappier"; Ram is still faster than SSD!)
* Ram is now used for application data caching (like it is supposed to be...). No more wasted SSD writing for webcaching!

SCRIPT SOLUTION DETRIMENTS:
* If the machine goes down / power goes out while running in ramdisk mode, your browsing history as well as any extensions you might have configured or installed will be gone.
* It's slower than it ought to be on the first start, because I decided to make a copy of the profile directories on the SSD before taking any other steps.  The script could be a lot faster if you didn't mind that your profile might be completely gone if the computer crahses / power dies. The script could also be better written to only backup the profile fully on some sort of periodic basis.
* The script doesn't have much error handling, and a few nagging "press here" messages that might not be necessary by default.
* This script can and has totally F*ed my profile up.  I think this version is good but who knows... backup everything first!!!
* I cannot find any arguments to pass to waterfox.exe when starting it from the command line that won't circumvent the update process.  Not only will it not circumvent the update process, it won't even do you the courtesy of displaying the "do you want to update" dialog box, and will just go ahead and do it all behind your back without consent :( . I changed updater.exe to a dummy file and took away all priveleges to it, but some may find this extreme and insecure.
* Still some manual steps you have to perform, not everything has been put into the unified script...
* Crummy dos window is present at all times, and requires finicky case-sensitive command-line usage...
* DOS Bat seems fundamentally shit for this purpose.  It acts wonky.  Especially when I depend on for loops to populate variables with the output from executables within if blocks, such as when I check to see if a folder is a symlink or not... (or god forbid put a commented line as the last line in an if block which is forbidden without any intelligible error message) DOWN WITH BAT!

MANUAL THINGS (Things you need to take care of, the script doesn't do it automatically):

1. Configure waterfox to not waste so much memory on caching in about:config ( you need to make sure it does not exceed the ramdisk size you provision, by default in the script it is 512mb, but could be much smaller or larger depending on your configurations).
2. OPT - Disable the jump list item for waterfox, so it isn't hammering your ssd on the jump list anymore (this is also a security issue, in that the recent temp files written and deleted hold your browsing history...).
3. Disable updater.exe / waterfox updates in some way.  Like I mentioned above, waterfox will just go ahead and update itself no matter what you think about it, so unless you disable the updater.exe in some way I could find no other method to stop the automatic updates which may break your plugins etc.
4. Modify the script to be correct for your system! (like the profile folder name, which is hardcoded and needs to be changed everywhere it is found)
5. ImDisk needs to be installed.  All the ramdisk magic is done by that!

USAGE:

I create a symbolic link using mklink to make a 0kb .exe from the .bat, so I can make a shortcut to it in the start menu which I pin to the taskbar. Because ImDisk requires admin priveleges, the UAC will be engaged :(

On the first execution your profile in local and roaming are renamed to .backup, a ramdisk is created, and both .backup folders are copied there. Symlinks are then created between the ramdisk and original paths of the profile folders.

When you exit waterfox, the bat file will stay up and ask you if you want to delete everything by typing "Y" (case sensitive!) and pressing enter.  Deleting everything is, writing everything back to the ssd and deleting the ramdisk.  This makes sense if you are done browsing for the day, or feel that something you did (plugin install / plugin or browser configuration change etc.) or something you browsed (history / bookmarks etc.) was important enough that you really want to write everything back to the hard drive.  If you intend to use non-ramdisk waterfox (just running the executable, instead of using the script), then you should definitely press "Y" and re-write everything.

Alternatively, and I most often do this, you may just close the script (press enter, enter anything other than "Y" and press enter, or press the red X) and re-open the script anytime to re-open ramdisk waterfox (without copying anything anywhere; it should be quite quick to start).  Whenever you are finally ready to "commit" the browsing history / broswer or plugin configuration back to the hard drive just press "Y" and push enter in the script after you have closed all waterfox windows.

When the script cleans up (following "Y" and ENTER) it will delete the symlinks and copy the folders back to the HD.

It will also backup the profile right before waterfox is run (assuming it is not a repeat run, following a close where you did not enter "Y") and keep the last 2 backups (deleting the oldest backup each time you run).
