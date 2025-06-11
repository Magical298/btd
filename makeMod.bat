:DELETE
:
:delete existing *.iwd and *.ff
:from your modfolder
:EXAMPLE: <del filname>
:----------------------
del images.iwd
:del weapons.iwd
del zz_svr_scripts.iwd
del mod.ff


:COPYING NEEDED FILES TO RAWFOLDER
:
:write all your folders to copy here
:fx, materials, ui, ui_mp etc.
:EXAMPLE: <xcopy foldername ..\..\raw\foldername /SY>
:----------------------
xcopy btd ..\..\raw\btd /SY
xcopy btd_menus ..\..\raw\btd_menus /SY
xcopy btd_waypoints ..\..\raw\btd_waypoints /SY
xcopy character ..\..\raw\character /SY
xcopy english ..\..\raw\english /SY
xcopy fx ..\..\raw\fx /SY
xcopy images ..\..\raw\images /SY
xcopy maps ..\..\raw\maps /SY
xcopy material_properties ..\..\raw\material_properties /SY
xcopy materials ..\..\raw\materials /SY
xcopy mp ..\..\raw\mp /SY
xcopy physic ..\..\raw\physic /SY
xcopy rumble ..\..\raw\rumble /SY
xcopy sound ..\..\raw\sound /SY
xcopy soundaliases ..\..\raw\soundaliases /SY
xcopy ui_mp ..\..\raw\ui_mp /SY
xcopy vision ..\..\raw\vision /SY
xcopy weapons ..\..\raw\weapons /SY
xcopy xanim ..\..\raw\xanim /SY
xcopy xmodel ..\..\raw\xmodel /SY
xcopy xmodelparts ..\..\raw\xmodelparts /SY
xcopy xmodelsurfs ..\..\raw\xmodelsurfs /SY

:COPYING CSV
:
:copy *.csv to zone_source
:EXAMPLE: <copy /Y csvfile ..\..\zone_source>
:----------------------
copy /Y mod.csv ..\..\zone_source



:GO TO BINFOLDER
:----------------------
cd ..\..\bin


:CREATE FF
:----------------------
linker_pc.exe -language english -compress -cleanup mod


:GO TO MODFOLDER
:----------------------
cd ..\mods\btdz_old



:COPYING FF
:
:copy created *.ff to zone
:----------------------
copy ..\..\zone\english\mod.ff


:RENAME
:
:rename created *.ff to mod.ff
:otherwise it cannot be loaded from CoD4
:----------------------
:rename  mymod.ff mod.ff


:CREATE IWD
:
:!be sure that 7za.exe exists in your modfolder!
:fx, materials, ui, ui_mp etc.
:EXAMPLE: <7za a -r -tzip iwdname foldername>
:----------------------
7za a -r -tzip images.iwd images
:7za a -r -tzip weapons.iwd weapons
7za a -r -tzip zz_svr_scripts.iwd btd
7za a -r -tzip zz_svr_scripts.iwd btd_menus
7za a -r -tzip zz_svr_scripts.iwd btd_waypoints
7za a -r -tzip zz_svr_scripts.iwd character
7za a -r -tzip zz_svr_scripts.iwd maps
pause