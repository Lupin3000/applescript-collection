global selected_feature
global target_posix_path

-- quit on error
on quit
	display dialog "Thanks for trying this!" buttons {"Exit"}
	continue quit
end quit

-- select features
on SelectFeature()
	set dialog_title to "virtualenv features"

	set possible_features to {"default", "system-site-packages", "symlinks", "without-pip"}

	try
		set selected_feature to choose from list possible_features with prompt "Select virtualenv features:" with title dialog_title default items {"default"}
	end try

	if (selected_feature as string is equal to "false") then
		quit
	end if
end SelectFeature

-- select target directory
on SelectDirectory()
	try
		set target_directoy to choose folder with prompt "What's the target directory?"
	on error
		quit
	end try

	set target_posix_path to POSIX path of target_directoy
end SelectDirectory

-- run command in terminal
on RunInTerminal()
	set shell_command to "python3 -m venv"
	
	if (selected_feature as string is not equal to "default") then
		set shell_command to terminal_command & " --" & selected_feature & " " & target_posix_path
	else
		set shell_command to terminal_command & " " & target_posix_path
	end if

	tell application "Terminal"
		if not running then activate
		do script with command shell_command
	end tell
end RunInTerminal

on run
	SelectFeature()
	SelectDirectory()
	RunInTerminal()
end run
