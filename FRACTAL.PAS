Program Dialog_Test (input,output);

{$I gemsubs.pas}
{$I auxsubs.pas}
{$I sirisubs.pas}
{$I screens.pas}
{$I resorce.pas}

Const
 mandel=1;
 rrandomm=2;
 
Type

  my_integer = 0..2000;

  Chunk = record
            coor_x:integer;
            coor_y:integer;
            coor_dep:my_integer;
            Max_Val:my_integer;
            Min_Val:my_integer;
            Val1:real;
            Val2:real;
            Val3:real;
            Val4:real;
            littlechunk : array [0..319,0..199] of my_integer;
            levels : array [0..16] of my_integer;
          end;

  Chunk_File = File of Chunk;

  err_array = array [-67..11] of Str255;

Var
  error_numbers: err_array;

  alert, pushed: short_integer;
  RealUpper, RealLower, ImagUpper, ImagLower: Real;  
  ChunkRec1, ChunkRec2: Chunk;
  pic_scrn1, pic_scrn2: Screen_Type;
  x_ax, y_ax, dep: my_integer;
  str_x_ax, str_y_ax, str_dep: Str255;
  pic_on_1, pic_on_2: byte;
  do_frac,break_out: byte;
  
  zoomx, zoomy, zoomx_two, zoomy_two: short_integer;

  Big_File: Chunk_File;
  pic_name,data_name,def_path,dat_path: Path_Name;
  pic_error: Short_Integer;
 
  {coor_box}
  ur_add, ur_sub, ur_add_exp, ur_sub_exp, lr_add, lr_sub, lr_add_exp,
  lr_sub_exp, ui_add, ui_sub, ui_add_exp, ui_sub_exp, li_add, li_sub,
  li_add_exp, li_sub_exp: short_integer;
  str_realupper, str_realupperexp, str_reallower, str_reallowerexp,
  str_imagupper, str_imagupperexp, str_imaglower, str_imaglowerexp: Str255;
  ur_val_sign, lr_val_sign, ui_val_sign, li_val_sign: integer;
  ur_val_exp, lr_val_exp, ui_val_exp, li_val_exp: integer;

{*************************************************************************}

Procedure Set_Error_Messages;

Begin
  error_numbers[-67]:='Setblock Failure';
  error_numbers[-66]:='Invalid program load format';
  error_numbers[-65]:='Internal error';
  error_numbers[-64]:='Range error';
  error_numbers[-49]:='No more files';
  error_numbers[-46]:='Invalid drive';
  error_numbers[-40]:='Invalid memory block address';
  error_numbers[-39]:='Insufficient memory';
  error_numbers[-36]:='Access denied';
  error_numbers[-35]:='Too many open files';
  error_numbers[-34]:='Path not found';
  error_numbers[-33]:='File not found';
  error_numbers[-32]:='Invalid function number';
  error_numbers[-17]:='Disk change';
  error_numbers[-16]:='Bad sectors on format';
  error_numbers[-15]:='Unknown device';
  error_numbers[-14]:='Medium change';
  error_numbers[-13]:='Write protect';
  error_numbers[-12]:='General error';
  error_numbers[-11]:='Read error';
  error_numbers[-10]:='Write error';
  error_numbers[-9]:='No paper';
  error_numbers[-8]:='Sector not found';
  error_numbers[-7]:='Unkown medium';
  error_numbers[-6]:='Seek error';
  error_numbers[-5]:='Bad request';
  error_numbers[-4]:='CRC error';
  error_numbers[-3]:='Unkown error';
  error_numbers[-2]:='Drive not ready';
  error_numbers[-1]:='Fundamental TOS system error';
  error_numbers[1]:='Input past end of file';
  error_numbers[2]:='Reset required prior to input';
  error_numbers[3]:='Rewrite required';
  error_numbers[8]:='Reading number overflow';
  error_numbers[9]:='Bad file name';
  error_numbers[10]:='Bad digit in reading Real';
  error_numbers[11]:='Error during Real Read';
End;

{*************************************************************************}

Procedure Put_In_Coors;

Var
  temp_string: Str255;

Begin
  writeV (temp_string,RealUpper);
  Set_DText (big_box,num_real_x,temp_string,3,TE_Center);
  writeV (temp_string,RealLower);
  Set_DText (big_box,num_real_y,temp_string,3,TE_Center);
  writeV (temp_string,ImagUpper);
  Set_DText (big_box,num_imag_x,temp_string,3,TE_Center);
  writeV (temp_string,ImagLower);
  Set_DText (big_box,num_imag_y,temp_string,3,TE_Center);
End;

{*************************************************************************}

Procedure Mouse_Pause(what_button: short_integer);

Var
  msg: Message_Buffer;
  dummy, pause_push: short_integer;
  pause_button: short_integer;
  
Begin
  Repeat
    pause_button:= Get_Event (E_button|E_Timer,
                              2, -1, -1, 0,
                              false,0,0,0,0,
                              false,0,0,0,0,
                              msg,dummy,pause_push,dummy,
                              dummy,dummy,dummy);
  Until (pause_push=what_button);
End;

{*************************************************************************}

Procedure Set_Starting_Levels;

Var
  i: integer;
  k, constant: real;

Begin
  constant:=dep/16;
  k:=0;
  For i:=0 to 16 do Begin
    ChunkRec1.Levels [i]:=round(k); 
    ChunkRec2.Levels [i]:=round(k); 
    k:=k+constant;  
  End;
End;

{*************************************************************************}

Function Do_View (text1,text2,text3:Str255):short_integer;

Var
  i:short_integer;
  
Begin
  Set_DText (view_box,tline_1,text1,3,TE_Center);
  Set_DText (view_box,tline_2,text2,3,TE_Center);
  Set_DText (view_box,tline_3,text3,3,TE_Center);
  i:=Do_Dialog (view_box,0);
  If i=v1_button then Obj_SetState (view_box,v1_button,Normal,false);
  If i=v2_button then Obj_SetState (view_box,v2_button,Normal,false);
  If i=can_button then Obj_SetState (view_box,can_button,Normal,false);
  Do_View:=i;
End;

{*************************************************************************}

Procedure Set_Scrn_Data;

Var
  temp_string: Str255;
  i: integer;

