#include <Misc.au3>

$piano_notes = StringSplit("CDEFGAB", "")
$nb_of_notes = 7
$pixel_size = 1
$final_partition = ""
Local $x[$nb_of_notes]
Local $y[$nb_of_notes]
Local $checksums[$nb_of_notes]
Local $isTaped[$nb_of_notes]

Func getAllMousePositions($nb_of_position)
   $counter = 0
   While $counter <= $nb_of_position - 1
	  If _IsPressed(01) Then
		 $MousePos = MouseGetPos()
		 $x[$counter] = $MousePos[0]
		 $y[$counter] = $MousePos[1]
		 ConsoleWrite("New pos added : " & $x[$counter] & ", " & $y[$counter])
		 $counter = $counter + 1
		 While _IsPressed(01)
			   Sleep(250)
		   WEnd
	  EndIf
   WEnd
EndFunc

Func initNotes($nb_of_init)
   For $i = 0 To $nb_of_init - 1 Step 1
	  $checksums[$i] = PixelChecksum($x[$i], $y[$i], $x[$i] + $pixel_size, $y[$i] + $pixel_size)
	  $isTaped[$i] = False
   Next
EndFunc

Func monitorPixels($nb_of_pixels)
   While True
	  For $i = 0 To $nb_of_pixels - 1 Step 1
		 $isChanged = $checksums[$i] <> PixelChecksum($x[$i], $y[$i], $x[$i] + $pixel_size, $y[$i] + $pixel_size)
		 If $isChanged And Not $isTaped[$i] Then
			ConsoleWrite("Changement " & $i & " : " & $checksums[$i] & " et " & PixelChecksum($x[$i], $y[$i], $x[$i] + $pixel_size, $y[$i] + $pixel_size))
			$checksums[$i] = PixelChecksum($x[$i], $y[$i], $x[$i] + $pixel_size, $y[$i] + $pixel_size)
			$final_partition = $final_partition & $piano_notes[$i+1] ; $i+1 because StringSplit begin at 1 for dark reasons that only AutoIt team can respond
			$isTaped[$i] = True
		 ElseIf $isChanged And $isTaped[$i] Then
			$checksums[$i] = PixelChecksum($x[$i], $y[$i], $x[$i] + $pixel_size, $y[$i] + $pixel_size)
			$isTaped[$i] = False
		 EndIf
	  Next

	  ConsoleWrite($final_partition & @CRLF)
	  Sleep(80)
   WEnd
EndFunc

getAllMousePositions($nb_of_notes)
initNotes($nb_of_notes)
monitorPixels($nb_of_notes)

