#!/usr/bin/osascript

global theURL
global theOutputFolder
global theOutputFileName

on SetURL()
  set theTitle to "Video URL"

  try
    set theURLDialog to display dialog "What's the file URL?" default answer "" with title theTitle buttons {"Continue"}
    set theURL to text returned of theURLDialog
  on error
    quit
  end try

  if theURL as string is equal to "" then
    quit
  end if
end SetURL

on SetOutputFolder()
  try
    set theOutputFolder to choose folder with prompt "In what folder you will save the file?"
  on error
    quit
  end try
end SetOutputFolder

on SetOutputFileName()
  set theTitle to "File Name"

  try
    set theOutputFileNameDialog to display dialog "What's your target file name?" default answer "" with title theTitle buttons {"Continue"}
    set theOutputFileName to text returned of theOutputFileNameDialog
  on error
    quit
  end try

  if theOutputFileName as string is equal to "" then
    quit
  end if
end SetOutputFileName

on RunTerminal()
  set theTargetPath to POSIX path of theOutputFolder & theOutputFileName
  set theCommand to "ffmpeg -i " & theURL & " -c copy -bsf:a aac_adtstoasc " & theTargetPath

  tell application "Terminal"
    activate
    do script with command theCommand in window 1
  end tell
end RunTerminal

on quit
  display dialog "Thanks for trying this!" buttons {"Continue"}
  continue quit
end quit

on run
  SetURL()
  SetOutputFolder()
  SetOutputFileName()

  RunTerminal()
end run
