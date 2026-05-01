UNIT ARCHIVO_PROP_MANEJO_SIMPLE;
INTERFACE
{$codepage UTF8}
uses crt;
const
	ruta_p = 'Archivo_Propietario.DAT';
type
	  t_datoprop=record
    nro_contr:string[8];
    apellido:string[30];
    nombres:string[30];
    direccion:string[40];
    ciudad:string[40];
    dni:string[8];
    fech_nac:string[8];
    tel:string[20];
    email:string[30];
    estado:boolean;
  end;
	 t_archivo_p = file of t_datoprop; 
procedure CREAR_ARCHIVO_P(var arch_p:t_archivo_p;ruta_p:string);
procedure CERRAR_ARCHIVO_P(var arch_p:t_archivo_p);
procedure ABRIR_ARCHIVO_P(var arch_p:t_archivo_p;ruta_p:string);
procedure POSICION_ARCHIVO_P(var arch_p:t_archivo_p;var pos:byte);
procedure LEER_DATO_ARCHIVO_P(var arch_p:t_archivo_p;var dato_prop:t_datoprop;pos:byte);
procedure ESCRIBIR_DATO_ARCHIVO_P(var arch_p:t_archivo_p;var dato_prop:t_datoprop;pos:byte);
IMPLEMENTATION
procedure CREAR_ARCHIVO_P(var arch_p:t_archivo_p;ruta_p:string);
	begin
		assign(arch_p,ruta_p);
		{$i-}
	  	Reset (arch_p);
	  	{$i+}
		if IOResult <> 0 then
		begin
		rewrite(arch_p);
		end;
		close(arch_p);
	end;
procedure CERRAR_ARCHIVO_P(var arch_p:t_archivo_p);
	begin
		close(arch_p);
	end;
procedure ABRIR_ARCHIVO_P(var arch_p:t_archivo_p;ruta_p:string);
	begin
	assign(arch_p,ruta_p);
	reset(arch_p);
	end;
procedure POSICION_ARCHIVO_P(var arch_p:t_archivo_p;var pos:byte);
	begin
	seek(arch_p,pos);
	end;
procedure LEER_DATO_ARCHIVO_P(var arch_p:t_archivo_p;var dato_prop:t_datoprop;pos:byte);
	begin
	seek(arch_p,pos);
	read(arch_p,dato_prop);
	end;
procedure ESCRIBIR_DATO_ARCHIVO_P(var arch_p:t_archivo_p;var dato_prop:t_datoprop;pos:byte);
	begin
	seek(arch_p,pos);
	write(arch_p,dato_prop);
	end;
END.