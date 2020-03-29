;Set the width, height and bit depth of the screen 
Global ScrW.l = 1024 
Global ScrH.l = 768 
Global ScrD.l = 32 
Global Quit.b = #False 
Global Start.b = #False
Global KeepMoving.b = #True

;this can easily be changed for manual testing
Racer1 = 0
Racer2 = 0
Racer3 = 0
FirstPlace$ = ""

Header$ = "Mini-Racing Competition by xdvrx1"

;Simple error checking procedure
Procedure HandleError(Result.l, Text.s) 
  If Result = 0 
    MessageRequester("Error", Text, #PB_MessageRequester_Ok)
    End 
  EndIf 
EndProcedure

;initialize environment through HandleError Procedure
HandleError(InitSprite(), "InitSprite() command failed.") 
HandleError(InitKeyboard(), "InitKeyboard() command failed.") 
HandleError(OpenScreen(ScrW, ScrH, ScrD, "Error"), "Could not open screen.") 

;common framerate
SetFrameRate(60)

;my fave font
Font1 = LoadFont(#PB_Any, "Consolas", 22)

;main loop:
;you want to take note of this
;main loop, because there is a tendency
;you put another iteration in one
;part that will cause the program to crash
;because there will be no exit condition
Repeat 
  ClearScreen(RGB(0, 0, 0))
  
  If StartDrawing (ScreenOutput())
    ;the area of the game
    DrawingFont(FontID(Font1))
    DrawText(ScrW/2-250, 10,Header$, RGB(244, 232, 102),RGB(0, 0, 0))
    LineXY(ScrW-40, ScrH, ScrW-40,0, RGB(255, 0, 200))
    DrawRotatedText(ScrW-45, ScrH/2+100, "FINISH LINE", 90,(RGB(255,0,200)))
    
    ;racer1
    Line(0, ScrH-200, ScrW, 1, RGB(255, 255, 255))
    Box(Racer1, ScrH-95, 60, 40, RGB(0, 150, 0))    
    DrawText(50, ScrH-130+20, Str(Racer1))
    DrawText(20, ScrH-170+20, "Racer 1")
    
    ;racer2
    Line(0, ScrH/2-150, ScrW,1, RGB(255, 255, 255))
    Box(Racer2, ScrH/2, 60, 40 , RGB(0, 0, 150)) 
    DrawText(50, ScrH/2-20, Str(Racer2)) 
    DrawText(20, ScrH/2-60, "Racer 2") 
    
    ;racer3
    Box(Racer3, 90, 60, 40, RGB(150, 0, 0)) 
    DrawText(50, 80, Str(Racer3))
    DrawText(20, 40, "Racer 3")
    
    ;draw text if paused
    If Start = #False
      DrawText(80, ScrH/2-140, "Press `R` to start/pause |")
      DrawText(Scrw/2, ScrH/2-140, "Press `Space` to restart")
      DrawText(Scrw/2-180, ScrH/2-100, "Press `esc` to terminate")      
    EndIf
    
    If KeepMoving = #True
      ;any if condition here
      ;that evaluates to true
      ;(`KeepMoving` becomes false)
      ;will make the flip buffers to stop      
      If Racer3 >= (ScrW-100+1)
        KeepMoving = #False
      EndIf      
      
      If Racer1 >= (ScrW-100+1)
        KeepMoving = #False
      EndIf
      
      If Racer2 >= (ScrW-100+1)
        KeepMoving = #False
      EndIf
      
    EndIf
    
    If KeepMoving = #False
      
      ;for first place
      If Racer1 > Racer2 
        If Racer1 > Racer3
          FirstPlace$ = "Racer 1"
          DrawText(140, ScrH-130+20, "Winner: " + FirstPlace$)
        EndIf
      EndIf 
      
      If Racer2 > Racer1
        If Racer2 > Racer3
          FirstPlace$ = "Racer 2"
          DrawText(140 ,ScrH/2-20, "Winner: " + FirstPlace$)
        EndIf
      EndIf
      
      If Racer3 > Racer1
        If Racer3 > Racer2
          FirstPlace$ = "Racer 3"
          DrawText(140, 80, "Winner: " + FirstPlace$)
        EndIf
      EndIf    
      
      ;for first place draw      
      ;Racer 1 & Racer 2 Tie
      If Racer2 = Racer1
        If Racer2 > Racer3          
          DrawText(Scrw/2-150, ScrH/2, "Racer 1 & Racer 2 Tie")
        EndIf
      EndIf 
      
      ;Racer 1 & Racer 3 Tie
      If Racer1 = Racer3
        If Racer1 > Racer2 
          DrawText(Scrw/2-150, ScrH/2, "Racer 1 & Racer 3 Tie")
        EndIf
      EndIf  
      
      ;Racer 3 & Racer 2 Tie
      If Racer3 = Racer2
        If Racer3 > Racer1 
          DrawText(Scrw/2-150, ScrH/2, "Racer 3 & Racer 2 Tie")
        EndIf
      EndIf       
      
      ;all draw
      If Racer1 = Racer2 And Racer2 = Racer3
        DrawText(Scrw/2-40, ScrH/2, "Draw!")
      EndIf
    EndIf
    
  EndIf
  
  StopDrawing( )
  
  ;this is where the illusion 
  ;of movement is created
  FlipBuffers( ) 
  
  ;don't get values here
  ;it's the control for the movement
  ;Racer1, Racer2, Racer3
  ;they are the `x` positions of the
  ;three boxes, so it seems when `x`
  ;position is changed in every frame
  ;there is horizontal movement,
  ;but there is none
  If Start = #True    
    If KeepMoving = #True
      
      RandomInt3 = Random(3)    
      Racer3 = Racer3 + 5 + RandomInt3  
      
      RandomInt1 = Random(3)    
      Racer1 = Racer1 + 5 + RandomInt1      
      
      RandomInt2 = Random(3)    
      Racer2 = Racer2 + 5 + RandomInt2  
      
    EndIf    
  EndIf
  
  If ExamineKeyboard() 
    
    If KeyboardPushed(#PB_Key_Space)      
      Racer1 = 0
      Racer2 = 0
      Racer3 = 0      
      KeepMoving = #True 
      FirstPlace$ = ""
    EndIf 
    
    If KeyboardReleased(#PB_Key_R)
      ;make `R` key a push button
      If Start = #False
        Start = #True
      Else
        Start = #False
      EndIf
    EndIf
    
    If KeyboardReleased(#PB_Key_Escape) 
      Quit = #True 
    EndIf 
    
  EndIf 
  
Until Quit = #True 
End
