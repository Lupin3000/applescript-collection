global selected_interface
global broadcast_ip
global network

-- quit on error
on quit
	display dialog "Thanks for trying this!" buttons {"Exit"}
	continue quit
end quit

-- select service
on SelectDevice()
	set dialog_title to "Video URL"

	tell application "System Events"
		tell current location of network preferences
			set all_networkservice to get name of every service whose active is true
		end tell
	end tell

	try
		set selected_networkservice to choose from list all_networkservice with prompt "Select your favorite interface:" with title dialog_title default items {""}
	on error
		quit
	end try

	if (selected_networkservice as string is equal to "false") then
		quit
	end if

	if (selected_networkservice contains "WLAN") then
		set selected_networkservice to "Wi-Fi"
	end if

	set shell_command to "networksetup -listnetworkserviceorder | grep -A1 '" & selected_networkservice & "' | sed -n -e 's/^.*Device: //p' | sed 's/)//'"

	set selected_interface to do shell script shell_command
end SelectDevice

-- get broadcast ip
on GetIP()
	set shell_command to "ifconfig " & selected_interface & " | grep 'broadcast' | awk '{ print $6 }'"
	set broadcast_ip to do shell script shell_command

	if (broadcast_ip is "") then
		quit
	end if
end GetIP

-- get network ip part
on GetNetwork()
	set shell_command to "echo '" & broadcast_ip & "' | cut -d '.' -f 1-3"

	set network to do shell script shell_command
end GetNetwork

-- run command in terminal
on RunInTerminal()
	set shell_command to "for ADDR in {1..254}; do ping -c 1 -n -i 0.5 " & network & ".$ADDR | grep 'bytes from' | cut -d ' ' -f 4 | cut -d ':' -f 1; done"

	tell application "Terminal"
		if not running then activate
		do script with command shell_command
	end tell
end RunInTerminal

-- main
on run
	SelectDevice()
	GetIP()
	GetNetwork()
	RunInTerminal()
end run
