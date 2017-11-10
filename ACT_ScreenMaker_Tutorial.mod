MODULE ACT_ScreenMaker_Tutorial
    
!******************************************************
!               ScreenMaker Set-Up    
!******************************************************
!             create arrays to plot graphs - dynamic
!******************************************************
CONST num graph_steps:= 300;
PERS num graph_array_X{graph_steps};
PERS num graph_array_Y{graph_steps};
VAR num currentarraysize_time:=0;
VAR num currentarraysize_velocity:=0;

PERS num Accel_Perc;
PERS num Jerk_Perc;
PERS num work_object;
PERS num wobj_array{3}:= [1,2,3];
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
    Accel_Perc:= 100;
    Jerk_Perc:= 100;
    
    IF work_object > 0 AND work_object < 2 THEN
        cur_wobj:= Wobj_Left;
        ENDIF
    IF work_object > 1 AND work_object < 23 THEN
        cur_wobj:= Wobj_Center;
        ENDIF
    IF work_object > 2 AND work_object < 4 THEN
        cur_wobj:= Wobj_Right;
        ENDIF
    
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
                            
    cur_velocity:= round(aoutput(aoTCPspeed)\Dec:=1)*1000;      !format signal data
    ref_velocity:= round(aoutput(aoTCPspeed_Ref)\Dec:=1)*1000;  
    
    AccSet Accel_Perc, Jerk_Perc;               !override motion settings
    
    insertelement_time(timer);
    insertelement_velocity(cur_velocity);
        

ENDTRAP      


PROC insertelement_time(num element)
        currentarraysize_time:=currentarraysize_time+1;
        graph_array_X{currentarraysize_time}:=element;
        FOR i FROM currentarraysize_time TO dim(graph_array_X,1) DO
            graph_array_X{i}:= element;
            ENDFOR
        ENDPROC

PROC insertelement_velocity(num element)
        currentarraysize_velocity:=currentarraysize_velocity+1;
        graph_array_Y{currentarraysize_time}:=element;
        FOR i FROM currentarraysize_velocity TO dim(graph_array_Y,1) DO
            graph_array_Y{i}:= element;
            ENDFOR
        ENDPROC        
        
ENDMODULE