Begin
  do_frac:=mandel;
  IO_Check (false);
  Set_Error_Messages;  
  ur_val_sign:=1;
  lr_val_sign:=-1;
  ui_val_sign:=1;
  li_val_sign:=-1;
  ur_val_exp:=-1;
  lr_val_exp:=1;
  ui_val_exp:=1;
  li_val_exp:=1;
  x_ax:=319;
  str_x_ax:='319';
  y_ax:=199;
  str_y_ax:='199';
  dep:=255;
  str_dep:='255';
  RealUpper:=0.8;
  Reallower:=-1.8;
  ImagUpper:=1.3;
  ImagLower:=-1.3;
  Put_In_Coors;
   str_realupper:='80000000000';
   str_realupperexp:='01';
   str_reallower:='18000000000';
   str_reallowerexp:='00';
   str_imagupper:='13000000000';
   str_imagupperexp:='00';
   str_imaglower:='13000000000';
   str_imaglowerexp:='00';
   dat_path:='A:\*.FRC';
   def_path:='A:\*.PI1';
   Set_Starting_Levels;
  For i:=0 to 16 do Begin
    WriteV (temp_string,ChunkRec1.Levels[i]);
    Set_DText (levels_box,numbers1[i],temp_string,3,TE_Left);
    WriteV (temp_string,ChunkRec2.Levels[i]);
    Set_DText (levels_box,numbers2[i],temp_string,3,TE_Right);
  End;
  Obj_SetState(big_box,set_auto,disabled,false);
  Obj_SetState(big_box,oth_opt,disabled,false); 
End;

{*************************************************************************}

Procedure Coordinate_Box;

Var
  pushed_coor: short_integer;
  display_string: Str255;

Begin
  pushed_coor:=Do_Dialog (coor_box, ur_numb);
  If (pushed_coor<>coor_ok) and (pushed_coor<>coor_cancel) then

  Repeat
  If pushed_coor=ur_sign then
    Begin
      ur_val_sign:=ur_val_sign*(-1);
      If ur_val_sign<0 then
        Set_DText (coor_box, ur_sign, '-',3,TE_Center)
      Else
        Set_DText (coor_box, ur_sign, '+',3,TE_Center);
      Obj_SetState (coor_box, ur_sign, normal, true);
      Obj_ReDraw (coor_box,ur_sign);
    End;

  If pushed_coor=ur_sign_exp then
    Begin
      ur_val_exp:=ur_val_exp*(-1);
      If ur_val_exp<0 then
        Set_DText (coor_box, ur_sign_exp, '-',3,TE_Center)
      Else
        Set_DText (coor_box, ur_sign_exp, '+',3,TE_Center);
      Obj_SetState (coor_box, ur_sign_exp, normal, true);
      Obj_ReDraw (coor_box,ur_sign_exp);
    End;
     
  If pushed_coor=lr_sign then
    Begin
      lr_val_sign:=lr_val_sign*(-1);
      If lr_val_sign<0 then
        Set_DText (coor_box, lr_sign, '-',3,TE_Center)
      Else
        Set_DText (coor_box, lr_sign, '+',3,TE_Center);
      Obj_SetState (coor_box, lr_sign, normal, true);
      Obj_ReDraw (coor_box,lr_sign);
    End;

  If pushed_coor=lr_sign_exp then
    Begin
      lr_val_exp:=lr_val_exp*(-1);
      If lr_val_exp<0 then
        Set_DText (coor_box, lr_sign_exp, '-',3,TE_Center)
      Else
        Set_DText (coor_box, lr_sign_exp, '+',3,TE_Center);
      Obj_SetState (coor_box, lr_sign_exp, normal, true);
      Obj_ReDraw (coor_box,lr_sign_exp);
    End;

  If pushed_coor=ui_sign then
    Begin
      ui_val_sign:=ui_val_sign*(-1);
      If ui_val_sign<0 then
        Set_DText (coor_box, ui_sign, '-',3,TE_Center)
      Else
        Set_DText (coor_box, ui_sign, '+',3,TE_Center);
      Obj_SetState (coor_box, ui_sign, normal, true);
      Obj_ReDraw (coor_box,ui_sign);
    End;

  If pushed_coor=ui_sign_exp then
    Begin
      ui_val_exp:=ui_val_exp*(-1);
      If ui_val_exp<0 then
        Set_DText (coor_box, ui_sign_exp, '-',3,TE_Center)
      Else
        Set_DText (coor_box, ui_sign_exp, '+',3,TE_Center);
      Obj_SetState (coor_box, ui_sign_exp, normal, true);
      Obj_ReDraw (coor_box,ui_sign_exp);
    End;

  If pushed_coor=li_sign then
    Begin
      li_val_sign:=li_val_sign*(-1);
      If li_val_sign<0 then
        Set_DText (coor_box, li_sign, '-',3,TE_Center)
      Else
        Set_DText (coor_box, li_sign, '+',3,TE_Center);
      Obj_SetState (coor_box, li_sign, normal, true);
      Obj_ReDraw (coor_box,li_sign);
    End;

  If pushed_coor=li_sign_exp then
    Begin
      li_val_exp:=li_val_exp*(-1);
      If li_val_exp<0 then
        Set_DText (coor_box, li_sign_exp, '-',3,TE_Center)
      Else
        Set_DText (coor_box, li_sign_exp, '+',3,TE_Center);
      Obj_SetState (coor_box, li_sign_exp, normal, true);
      Obj_ReDraw (coor_box,li_sign_exp);
    End;

  pushed_coor:=Redo_Dialog (coor_box, ur_numb);
  Until (pushed_coor=coor_ok) or (pushed_coor=coor_cancel);

      If pushed_coor=coor_ok then Begin
        Get_DEdit (coor_box, ur_numb, str_realupper);
        Get_DEdit (coor_box, ur_exp, str_realupperexp);
        RealUpper:=Str255_Cplx (str_realupper, str_realupperexp,
				ur_val_sign, ur_val_exp);
        Get_DEdit (coor_box, lr_numb, str_reallower);
        Get_DEdit (coor_box, lr_exp, str_reallowerexp);
        RealLower:=Str255_Cplx (str_reallower, str_reallowerexp,
        			lr_val_sign,lr_val_exp);
        Get_DEdit (coor_box, ui_numb, str_imagupper);
        Get_DEdit (coor_box, ui_exp, str_imagupperexp);
        ImagUpper:=Str255_Cplx (str_imagupper, str_imagupperexp,
        			ui_val_sign, ui_val_exp);
        Get_DEdit (coor_box, li_numb, str_imaglower);
        Get_DEdit (coor_box, li_exp, str_imaglowerexp);
        ImagLower:=Str255_Cplx (str_imaglower, str_imaglowerexp,
        			li_val_sign, li_val_sign);
        			
      End
      Else Begin
        Set_DText (coor_box, ur_numb, str_realupper,3,TE_Center);
        Set_DText (coor_box, ur_exp, str_realupperexp,3,TE_Center);
        Set_DText (coor_box, lr_numb, str_reallower,3,TE_Center);
        Set_DText (coor_box, lr_exp, str_reallowerexp,3,TE_Center);
        Set_DText (coor_box, ui_numb, str_imagupper,3,TE_Center);
        Set_DText (coor_box, ui_exp, str_imagupperexp,3,TE_Center);
        Set_DText (coor_box, li_numb, str_imaglower,3,TE_Center);
        Set_DText (coor_box, li_exp, str_imaglowerexp,3,TE_Center);
      End;
      End_Dialog (coor_box);

      Put_In_Coors;

      Show_Mouse;
      If pushed_coor=coor_ok then
        Begin
          Obj_SetState (coor_box, coor_ok, normal, false);
          {type out the data}
        End
        Else
          Obj_SetState (coor_box, coor_cancel, normal, false);
