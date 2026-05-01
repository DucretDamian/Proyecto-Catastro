UNIT VALIDACION_DE_DATOS;
INTERFACE
{$codepage UTF8}
uses crt;
function comprobar_num(dato:string;LINEA_ELIMINAR:byte):boolean;
function comprobar_fecha(fecha:string;LINEA_ELIMINAR:byte):boolean;
function mostrar_fecha(fecha:string):string;
IMPLEMENTATION
function comprobar_num(dato:string;LINEA_ELIMINAR:byte):boolean;
var pos,cont:byte;
	car:string[1];
	begin
	pos:=1;
	cont:=0;
	while (pos<=length(dato)) do
		begin
		car:= copy(dato,pos,pos);
		if ((car <= char(57))and(car >= char(48))) and (dato <>'') then
		begin
		comprobar_num:= true;
		cont:= cont+1;
		end;
		pos:= pos +1;
		end;
		if cont < length(dato) then
		comprobar_num:=false;
		if comprobar_num = false then
		begin
		gotoxy(1,LINEA_ELIMINAR);
		DelLine;
		end;
	end;
function comprobar_fecha(fecha:string;LINEA_ELIMINAR:byte):boolean;
var aaaa:string[4];
var mes,dia:string[2];
begin
aaaa:=copy(fecha, 1,4);
mes:=copy(fecha, 5,6);
dia:=copy(fecha, 7,8);
 if (aaaa<='2024') and (mes<='12') then //AUTOMATIZAR PARA EL AÑO EN EL QUE SE USA EL PROGRAMA
 	begin
 		if (mes='01') or (mes='03') or (mes='05') or (mes='07') or (mes='08') or (mes='10') or (mes='12') then
 			comprobar_fecha:= (dia<='31') and (dia > '00')
 		else comprobar_fecha:= (dia<='30')and (dia > '00');

 	end
 else comprobar_fecha:= false;
 if comprobar_fecha = false then
 	begin
 	gotoxy(1,LINEA_ELIMINAR);
 	DelLine;
 	end;
 end;
function mostrar_fecha(fecha:string):string;
var aaaa:string[4];
	mes,dia:string[2];
	begin
		aaaa:=copy(fecha, 1,4);
		mes:=copy(fecha, 5,6);
		dia:=copy(fecha, 7,8);
		mostrar_fecha:= aaaa + CHR(47) + mes + CHR(47) + dia; //CHR(47) = '/'
	end;
END.