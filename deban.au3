;/////////////////////////////////////////////////////////////////////////////
;
;	Author : Monsef ALAHEM
;	Date 	: 2017
;	note	: its a good idea to change the fly's image to something that suits your taste
;
;/////////////////////////////////////////////////////////////////////////////

#include <GDIPlus.au3>
#include <WindowsConstants.au3>
#include <GuiConstantsEx.au3>
#include <Timers.au3>

Opt("GuiOnEventMode", 1)
HotKeySet("{ESC}", "_Terminate")
Global $oldsens, $sens = Random(1, 4, 1)

Global $gui, $hImage, $imgW, $imgH, $x = 800, $y = 400, $my_duree = $CmdLine[1] ;like argv[1] equivalent in C
$tmpx = Random(-100, 100, 1)
$tmpy = Random(-100, 100, 1)
$gui = GUICreate("Test", 128, 128, -1, 20, $WS_POPUP, $WS_EX_LAYERED)
$start = TimerInit()
$anime = TimerInit()
$app_timer = TimerInit()

_GDIPlus_Startup()
$hImage = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\1.png")
$hImage2 = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\2.png")
$hImage3 = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\3.png")
$imgW = _GDIPlus_ImageGetWidth ($hImage)
$imgH = _GDIPlus_ImageGetHeight($hImage)
SetBitMap($gui, $hImage, 255)
$label = GuiCtrlCreateLabel("", 0, 0, 128, 128)
GUICtrlSetBkColor($label, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetState($label, $GUI_ONTOP)
$contextmenu = GUICtrlCreateContextMenu($label)
$exit = GUICtrlCreateMenuItem("Exit", $contextmenu)
 GUICtrlSetOnEvent(-1, "_Terminate")
GUISetState()


While 1

   ;_NotNormal ( )
   WinMove($gui, "",600,400, Default,Default, 1)
   While 1
	   Global $anim_factor = 50

	   If TimerDiff($anime) > $anim_factor*1 And TimerDiff($anime) <= $anim_factor*2 Then
		  SetBitMap($gui, $hImage, 255)
	   EndIf

	   If TimerDiff($anime) > $anim_factor*2 And TimerDiff($anime) <= $anim_factor*3 Then
		  SetBitMap($gui, $hImage2, 255)
	   EndIf

	   If TimerDiff($anime) > $anim_factor*3 Then
		  SetBitMap($gui, $hImage3, 255)
		  $anime = TimerInit()
	   EndIf


	  WinMove($gui, "",$x,$y, Default,Default, 1)
	  WinSetOnTop($gui, "", 1)
	  $x += $tmpx
	  $y += $tmpy
	  If TimerDiff($start) > 1000 Then
		  $start = TimerInit()
		  $mov = 20
		  $tmpx = Random(-$mov, $mov, 1)
		  $tmpy = Random(-$mov, $mov, 1)
	  EndIf

	  If $x <0  Then
	  $tmpx = 20
	  EndIf

	  If  $y < 0 Then
	  $tmpy = 20
	  EndIf

      If $x > @DeskTopWidth  Then
	  $tmpx = -20
	  EndIf

      If $y > @DeskTopHeight Then
	  $tmpy = -20
	  EndIf

	  If TimerDiff($app_timer) > $my_duree Then
		  _Terminate()
	   EndIf


	  HotKeySet("{ESC}", "_Terminate")

   Wend
Wend

_GDIPlus_ImageDispose($hImage)
_GDIPlus_Shutdown()


;=========================================================


Func _Terminate()
  ;_Normal ( )
  _GDIPlus_Shutdown()
  GUIDelete ()
  Exit
EndFunc


Func SetBitmap($hGUI, $hImage, $iOpacity)
  Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend

  $hScrDC  = _WinAPI_GetDC(0)
  $hMemDC  = _WinAPI_CreateCompatibleDC($hScrDC)
  $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
  $hOld    = _WinAPI_SelectObject($hMemDC, $hBitmap)
  $tSize   = DllStructCreate($tagSIZE)
  $pSize   = DllStructGetPtr($tSize  )
  DllStructSetData($tSize, "X", $imgW)
  DllStructSetData($tSize, "Y", $imgH)
  $tSource = DllStructCreate($tagPOINT)
  $pSource = DllStructGetPtr($tSource)
  $tBlend  = DllStructCreate($tagBLENDFUNCTION)
  $pBlend  = DllStructGetPtr($tBlend)
  DllStructSetData($tBlend, "Alpha" , $iOpacity    )
  DllStructSetData($tBlend, "Format", 1)  ; $AC_SRC_ALPHA
  _WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
  _WinAPI_ReleaseDC   (0, $hScrDC)
  _WinAPI_SelectObject($hMemDC, $hOld)
  _WinAPI_DeleteObject($hBitmap)
  _WinAPI_DeleteDC    ($hMemDC)
EndFunc

Func _SetGamma ( $vRed=128, $vGreen=128, $vBlue=128 )
    Local $n_ramp, $rVar, $gVar, $bVar, $Ret, $i, $dc
    If $vRed < 0 Or $vRed > 386 Then Return -1
    If $vGreen < 0 Or $vGreen > 386 Then Return -1
    If $vBlue < 0 Or $vBlue > 386 Then Return -1
    $dc = DLLCall ( "user32.dll", "int", "GetDC","hwnd", 0 )
    $n_ramp = DllStructCreate ( "short[" & ( 256*3 ) & "]" )
    For $i = 0 to 256
    $rVar = $i * ( $vRed + 128 )
    If $rVar > 65535 Then $rVar = 65535
    $gVar = $i * ( $vGreen + 128 )
    If $gVar > 65535 Then $gVar = 65535
    $bVar = $i * ( $vBlue + 128 )
    If $bVar > 65535 Then $bVar = 65535
    DllStructSetData ( $n_ramp, 1, Int ( $rVar ), $i )  ; red
    DllStructSetData ( $n_ramp, 1, Int ( $gVar ), $i+256 ) ; green
    DllStructSetData ( $n_ramp, 1, Int ( $bVar ), $i+512 ) ; blue
    Next
    $ret = DLLCall ( "gdi32.dll", "int", "SetDeviceGammaRamp", "int", $dc[0], "ptr", DllStructGetPtr ( $n_Ramp ) )
    $dc = 0
    $n_Ramp = 0
EndFunc ;==> _SetGamma ( )

Func _Normal ( )

    $_Rgb = 0

    _SetGamma ( $_Rgb, $_Rgb, $_Rgb )
EndFunc ;==> _Normal ( )

Func _NotNormal ( )

    $_Rgb = 30

    _SetGamma ( $_Rgb, $_Rgb, $_Rgb )
EndFunc ;==> _Normal ( )


#cs
If $tmpx < 0 Then
		  Do
			  WinMove($gui, "",$x,$y, Default,Default, 1)
			  $x -= 1
			  $y -= 1
		  Until $x < $tmpx And $y < $tmpy
EndIf
#ce