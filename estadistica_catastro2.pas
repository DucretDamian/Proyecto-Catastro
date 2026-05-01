unit estadistica_catastro2;
interface
uses crt,ARCHIVO_PROP_MANEJO_SIMPLE,ARCHIVO_TERREN_MANEJO_SIMPLE,VALIDACION_DE_DATOS;
procedure cantidad_incripciones(var arch_t:t_archivo_t);
function buscar(var arch_t:t_archivo_t; dato_p:t_datoprop):boolean;
procedure porcentaje_propietarios_mas1prop(var arch_t:t_archivo_t; var arch_p:t_archivo_p);
procedure porcentaje_tipo_de_edificacion(var arch_t:t_archivo_t);
 procedure cant_propietarios_baja(var arch_t:t_archivo_t;var arch_p:t_archivo_p);
procedure estadistica(var arch_p:t_archivo_p;var arch_t:t_archivo_t);
implementation
//ESTADISTICASSSS
procedure cantidad_incripciones(var arch_t:t_archivo_t);
var
 fechai, fechaf:string[10]; //fecha inicio y final
 pos:byte;
 x:t_datoterr;
 cant_fecha:word;
begin
  clrscr;
  pos:=0;
  cant_fecha:=0;
  ABRIR_ARCHIVO_T(arch_t,ruta_t);
  writeln('INGRESAR FECHAS DE LA SIGUIENTE FORMA: aaaammdd');
  repeat
  write('Ingrese fecha inicial (aaaa/mm/dd): '); 
  textcolor(11);
  readln(fechai);
  textcolor(white);
  until comprobar_fecha(fechai,2) = true ;
  repeat
  write('ingrese fecha final (aaaa/mm/dd): ');
  textcolor(11);
  readln(fechaf);
  textcolor(white);
  until comprobar_fecha(fechaf,3) = true;
  while not (EOF(arch_t)) do
        begin
          LEER_DATO_ARCHIVO_T(arch_t,x,pos);
          if (x.fecha_insc <= fechaf) and (x.fecha_insc >= fechai) then
             begin
               cant_fecha:=cant_fecha+1;
             end;
          pos:=pos+1;
        end;
  CERRAR_ARCHIVO_T(arch_t);
  textcolor(11);
  writeln('|---------------------------------------------------------');
  textcolor(white);
  fechai:= mostrar_fecha(fechai);
  fechaf:= mostrar_fecha(fechaf);
  writeln('|La cantidad de inscripciones entre ',fechai, ' y ',fechaf,' es de: ',cant_fecha,'|');
  readkey;
end;
//porcentaje de propientarios con mas de una propiedad
function buscar(var arch_t:t_archivo_t; dato_p:t_datoprop):boolean;
var
 i,cont:byte;
 dato_t:t_datoterr;
 valor:boolean;
begin
    i:= 0; //pos +1
    cont:= 0;
    valor:= false;
    ABRIR_ARCHIVO_T(arch_t,ruta_t);
    while (not (EOF(arch_t))) and (valor = false) do
        begin
          LEER_DATO_ARCHIVO_T(arch_t,dato_t,i);
          if dato_t.nro_contr = dato_p.nro_contr then //(dato_t.nro_contr = x.nro_contr) and (dato_t.nro_plano <> x.nro_plano)
            begin
            cont:= cont + 1;
            end;
          if cont >1 then
          begin
          valor:= true;
          end
          else valor:=false;
          i:= i+1;
        end;
          CERRAR_ARCHIVO_T(arch_t);
          buscar:=valor;
end;
procedure porcentaje_propietarios_mas1prop(var arch_t:t_archivo_t; var arch_p:t_archivo_p);
var
 dato_p:t_datoprop;
 porc,cont,total:real;
 pos:byte;
begin
  clrscr;
  porc:=0;
  cont:=0;
  pos:=0;
  // ABRIR_ARCHIVO_T(arch_t,ruta_t);
  ABRIR_ARCHIVO_P(arch_p,ruta_p);
    for pos:=0 to filesize(arch_p)-1 do
        begin
          LEER_DATO_ARCHIVO_P(arch_p,dato_p,pos);
          if dato_p.estado = true then
          begin
            if buscar(arch_t,dato_p) = true then
            begin
            cont:=cont+1;
            end;
          end;
        end;
  total:=filesize(arch_p);
  porc:=(cont/total)*100;
  writeln('El procentaje de propietarios con mas de una propiedad es: ');
  textcolor(14);
  writeln(porc:0:2, '%');
  readkey;
  CERRAR_ARCHIVO_P(arch_p);
