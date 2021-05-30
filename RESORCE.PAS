{resorce include file for FRACTAL.PRG}

Type
  color_array = array [0..15] of short_integer;
  levels_array = array [0..16] of short_integer;
  on_level = array [1..6] of short_integer;
    
Var
  big_box: Dialog_Ptr;
  cpallet,pallet: short_integer;
  coor_button, real_x, real_y, imag_x, imag_y, num_real_x, num_real_y,
  oth_opt,set_auto,num_imag_x, num_imag_y, load, save: short_integer;
  lline,bkpts,quit,cbox_0,plott,zoom,pers,view_1,view_2: short_integer;
  color_but: color_array;

  ur_sign, ur_sign_exp, ur_numb, ur_exp, lr_sign, lr_sign_exp,
  lr_numb, lr_exp, ui_sign, ui_sign_exp, ui_numb, ui_exp,
  li_sign, li_sign_exp, li_numb, li_exp: short_integer;
  coor_box:Dialog_Ptr;
  coor_name, up_real_str, lo_real_str, up_img_str: short_integer; 
  lo_img_str, coor_ok, coor_cancel: Short_Integer;

  info_box_1: Dialog_Ptr;
  title_text_1, map_name_str_1, map_name_1, up_re_str_1, up_re_1,
  lw_re_str_1, lw_re_1, up_im_str_1, up_im_1, lw_im_str_1, lw_im_1,
  max_pt_str_1, max_pt_1, min_pt_str_1, min_pt_1, ok_but_1,
  can_but_1: short_integer;

  save_options: Dialog_Ptr;
  save_title, screen_tit, but_1, but_2, save_comp_map, save_raw_data,
  save_degas_pic, save_breakpt, save_colors, save_3D, 
  save_cancel: short_integer;

  load_options: Dialog_Ptr;
  load_title, load_tit, lbut_1, lbut_2, load_comp_map, load_raw_data,
  load_breakpt, load_colors, load_cancel: short_integer;

  alrt_dilg: Dialog_Ptr;
  problem_line, under_prob: Short_Integer;

  l_pallet:short_integer;
  levels_box: Dialog_Ptr;
  color_lev1, color_lev2: color_array;
  numbers1,numbers2: levels_array;  
  set_number,go_up,auto_1,auto_2,levels_ok,levels_cancel: short_integer;
  Str_Lev: Str255;
  up_arrow, down_arrow: char;
  go_down: short_integer;

  view_box: Dialog_Ptr;
  v1_button,v2_button,can_button,tline_1,tline_2,tline_3: short_integer;
  
  options_box: Dialog_Ptr;
  options_title, mandle_opt, random_opt: short_integer;
  
  prog_box: Dialog_Ptr;
  prog_level: On_level;
  str_level: Str255;
  prog_title, create_oce, calc_hi: short_integer;
      
Procedure Create_Dialogs;

Var
  i: integer;

