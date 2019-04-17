@echo off
:: browser.cache.disk.enable;false
:: browser.cache.memory.max_entry_size;51200 - To match default browser.cache.disk.max_entry_size;51200
:: cd %USERPROFILE%\AppData\Roaming\Waterfox
:: http://istomin.de/2015/02/23/windows-disable-taskbar-jump-lists/
:: TODO Read from profile.ini to extract the correct active profile path

:: mkdir p68xw6kw.default.backup
:: Move command below fails (access denied) for unknown reasons, potentially permissions related?  User has no issue moving folder.
:: move p68xw6kw.default W:\
setlocal

:: set defaultprofilefoldername="p68xw6kw.default"

C:
cd %USERPROFILE%\AppData\Local\Waterfox\Profiles

FOR /F "tokens=*" %%g IN ('dir /AL /B 2^> nul') DO (set crashtest1=%%g)

C:
cd %USERPROFILE%\AppData\Roaming\Waterfox\Profiles

FOR /F "tokens=*" %%g IN ('dir /AL /B 2^> nul') DO (set crashtest=%%g)

IF NOT EXIST W:\ 2> nul (
	IF "%crashtest%" == "p68xw6kw.default" (
		echo "Computer crashed, or was otherwise restarted without copying the ramdisk profile back to the SSD.  Restoring from last backup, some browsing history was likely lost. Press any key to continue."
		:: pause
		C:
		cd %USERPROFILE%\AppData\Roaming\Waterfox\Profiles
		rmdir p68xw6kw.default
		IF NOT EXIST %USERPROFILE%\AppData\Roaming\Waterfox\Profiles\p68xw6kw.default.backup (
			echo "Roaming Backup not found as expected, aborting!"
			pause
			exit
		)
		ren p68xw6kw.default.backup p68xw6kw.default
		ren p68xw6kw.default.backup.previous p68xw6kw.default.backup
		ren p68xw6kw.default.backup.previous.previous p68xw6kw.default.backup.previous
		:: echo "done deleting roaming symlink"
		:: pause
		
		C:
		cd %USERPROFILE%\AppData\Local\Waterfox\Profiles
		IF "%crashtest1%" == "p68xw6kw.default" (
			C:
			cd %USERPROFILE%\AppData\Local\Waterfox\Profiles
			rmdir p68xw6kw.default
			IF NOT EXIST %USERPROFILE%\AppData\Local\Waterfox\Profiles\p68xw6kw.default.backup (
				echo "Local Backup not found as expected, aborting!"
				pause
				exit
			)
			ren p68xw6kw.default.backup p68xw6kw.default
			ren p68xw6kw.default.backup.previous p68xw6kw.default.backup
			ren p68xw6kw.default.backup.previous.previous p68xw6kw.default.backup.previous
		)
	) ELSE (
		IF NOT EXIST %USERPROFILE%\AppData\Roaming\Waterfox\Profiles\p68xw6kw.default (
			C:
			cd %USERPROFILE%\AppData\Roaming\Waterfox\Profiles
			
			IF NOT EXIST %USERPROFILE%\AppData\Roaming\Waterfox\Profiles\p68xw6kw.default.backup (
				echo "Unexpected Problem, no roaming backup folder found"
				pause
				exit
			)
			ren p68xw6kw.default.backup p68xw6kw.default
		)
		IF NOT EXIST %USERPROFILE%\AppData\Local\Waterfox\Profiles\p68xw6kw.default (
			C:
			cd %USERPROFILE%\AppData\Local\Waterfox\Profiles
			
			IF NOT EXIST %USERPROFILE%\AppData\Local\Waterfox\Profiles\p68xw6kw.default.backup (
				echo "Unexpected Problem, no roaming backup folder found"
				pause
				exit
			)
			ren p68xw6kw.default.backup p68xw6kw.default
		)
	)

	:: Below command as is works fine, but requires UAC / Admin
	:: I have opted for the severely insecure /savecred and enabled my local admin account :(
	:: It is a security risk, but it works...
	:: imdisk -a -s 512000k -m W: -p "/fs:ntfs /q /y"
	
	:: Works fine, but does not wait -- Doesn't seem to matter anyway... Must do a loop or something to check for the instant that imdisk is done (or break formatting step into 2nd command, that will probably work too)
	:: runas.exe /profile /savecred /user:administrator "imdisk -a -s 512000k -m W: -p \"/fs:ntfs /q /y\""
	
	start /B /WAIT runas.exe /profile /savecred /user:administrator "imdisk -a -s 512000k -m W: -p \"/fs:ntfs /q /y\""
	
	Timeout 10
	
	:: echo "Before continuing, please verify that you would like the previous previous 
	:: profile backup to be deleted"

	C:
	cd %USERPROFILE%\AppData\Roaming\Waterfox\Profiles
	
	IF EXIST %USERPROFILE%\AppData\Roaming\Waterfox\Profiles\p68xw6kw.default.backup (
		:: echo "DEBUG - Roaming .backup found"
		:: pause
		rmdir /S /Q p68xw6kw.default.backup.previous.previous
		ren p68xw6kw.default.backup.previous p68xw6kw.default.backup.previous.previous
		ren p68xw6kw.default.backup p68xw6kw.default.backup.previous
	)

	C:
	cd %USERPROFILE%\AppData\Roaming\Waterfox\Profiles

	ren p68xw6kw.default p68xw6kw.default.backup
	
	IF NOT EXIST %USERPROFILE%\AppData\Roaming\Waterfox\Profiles\p68xw6kw.default.backup (
		echo "Unexpected Problem, no roaming backup folder found"
		pause
		exit
	)
	
	xcopy /S /I /E /H p68xw6kw.default.backup W:\Roaming\p68xw6kw.default
	:: same deal with this command, UAC
	:: mklink /D "p68xw6kw.default" "W:\Roaming\p68xw6kw.default"
	runas.exe /profile /savecred /user:administrator "cmd /C mklink /D \"%USERPROFILE%\AppData\Roaming\Waterfox\Profiles\p68xw6kw.default\" \"W:\Roaming\p68xw6kw.default\""

	cd %USERPROFILE%\AppData\Local\Waterfox\Profiles

	IF EXIST %USERPROFILE%\AppData\Local\Waterfox\Profiles\p68xw6kw.default.backup (
		rmdir /S /Q p68xw6kw.default.backup.previous.previous
		ren p68xw6kw.default.backup.previous p68xw6kw.default.backup.previous.previous
		ren p68xw6kw.default.backup p68xw6kw.default.backup.previous
	)
	
	C:
	cd %USERPROFILE%\AppData\Local\Waterfox\Profiles
	
	ren p68xw6kw.default p68xw6kw.default.backup
	
	IF NOT EXIST %USERPROFILE%\AppData\Local\Waterfox\Profiles\p68xw6kw.default.backup (
		echo "Unexpected Problem, no roaming backup folder found"
		pause
		exit
	)
	
	xcopy /S /I /E /H p68xw6kw.default.backup W:\Local\p68xw6kw.default
	:: same deal, uac
	:: mklink /D "p68xw6kw.default" "W:\Local\p68xw6kw.default"
	runas.exe /profile /savecred /user:administrator "cmd /C mklink /D \"%USERPROFILE%\AppData\Local\Waterfox\Profiles\p68xw6kw.default\" \"W:\Local\p68xw6kw.default\""
	
) ELSE (
	IF NOT EXIST W:\Roaming\p68xw6kw.default\ (
		IF "%crashtest%" == "p68xw6kw.default" (
			echo "Computer crashed, or was otherwise restarted without copying the ramdisk profile back to the SSD.  Restoring from last backup, some browsing history was likely lost. Press any key to continue."
			:: pause
			cd %USERPROFILE%\AppData\Roaming\Waterfox\Profiles
			xcopy /S /I /E /H p68xw6kw.default.backup W:\Roaming\p68xw6kw.default
			cd %USERPROFILE%\AppData\Local\Waterfox\Profiles
			xcopy /S /I /E /H p68xw6kw.default.backup W:\Local\p68xw6kw.default
		)
	)
	IF EXIST W:\Roaming\p68xw6kw.default\ (
        echo "Skipping Ramdisk Creation, and Backup. Enter Y when prompted to backup your profile to the SSD from the Ramdisk."
    )
) 

:: If you want netflix to work use the line below, and comment out the other waterfox.exe line.
:: "C:\Program Files\Waterfox\waterfox.exe" ::"--enable-eme=widevine"
"C:\Program Files\Waterfox\waterfox.exe"
:: Below command did absolutely nothing, there doesn't seem to be a way to disable this when executing from the command line this way.  I am manually disabling updater.exe
:: -P "No Updates"

C:
cd %USERPROFILE%\AppData\Roaming\Waterfox\Profiles

FOR /F "tokens=*" %%g IN ('dir /AL /B 2^> nul') DO (set crashtest4=%%g)

set /p deleteflag="Delete temporary ramdrive and restore profile?  Enter Y to delete, any other key to keep ramdrive and don't write back to the SSD (Don't Restart!)"
if "%deleteflag%" == "Y" (
	IF "%crashtest4%" == "p68xw6kw.default" (
		cd %USERPROFILE%\AppData\Roaming\Waterfox\Profiles
		C:
		rmdir p68xw6kw.default
		cd %USERPROFILE%\AppData\Local\Waterfox\Profiles
		C:
		rmdir p68xw6kw.default
		W:
		xcopy /S /I /E /H W:\Roaming\p68xw6kw.default %USERPROFILE%\AppData\Roaming\Waterfox\Profiles\p68xw6kw.default && C: && xcopy /S /I /E /H W:\Local\p68xw6kw.default %USERPROFILE%\AppData\Local\Waterfox\Profiles\p68xw6kw.default && C: && imdisk -D -m W:
		echo "Profile restored to the SSD and ramdisk deleted."
		pause
	) ELSE (
		echo "Nothing was deleted because it was detected that the roaming profile directory was NOT a symlink!!! Please figure out what went wrong!"
		pause
	)
) ELSE (
    echo "Ramdisk is still cached, profile is not saved to the SSD."
	pause
)

set deleteflag=
set crashtest=
set crashtest1=
set crashtest2=
set crashtest3=
set crashtest4=