end;
 //Porcentaje de propiedades por tipo de edificación
procedure porcentaje_tipo_de_edificacion(var arch_t:t_archivo_t);
var
 total,porc1,porc2,porc3,porc4,porc5,cont1,cont2,cont3,cont4,cont5:real;
 pos:byte;
 x:t_datoterr;
begin
	clrscr;
  pos:=0;
  total:=0;
  porc1:=0;
  porc2:=0;
  porc3:=0;
  porc4:=0;
  porc5:=0;
  cont1:=0;
  cont2:=0;
  cont3:=0;
  cont4:=0;
  cont5:=0;
  ABRIR_ARCHIVO_T(arch_t,ruta_t);
  if filesize(arch_t)= 0 then
    writeln('No hay datos para analizar')
  else begin
  while (not (EOF(arch_t))) and (filesize(arch_t)<>0) do
        begin
          LEER_DATO_ARCHIVO_T(arch_t,x,pos);
          case x.tipo_edif of
           1:cont1:=cont1+1;
           2:cont2:=cont2+1;
           3:cont3:=cont3+1;
           4:cont4:=cont4+1;
           5:cont5:=cont5+1;
          end;
  pos:=pos+1;
        end;
  total:=filesize(arch_t);

  porc1:=(cont1/total)*100;
  textcolor(white);write('porcentaje de tipo de edificacion 1: ');
  textcolor(14); write(porc1:0:1); textcolor(white);writeln('%');
  porc2:=(cont2/total)*100;
  textcolor(white);write('porcentaje de tipo de edificacion 2: ');
  textcolor(14);write (porc2:0:1);textcolor(white);writeln('%');
   porc3:=(cont3/total)*100;
  textcolor(white);write('porcentaje de tipo de edificacion 3: ');
  textcolor(14);write (porc3:0:1);textcolor(white);writeln('%');
   porc4:=(cont4/total)*100;
  textcolor(white);write('porcentaje de tipo de edificacion 4: ');
  textcolor(14);write (porc4:0:1);textcolor(white);writeln('%');
   porc5:=(cont5/total)*100;
  textcolor(white);write('porcentaje de tipo de edificacion 5: ');
  textcolor(14);write(porc5:0:1);textcolor(white);writeln('%');
  end;
  readkey;
  CERRAR_ARCHIVO_T(arch_t);
end;
 procedure cant_propietarios_baja(var arch_t:t_archivo_t;var arch_p:t_archivo_p);
 var
  pos,cant,total:byte;
  x:t_datoprop;
 begin
 clrscr;
   pos:=0;
   cant:=0;
   ABRIR_ARCHIVO_P(arch_p,ruta_p);
   total:=filesize(arch_p);
   for pos:=0 to filesize(arch_p)-1 do
        begin
          LEER_DATO_ARCHIVO_P(arch_p,x,pos);
          if x.estado = false then
             cant:=cant+1;
        end;
   write('La cantidad de propietarios dados de baja es: ');
   textcolor(14);
    writeln(cant,' de ',total);
   readkey;
   CERRAR_ARCHIVO_P(arch_p);
 end;
procedure estadistica(var arch_p:t_archivo_p;var arch_t:t_archivo_t);
var
 op:byte;
begin
  repeat
  clrscr;
    textcolor(14);
    writeln('------ ESTADISTICAS -------');
    writeln(' ');
    textcolor(white);
    writeln('1: Cantidad de incripciones entre 2 fechas');
    writeln('2: Porcentaje de propietarios con mas de una propiedad');
    writeln('3: Porcentaje de propiedades por tipo de edificacion');
    writeln('4: Cantidad de propietarios dados de baja');
    writeln('0: salir');
    writeln('OPCION: '); readln(op);
    case op of
        1:cantidad_incripciones(arch_t);
        2:porcentaje_propietarios_mas1prop(arch_t, arch_p);
        3:porcentaje_tipo_de_edificacion(arch_t);
        4:cant_propietarios_baja(arch_t,arch_p);
     end;
  until op=0;
  end;
end.