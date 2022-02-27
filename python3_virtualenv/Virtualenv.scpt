#!/usr/bin/osascript
global selected_feature
global target_directoy

on quit
	continue quit
end quit

on SelectFeature()
	# feature list
	set possible_features to {"default", "system-site-packages", "symlinks", "without-pip"}

	# show feature dialog
	try
		set selected_feature to choose from list possible_features with prompt "Select virtualenv features" with title "virtualenv features" default items {"default"}
	end try

	# stop on no selection
	if (selected_feature as string is equal to "false") or (selected_feature is missing value) then
		quit
	end if
end SelectFeature

on SelectDirectory()
	# show selection dialog
	try
		set target_directoy to choose folder with prompt "Select directory?"
	on error
		quit
	end try
end SelectDirectory

on ExecuteTerminal()
	# set posix path
	set target_posix_path to POSIX path of target_directoy

	# set terminal command
	set terminal_command to "python3 -m venv"

	# add feature and path
	if (selected_feature as string is not equal to "default") then
		set terminal_command to terminal_command & " --" & selected_feature & " " & target_posix_path
	else
		set terminal_command to terminal_command & " " & target_posix_path
	end if

	tell application "Terminal"
		activate
		do script with command terminal_command in window 1
	end tell
end ExecuteTerminal

on run
	SelectFeature()
	SelectDirectory()
	ExecuteTerminal()
end run