End;      

{*************************************************************************}

Procedure Use_Data_Box_1;

Var
  pushed_1, choice: short_integer;
  temp: Str255;

Begin
    If pic_on_1=1 then
    Begin
      Set_DText (info_box_1,title_text_1,'Screen 1 Parameters',3,TE_Center);
      Set_DText (info_box_1,map_name_1,'        ',3,TE_Center);
      WriteV (temp,ChunkRec1.Val1);
      Set_DText (info_box_1,up_re_1,temp,3,TE_Center);
      WriteV (temp,ChunkRec1.Val2);
      Set_DText (info_box_1,lw_re_1,temp,3,TE_Center);
      WriteV (temp,ChunkRec1.Val3);
      Set_DText (info_box_1,up_im_1,temp,3,TE_Center);
      WriteV (temp,ChunkRec1.Val4);
      Set_DText (info_box_1,lw_im_1,temp,3,TE_Center);
      WriteV (temp,ChunkRec1.Max_Val);
      Set_DText (info_box_1,max_pt_1,temp,3,TE_Center);
      WriteV (temp,ChunkRec1.Min_Val);
      Set_DText (info_box_1,min_pt_1,temp,3,TE_Center);
      pushed_1:=Do_Dialog (info_box_1,0);
      Obj_SetState (info_box_1,ok_but_1,Normal,False);
      Obj_SetState (info_box_1,can_but_1,Normal,False);
      End_Dialog (info_box_1);
    End
    Else
      choice:=Do_Alert ('[0][ There is no data to show.     ][ OK ]',1);
End;

{*************************************************************************}

Procedure Use_Data_Box_2;

Var
  pushed_1, choice: short_integer;
  temp: Str255;

Begin
    If pic_on_2=1 then
    Begin
      Set_DText (info_box_1,title_text_1,'Screen 2 Parameters',3,TE_Center);
      Set_DText (info_box_1,map_name_1,'        ',3,TE_Center);
      WriteV (temp,ChunkRec2.Val1);
      Set_DText (info_box_1,up_re_1,temp,3,TE_Center);
      WriteV (temp,ChunkRec2.Val2);
      Set_DText (info_box_1,lw_re_1,temp,3,TE_Center);
      WriteV (temp,ChunkRec2.Val3);
      Set_DText (info_box_1,up_im_1,temp,3,TE_Center);
      WriteV (temp,ChunkRec2.Val4);
      Set_DText (info_box_1,lw_im_1,temp,3,TE_Center);
      WriteV (temp,ChunkRec2.Max_Val);
      Set_DText (info_box_1,max_pt_1,temp,3,TE_Center);
      WriteV (temp,ChunkRec2.Min_Val);
      Set_DText (info_box_1,min_pt_1,temp,3,TE_Center);
      pushed_1:=Do_Dialog (info_box_1,0);
      Obj_SetState (info_box_1,ok_but_1,Normal,False);
      Obj_SetState (info_box_1,can_but_1,Normal,False);
      End_Dialog (info_box_1);
    End
    Else
      choice:=Do_Alert ('[0][ There is no data to show.     ][ OK ]',1);
End;

{*************************************************************************}

Function Check_IO: short_integer;

Var
  choice,b: Short_Integer;

Begin
  b:=IO_Result;
  if b <> 0 then
    Begin
      Set_Mouse (M_Arrow);
      Set_DText (alrt_dilg,problem_line,error_numbers[b],3,TE_Center);
      choice:=Do_Dialog (alrt_dilg,0);
      End_Dialog (alrt_dilg);
    End;
  Check_IO:=b;
End;
      
{*************************************************************************}

Procedure Generate(choice:integer);

Var
  RealPart,Imaginary,ZR,ZI,StepX,StepY,ZrSquared,ZISquared : real;
  N, Xpic, Ypic: integer;  
  high_val, low_val: my_integer;

