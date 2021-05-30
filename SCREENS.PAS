Type
  color_pall = array [0..15] of short_integer;

Var
  pall, system_pal, pic_pal, preset_1, preset_2, preset_3,
  preset_4: color_pall;

Procedure Set_Pallet;
   
Begin
  pall[0]:=0;
  pall[1]:=2;
  pall[2]:=3;
  pall[3]:=6;
  pall[4]:=4;
  pall[5]:=7;
  pall[6]:=5;
  pall[7]:=8;
  pall[8]:=9;
  pall[9]:=10;
  pall[10]:=11;
  pall[11]:=14;
  pall[12]:=12;
  pall[13]:=15;
  pall[14]:=13;
  pall[15]:=1;
End;

Procedure Set_Colors;

Var
  j: integer;

Begin
  j:=setcolor(0,$000);
  j:=setcolor(15,$777);
End;

Procedure Set_Pallets;

Var
  j: integer;

Begin
  j:=setcolor(0,$000);
  j:=setcolor(1,$001);
  j:=setcolor(2,$002);
  j:=setcolor(3,$003);
  j:=setcolor(4,$004);
  j:=setcolor(5,$005);
  j:=setcolor(6,$006);
  j:=setcolor(7,$007);
  j:=setcolor(8,$007);
  j:=setcolor(9,$117);
  j:=setcolor(10,$227);
  j:=setcolor(11,$337);
  j:=setcolor(12,$447);
  j:=setcolor(13,$557);
  j:=setcolor(14,$667);
  j:=setcolor(15,$777);
End;

Procedure Get_System_Pallet;

Var
  i: integer;

Begin
  For i:=0 to 15 do
    system_pal[i]:=setcolor (pall[i],-1);
End;


Procedure Use_System_Pallet;

Var
  i, pop: integer;

Begin
  For i:=0 to 15 do
    pop:=setcolor (pall[i],system_pal[i]);
End;


Procedure Set_Usage_Pallet;

Var 
  i: integer;

Begin
  For i:=0 to 15 do
    pic_pal[i]:=setcolor (pall[i],-1);
End;


Procedure Use_Usage_Pallet;

Var
  i, pop: integer;

Begin
  For i:=0 to 15 do
    pop:=setcolor (pall[i],pic_pal[i]);
End;

{Procedure Set_Levels_1;

Var
  k,i,constant: integer;

Begin
  constant:=trunc((chunkrec1.max-chunkrec1.min)/16);
  k:=0;
  For i:=0 to 16 do Begin
    ChunkRec1.Levels [i]:=k+chunkrec1.min; 
    k:=k+constant;  
  End;
End;

Procedure Set_Levels_2;

Var
  k,i,constant: integer;

Begin
  constant:=trunc((chunkrec2.max-chunkrec2.min)/16);
  k:=0;
  For i:=0 to 16 do Begin
    ChunkRec2.Levels [i]:=k+chunkrec2.min; 
    k:=k+constant;  
  End;
End;}

  
