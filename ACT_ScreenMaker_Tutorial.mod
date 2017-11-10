MODULE ACT_ScreenMaker_Tutorial
    
!******************************************************
!               ScreenMaker Set-Up    
!******************************************************
!             update variable dynamically w/ TRAP
!******************************************************
VAR intnum SM_int;
PERS num timer;
PERS num cur_piece;

PERS num total_pieces;
PERS num finish_time;
VAR clock smClock;


!************************************************************
PROC main()
    ClkStart smClock;
    total_pieces:= dim(allPlacePoints,1);       !array of placing targets
    
    CONNECT SM_int WITH SM_update;              !connect interrupt w/ Trap
    ITimer 1.0, SM_int;                         !trigger interrupt every 1 sec
    
    Pick_and_Place;
    finish_time:= ClkRead(smClock);             !read clock at process end
ENDPROC
      
TRAP SM_update
    timer := ClkRead(smClock);                  !read process timer
    cur_piece:= nCurrentPoint;                  !find current piece iin list
ENDTRAP      




ENDMODULE