unit listado_zonass22;
interface
{$codepage UTF8}
uses crt,VALIDACION_DE_DATOS,ARCHIVO_TERREN_MANEJO_SIMPLE;
procedure ordenar_arch_fechas(var arch_t:t_archivo_t);
procedure mostrar_listado ( var arch_t:t_archivo_t);
procedure listado_por_zona(var arch_t:t_archivo_t);
implementation
procedure ordenar_arch_fechas(var arch_t:t_archivo_t);
var dato_arch,dato_i,dato_j:t_datoterr;
    i,j:byte;
    zona_1,zona_2:1..5;
  begin
    for i:=0 to (filesize(arch_t)-1)-1 do
    begin
      for  j:=i+1 to filesize(arch_t)-1 do
      begin
      LEER_DATO_ARCHIVO_T(arch_t,dato_arch,i);
      zona_1:= dato_arch.zona;
      dato_i:=dato_arch;
      LEER_DATO_ARCHIVO_T(arch_t,dato_arch,j);
      zona_2:=dato_arch.zona;
      dato_j:=dato_arch;
        IF zona_1 < zona_2  then
        begin
        dato_arch := dato_j;
        ESCRIBIR_DATO_ARCHIVO_T(arch_t,dato_arch,i);
        dato_arch := dato_i;
        ESCRIBIR_DATO_ARCHIVO_T(arch_t,dato_arch,j);
        end;
      end;
    end;
  end;
procedure mostrar_listado (var arch_t:t_archivo_t);
var
  dato_t:t_datoterr;
  i,y:word;
  direc_short:string;
  fecha_con_barras:string[10];
  begin
  y:=5;
  for i:= 0 to filesize(arch_t)-1 do
    begin
    LEER_DATO_ARCHIVO_T(arch_t,dato_t,i);
    direc_short:= copy(dato_t.domicilio, 1, 14);
    fecha_con_barras:= mostrar_fecha(dato_t.fecha_insc);
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
      textcolor(11);write('|',dato_t.zona); textcolor(white);
      gotoxy(79,y);
      writeln('|',dato_t.tipo_edif,'        |');
      writeln('|---------|---------|-------------|------------|--------------|---------|-----|---------|');
      y:=y+2;
      writeln('');
      if ((i mod 10) = 0 )and (i <> 0)then
        readkey;
    end;
  end;
procedure listado_por_zona(var arch_t:t_archivo_t);
  begin
  clrscr;
    textcolor(14);
    ABRIR_ARCHIVO_T(arch_t,ruta_t);
    if filesize(arch_t) <> 0 then
    begin
      writeln('------------------------------------ Listado Por Zona -------------------------------------------------');
      writeln(' ');
      writeln('|Nro contr|Nro plano|Avaluo       |Fecha insc. |Domicilio     |super    |zona |tipo_edif|');
      writeln('-------------------------------------------------------------------------------------------------------');
      ordenar_arch_fechas(arch_t);
      mostrar_listado (arch_t);
    end
    else begin
          writeln(' ');
          writeln(' |//////////////////////////////|');
          writeln(' | NO EXISTE ARCHIVOS A MOSTRAR |');
          writeln(' |//////////////////////////////|');
          end;
    readkey;
    CERRAR_ARCHIVO_T(arch_t);
  end;
end.