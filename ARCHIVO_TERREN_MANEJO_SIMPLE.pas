UNIT ARCHIVO_TERREN_MANEJO_SIMPLE;
INTERFACE
{$codepage UTF8}
uses crt;
const
	ruta_t = 'Archivo_Terrenos.DAT';
	ruta_t2 = 'Archivo_Terrenos_copia.DAT';
type t_datoterr=record
     nro_contr:string[8];
     nro_plano:string[8];
     valor:real;
     fecha_insc:string[8]; //fecha aaaa mm dd
     domicilio:string[40];
     super:string[8];
     zona:byte;
     tipo_edif:byte;
  end; 
TYPE t_archivo_t = file of t_datoterr;
procedure CREAR_ARCHIVO_T(var arch_t:t_archivo_t;ruta:string);
procedure CERRAR_ARCHIVO_T(var arch_t:t_archivo_t);
procedure ABRIR_ARCHIVO_T(var arch_t:t_archivo_t;ruta:string);
procedure POSICIONAR_ARCHIVO_T(var arch_t:t_archivo_t;var pos:byte);
procedure BORRAR_ARCHIVO_T(var arch_t:t_archivo_t);
procedure LEER_DATO_ARCHIVO_T(var arch_t:t_archivo_t;var dato_terr:t_datoterr;pos:byte);
procedure ESCRIBIR_DATO_ARCHIVO_T(var arch_t:t_archivo_t;var dato_terr:t_datoterr;pos:byte);
IMPLEMENTATION
procedure CREAR_ARCHIVO_T(var arch_t:t_archivo_t;ruta:string);
	begin
		assign(arch_t,ruta);
		{$i-}
	  	Reset (arch_t);
	  	{$i+}
		if IOResult <> 0 then
		begin
		rewrite(arch_t);
		end;
		close(arch_t);
	end;
procedure CERRAR_ARCHIVO_T(var arch_t:t_archivo_t);
	begin
		close(arch_t);
	end;
procedure ABRIR_ARCHIVO_T(var arch_t:t_archivo_t;ruta:string);
	begin
	assign(arch_t,ruta);
	reset(arch_t);
	end;
procedure POSICIONAR_ARCHIVO_T(var arch_t:t_archivo_t;var pos:byte);
	begin
	seek(arch_t,pos);
	end;
procedure REESCRIBIR_ARCHIVO_T(var arch_t:t_archivo_t);
	begin
		rewrite(arch_t);
	end;
procedure BORRAR_ARCHIVO_T(var arch_t:t_archivo_t);
	begin
		erase(arch_t);
	end;
procedure LEER_DATO_ARCHIVO_T(var arch_t:t_archivo_t;var dato_terr:t_datoterr;pos:byte);
	begin
	seek(arch_t,pos);
	read(arch_t,dato_terr);
	end;
procedure ESCRIBIR_DATO_ARCHIVO_T(var arch_t:t_archivo_t;var dato_terr:t_datoterr;pos:byte);
	begin
	seek(arch_t,pos);
	write(arch_t,dato_terr);
	end;
END.