Begin
  high_val:=0;
  low_val:={dep}255+1;
  Break_Out:=0;
  StepX := (RealUpper-RealLower)/(x_ax+1);
  StepY := (ImagUpper-Imaglower)/(y_ax+1);
  For Xpic := 0 to x_ax do begin
    For Ypic := 0 to y_ax do begin
      Line_Color (pall[15]);
      Plot (Xpic,Ypic);
      N := 0;
      ZR := 0;
      ZI := 0;
      RealPart := RealLower+Xpic*StepX;
      Imaginary := ImagLower+Ypic*StepY;
      ZrSquared := 0;
      ZISquared := 0;
      repeat
        ZI := ZI*ZR*2+imaginary;
        Zr := ZrSquared+RealPart-ZISquared;
        N := N+1;
        ZrSquared := Sqr(Zr);
        ZISquared := Sqr(ZI);
      If keypress then Begin
        Show_Mouse;
        choice:=Do_Alert ('[0][Are you sure you want to quit?     ][ Quit | Continue ]',2);
        If choice=1 then Begin
           n:=dep;
           Xpic:=x_ax;
           Ypic:=y_ax;
           Break_Out:=1;
           Hide_Mouse;
        End
        Else
           Hide_Mouse;
      End;
      until ((ZrSquared+ZISquared)>4) or (N>dep-1);
      {If choice=1 then Begin
        If (N>=ChunkRec1.Levels[15]) and (N<ChunkRec1.Levels[14]) then
          Line_Color (pall[0])
        Else If N>=ChunkRec1.Levels[14] then
          Line_Color (pall[1])
        Else If N>=ChunkRec1.Levels[13] then
          Line_Color (pall[2])
        Else If N>=ChunkRec1.Levels[12] then
          Line_Color (pall[3])
        Else If N>=ChunkRec1.Levels[11] then
          Line_Color (pall[4])
        Else If N>=ChunkRec1.Levels[10] then
          Line_Color (pall[5])
        Else If N>=ChunkRec1.Levels[9] then
          Line_Color (pall[6])
        Else If N>=ChunkRec1.Levels[8] then
          Line_Color (pall[7])
        Else If N>=ChunkRec1.Levels[7] then
          Line_Color (pall[8])
        Else If N>=ChunkRec1.Levels[6] then
          Line_Color (pall[9])
        Else If N>=ChunkRec1.Levels[5] then
          Line_Color (pall[10])
        Else If N>=ChunkRec1.Levels[4] then
          Line_Color (pall[11])
        Else If N>=ChunkRec1.Levels[3] then
          Line_Color (pall[12])
        Else If N>=ChunkRec1.Levels[2] then
          Line_Color (pall[13])
        Else If N>=ChunkRec1.Levels[1] then
          Line_Color (pall[14])
        Else If N>=ChunkRec1.Levels[0] then
          Line_Color (pall[15]);
      End;
      If choice=2 then Begin
        If (N>=ChunkRec2.Levels[15]) and (N<ChunkRec2.Levels[14]) then
          Line_Color (pall[0])
        Else If N>=ChunkRec2.Levels[14] then
          Line_Color (pall[1])
        Else If N>=ChunkRec2.Levels[13] then
          Line_Color (pall[2])
        Else If N>=ChunkRec2.Levels[12] then
          Line_Color (pall[3])
        Else If N>=ChunkRec2.Levels[11] then
          Line_Color (pall[4])
        Else If N>=ChunkRec2.Levels[10] then
          Line_Color (pall[5])
        Else If N>=ChunkRec2.Levels[9] then
          Line_Color (pall[6])
        Else If N>=ChunkRec2.Levels[8] then
          Line_Color (pall[7])
        Else If N>=ChunkRec2.Levels[7] then
          Line_Color (pall[8])
        Else If N>=ChunkRec2.Levels[6] then
          Line_Color (pall[9])
        Else If N>=ChunkRec2.Levels[5] then
          Line_Color (pall[10])
        Else If N>=ChunkRec2.Levels[4] then
          Line_Color (pall[11])
        Else If N>=ChunkRec2.Levels[3] then
          Line_Color (pall[12])
        Else If N>=ChunkRec2.Levels[2] then
          Line_Color (pall[13])
        Else If N>=ChunkRec2.Levels[1] then
          Line_Color (pall[14])
        Else If N>=ChunkRec2.Levels[0] then
          Line_Color (pall[15]);
        End;}
        
      Line_Color (pall[round((dep-1-N)/(dep/15))]);
      Plot ( Xpic,Ypic );
      If choice=1 then
        ChunkRec1.LittleChunk [Xpic,Ypic] := N;
      If choice=2 then
        ChunkRec2.LittleChunk [Xpic,Ypic] := N;
      If N>high_val then high_val:=N;
      If N<low_val then low_val:=N;
    end;
  end;
  If Break_Out<>1 then
  If choice=1 then
    Begin
      pic_on_1:=1;
      ChunkRec1.Max_Val := high_val;
      ChunkRec1.Min_Val := low_val;
      ChunkRec1.Val1 := RealUpper;
      ChunkRec1.Val2 := RealLower;
      ChunkRec1.Val3 := ImagUpper;
      ChunkRec1.Val4 := ImagLower;
      ChunkRec1.Coor_Dep := dep;
      ChunkRec1.coor_x := x_ax;
      ChunkRec1.coor_y := y_ax;
    End
  Else
    Begin
      pic_on_2:=1;
      ChunkRec2.Max_Val := high_val;
      ChunkRec2.Min_Val := low_val;
      ChunkRec2.Val1 := RealUpper;
      ChunkRec2.Val2 := RealLower;
      ChunkRec2.Val3 := ImagUpper;
      ChunkRec2.Val4 := ImagLower;
      ChunkRec2.Coor_Dep := dep;
      ChunkRec2.coor_x := x_ax;
      ChunkRec2.coor_y := y_ax;
    End;
End;

{*************************************************************************}

{*************************************************************************}

Procedure Create (choice: short_integer);

Var
  i,j,numb_levels,power,start_diff,start,jump,x,y,diffx,diffy,diff:integer;
  heights,event, mx, my, level, high, low: integer;
  delta:real;  
 
