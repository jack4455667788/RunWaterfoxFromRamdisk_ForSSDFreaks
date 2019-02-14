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
* Still some manual steps you have to perform, not everything has been put into the unified script...

MANUAL THINGS (Things you need to take care of, the script doesn't do it automatically):

1. Configure waterfox to not waste so much memory on caching in about:config ( you need to make sure it does not exceed the ramdisk size you provision, by default in the script it is 512mb, but could be much smaller or larger depending on your configurations).
2. OPT - Disable the jump list item for waterfox, so it isn't hammering your ssd on the jump list anymore (this is also a security issue, in that the recent temp files written and deleted hold your browsing history...).
3. Modify the script to be correct for your system! (like the profile name, which is hardcoded and needs to be changed.)
4. ImDisk needs to be installed.  All the ramdisk magic is done by that!
