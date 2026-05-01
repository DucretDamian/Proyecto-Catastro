unit visual_op;
interface
uses crt;
procedure pinta_linea(x,y,actual,colortxt,colorback:byte);
procedure mover_mouse(var actual:byte;max_fila,min_fila:byte; tecla:string);
implementation
procedure pinta_linea(x,y,actual,colortxt,colorback:byte);
	begin
	{writeln(actual);
		writeln(y);
		writeln(y-actual);
		readkey;}
	if actual <> y then
	begin
	gotoxy(x,y+2);
	textcolor(white);
	textbackground(black);
	end
	else if actual = y then
			begin
			gotoxy(x+2,y+2);
			textcolor(colortxt);
			textbackground(colorback);
			end;
	end;
procedure mover_mouse(var actual:byte;max_fila,min_fila:byte; tecla:string);
	begin
	if tecla = chr(0)then
		tecla:= readkey;
		writeln(tecla);
	if tecla = chr(80) then
		actual:= actual+1;
	if tecla = chr(72) then
		actual:= actual-1;
	if actual > max_fila then
		actual:= min_fila;
	if actual < min_fila then
		actual:= max_fila;
	end;
end.