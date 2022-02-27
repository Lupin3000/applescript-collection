global sdp_posix_file

-- quit on error
on quit
	display dialog "Thanks for trying this!" buttons {"Exit"}
	continue quit
end quit

-- set sdp file
on SetSDPFile()
	try
		set sdp_file to choose file with prompt "What's the SDP file?"
	on error
		quit
	end try

	if (sdp_file as string is equal to "false") then
		quit
	end if

	set sdp_posix_file to POSIX path of sdp_file
end SetSDPFile

-- run command in terminal
on RunInTerminal()
	set shell_command to "ffplay -hide_banner -protocol_whitelist \"file,udp,rtp\" -i " & sdp_posix_file

	tell application "Terminal"
		if not running then activate
		do script with command shell_command
	end tell
end RunInTerminal

-- main
on run
	SetSDPFile()
	RunInTerminal()
end run
