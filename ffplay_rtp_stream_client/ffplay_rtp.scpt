#!/usr/bin/osascript

global sdp_file

on quit
	display dialog "Thanks for trying this!" buttons {"Continue"}
	continue quit
end quit

on SetSDPFile()
	set window_title to "ffplay SDP location"

	try
		set sdp_file to choose file with prompt "Please select a document to process:"
	on error
		quit
	end try
end SetSDPFile

on RunInTerminal()
	set posix_sdp_file to POSIX path of sdp_file
	set terminal_command to "ffplay -protocol_whitelist \"file,udp,rtp\" -i" & posix_sdp_file

	tell application "Terminal"
		activate
		do script with command terminal_command in window 1
	end tell
end RunInTerminal

on run
	SetSDPFile()
	RunInTerminal()
end run
