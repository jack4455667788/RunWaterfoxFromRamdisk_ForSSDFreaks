echo off
:: browser.cache.disk.enable;false
:: browser.cache.memory.max_entry_size;51200 - To match default browser.cache.disk.max_entry_size;51200
:: cd %USERPROFILE%\AppData\Roaming\Waterfox
:: TODO Read from profile.ini to extract the correct active profile path

:: mkdir p68xw6kw.default.backup
:: Move command below fails (access denied) for unknown reasons, potentially permissions related?  User has no issue moving folder.
::move p68xw6kw.default W:\

cd %USERPROFILE%\AppData\Roaming\Waterfox\Profiles
C:
FOR /F "tokens=*" %%g IN ('dir /AL /B') DO (set crashtest=%%g)

IF NOT EXIST W:\ (
	IF "%crashtest%" == "p68xw6kw.default" (
		echo "Computer crashed, or was otherwise restarted without copying the ramdisk profile back to the SSD.  Restoring from last backup, some browsing history was likely lost. Press any key to continue."
		pause
		cd %USERPROFILE%\AppData\Roaming\Waterfox\Profiles
		rmdir p68xw6kw.default
		ren p68xw6kw.default.backup p68xw6kw.default
		
		cd %USERPROFILE%\AppData\Local\Waterfox\Profiles
		C:
		FOR /F "tokens=*" %%g IN ('dir /AL /B') DO (set crashtest=%%g)
	
		IF "%crashtest%" == "p68xw6kw.default" (
			cd %USERPROFILE%\AppData\Local\Waterfox\Profiles
			rmdir p68xw6kw.default
			ren p68xw6kw.default.backup p68xw6kw.default
		)
	)
)

IF EXIST W:\ (
	IF NOT EXIST W:\Roaming\p68xw6kw.default\ (
		IF "%crashtest%" == "p68xw6kw.default" (		
			echo "Computer crashed, or was otherwise restarted without copying the ramdisk profile back to the SSD.  Restoring from last backup, some browsing history was likely lost. Press any key to continue."
			pause
			cd %USERPROFILE%\AppData\Roaming\Waterfox\Profiles
			xcopy /S /I /E /H p68xw6kw.default.backup W:\Roaming\p68xw6kw.default
			cd %USERPROFILE%\AppData\Local\Waterfox\Profiles
			xcopy /S /I /E /H p68xw6kw.default.backup W:\Local\p68xw6kw.default
		)
	)
	IF EXIST W:\Roaming\p68xw6kw.default\ (
        echo "Skipping Ramdisk Creation, and Backup. Enter Y when prompted to backup your profile to the SSD from the Ramdisk."
    )
) ELSE (
    imdisk -a -s 512000k -m W: -p "/fs:ntfs /q /y"
	echo "Before continuing, please verify that you would like the previous previous profile backup to be deleted"
	pause
	rmdir /S /Q p68xw6kw.default.backup.previous.previous 
	IF EXIST %USERPROFILE%\AppData\Roaming\Waterfox\Profiles\p68xw6kw.default.backup (
		ren p68xw6kw.default.backup.previous p68xw6kw.default.backup.previous.previous
		ren p68xw6kw.default.backup p68xw6kw.default.backup.previous
	)
	cd %USERPROFILE%\AppData\Roaming\Waterfox\Profiles
	C:
	FOR /F "tokens=*" %%g IN ('dir /AL /B') DO (set crashtest=%%g)
	IF NOT "%crashtest%" == "p68xw6kw.default" (
		ren p68xw6kw.default p68xw6kw.default.backup
	) ELSE (
		echo "Symlink not expected!!!!"
		pause
		exit
	)
	xcopy /S /I /E /H p68xw6kw.default.backup W:\Roaming\p68xw6kw.default
	mklink /D "p68xw6kw.default" "W:\Roaming\p68xw6kw.default"

	cd %USERPROFILE%\AppData\Local\Waterfox\Profiles
	rmdir /S /Q p68xw6kw.default.backup.previous.previous
	IF EXIST %USERPROFILE%\AppData\Local\Waterfox\Profiles\p68xw6kw.default.backup (
		ren p68xw6kw.default.backup.previous p68xw6kw.default.backup.previous.previous
		ren p68xw6kw.default.backup p68xw6kw.default.backup.previous
	)
	cd %USERPROFILE%\AppData\Local\Waterfox\Profiles
	C:
	FOR /F "tokens=*" %%g IN ('dir /AL /B') DO (set crashtest=%%g)
	IF NOT "%crashtest%" == "p68xw6kw.default" (
		ren p68xw6kw.default p68xw6kw.default.backup
	) ELSE (
		echo "Symlink not expected!!!!"
		pause
		exit
	)
	xcopy /S /I /E /H p68xw6kw.default.backup W:\Local\p68xw6kw.default
	mklink /D "p68xw6kw.default" "W:\Local\p68xw6kw.default"
)

:: If you want netflix to work use the line below, and comment out the other waterfox.exe line.
::"C:\Program Files\Waterfox\waterfox.exe" "--enable-eme=widevine"

"C:\Program Files\Waterfox\waterfox.exe"
:: Below command did absolutely nothing, there doesn't seem to be a way to disable this when executing from the command line this way.  I am manually disabling updater.exe
:: -P "No Updates"

cd %USERPROFILE%\AppData\Roaming\Waterfox\Profiles
C:
FOR /F "tokens=*" %%g IN ('dir /AL /B') DO (set crashtest=%%g)

set /p deleteflag="Delete temporary ramdrive and restore profile?  Enter Y to delete, any other key to keep ramdrive and don't write back to the SSD (Don't Restart!)"
if "%deleteflag%" == "Y" (
	IF "%crashtest%" == "p68xw6kw.default" (
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
