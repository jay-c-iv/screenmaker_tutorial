MODULE ACT_ScreenMaker_Tutorial
    
!******************************************************
!               ScreenMaker Set-Up    
!******************************************************
!             boolean switched by CheckBox
!******************************************************
PERS bool ConfJ_on;
PERS bool ConfL_on;

PERS num cur_velocity;
PERS num ref_velocity;
PERS robtarget cur_target;
PERS pos cur_pos;
PERS num wait := 1;
VAR intnum SM_int;
PERS num timer;
PERS num cur_piece;
PERS num total_pieces;
PERS num finish_time;
VAR clock smClock;


!************************************************************
PROC main()
    IF ConfJ_on THEN
        ConfJ\On;
    ELSE ConfJ\Off;
    ENDIF
    
    IF ConfL_on THEN
        ConfL\On;
    ELSE ConfL\Off;
    ENDIF
    
    
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
     cur_target:= crobt(\WObj:=cur_wobj);       !read current robot position
     cur_pos:= [cur_target.trans.x,             
                            cur_target.trans.y,
                            cur_target.trans.z]; !coordinates of robot position
                            
    cur_velocity:= round(aoutput(aoTCPspeed)\Dec:=1)*1000;  
    ref_velocity:= round(aoutput(aoTCPspeed_Ref)\Dec:=1)*1000;  
ENDTRAP      




ENDMODULE