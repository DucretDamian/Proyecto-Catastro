unit listado_apinomb22;
interface
{$codepage UTF8}
uses crt,ARCHIVO_PROP_MANEJO_SIMPLE,ARCHIVO_TERREN_MANEJO_SIMPLE,arbol_pro22;
procedure inorden(var raiz:t_puntero;var arch_p:t_archivo_p;var arch_t:t_archivo_t);
procedure listado_apynom(var arch_t:t_archivo_t;var arch_p:t_archivo_p;var raiz_nomb:t_puntero);
implementation
procedure inorden(var raiz:t_puntero;var arch_p:t_archivo_p;var arch_t:t_archivo_t);
var i,pos:word;
var dato:t_datoprop;
var dato_t:t_datoterr;
    begin
        if raiz <> nil then
        begin
        inorden(raiz^.SAI,arch_p,arch_t);
        {---------------------------------}
        pos:=raiz^.info.posi;
        LEER_DATO_ARCHIVO_P(arch_p,dato,pos);
            textcolor(14);
            if dato.estado = true then
            begin
            textcolor(11);
            writeln('|---------------------------------------------------------');
            writeln('|',dato.apellido,' ',dato.nombres,' --- ',dato.nro_contr,'---',dato.dni,'---',dato.estado,'|');
            writeln('|---------------------------------------------------------');
            readkey;
            end;
        if (dato.estado = false)  then
        begin
        write('|');
        textcolor(lightred);
        writeln('NO TIENE PROPIEDADES');
        end
        else 
            begin
            for i:=0 to filesize(arch_t)-1 do
                begin
                LEER_DATO_ARCHIVO_T(arch_t,dato_t,i);
                if dato_t.nro_contr = dato.nro_contr then
                    begin
                    textcolor(11);write('|Nro plano: ');textcolor(white);write(dato_t.nro_plano);
                    textcolor(11);write(' Valor: ');textcolor(white);write(dato_t.valor:0:2);
                    textcolor(11);write(' Super: ');textcolor(white);write(dato_t.super);
                    textcolor(11);write(' Zona: ');textcolor(white);write(dato_t.zona);
                    textcolor(11);write(' Tipo edif.: ');textcolor(white);write(dato_t.tipo_edif);
                    writeln('');
                    readkey;
                    end;
                end;
            end;
        {--------------------------------}
        inorden(raiz^.SAD,arch_p,arch_t);
        end;
    end;
//muestra la lista ordenada con sus propiedades valorizadas
procedure listado_apynom(var arch_t:t_archivo_t;var arch_p:t_archivo_p;var raiz_nomb:t_puntero);
begin
  clrscr;
  {-------------------------------}
  textcolor(14);
    writeln('------ LISTADO POR APELLIDO Y NOMBRE  -------');
    writeln('');
    ABRIR_ARCHIVO_P(arch_p,ruta_p);
    ABRIR_ARCHIVO_T(arch_t,ruta_t);
    if filesize(arch_t) <> 0 then
    begin
        if not(arbol_vacio(raiz_nomb))then
            begin
            inorden(raiz_nomb,arch_p,arch_t);
            textcolor(14);
            writeln('|---------------------------------------------------------');
            end
            else begin
                writeln('Arbol VACIO');
                end;
    end
    else begin
          writeln(' ');
          writeln('|///////////////////////////////////|');
          writeln('| NINGUN PROPIETARIO TIENE TERRENOS |');
          writeln('|///////////////////////////////////|');
         end;
        readkey;
        CERRAR_ARCHIVO_P(arch_p);
        CERRAR_ARCHIVO_T(arch_t);
  {-------------------------------}
end;
end.