Begin
  Clear_Screen;
  If choice=1 then Begin
    ChunkRec1.littlechunk[0,0]:=trunc(random*4);
    ChunkRec1.littlechunk[0,128]:=trunc(random*4);
    ChunkRec1.littlechunk[128,0]:=trunc(random*4);
    ChunkRec1.littlechunk[128,128]:=trunc(random*4);
    ChunkRec1.littlechunk[0,64]:=trunc(random*4);
    ChunkRec1.littlechunk[64,0]:=trunc(random*4);
    ChunkRec1.littlechunk[128,64]:=trunc(random*4);
    ChunkRec1.littlechunk[64,128]:=trunc(random*4);
    ChunkRec1.littlechunk[64,64]:=trunc(random*4);
    level:=1;
    start_diff:=64;
    Repeat
      Obj_SetState (prog_box,prog_level[level],Selected,False);
      Show_Dialog (prog_box,0);
      jump:=start_diff;
      start:=trunc(jump/2);
      y:=0;
      Repeat
        x:=start;
        Repeat
          ChunkRec1.littlechunk[x,y]:=round((ChunkRec1.littlechunk[x-start,y]+ChunkRec1.littlechunk[x+start,y])/2)
                     +round(Random*(start_diff/8+0.5));
          x:=x+jump;
        Until x>128;
        y:=y+jump;
      Until y>128;
      x:=0;
      Repeat
        y:=start;
        Repeat
          ChunkRec1.littlechunk[x,y]:=round((ChunkRec1.littlechunk[x,y-start]+ChunkRec1.littlechunk[x,y+start])/2)
                     +round(Random*(start_diff/8+0.5));
          y:=y+jump;
        Until y>128;
        x:=x+jump;
      until x>128;

      y:=start_diff;
      diffx:=trunc(start_diff/2);
      diffy:=trunc(start_diff/2);
      Repeat
        x:=start_diff;
        Repeat
          ChunkRec1.littlechunk[x-diffx,y-diffy]:=round((ChunkRec1.littlechunk[x,y]
                                  +ChunkRec1.littlechunk[x-start_diff,y]
                                  +ChunkRec1.littlechunk[x,y-start_diff]
                                  +ChunkRec1.littlechunk[x-start_diff,y-start_diff])
                                  /4)+round(Random*(start_diff/8+0.5));
          x:=x+start_diff;  
        Until x>128;      
        y:=y+start_diff;
      Until y>128;
      start_diff:=trunc(start_diff/2);
      level:=level+1;
    Until start_diff=1;
    
    Obj_SetState (prog_box,create_oce,selected,false);
    Show_Dialog (prog_box,0);
    For i:=0 to 128 do 
      For j:=0 to 128 do
        If ChunkRec1.littlechunk[j,i]>0 then Begin
          ChunkRec1.littlechunk[j,i]:=0;
          If i<>128 then
            ChunkRec1.littlechunk[j,i+1]:=0;
          If j<>128 then
            ChunkRec1.littlechunk[j+1,i]:=0;
          If j<>0 then
            ChunkRec1.littlechunk[j-1,i]:=0;
          If i<>0 then
            ChunkRec1.littlechunk[j,i-1]:=0;
        End;
    
    Obj_SetState (prog_box,calc_hi,selected,false);
    Show_Dialog (prog_box,0);
    low:=100;
    high:=0;
    For j:=0 to 128 do Begin
      For i:=0 to 128 do Begin
        heights:=ChunkRec1.littlechunk[i,j];
        if heights>high then high:=heights;
        if heights<low then low:=heights;
      End;
    End;
    ChunkRec1.max_val:=high;
    ChunkRec1.min_val:=low;
    pic_on_1:=0;
    End_Dialog (prog_box);
    Clear_screen;
    delta:=(high-low)/13;
    For i:=0 to 128 do Begin
      For j:=0 to 128 do Begin
        If ChunkRec1.littlechunk[i,j]=0 then 
          Line_Color(1)
        else
          Line_Color(trunc((chunkrec1.littlechunk[i,j]-low)/delta)+2);  
        Plot (i,j);
      End;
    End;
  End;

  If choice=2 then Begin
    ChunkRec2.littlechunk[0,0]:=trunc(random*4);
    ChunkRec2.littlechunk[0,128]:=trunc(random*4);
    ChunkRec2.littlechunk[128,0]:=trunc(random*4);
    ChunkRec2.littlechunk[128,128]:=trunc(random*4);
    ChunkRec2.littlechunk[0,64]:=trunc(random*4);
    ChunkRec2.littlechunk[64,0]:=trunc(random*4);
    ChunkRec2.littlechunk[128,64]:=trunc(random*4);
    ChunkRec2.littlechunk[64,128]:=trunc(random*4);
    ChunkRec2.littlechunk[64,64]:=trunc(random*4);
    level:=1;
    start_diff:=64;
    Repeat
      Obj_SetState (prog_box,prog_level[level],Selected,True);
      Show_Dialog (prog_box,0);
      jump:=start_diff;
      start:=trunc(jump/2);
      y:=0;
      Repeat
        x:=start;
        Repeat
          ChunkRec2.littlechunk[x,y]:=round((ChunkRec2.littlechunk[x-start,y]+ChunkRec2.littlechunk[x+start,y])/2)
                     +round(Random*(start_diff/8+0.5));
          x:=x+jump;
        Until x>128;
        y:=y+jump;
      Until y>128;
      x:=0;
      Repeat
        y:=start;
        Repeat
          ChunkRec2.littlechunk[x,y]:=round((ChunkRec2.littlechunk[x,y-start]+ChunkRec2.littlechunk[x,y+start])/2)
                     +round(Random*(start_diff/8+0.5));
          y:=y+jump;
        Until y>128;
        x:=x+jump;
      until x>128;

      y:=start_diff;
      diffx:=trunc(start_diff/2);
      diffy:=trunc(start_diff/2);
      Repeat
        x:=start_diff;
        Repeat
          ChunkRec2.littlechunk[x-diffx,y-diffy]:=round((ChunkRec2.littlechunk[x,y]
                                  +ChunkRec2.littlechunk[x-start_diff,y]
                                  +ChunkRec2.littlechunk[x,y-start_diff]
                                  +ChunkRec2.littlechunk[x-start_diff,y-start_diff])
                                  /4)+round(Random*(start_diff/8+0.5));
          x:=x+start_diff;  
        Until x>128;      
        y:=y+start_diff;
      Until y>128;
      start_diff:=trunc(start_diff/2);
      level:=level+1;
    Until start_diff=1;

    Obj_SetState (prog_box,create_oce,selected,false);
    Show_Dialog (prog_box,0);
    For i:=0 to 128 do 
      For j:=0 to 128 do
        If ChunkRec2.littlechunk[j,i]>0 then Begin
          ChunkRec2.littlechunk[j,i]:=0;
          If i<>128 then
            ChunkRec2.littlechunk[j,i+1]:=0;
          If j<>128 then
            ChunkRec2.littlechunk[j+1,i]:=0;
          If j<>0 then
            ChunkRec2.littlechunk[j-1,i]:=0;
          If i<>0 then
            ChunkRec2.littlechunk[j,i-1]:=0;
        End;
    
    Obj_SetState (prog_box,calc_hi,selected,false);
    Show_Dialog (prog_box,0);
    low:=100;
    high:=0;
    For j:=0 to 128 do Begin
      For i:=0 to 128 do Begin
        heights:=ChunkRec2.littlechunk[i,j];
        if heights>high then high:=heights;
        if heights<low then low:=heights;
      End;
    End;
    ChunkRec2.max_val:=high;
    ChunkRec2.min_val:=low;
    pic_on_2:=0;
    End_Dialog (prog_box);
    Clear_screen;
    delta:=(high-low)/13;
    For i:=0 to 128 do Begin
      For j:=0 to 128 do Begin
        If ChunkRec2.littlechunk[i,j]=0 then 
          Line_Color(1)
        else
          Line_Color(trunc((chunkrec2.littlechunk[i,j]-low)/delta)+2);  
        Plot (i,j);
      End;
    End;
  End;
End;
{*************************************************************************}

Procedure Do_Plot (frac_type: short_integer);

Var
  choice2, dummy: short_integer;

