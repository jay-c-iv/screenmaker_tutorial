MODULE ACT_ScreenMaker_Tutorial
    
!******************************************************
!               ScreenMaker Set-Up    
!******************************************************
!             add variables to bind to
!******************************************************

PERS num total_pieces;
PERS num finish_time;

VAR clock smClock;


!************************************************************
PROC main()
    ClkStart smClock;
    total_pieces:= dim(allPlacePoints,1);       !array of placing targets
    
    Pick_and_Place;

    finish_time:= ClkRead(smClock);             !read clock at process end
ENDPROC
      
      




ENDMODULE