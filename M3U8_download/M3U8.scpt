global video_url
global target_posix_path
global target_file

-- quit on error
on quit
	display dialog "Thanks for trying this!" buttons {"Exit"}
	continue quit
end quit

-- set video url
on SetVideoURL()
	set dialog_title to "Video URL"

	try
		set Dialog to display dialog "What's the video URL?" default answer "" with title dialog_title buttons {"Next Step"}
		set video_url to text returned of Dialog
	on error
		quit
	end try

	if (video_url as string is equal to "") then
		quit
	end if
end SetVideoURL

-- set target directory
on SetTargetDirectory()
	try
		set target_directory to choose folder with prompt "Where should the video be saved?"
	on error
		quit
	end try

	set target_posix_path to POSIX path of target_directory
end SetTargetDirectory

-- set target file name
on SetTargetFile()
	set dialog_title to "Video filename"

	try
		set Dialog to display dialog "What should be the name for video file?" default answer "" with title dialog_title buttons {"Start Download"}
		set target_file to text returned of Dialog
	on error
		quit
	end try

	if (target_file as string is equal to "") then
		quit
	end if
end SetTargetFile

-- run command in terminal
on RunInTerminal()
	set shell_command to "ffmpeg -hide_banner -i \"" & video_url & "\" -c copy -bsf:a aac_adtstoasc " & target_posix_path & target_file

	tell application "Terminal"
		if not running then activate
		do script with command shell_command
	end tell
end RunInTerminal

-- main
on run
	SetVideoURL()
	SetTargetDirectory()
	SetTargetFile()
	RunInTerminal()
end run
