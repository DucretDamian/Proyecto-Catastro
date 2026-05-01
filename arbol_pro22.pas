unit arbol_pro22;
interface
{$codepage UTF8}
uses crt,ARCHIVO_PROP_MANEJO_SIMPLE;
	type t_dato_arb_prop=record
				dato:string[100];//dni o api y nomb
				posi:byte;
				end;
		t_puntero = ^t_nodo;
		
		t_nodo =record
			info:t_dato_arb_prop;
			SAI,SAD:t_puntero;
			end;
procedure crear_arbol(var raiz:t_puntero);
function arbol_vacio(raiz:t_puntero):boolean;
procedure agregar_nodo(var raiz:t_puntero; x:t_dato_arb_prop);
procedure cargar_arbol_dni(var raiz_dni:t_puntero;var arch_p:t_archivo_p);
procedure cargar_arbol_api(var raiz_nomb:t_puntero;var arch_p:t_archivo_p);
function preorden(var raiz:t_puntero;buscar:string):t_puntero;
implementation
//crea el arbol
procedure crear_arbol(var raiz:t_puntero);
	begin
	raiz:=nil;
	end;
//verificacion de si el arbol esta vacio
function arbol_vacio(raiz:t_puntero):boolean;
	begin
		arbol_vacio:=raiz=nil;
	end;
//agrega nodos
procedure agregar_nodo(var raiz:t_puntero; x:t_dato_arb_prop);
	begin
		if (raiz=nil) or ((raiz^.info.dato = x.dato) and (raiz^.info.posi = x.posi)) then
			begin
				new(raiz);
				raiz^.info:=x;
				raiz^.SAI:=nil;
				raiz^.SAD:=nil;
			end
		else
			begin
			if raiz^.info.dato > x.dato then 
			begin
					agregar_nodo(raiz^.SAI,x);
			end
			else 
					agregar_nodo(raiz^.SAD,x);
				end;
	end;
//carga los arboles 
procedure cargar_arbol_dni(var raiz_dni:t_puntero;var arch_p:t_archivo_p);
var x:t_datoprop;
var pos:byte;
var dato_arb:t_dato_arb_prop;
	begin
	ABRIR_ARCHIVO_P(arch_p,ruta_p);
	pos:=0;
		while (NOT(EOF(arch_p))) do
		begin
			LEER_DATO_ARCHIVO_P(arch_p,x,pos);
			dato_arb.posi:= pos;
			dato_arb.dato:= x.dni;
			agregar_nodo(raiz_dni,dato_arb);
			pos:=pos+1;
		end;
	CERRAR_ARCHIVO_P(arch_p);
	end;
procedure cargar_arbol_api(var raiz_nomb:t_puntero;var arch_p:t_archivo_p);
var x:t_datoprop;
var dato_arb:t_dato_arb_prop;
var pos:byte;
	begin
	ABRIR_ARCHIVO_P(arch_p,ruta_p);
	pos:=0;
		while (NOT(EOF(arch_p))) do
		begin
			LEER_DATO_ARCHIVO_P(arch_p,x,pos);
			dato_arb.posi:= pos;
			dato_arb.dato:= x.apellido + x.nombres;
			textcolor(11);
			agregar_nodo(raiz_nomb,dato_arb);
			pos:=pos+1;
		end;
	CERRAR_ARCHIVO_P(arch_p);
	textcolor(white);
	end;
function preorden(var raiz:t_puntero;buscar:string):t_puntero;
	begin
		if raiz = nil then
		begin
		preorden:=nil;
		end
		else if (raiz^.info.dato = buscar) then
			begin
			preorden:= raiz;
			end
			else if raiz^.info.dato > buscar then
				preorden:= preorden(raiz^.SAI,buscar)
				else if raiz^.info.dato < buscar then
				preorden:= preorden(raiz^.SAD,buscar)
				else if raiz^.info.dato <> buscar then
				preorden:=nil;
	end;
end.