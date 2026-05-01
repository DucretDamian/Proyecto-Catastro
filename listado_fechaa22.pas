unit listado_fechaa22;
interface
{$codepage UTF8}
uses crt,ARCHIVO_TERREN_MANEJO_SIMPLE,VALIDACION_DE_DATOS;
procedure ORDENAR(var arch_t:t_archivo_t);
procedure BUSQUEDA(var arch_t:t_archivo_t; buscado:string; var pos:word;var encontrado:boolean);
procedure LISTADO_ANIO_FECHA (var arch_t:t_archivo_t;buscado:string);
procedure CONSULTAR_ANIO(var arch_t:t_archivo_t);
procedure genera_listado_fecha(var arch_t:t_archivo_t);
implementation
procedure ORDENAR(var arch_t:t_archivo_t);
VAR
reg_dato,reg_dat_I,reg_dat_J:t_datoterr;
i,j:word;
fecha_i,fecha_j:string;
  begin
    for i:=1 to (filesize(arch_t)-1)-1 do
      begin
        for  j:=i+1 to filesize(arch_t)-1 do
        begin
        LEER_DATO_ARCHIVO_T(arch_t,reg_dato,i);
        fecha_i:=reg_dato.fecha_insc;
        reg_dat_I:=reg_dato;
        LEER_DATO_ARCHIVO_T(arch_t,reg_dato,j);
        fecha_j:=reg_dato.fecha_insc ;
        reg_dat_J:=reg_dato;
          if fecha_i > fecha_j  then
          begin
          reg_dato := reg_dat_J;
          ESCRIBIR_DATO_ARCHIVO_T(arch_t,reg_dato,i);
          reg_dato :=reg_dat_I;
          ESCRIBIR_DATO_ARCHIVO_T(arch_t,reg_dato,j);
           end;
        end;
      end;
  end;

procedure BUSQUEDA(var arch_t:t_archivo_t; buscado:string; var pos:word;var encontrado:boolean);
var i:word;
    dato:t_datoterr;
    begin
     pos:=0;
     i:=0;
     encontrado:=false;
     while (i < filesize(arch_t)) and (not encontrado) do
       begin
       LEER_DATO_ARCHIVO_T(arch_t,dato,i);
       if copy(dato.fecha_insc,1,4) = buscado then
         begin
           pos:=i;
           encontrado:=true;
           end
         else
           begin
           i:=i+1;
           end;
       end;
    end;
procedure LISTADO_ANIO_FECHA (var arch_t:t_archivo_t;buscado:string);
var
  dato_t:t_datoterr;
  i,y:word;
  direc_short:string;
  fecha_con_barras:string[10];
    begin
    y:=7;
    textcolor(14);
    writeln('|Nro contr|Nro plano|Avaluo       |Fecha insc. |Domicilio     |super    |zona |tipo_edif|');
    writeln('|---------------------------------------------------------------------------------------|');
    textcolor(white);
    for i:= 0 to filesize(arch_t)-1 do
    begin
    LEER_DATO_ARCHIVO_T(arch_t,dato_t,i);
    if copy(dato_t.fecha_insc,1,4) = buscado then
      begin
      fecha_con_barras:= mostrar_fecha(dato_t.fecha_insc);
      direc_short:= copy(dato_t.domicilio, 1, 14);
          textcolor(white);
          gotoxy(1,y);
          write('|',dato_t.nro_contr);
          gotoxy(11,y);
          write('|',dato_t.nro_plano);
          gotoxy(21,y);
          write('|',dato_t.valor:0:2);
          gotoxy(35,y);
          write('|',fecha_con_barras);
          gotoxy(48,y);
          write('|',direc_short);
          gotoxy(63,y);
          write('|',dato_t.super);
          gotoxy(73,y);
          write('|',dato_t.zona);
          gotoxy(79,y);
          writeln('|',dato_t.tipo_edif,'        |');
          writeln('|---------|---------|-------------|------------|--------------|---------|-----|---------|');
          y:=y+2;
          writeln('');
          if ((i mod 10) = 0 )and (i <> 0)then
            readkey;
      end;
    end;
    end;
procedure CONSULTAR_ANIO(var arch_t:t_archivo_t);
var buscado:string;
    pos:word;
    encontrado:boolean;
    begin
    ABRIR_ARCHIVO_T(arch_t,ruta_t);
    clrscr;
    write('Ingrese un año del cual desea listar las fechas: ');
    readln(buscado);
    BUSQUEDA(arch_t,buscado,pos,encontrado);
    if encontrado = true then
      begin
      ORDENAR(arch_t);
      writeln(' " LISTADO ORDENADO EN EL AÑO ', buscado,' POR FECHA " ' );
      writeln('');
      LISTADO_ANIO_FECHA(arch_t,buscado);
      end
      else begin
            writeln('No se encontro el año ');
            end;
    readkey;
    CERRAR_ARCHIVO_T(arch_t);
    end;
procedure genera_listado_fecha(var arch_t:t_archivo_t);
var
  pos:byte;
  aaaa:string;
  x:t_datoterr;
  encontrado:boolean;
  begin
    encontrado:=false;
    pos:=0;
    clrscr;
    textcolor(14);
    writeln('------ LISTADO POR FECHAS -------');
    textcolor(white);
    textcolor(14);    write('Ingrese Año a generar listado: '); 
    textcolor(white); readln(aaaa);

    ABRIR_ARCHIVO_T(arch_t,ruta_t);
    while not (EOF(arch_t)) do
          begin
            LEER_DATO_ARCHIVO_T(arch_t,x,pos);
            if copy(x.fecha_insc, 1, 4) = copy(aaaa,1,4) then
              begin
                encontrado:= true;
              end;
            pos:=pos+1;
          end;
    CERRAR_ARCHIVO_T(arch_t);
    ABRIR_ARCHIVO_T(arch_t,ruta_t);
    if (encontrado = true) and (filesize(arch_t) = 1 )then
      begin
          writeln('Listado ordenado en el año ', aaaa,' por fecha' );
          writeln('');
          LISTADO_ANIO_FECHA(arch_t,aaaa);
      end
      else  if encontrado = true then
            begin
            ORDENAR(arch_t);
          writeln('Listado ordenado en el año ', aaaa,' por fecha' );
          writeln('');
          LISTADO_ANIO_FECHA(arch_t,aaaa);
            end
      else begin
            writeln('No hay datos en ese año ');
            end;
      CERRAR_ARCHIVO_T(arch_t);
      readkey;
  end;
end.