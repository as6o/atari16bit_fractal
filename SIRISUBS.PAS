Procedure Screen_Dump;
  XBios (20);

Function Randomizer: integer;
  XBios (17);

Function Get_Res: integer;
  XBios (4);

Procedure SetScreen (logadr, physadr: long_integer; res: short_integer);
  XBios (5);

Function SetColor (colornum, color: integer): integer;
  XBios (7);

Function Str255_Int (data: Str255): Integer;

Var
  newdata,k,i,p: integer;

Begin
  k:=length(data);
  newdata:=ord(data[k])-ord('0');
  p:=10;
  for i:=k-1 downto 1 do begin
      if (data[i]='-') then newdata:=newdata*(-1)
      else begin
        newdata:=(ord(data[i])-ord('0'))*p+newdata;
        p:=p*10;
      end;
  end;
  Str255_Int:=newdata;
End;

Function Random: real;

Var
  frac: real;

Begin
  frac:=(Randomizer)/1000;
  random:=frac-trunc(frac);
End;

Procedure Int_Str255 (data: Integer; Var newint: Str255);

var
  newdata,subt :real;
  truncated, updated, newchr, i: integer;
  neg: char;

Begin
  If (data<>0) then begin
    neg:='-';
    if (data<0) then truncated:=data*(-1)
      else truncated:=data;
    for i:=1 to 5 do begin
      newdata:=(truncated*0.1);
      truncated:=trunc(truncated*0.1);
      updated:=round((newdata-truncated)*10);
      newchr:=ord('0')+updated;
      insert (chr(newchr),Newint,1);
    repeat
      if (newint[1]='0') then delete (newint,1,1);
    until newint[1]<>'0';
    end;
    if (data<0) then insert (neg,newint,1);
  End
  else
    newint:='0';
End;      

Function Str255_Real (in_string: Str255): real;

Var
  i, j: integer;
  str_real, digit1, digit2, k, whole, frac: real;
  
Begin
  i:=1;
  repeat
    if in_string[i]<>'.' then
      i:=i+1;
  until in_string[i]='.';

  k:=1;
  for j:=i-1 downto 1 do begin
    digit1:=(ord(in_string[j])-ord('0'));
    if (digit1<0) or (digit1>9) then
      digit1:=0;
    whole:=whole+digit1*k;
    k:=k*10;
  end;

  k:=0.1;
  for j:=i+1 to i+40 do begin
    digit2:=(ord(in_string[j])-ord('0'));
    if (digit2<0) or (digit2>9) then
      digit2:=0;
    frac:=frac+digit2*k;
    k:=k*0.1;
  end;
  Str_Real:=whole+frac; 
  If in_string[1]='-' then 
    Str_Real:=Str_Real*(-1);
  Str255_Real:=Str_Real;
End;


Function Str255_Cplx (num_string, exp_string: Str255;
 		      sign_num, sign_exp: integer): real;

Var
  i, j: integer;
  exp,tenpow, digit3, str_real, digit1, digit2, k, whole, frac: real;
  h: integer;

Begin

    i:=1;
  tenpow:=1.0;
  k:=1;
  for j:=i downto 1 do begin
    digit1:=(ord(num_string[j])-ord('0'));
    if (digit1<0) or (digit1>9) then
      digit1:=0;
    whole:=whole+digit1*k;
    k:=k*10;
  end;

  k:=0.1;
  for j:=i+1 to 12 do begin
    digit2:=(ord(num_string[j])-ord('0'));
    if (digit2<0) or (digit2>9) then
      digit2:=0;
    frac:=frac+digit2*k;
    k:=k*0.1;
  end;

  k:=1;
  for j:=2 downto 1 do begin
    digit3:=(ord(exp_string[j])-ord('0'));
    if (digit3<0) or (digit3>9) then
      digit3:=0;
    exp:=exp+digit3*k;
    k:=k*10;
  end;
  if exp>37 then exp:=37;
  If sign_exp<0 then
    exp:=exp*(-1);


  If exp>0 then
    For h:=1 to trunc(exp) do
      tenpow:=tenpow*10;
  
  If exp< 0 then
    For h:=1 to trunc(abs(exp)) do
      tenpow:=tenpow*0.1;
  
  Str_Real:=whole+frac; 
  If sign_num<0 then 
    Str_Real:=Str_Real*(-1);
  Str255_Cplx:=Str_Real*tenpow;
End;

Function Dec_Mod (number_in: real): real;

Var
  temp: integer;
  
Begin
  temp:=trunc(number_in);
  Dec_Mod:=number_in-temp;
End;