Begin
  choice2:=Do_View ('Plot onto','which screen?',' ');
  GotoXY (18,0);
  write (choice2);
  If choice2<>3 then
  Begin
    Hide_Mouse;
    Clear_Screen;
    If frac_type=1 then Begin
      Generate(choice2);
      If Break_Out <>1 then Begin
        If choice2=1 then
          Save_Scrn (pic_scrn1);
        If choice2=2 then
          Save_Scrn (pic_scrn2);
      End;
      If Break_Out<>1 then
        dummy:=Do_Alert ('[0][ All Done!    ][ OK ]',1);
    End;
    If frac_type=2 then Begin
      Create (choice2);
      If choice2=1 then
        Save_Scrn (pic_scrn1);
      If choice2=2 then
        Save_Scrn (pic_scrn2);
    End;
    Clear_Screen;
    Show_Mouse;
  End;
End;

{*************************************************************************}

Procedure Zoom_Grid;

Var
  i,dummy,what_button_out_box,key_state: short_integer;
  event_one, event_two, what_button_in_box: short_integer;
  msg: message_buffer;
  
Begin
  what_button_out_box:=1;
  Draw_Mode(3);
    Repeat
      event_one:=Get_Event (E_button|E_Timer,
                        2,-1,-1,0,
                        false,0,0,0,0,
                        false,0,0,0,0,
                        msg,dummy,what_button_in_box,dummy,
                        zoomx,zoomy,
                        key_state);
       Begin
         Hide_Mouse;
         If zoomy>y_ax then zoomy:=y_ax;
         If zoomx>x_ax then zoomx:=x_ax;
         Line (0,zoomy,x_ax,zoomy);
         Line (zoomx,0,zoomx,y_ax);
         Line (0,zoomy,X_ax,zoomy);
         Line (zoomx,0,zoomx,y_ax);
         Show_Mouse;
       End;
    If what_button_in_box=1 then 
      Repeat
        event_two:=Get_Event (E_button|E_Timer,
                           2,-1,-1,0,
                           false,0,0,0,0,
                           false,0,0,0,0,
                           msg,dummy,what_button_out_box,dummy,
                           zoomx_two,zoomy_two,
                           key_state);
         Begin
           Hide_Mouse;
           If zoomy_two>y_ax then zoomy_two:=y_ax;
           If zoomx_two>x_ax then zoomx_two:=x_ax;
           Frame_Rect (zoomx,zoomy,zoomx_two-zoomx,zoomy_two-zoomy);
           Frame_Rect (zoomx,zoomy,zoomx_two-zoomx,zoomy_two-zoomy);
           Show_Mouse;
         End;
       Until (what_button_out_box=0);
    Until (what_button_out_box=0);
    Show_Mouse;
    Draw_Mode (1);
End;

{*************************************************************************}

Function Screen_ConvX (ext,min:real; coord,x_conv:integer): real;

Begin
  Screen_ConvX:=((abs(ext-min)*coord)/(x_conv+1))+min;
End;  

{*************************************************************************}

Function Screen_ConvY (ext,min:real; coord,y_conv:integer): real;

Begin
  Screen_ConvY:=((abs(ext-min)*coord)/(y_conv+1))+min;
End;  

{*************************************************************************}

Procedure Do_Zoom;

Var
  choice: short_integer;

Begin
    choice:=Do_View ('Magnify','which screen?',' ');
    If ((choice=1) and (pic_on_1=0)) or ((choice=2) and (pic_on_2=0)) then
      alert:=Do_Alert ('[0][ You may not magnify     |  a percpective or |   blank screen! ][ Sorry! ]',1)
    Else
    IF (choice=1) or (choice=2) then Begin
      Set_Usage_Pallet;
      Hide_Mouse;
      If (choice=1) and (pic_on_1=1) then
        Restr_Scrn (pic_scrn1)
      Else
        Restr_Scrn (pic_scrn2);
      Zoom_Grid;
      If (choice=1) and (pic_on_1=1) then
      Begin
        RealUpper:=Screen_ConvX (ChunkRec1.Val1, ChunkRec1.Val2, zoomx_two, ChunkRec1.coor_x);
        RealLower:=Screen_ConvX (ChunkRec1.Val1, ChunkRec1.Val2, zoomx, ChunkRec1.coor_x);
        ImagUpper:=Screen_ConvY (ChunkRec1.Val3, ChunkRec1.Val4, zoomy_two, ChunkRec1.coor_y);
        ImagLower:=Screen_ConvY (ChunkRec1.Val3, ChunkRec1.Val4, zoomy, ChunkRec1.coor_y);
      End
      Else
      Begin
        RealUpper:=Screen_ConvX (ChunkRec2.Val1, ChunkRec2.Val2, zoomx_two, ChunkRec2.coor_x);
        RealLower:=Screen_ConvX (ChunkRec2.Val1, ChunkRec2.Val2, zoomx, ChunkRec2.coor_x);
        ImagUpper:=Screen_ConvY (ChunkRec2.Val3, ChunkRec2.Val4, zoomy_two, ChunkRec2.coor_y);
        ImagLower:=Screen_ConvY (ChunkRec2.Val3, ChunkRec2.Val4, zoomy, ChunkRec2.coor_y);
      End;
      Put_In_Coors;
      Clear_Screen;
      Use_Usage_Pallet;
    End;
End;  

{*************************************************************************}

Procedure Save_Comp (choice: short_integer);

Var
  d,alert_choice: short_integer;

Begin
  If (pic_on_1=1) or (pic_on_2=1) then Begin
      If Get_In_File (dat_path,data_name) then
        Set_Mouse (M_Bee);
        Begin
        rewrite (Big_File,data_name);
        If (choice=1) and (pic_on_1=1) then begin
          big_file^:=ChunkRec1;
          put (big_file);
        End
        Else if (choice=2) and (pic_on_2=1) then Begin
          big_file^:=ChunkRec2;
          put (big_file);
        End
        Else
          alert_choice:=Do_Alert ('[0][ The screen you choose is blank!     ][ OK ]',1);
      End;
      Set_Mouse (M_Arrow);
      d:=Check_IO;
  End
  Else
      alert_choice:=Do_Alert ('[0][ The screen you choose is blank!     ][ OK ]',1);
End;

{*************************************************************************}

Procedure Perspective_Plot;

Var
  choice, Xpic, Ypic: integer;
  
