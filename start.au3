#include <Misc.au3>


$nb_of_notes = 7
Local $x[$nb_of_notes]
Local $y[$nb_of_notes]
Local $initChecksums[$nb_of_notes]
Local $areTaped[$nb_of_notes]
$getMousePosCounter = 0

While $getMousePosCounter <= $nb_of_notes - 1
   If _IsPressed(01) Then
	  $MousePos = MouseGetPos()
	  $x[$getMousePosCounter] = $MousePos[0]
	  $y[$getMousePosCounter] = $MousePos[1]
	  ConsoleWrite("New pos added : " & $x[$getMousePosCounter] & ", " & $y[$getMousePosCounter])
	  $getMousePosCounter = $getMousePosCounter + 1
	  While _IsPressed(01)
            Sleep(250)
        WEnd
   EndIf
WEnd

$pixel_size = 1

For $i = 0 To $nb_of_notes - 1 Step 1
   $initChecksums[$i] = PixelChecksum($x[$i], $y[$i], $x[$i] + $pixel_size, $y[$i] + $pixel_size)
   $areTaped[$i] = False
Next

$count = 0
While True
   For $i = 0 To $nb_of_notes - 1 Step 1
	  $isChanged = $initChecksums[$i] <> PixelChecksum($x[$i], $y[$i], $x[$i] + $pixel_size, $y[$i] + $pixel_size)
	  If $isChanged And Not $areTaped[$i] Then
		 $initChecksums[$i] = PixelChecksum($x[$i], $y[$i], $x[$i] + $pixel_size, $y[$i] + $pixel_size)
		 $count = $count + 1
		 $areTaped[$i] = True
	  ElseIf $isChanged And $areTaped[$i] Then
		 $initChecksums[$i] = PixelChecksum($x[$i], $y[$i], $x[$i] + $pixel_size, $y[$i] + $pixel_size)
		 $areTaped[$i] = False
	  EndIf

   Next

	  ConsoleWrite("Tapped " & $count & " times" & @CRLF)
   Sleep(50)
WEnd