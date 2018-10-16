@ECHO OFF

set "flat=0"
set "overlay=0"
set "nohats=0"
set "shells=0"
set "surfaceproperties=0"
set "soundscapes=0"
set "mtp=0"

:FLAT
set /P c=would you like flat materials? Y/N/Help     
if /I "%c%" EQU "Y" goto :FLAT_GEN
if /I "%c%" EQU "N" goto :OVERLAY
if /I "%c%" EQU "HELP" (echo flat materials make all world textures one solid color, also known as quake textures) else (echo invalid input)
goto :FLAT

:FLAT_GEN
set /P c=would you like flat textures resized? Y/N/Help     
if /I "%c%" EQU "Y" goto :FLAT_GEN_RESIZED
if /I "%c%" EQU "N" goto :FLAT_GEN_STANDARD
if /I "%c%" EQU "HELP" (echo resized flat textures causes grainyness on sv_pure, non-resized appears as stock tf2 textures) else (echo invalid input)
goto :FLAT_GEN

:FLAT_GEN_STANDARD
set "flat=1"
goto :OVERLAY

:FLAT_GEN_RESIZED
set "flat=2"
goto :OVERLAY

:OVERLAY
set /P c=would you like to remove overlay materials? Y/N/Help     
if /I "%c%" EQU "Y" goto :OVERLAY_GEN
if /I "%c%" EQU "N" goto :NOHATS
if /I "%c%" EQU "HELP" (echo this removes materials that get overlayed on the world) else (echo invalid input)
goto :OVERLAY

:OVERLAY_GEN
set "overlay=1"
goto :NOHATS

:NOHATS
set /P c=would you like to remove hats? Y/N/Help     
if /I "%c%" EQU "Y" goto :NOHATS_GEN
if /I "%c%" EQU "N" goto :SHELLS
if /I "%c%" EQU "HELP" (echo this removes all hats and cosmetics from players) else (echo invalid input)
goto :NOHATS

:NOHATS_GEN
set "nohats=1"
goto :SHELLS

:SHELLS
set /P c=would you like to remove shells from guns? Y/N/Help     
if /I "%c%" EQU "Y" goto :SHELLS_GEN
if /I "%c%" EQU "N" goto :SURFACEPROPERTIES
if /I "%c%" EQU "HELP" (echo this removes the shells that are ejected from some guns) else (echo invalid input)
goto :SHELLS

:SHELLS_GEN
set "shells=1"
goto :SURFACEPROPERTIES

:SURFACEPROPERTIES
set /P c=would you like to add surfaceproperties? Y/N/Help     
if /I "%c%" EQU "Y" goto :SURFACEPROPERTIES_GEN
if /I "%c%" EQU "N" goto :SOUNDSCAPES
if /I "%c%" EQU "HELP" (echo this removes bullet impacts and sets all footstep sounds to be the same) else (echo invalid input)
goto :SURFACEPROPERTIES

:SURFACEPROPERTIES_GEN
set /P c=would you want there to be footstep sounds or no sounds? Y/N/Help     
if /I "%c%" EQU "Y" goto :SURFACEPROPERTIES_GEN_METAL
if /I "%c%" EQU "N" goto :SURFACEPROPERTIES_GEN_NOSTEPS
if /I "%c%" EQU "HELP" (echo choosing yes will let there be metal footstep sounds on all materials, otherwise there will be no footstep sounds) else (echo invalid input)
goto :SURFACEPROPERTIES_GEN

:SURFACEPROPERTIES_GEN_METAL
set "surfaceproperties=1"
goto :SOUNDSCAPES

:SURFACEPROPERTIES_GEN_NOSTEPS
set "surfaceproperties=2"
goto :SOUNDSCAPES

:SOUNDSCAPES
set /P c=would you like to remove soundscapes? Y/N/Help     
if /I "%c%" EQU "Y" goto :SOUNDSCAPES_GEN
if /I "%c%" EQU "N" goto :MTP
if /I "%c%" EQU "HELP" (echo this removes many world sounds from maps) else (echo invalid input)
goto :SOUNDSCAPES

:SOUNDSCAPES_GEN
set "soundscapes=1"
goto :MTP

:MTP
set /P c=would you like to add mtp.cfg? Y/N/Help     
if /I "%c%" EQU "Y" goto :MTP_GEN
if /I "%c%" EQU "N" goto :END
if /I "%c%" EQU "HELP" (echo this sets which maps are affected by pyrovision) else (echo invalid input)
goto :MTP

:MTP_GEN
set "mtp=1"
goto :END

:END
if %flat% EQU 1 (
	echo generating flat textures
	call dev\generators\textures_flat.bat dev\lists\flat.txt "../../tf2_textures_dir.vpk"
	call dev\generators\textures_flat.bat dev\lists\flat_hl2.txt "../../../hl2/hl2_textures_dir.vpk"
	)
if %flat% EQU 2 (
	echo generating flat textures
	call dev\generators\textures_flat.bat dev\lists\flat.txt "../../tf2_textures_dir.vpk" 1
	call dev\generators\textures_flat.bat dev\lists\flat_hl2.txt "../../../hl2/hl2_textures_dir.vpk" 1
	)
if %overlay% EQU 1 (
	echo removing overlay materials
	call dev\generators\textures_nodraw.bat dev\lists\nodraw.txt
	call dev\generators\scripts_copy.bat extra_models.txt scripts
)
if %nohats% EQU 1 (
	echo removing hats
	call dev\generators\models_null.bat dev\lists\nohats.txt
)
if %shells% EQU 1 (
	echo removing shell models
	call dev\generators\models_null.bat dev\lists\model_removal_shells.txt
)
if %surfaceproperties% EQU 1 (
	echo adding surfaceproperties
	call dev\generators\scripts_copy.bat surfaceproperties_manifest.txt scripts
	call dev\generators\scripts_find_and_replace.bat surfaceproperties.txt "REPLACEME" "SolidMetal.StepLeft"
)
if %surfaceproperties% EQU 2 (
	echo adding surfaceproperties
	call dev\generators\scripts_copy.bat surfaceproperties_manifest.txt scripts
	call dev\generators\scripts_find_and_replace.bat surfaceproperties.txt "REPLACEME" " "
)
if %soundscapes% EQU 1 (
	echo removing soundscapes
	call dev\generators\scripts_copy.bat soundscapes_manifest.txt scripts
)
if %mtp% EQU 1 (
	echo removing soundscapes
	call dev\generators\scripts_copy.bat mtp.cfg cfg
)
echo thank you for using Clean TF2+
pause