Begin
  choice:=Do_View ('Plot','which screen?',' ');
  If (choice=1) and (pic_on_1=0) then
      choice:=4;
  If (choice=2) and (pic_on_2=0) then
      choice:=4;
  If choice<3 then
    Begin
      Hide_Mouse;
      Clear_Screen;
      If choice=1 then
        For Ypic:=0 to trunc(ChunkRec1.coor_y/2) do
          For Xpic:=0 to trunc(ChunkRec1.coor_x/2) do
            Begin
              Line_Color (pall[round((ChunkRec1.Coor_Dep-ChunkRec1.LittleChunk [Xpic*2,Ypic*2])/(dep/15))]);
              Plot (Xpic+YPic+40,Ypic-round((ChunkRec1.Coor_Dep-ChunkRec1.LittleChunk [Xpic*2,Ypic*2])/(dep/15))+50);
              Line_Color (pall[0]);
              Line (Xpic+YPic+40,Ypic-round((ChunkRec1.Coor_Dep-ChunkRec1.LittleChunk [Xpic*2,Ypic*2])/(dep/15))+51,
                    Xpic+YPic+40,Ypic+66);
            End;
      If choice=2 then
        For Ypic:=0 to trunc(ChunkRec2.coor_y/2) do
          For Xpic:=0 to trunc(ChunkRec2.coor_x/2) do
            Begin
              Line_Color (pall[round((ChunkRec2.Coor_dep-ChunkRec2.LittleChunk [Xpic*2,Ypic*2])/(dep/15))]);
              Plot (Xpic+YPic+40,Ypic-round((ChunkRec2.Coor_dep-ChunkRec2.LittleChunk [Xpic*2,Ypic*2])/(dep/15))+50);
              Line_Color (pall[0]);
              Line (Xpic+YPic+40,Ypic-round((ChunkRec2.Coor_dep-ChunkRec2.LittleChunk [Xpic*2,Ypic*2])/(dep/15))+51,
                    Xpic+YPic+40,Ypic+66);
            End;
      Show_Mouse;
      choice:=Do_View ('Save onto','which screen?',' ');
      If choice=1 then Begin
        Hide_Mouse;
        Save_Scrn (Pic_Scrn1);
        pic_on_1:=0;
        Show_Mouse;
      End;
      If choice=2 then Begin
        Hide_Mouse;
        Save_Scrn (pic_scrn2);
        pic_on_2:=0;
        Show_Mouse;
      End;
    End;
  If choice=4 then
    choice:=Do_Alert ('[0][ The screen you choose is blank!     ][ OK ]',1);
End;

{*************************************************************************}

Procedure Save_Degas(choice: short_integer);

Var 
  d: Short_Integer;

Begin
    If Get_In_File (def_path,pic_name) then Begin
      Set_Mouse (M_Bee);
      Hide_Mouse;
      Clear_Screen;
      Show_Dialog (big_box,0);
      Show_Mouse;
      If choice=1 then
        pic_error:=Write_Scrn (pic_name,pic_scrn1)
      Else
        pic_error:=Write_Scrn (pic_name,pic_scrn2);
    End;
    Set_Mouse (M_Arrow);
    d:=Check_IO;
End;

{*************************************************************************}

Procedure Save_Dialog;

Var
  d,save_choice, screen_choosen: Short_Integer;
  
Begin
  save_choice:=Do_Dialog (save_options,0);
  If Obj_State (save_options,but_1) = 0 then
    screen_choosen:=2
  else
    screen_choosen:=1;
  If save_choice=save_comp_map then
    Save_Comp (screen_choosen);
  If save_choice=save_degas_pic then
    Save_Degas (screen_choosen);
  Obj_SetState (save_options,save_cancel,normal,false);
  End_Dialog(save_options);
  d:=Check_IO;
End;

{*************************************************************************}

Procedure Load_Comp(choice: short_integer);

Var
  x_incr, y_incr, Xpic, Ypic: integer;
  N: my_integer;

Begin
    Begin
      If Get_In_File (dat_path,data_name) then begin
        Set_Mouse (M_Bee);
        Show_Dialog (big_box,0);
        reset (Big_File,data_name);
        If choice=1 then begin
          ChunkRec1:=Big_File^;
          get (Big_File);
        End
        Else begin
          ChunkRec2:=Big_File^;
          get (Big_File);
        End;
      If Check_IO = 0 then Begin;
        Hide_Mouse;
        Clear_Screen;
        If choice=1 then begin
          x_incr:=ChunkRec1.coor_x;
          y_incr:=ChunkRec1.coor_y;
        End;
        If choice=2 then begin
          x_incr:=ChunkRec2.coor_x;
          y_incr:=ChunkRec2.coor_y;
        End;
        For Xpic:=0 to x_incr do
          For Ypic:=0 to y_incr do
            Begin
                If choice=1 then Begin
                  N:=ChunkRec1.littlechunk[Xpic,Ypic];
                  If (N>=ChunkRec1.Levels[15]) and (N<ChunkRec1.Levels[14]) then
                    Line_Color (pall[0])
                  Else If N>=ChunkRec1.Levels[14] then
                    Line_Color (pall[1])
                  Else If N>=ChunkRec1.Levels[13] then
                    Line_Color (pall[2])
                  Else If N>=ChunkRec1.Levels[12] then
                    Line_Color (pall[3])
                  Else If N>=ChunkRec1.Levels[11] then
                    Line_Color (pall[4])
                  Else If N>=ChunkRec1.Levels[10] then
                    Line_Color (pall[5])
                  Else If N>=ChunkRec1.Levels[9] then
                    Line_Color (pall[6])
                  Else If N>=ChunkRec1.Levels[8] then
                    Line_Color (pall[7])
                  Else If N>=ChunkRec1.Levels[7] then
                    Line_Color (pall[8])
                  Else If N>=ChunkRec1.Levels[6] then
                    Line_Color (pall[9])
                  Else If N>=ChunkRec1.Levels[5] then
                    Line_Color (pall[10])
                  Else If N>=ChunkRec1.Levels[4] then
                    Line_Color (pall[11])
                  Else If N>=ChunkRec1.Levels[3] then
                    Line_Color (pall[12])
                  Else If N>=ChunkRec1.Levels[2] then
                    Line_Color (pall[13])
                  Else If N>=ChunkRec1.Levels[1] then
                    Line_Color (pall[14])
                  Else If N>=ChunkRec1.Levels[0] then
                    Line_Color (pall[15]);
                End;
                If choice=2 then Begin
                  N:=ChunkRec2.littlechunk[Xpic,Ypic];
                  If (N>=ChunkRec2.Levels[15]) and (N<ChunkRec2.Levels[14]) then
                    Line_Color (pall[0])
                  Else If N>=ChunkRec2.Levels[14] then
                    Line_Color (pall[1])
                  Else If N>=ChunkRec2.Levels[13] then
                    Line_Color (pall[2])
                  Else If N>=ChunkRec2.Levels[12] then
                    Line_Color (pall[3])
                  Else If N>=ChunkRec2.Levels[11] then
                    Line_Color (pall[4])
                  Else If N>=ChunkRec2.Levels[10] then
                    Line_Color (pall[5])
                  Else If N>=ChunkRec2.Levels[9] then
                    Line_Color (pall[6])
                  Else If N>=ChunkRec2.Levels[8] then
                    Line_Color (pall[7])
                  Else If N>=ChunkRec2.Levels[7] then
                    Line_Color (pall[8])
                  Else If N>=ChunkRec2.Levels[6] then
                    Line_Color (pall[9])
                  Else If N>=ChunkRec2.Levels[5] then
                    Line_Color (pall[10])
                  Else If N>=ChunkRec2.Levels[4] then
                    Line_Color (pall[11])
                  Else If N>=ChunkRec2.Levels[3] then
                    Line_Color (pall[12])
                  Else If N>=ChunkRec2.Levels[2] then
                    Line_Color (pall[13])
                  Else If N>=ChunkRec2.Levels[1] then
                    Line_Color (pall[14])
                  Else If N>=ChunkRec2.Levels[0] then
                    Line_Color (pall[15]);
                End;
              Plot (Xpic,Ypic);
            End;
          If choice=1 then Begin
            pic_on_1:=1;
            Save_Scrn (pic_scrn1)
          End
          Else Begin
            pic_on_2:=1;
            Save_Scrn (pic_scrn2);
          End;
        Clear_Screen;
        Show_Mouse;
        Set_Mouse (M_Arrow);
      End;
    End;
  End;