Begin
  up_arrow:=chr(1);
  down_arrow:=chr(2);
  pallet:=D_Color (pall[15],pall[15],true,0,pall[0]);
  big_box:=New_Dialog (36,0,1,40,24);
  lline:=Add_DItem (big_box,G_IBox,None,20,8,0,8,1,pallet);
  real_x:=Add_DItem (big_box,G_String,None,3,2,17,1,0,pallet);
  real_y:=Add_DItem (big_box,G_String,None,3,3,17,1,0,pallet);
  imag_x:=Add_DItem (big_box,G_String,None,3,4,17,1,0,pallet);
  imag_y:=Add_DItem (big_box,G_String,None,3,5,17,1,0,pallet);
  num_real_x:=Add_DItem (big_box,G_String,None,20,2,16,1,0,pallet);
  num_real_y:=Add_DItem (big_box,G_String,None,20,3,16,1,0,pallet);
  num_imag_x:=Add_DItem (big_box,G_String,None,20,4,16,1,0,pallet);
  num_imag_y:=Add_DItem (big_box,G_String,None,20,5,16,1,0,pallet);
  coor_button:=Add_DItem (big_box,G_IBox,Touch_Exit,2,1,36,6,1,
                          pallet);
  load:=Add_DItem (big_box,G_Button,Touch_Exit,2,17,13,2,1,pallet);
  save:=Add_DItem (big_box,G_Button,Touch_Exit,16,17,13,2,1,pallet);
  view_1:=Add_DItem (big_box,G_Button,Touch_Exit,2,8,8,2,1,pallet);
  view_2:=Add_DItem (big_box,G_Button,Touch_Exit,11,8,8,2,1,pallet);  
  pers:=Add_DItem (big_box,G_Button,Touch_Exit,2,11,17,2,1,pallet);
  set_auto:=Add_DItem (big_box,G_Button,Touch_Exit,2,14,17,2,1,pallet);
  oth_opt:=Add_DItem (big_box,G_Button,Touch_Exit,21,14,17,2,1,pallet);
  zoom:=Add_DItem (big_box,G_Button,Touch_Exit,30,8,8,2,1,pallet);
  plott:=Add_DItem (big_box,G_Button,Touch_Exit,21,8,8,2,1,pallet);
  bkpts:=Add_DItem (big_box,G_Button,Touch_Exit,21,11,17,2,1,pallet);
  quit:=Add_DItem (big_box,G_Button,Touch_Exit,30,17,8,2,1,pallet);
  For i:=0 to 15 do Begin
    cpallet:=D_Color (pall[15],pall[15],false,7,pall[i]);
    color_but[i]:=Add_DItem(big_box,G_Box,None,(i*2)+4,20,2,3,1,cpallet);
  End;
  Set_DText (big_box,real_x,'Upper Real     =',3,TE_Center);
  Set_DText (big_box,real_y,'Lower Real     =',3,TE_Center);
  Set_DText (big_box,imag_x,'Upper Imaginary= ',3,TE_Center);
  Set_DText (big_box,imag_y,'Lower Imaginary= ',3,TE_Center);
  Set_DText (big_box,load,'Load Options',3,TE_Center);
  Set_DText (big_box,save,'Save Options',3,TE_Center);
  Set_DText (big_box,view_1,' View 1 ',3,TE_Center);
  Set_DText (big_box,view_2,' View 2 ',3,TE_Center);
  Set_DText (big_box,pers,'Perspective Plot',3,TE_Center);
  Set_DText (big_box,set_auto,'Set Auto Plot',3,TE_Center);
  Set_DText (big_box,oth_opt,'Other Options',3,TE_Center);
  Set_DText (big_box,zoom,' Zoom ',3,TE_Center);
  Set_DText (big_box,plott,' Plot ',3,TE_Center);
  Set_DText (big_box,quit,' Quit ',3,TE_Center);
  Set_DText (big_box,bkpts,'Set Color Levels',3,TE_Center);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
  
  coor_box:=New_Dialog (42,0,0,36,23);
  coor_name:=Add_DItem (coor_box, G_String, None, 9, 1, 19, 1, 0, 
  			pallet);
  up_real_str:=Add_DItem (coor_box, G_String, None, 1, 4, 17, 1, 0, 
                          pallet);
  lo_real_str:=Add_DItem (coor_box, G_String, None, 1, 8, 34, 1, 0,
  			  pallet);
  up_img_str:=Add_DItem (coor_box, G_String, None, 1, 12, 34, 1, 0,
  			 pallet);
  lo_img_str:=Add_DItem (coor_box, G_String, None, 1, 16, 34, 1, 0,
  			 pallet);

  ur_sign:=Add_DItem (coor_box, G_Text, Selectable|Exit_Btn, 
                      18,4,1,1,0,pallet);
  ur_sign_exp:=Add_DItem (coor_box, G_Text , Selectable|Exit_Btn, 
                          32,4,1,1,0,pallet);
  ur_numb:=Add_DItem (coor_box, G_FText, Editable, 19,4,13,1,0,
                      pallet);
  ur_exp:=Add_DItem (coor_box, G_FText, Editable, 33,4,2,1,0,
		     pallet);
  
  lr_sign:=Add_DItem (coor_box, G_Text , Selectable|Exit_Btn, 
                      18,8,1,1,0,pallet);
  lr_sign_exp:=Add_DItem (coor_box, G_Text , Selectable|Exit_Btn, 
                          32,8,1,1,0,pallet);
  lr_numb:=Add_DItem (coor_box, G_FText, Editable, 19,8,13,1,0,
                      pallet);
  lr_exp:=Add_DItem (coor_box, G_FText, Editable, 33,8,2,1,0,
		     pallet);

  ui_sign:=Add_DItem (coor_box, G_text , Selectable|Exit_Btn, 
		      18,12,1,1,0,pallet);
  ui_sign_exp:=Add_DItem (coor_box, G_Text , Selectable|Exit_Btn, 
			  32,12,1,1,0,pallet);
  ui_numb:=Add_DItem (coor_box, G_FText, Editable, 19,12,13,1,0,
                      pallet);
  ui_exp:=Add_DItem (coor_box, G_FText, Editable, 33,12,2,1,0,
		     pallet);

  li_sign:=Add_DItem (coor_box, G_Text , Selectable|Exit_Btn, 
  		      18,16,1,1,0,pallet);
  li_sign_exp:=Add_DItem (coor_box, G_Text , Selectable|Exit_Btn, 
                          32,16,1,1,0,pallet);
  li_numb:=Add_DItem (coor_box, G_FText, Editable, 19,16,13,1,0,
                      pallet);
  li_exp:=Add_DItem (coor_box, G_FText, Editable, 33,16,2,1,0,
		     pallet);

  coor_ok:=Add_DItem (coor_box, G_Button, Selectable|Exit_Btn, 8, 19, 8, 3, 
  		      1, pallet);
  coor_cancel:=Add_DItem (coor_box, G_Button, Selectable|Exit_Btn|Default,
  			  21, 19, 8, 3, 1, pallet);

  Set_DText (coor_box, ur_sign,'+',3,TE_Center);
  Set_DText (coor_box, ur_sign_exp,'-',3,TE_Center);
  Set_DEdit (coor_box, ur_numb,'_.__________E','99999999999','80000000000',
  	     3,TE_Center);
  Set_DEdit (coor_box, ur_exp,'__','99','01',3,TE_Center);

  Set_DText (coor_box, lr_sign,'-',3,TE_Center);
  Set_DText (coor_box, lr_sign_exp,'+',3,TE_Center);
  Set_DEdit (coor_box, lr_numb,'_.__________E','99999999999','18000000000',
  	     3,TE_Center);
  Set_DEdit (coor_box, lr_exp,'__','99','00',3,TE_Center);

  Set_DText (coor_box, ui_sign,'+',3,TE_Center);
  Set_DText (coor_box, ui_sign_exp,'+',3,TE_Center);
  Set_DEdit (coor_box, ui_numb,'_.__________E','99999999999','13000000000',
  	     3,TE_Center);
  Set_DEdit (coor_box, ui_exp,'__','99','00',3,TE_Center);

  Set_DText (coor_box, li_sign,'-',3,TE_Center);
  Set_DText (coor_box, li_sign_exp,'+',3,TE_Center);
  Set_DEdit (coor_box, li_numb,'_.__________E','99999999999','13000000000',
  	     3,TE_Center);
  Set_DEdit (coor_box, li_exp,'__','99','00',3,TE_Center);
  
  Set_DText (coor_box, coor_name,'Fractal Coordinates', 3, TE_Center);
  Set_DText (coor_box, up_real_str,'Upper Real      =',3,TE_Center);
  Set_DText (coor_box, lo_real_str,'Lower Real      =',3,TE_Center);
  Set_DText (coor_box, up_img_str,'Upper Imaginary =',3,TE_Center);
  Set_DText (coor_box, lo_img_str,'Lower Imaginary =',3,TE_Center);
  Set_DText (coor_box, coor_ok,'OK',3,TE_Center);
  Set_DText (coor_box, coor_cancel,'Cancel',3,TE_Center);
  Center_Dialog (coor_box);

  {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  info_box_1:=New_Dialog (18,0,0,35,17);
  title_text_1:=Add_DItem (info_box_1,G_String,None,8,1,19,1,0,pallet);
  map_name_str_1:=Add_DItem (info_box_1,G_String,None,1,3,8,1,0,pallet);
  map_name_1:=Add_DItem (info_box_1,G_String,None,10,3,12,1,0,pallet);
  up_re_str_1:=Add_DItem (info_box_1,G_String,None,1,5,16,1,0,pallet);
  up_re_1:=Add_DItem (info_box_1,G_String,None,17,5,17,1,0,pallet);
  lw_re_str_1:=Add_DItem (info_box_1,G_String,None,1,6,16,1,0,pallet);
  lw_re_1:=Add_DItem (info_box_1,G_String,None,17,6,17,1,0,pallet);
  up_im_str_1:=Add_DItem (info_box_1,G_String,None,1,7,16,1,0,pallet);
  up_im_1:=Add_DItem (info_box_1,G_String,None,17,7,17,1,0,pallet);
  lw_im_str_1:=Add_DItem (info_box_1,G_String,None,1,8,16,1,0,pallet);
  lw_im_1:=Add_DItem (info_box_1,G_String,None,17,8,17,1,0,pallet);
  max_pt_str_1:=Add_DItem (info_box_1,G_String,None,1,10,15,1,0,pallet);
  max_pt_1:=Add_DItem (info_box_1,G_String,None,17,10,4,1,0,pallet);
  min_pt_str_1:=Add_DItem (info_box_1,G_String,None,1,11,14,1,0,pallet);
  min_pt_1:=Add_DItem (info_box_1,G_String,None,16,11,4,1,0,pallet);
  ok_but_1:=Add_DItem (info_box_1,G_Button,Selectable|Touch_Exit,4,13,8,3,
                       0,pallet);
  can_but_1:=Add_DItem (info_box_1,G_Button,Selectable|Touch_Exit,22,13,8,3,
                        0,pallet);
  Set_DText (info_box_1,map_name_str_1,'Map Name',3,TE_Center);
  Set_DText (info_box_1,up_re_str_1,'Upper Real     = ',3,TE_Center);
  Set_DText (info_box_1,lw_re_str_1,'Lower Real     = ',3,TE_Center);
  Set_DText (info_box_1,up_im_str_1,'Upper Imaginary= ',3,TE_Center);
  Set_DText (info_box_1,lw_im_str_1,'Lower Imaginary= ',3,TE_Center);
  Set_DText (info_box_1,max_pt_str_1,'Highest Point =',3,TE_Center);
  Set_DText (info_box_1,min_pt_str_1,'Lowest Point =',3,TE_Center);
  Set_DText (info_box_1,ok_but_1,'   OK   ',3,TE_Center);
  Set_DText (info_box_1,can_but_1,' Cancel ',3,TE_Center);
  Center_Dialog (info_box_1);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  save_options:=New_Dialog (12,0,0,20,16);
  save_title:=Add_DItem (save_options,G_String,None,4,1,12,1,0,pallet);
  screen_tit:=Add_DItem (save_options,G_String,None,3,3,7,1,0,pallet);
  but_1:=Add_DItem (save_options,G_Button,Selectable|Radio_Btn,11,3,2,2,0,pallet);
  but_2:=Add_DItem (save_options,G_Button,Selectable|Radio_Btn,15,3,2,2,0,pallet);
  save_comp_map:=Add_DItem (save_options,G_Text,Touch_Exit,0,6,20,1,0,pallet);
  save_raw_data:=Add_DItem (save_options,G_Text,Touch_Exit,0,7,20,1,0,pallet);
  save_degas_pic:=Add_DItem (save_options,G_Text,Touch_Exit,0,8,20,1,0,pallet);
  save_breakpt:=Add_DItem (save_options,G_Text,Touch_Exit,0,9,20,1,0,pallet);
  save_colors:=Add_DItem (save_options,G_Text,Touch_Exit,0,10,20,1,0,pallet);
  save_3D:=Add_DItem (save_options,G_Text,Touch_Exit,0,11,20,1,0,pallet);
  save_cancel:=Add_DItem (save_options,G_Button,Selectable|Touch_Exit,1,13,18,2,0,pallet);
  Set_DText (save_options,save_title,'Save Options',3,TE_Center);
  Set_DText (save_options,screen_tit,'Screen:',3,TE_Center);
  Set_DText (save_options,but_1,'1',3,TE_Center);
  Set_DText (save_options,but_2,'2',3,TE_Center);
  Set_DText (save_options,save_comp_map,'Save Complete Map',3,TE_Center);
  Set_DText (save_options,save_raw_data,'Save Raw Data',3,TE_Center);
  Set_DText (save_options,save_degas_pic,'Save Degas Picture',3,TE_Center);
  Set_DText (save_options,save_breakpt,'Save Breakpoints',3,TE_Center);
  Set_DText (save_options,save_colors,'Save Colors',3,TE_Center);
  Set_DText (save_options,save_3D,'Save CAD-3D File',3,TE_Center);
  Set_DText (save_options,save_cancel,'Cancel',3,TE_Center);
  Obj_SetState (save_options,but_1,Selected,false);
  Center_Dialog (save_options);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  load_options:=New_Dialog (12,0,0,20,14);
  load_title:=Add_DItem (load_options,G_String,None,4,1,12,1,0,pallet);
  load_tit:=Add_DItem (load_options,G_String,None,3,3,7,1,0,pallet);
  lbut_1:=Add_DItem (load_options,G_Button,Selectable|Radio_Btn,11,3,2,2,0,pallet);
  lbut_2:=Add_DItem (load_options,G_Button,Selectable|Radio_Btn,15,3,2,2,0,pallet);
  load_comp_map:=Add_DItem (load_options,G_Text,Touch_Exit,0,6,20,1,0,pallet);
  load_raw_data:=Add_DItem (load_options,G_Text,Touch_Exit,0,7,20,1,0,pallet);
  load_breakpt:=Add_DItem (load_options,G_Text,Touch_Exit,0,8,20,1,0,pallet);
  load_colors:=Add_DItem (load_options,G_Text,Touch_Exit,0,9,20,1,0,pallet);
  load_cancel:=Add_DItem (load_options,G_Button,Selectable|Touch_Exit,1,11,18,2,0,pallet);
  Set_DText (load_options,load_title,'Load Options',3,TE_Center);
  Set_DText (load_options,load_tit,'Screen:',3,TE_Center);
  Set_DText (load_options,lbut_1,'1',3,TE_Center);
  Set_DText (load_options,lbut_2,'2',3,TE_Center);
  Set_DText (load_options,load_comp_map,'Load Complete Map',3,TE_Center);
  Set_DText (load_options,load_raw_data,'Load Raw Data',3,TE_Center);
  Set_DText (load_options,load_breakpt,'Load Breakpoints',3,TE_Center);
  Set_DText (load_options,load_colors,'Load Colors',3,TE_Center);
  Set_DText (load_options,load_cancel,'Cancel',3,TE_Center);
  Obj_SetState (load_options,lbut_1,Selected,false);
  Center_Dialog (load_options);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  alrt_dilg:=New_Dialog (3,0,0,30,5);
  problem_line:=Add_DItem (alrt_dilg,G_Text,None,0,1,30,1,0,pallet);
  under_prob:=Add_DItem (alrt_dilg,G_Button,Touch_Exit,13,3,6,1,0,pallet);
  Set_DText (alrt_dilg,under_prob,'OK',3,TE_Center);
  Center_Dialog (alrt_dilg);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  l_pallet:=D_Color (pall[15],pall[15],true,0,pall[0]);
  levels_box:=New_Dialog (130,0,0,38,23);
  go_up:=Add_DItem (levels_box,G_Button,Touch_Exit,13,5,2,2,1,cpallet);
  set_number:=Add_DItem (levels_box,G_BoxText,Selectable,15,5,6,2,1,cpallet);
  go_down:=Add_DItem (levels_box,G_Button,Touch_Exit,19,5,2,2,1,cpallet);
  levels_ok:=Add_DItem(levels_box,G_Button,Selectable|Touch_Exit|Default,13,12,8,2,1,pallet);
  levels_cancel:=Add_DItem(levels_box,G_Button,Selectable|Touch_Exit,16,14,8,2,1,pallet);
  auto_1:=Add_DItem(levels_box,G_Button,Selectable,4,20,13,2,1,pallet);
  auto_2:=Add_DItem(levels_box,G_Button,Selectable,24,20,13,2,1,pallet);
  For i:=0 to 15 do Begin
    cpallet:=D_Color (pall[15],pall[15],false,7,pall[i]);
    color_lev1[i]:=Add_DItem(levels_box,G_Box,None,4,i+3,2,1,1,cpallet);
    color_lev2[i]:=Add_DItem(levels_box,G_Box,None,33,i+3,2,1,1,cpallet);
  End;
  For i:=0 to 16 do Begin
      numbers1[i]:=Add_DItem(levels_box,G_Text,Selectable,7,i+2,4,1,0,l_pallet);
  End;
  For i:=0 to 16 do Begin
      numbers2[i]:=Add_DItem(levels_box,G_Text,Selectable,28,i+2,4,1,0,l_pallet);
  End;
  Set_DText (levels_box,levels_ok,'   OK   ',3,TE_Center);
  Set_DText (levels_box,levels_cancel,' Cancel ',3,TE_Center);
  Set_DText (levels_box,auto_1,' Auto Adjust ',3,TE_Center);
  Set_DText (levels_box,auto_2,' Auto Adjust ',3,TE_Center);
  Set_DText (levels_box,go_up,up_arrow,3,TE_Center);
  Set_DText (levels_box,go_down,down_arrow,3,TE_Center);
  Set_DText (levels_box,set_number,'9999',3,TE_Center);
  Center_Dialog (levels_box);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  view_box:=New_Dialog (7,0,0,16,17);
  v1_button:=Add_DItem (view_box,G_Button,Touch_Exit,3,7,10,2,1,cpallet);
  v2_button:=Add_DItem (view_box,G_Button,Touch_Exit,3,10,10,2,1,cpallet);
  can_button:=Add_DItem (view_box,G_Button,Touch_Exit|Default,3,13,10,2,1,cpallet);
  tline_1:=Add_DItem (view_box,G_Text,None,1,2,14,1,0,cpallet);
  tline_2:=Add_DItem (view_box,G_Text,None,1,3,14,1,0,cpallet);
  tline_3:=Add_DItem (view_box,G_Text,None,1,4,14,1,0,cpallet);
  Set_DText (view_box,v1_button,'  Screen 1  ',3,TE_Center);
  Set_DText (view_box,v2_button,'  Screen 2  ',3,TE_Center);
  Set_DText (view_box,can_button,'   Cancel   ',3,TE_Center);
  Center_Dialog (view_box);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  options_box:=New_Dialog (3,0,0,22,10);
  options_title:=Add_DItem (options_box,G_Text,None,7,1,7,1,1,cpallet);
  mandle_opt:=Add_DItem (options_box,G_Button,Touch_Exit,1,4,20,2,1,cpallet);
  random_opt:=Add_DItem (options_box,G_Button,Touch_Exit,1,7,20,2,1,cpallet);
  Set_DText (options_box,options_title,'Options',3,TE_Center);
  Set_DText (options_box,mandle_opt,'Mandelbrot Fractal',3,TE_Center);
  Set_DText (options_box,random_opt,'Random Fractal',3,TE_Center);
  Center_Dialog (options_box);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  prog_box:=New_Dialog (9,0,0,21,19);
  prog_title:=Add_DItem (prog_box,G_Text,None,7,1,8,1,1,cpallet);
  For i:=0 to 5 do
    prog_level[i+1]:=Add_DItem (prog_box,G_Button,None,1,(i*2)+3,18,1,1,cpallet);
  create_oce:=Add_DItem (prog_box,G_Button,None,1,15,18,1,1,cpallet);
  calc_hi:=Add_DItem (prog_box,G_Button,None,1,17,18,1,1,cpallet);
  Set_DText (prog_box,prog_title,'Progress',3,TE_Center);
  For i:=0 to 5 do Begin
    WriteV (str_level,'On Level ',i+1);
    Set_DText (prog_box,prog_level[i+1],Str_Level,3,TE_Center);
  End;
  Set_DText (prog_box,create_oce,'Creating Oceans',3,TE_Center);
  Set_DText (prog_box,calc_hi,'Computing Heights',3,TE_Center);
  Center_Dialog (prog_box);
  
End;    
