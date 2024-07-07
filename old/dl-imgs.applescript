set fixedDirectory to "/Users/username/path/to/images"

tell application "Preview"
	activate
	tell front document
		tell application "System Events" to tell process "Preview"
			set windowState to name of 1st menu item of menu 1 of menu bar item "Window" of menu bar 1 whose name ends with ")"
			--display dialog windowState
			-- Go to page 1
			set AppleScript's text item delimiters to {"(Page ", " of ", ")"}
			set totalPages to text item 3 of windowState as integer
			if text item 2 of windowState is not "1" then
				display dialog "Please navigate to the first page then rerun this script (current page: " & text item 2 of windowState & ")"
				return
			end if
			set AppleScript's text item delimiters to ""
			repeat with i from 1 to totalPages
				set newFilename to "pg_" & i & ".jpg"
				click (get 1st menu item of menu 1 of menu bar item "File" of menu bar 1 whose name begins with "Export")
				repeat until exists sheet 1 of window 1
					delay 0.1
				end repeat
				-- Enter the name of the new jpeg
				set value of text field 1 of sheet 1 of window 1 to newFilename
				delay 0.1
				-- Select the "Format" dropdown menu
				click pop up button 2 of sheet 1 of window 1
				-- Wait for the dropdown menu to be visible
				delay 0.1
				-- Select "JPEG" from the dropdown menu
				click menu item "JPEG" of menu 1 of pop up button 2 of sheet 1 of window 1
				delay 0.5
				-- Set DPI to be 300
				if i is 1 then
					repeat until exists text field 4 of sheet 1 of window 1
						delay 0.1
					end repeat
					set value of text field 4 of sheet 1 of window 1 to "1000"
					delay 0.1
				end if
				-- Set quality slider to max
				repeat until exists slider 1 of sheet 1 of window 1
					delay 0.1
				end repeat
				set value of slider 1 of sheet 1 of window 1 to 100
				delay 0.1
				keystroke "g" using {command down, shift down}
				repeat until exists sheet 1 of sheet 1 of window 1
					delay 0.1
				end repeat
				set value of text field 1 of sheet 1 of sheet 1 of window 1 to fixedDirectory
				keystroke return
				delay 0.1
				click button "Save" of sheet 1 of window 1
				delay 0.5
				repeat while exists sheet 1 of window 1
					delay 0.1
				end repeat
				key code 125 using {option down}
				delay 0.1
			end repeat
		end tell
	end tell
end tell

