#!/usr/bin/osascript

global selected_interface
global broadcast_ip
global network

on quit
	display dialog "Thanks for trying this!" buttons {"Continue"}
	continue quit
end quit

on SelectDevice()
	# get active interfaces
	tell application "System Events"
		tell current location of network preferences
			set all_networkservice to get name of every service whose active is true
		end tell
	end tell

	# show select dialog
	try
		set selected_networkservice to choose from list all_networkservice with prompt "Select your favorite interface:" with title "Service Picker" default items {""}
	on error
		quit
	end try

	# stop
	if (selected_networkservice as string is equal to "") or (selected_networkservice is missing value) then
		quit
	end if

	# verify for string WLAN
	if (selected_networkservice contains "WLAN") then
		set selected_networkservice to "Wi-Fi"
	end if

	# create shell command
	set the_command to "networksetup -listnetworkserviceorder | grep -A1 '" & selected_networkservice & "' | sed -n -e 's/^.*Device: //p' | sed 's/)//'"

	# store interface
	set selected_interface to do shell script the_command
end SelectDevice

on GetIP()
	# create shell command
	set the_command to "ifconfig " & selected_interface & " | grep 'broadcast' | awk '{ print $6 }'"

	# store broadcast
	set broadcast_ip to do shell script the_command

	# check for IP
	if broadcast_ip is "" then
		quit
	end if
end GetIP

on GetNetwork()
	# create shell command
	set the_command to "echo '" & broadcast_ip & "' | cut -d '.' -f 1-3"

	# store network
	set network to do shell script the_command
end GetNetwork

on RunInTerminal()
	# create shell command
	set the_command to "for ADDR in {1..254}; do ping -c 1 -n -i 0.5 " & network & ".$ADDR | grep 'bytes from' | cut -d ' ' -f 4 | cut -d ':' -f 1; done"

	# run in Terminal
	tell application "Terminal"
		activate
		do script with command the_command in window 1
	end tell
end RunInTerminal

on run
	set selected_interface to ""
	set broadcast_ip to ""
	set network to ""

	SelectDevice()
	GetIP()
	GetNetwork()
	RunInTerminal()
end run