End;

{*************************************************************************}

Procedure Load_Dialog;

Var
  load_choice, screen_choosen: short_integer;

Begin
  load_choice:=Do_Dialog (load_options,0);
  GotoXY (20,0);
  write (obj_state(load_options,lbut_1));
  If Obj_State (load_options,lbut_1) = 0 then
    screen_choosen:=2
  else
    screen_choosen:=1;
  If load_choice=load_comp_map then
    load_Comp (screen_choosen);
  Obj_SetState (load_options,load_cancel,normal,false);
  End_Dialog(load_options);
End;

{*************************************************************************}

Procedure Do_Levels;

Var
  use_num,choice,i: short_integer;
  temp_str: Str255;

Begin
  choice:=Do_Dialog (levels_box,0);
  Repeat
    choice:=Redo_Dialog (levels_box,0);
    If choice=go_up then Begin
      If use_num<=255 then
        use_num:=use_num+1;
      WriteV (temp_str,use_num);
      Set_DText (levels_box,set_number,temp_str,3,TE_Center);
      Obj_Redraw (levels_box,set_number);
      Obj_SetState (levels_box,go_up,normal,true);
    End;
  Until (choice=levels_ok) or (choice=levels_cancel); 
  Obj_SetState (levels_box,levels_ok,normal,false);
  Obj_SetState (levels_box,levels_cancel,normal,false);
  End_Dialog (levels_box);  
End;

{*************************************************************************}

Procedure Do_Options;

Var
  choice: short_integer;
  
Begin
  choice:=Do_Dialog (options_box,0);
  if choice=mandle_opt then Begin
    Obj_SetState (big_box,zoom,normal,false);
    Obj_SetFlags (big_box,zoom,Touch_Exit);
    Obj_SetState (big_box,pers,normal,false);
    Obj_SetFlags (big_box,pers,Touch_Exit);
    do_frac:=mandel;
  end;
  if choice=random_opt then Begin
    Obj_SetState (big_box,zoom,disabled,false);
    Obj_SetFlags (big_box,zoom,none);
    Obj_SetState (big_box,pers,disabled,false);
    Obj_SetFlags (big_box,pers,none);
    do_frac:=rrandomm;
  end;
End;

{*************************************************************************}

Procedure Main_Loop;

Begin
      Repeat
        GotoXY (13,0);
        Write ('FRACTAL ENGINE');
        pushed:=Do_Dialog (big_box,0);
        GotoXY (0,0);
        Write (pushed);
        If pushed=coor_button then
            coordinate_box;
        If pushed=save then
            Save_Dialog;
        If pushed=load then
            Load_Dialog;
        If pushed=oth_opt then
            Do_options;
        If pushed=-32757 then
            alert:=Do_Alert ('[0][You doubl save][ ok ]',0);
        If pushed=-32758 then
            alert:=Do_Alert ('[0][You doubl load][ ok ]',0);
        If pushed=view_1 then
            Begin
              Hide_Mouse;
              Clear_Screen;
              Set_Usage_Pallet;
              Restr_Scrn (pic_scrn1);
              Mouse_Pause (1);
              Use_Usage_Pallet;
              Clear_Screen;
              Show_Mouse;
            End;
        If pushed=view_2 then
            Begin
              Hide_Mouse;
              Clear_Screen;
              Set_Usage_Pallet;
              Restr_Scrn (pic_scrn2);
              Mouse_Pause (1);
              Use_Usage_Pallet;
              Clear_Screen;
              Show_Mouse;
            End;
        If pushed=pers then
            Perspective_Plot;
        If pushed=plott then
            Do_Plot (do_frac);
        If pushed=zoom then
            Do_Zoom;
        If pushed=quit then
            alert:=Do_Alert ('[0][  Are you sure you       |   want to quit?     ][ Quit | Cancel ]',2);
        If pushed=-32755 then
            Use_Data_Box_1;
        If pushed=-32754 then
            Use_Data_Box_2;
        If pushed=bkpts then
            Do_Levels;
      until (pushed=quit) and (alert=1);
End;

Begin
  If Init_Gem>=0 then
    If Get_Res=0 then
    Begin
      Init_Mouse;
      Clear_Screen;
      Set_Pallet;
      Get_System_Pallet;
      Set_Pallets;
      Create_Dialogs;
      Set_Scrn_Data;
      Main_Loop;
      Use_System_Pallet;
    End
    Else
      alert:=Do_Alert ('[0][ Wrong Rezolution! | ][ Sorry! ]',1);
  Exit_Gem;
End.
  
