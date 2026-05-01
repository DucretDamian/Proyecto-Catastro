unit archivo_prop22;
interface
{$codepage UTF8}
//incroporar los ueses y los encabezados de los procedimientos y funciones necesarios
uses crt, ARCHIVO_PROP_MANEJO_SIMPLE,ARCHIVO_TERREN_MANEJO_SIMPLE,VALIDACION_DE_DATOS,arbol_pro22;
procedure baja_terr(nro_contr:string;var arch_t,arch_t2:t_archivo_t);//ELIMINA TERRENOS DEL CONTTRIIBUYENTE
procedure alta_c(dni:string;var arch_p:t_archivo_p;var raiz_dni,raiz_nomb:t_puntero);
procedure baja_c(posi:byte;var arch_p:t_archivo_p);//DA BAJA LOGICA
procedure modificacion_c(var pos:byte;var arch_p:t_archivo_p);
procedure consulta_c(var state:boolean;var pos:byte;var arch_p:t_archivo_p);
procedure ABMC_c2(pos:byte;dni:string;var arch_p:t_archivo_p); //;var raiz_dni,raiz_nomb:t_puntero
procedure ABMC_c(var arch_p:t_archivo_p;var raiz_dni,raiz_nomb:t_puntero);
implementation
procedure baja_terr(nro_contr:string;var arch_t,arch_t2:t_archivo_t);
var pos,pos2:byte;
	x,aux:t_datoterr;
	buscado:boolean;
begin
	pos:=0;
	pos2:=0;
	buscado:= false;
	CREAR_ARCHIVO_T(arch_t2,ruta_t2);

	ABRIR_ARCHIVO_T(arch_t,ruta_t);
	ABRIR_ARCHIVO_T(arch_t2,ruta_t2);
	 while NOT(EOF(arch_t)) do
	    begin
	  		LEER_DATO_ARCHIVO_T(arch_t,x,pos);
	    	if (nro_contr = x.nro_contr) then
	    	begin
	    	buscado:=true;
			end
			else 	begin
					ESCRIBIR_DATO_ARCHIVO_T(arch_t2,x,pos2);
		    		pos2:=pos2+1;
		    	end;
		    	pos:=pos+1;
	    end;

	if (buscado = true)then
		begin
			CERRAR_ARCHIVO_T(arch_t);
			BORRAR_ARCHIVO_T(arch_t);
			CERRAR_ARCHIVO_T(arch_t2);
    	end;
	
		pos2:=0;
		CREAR_ARCHIVO_T(arch_t,ruta_t);
		ABRIR_ARCHIVO_T(arch_t,ruta_t);
		ABRIR_ARCHIVO_T(arch_t2,ruta_t2);
		while not(EOF(arch_t2)) do
			begin
				LEER_DATO_ARCHIVO_T(arch_t2,aux,pos2);
				ESCRIBIR_DATO_ARCHIVO_T(arch_t,aux,pos2);
				pos2:=pos2+1;
			end;
		CERRAR_ARCHIVO_T(arch_t2);
		BORRAR_ARCHIVO_T(arch_t2);
		CERRAR_ARCHIVO_T(arch_t);
end;
procedure alta_c(dni:string;var arch_p:t_archivo_p;var raiz_dni,raiz_nomb:t_puntero);
var dato_prop:t_datoprop;
	opcion,opcion2:string;
	pos:byte;
	dato_dni_arbol,dato_apinomb_arbol:t_dato_arb_prop;
	begin
    textcolor(11);
    writeln('Para dar de Alta: ');
    writeln('| Ingrese los datos a continuacion: |');
    write('Numero de Contribuyente: ');
    textcolor(white);
    
    writeln(filesize(arch_p));
    str(filesize(arch_p),dato_prop.nro_contr);

    textcolor(11);
    write('Apellido: ');
    textcolor(white);
    readln(dato_prop.apellido);
    dato_prop.apellido:= LowerCase(dato_prop.apellido);
    textcolor(11);
    write('Nombre: ');
    textcolor(white);
    readln(dato_prop.nombres);
    dato_prop.nombres:= LowerCase(dato_prop.nombres);
    textcolor(11);
    write('Direccion: ');
    textcolor(white);
    readln(dato_prop.direccion);
    dato_prop.direccion:= LowerCase(dato_prop.direccion);
    textcolor(11);
    write('Ciudad: ');
    textcolor(white);
    readln(dato_prop.ciudad);
    dato_prop.ciudad:= LowerCase(dato_prop.ciudad);
    dato_prop.dni:= dni;
    repeat
    textcolor(11);
    write('Fecha de Nacimiento (aaaa/mm/dd): ');
    textcolor(white);
    readln(dato_prop.fech_nac);
	until comprobar_fecha(dato_prop.fech_nac,17) = true;//borre linea
    repeat
    textcolor(11);
    write('Telefono: ');
    textcolor(white);
    readln(dato_prop.tel);
    until comprobar_num(dato_prop.tel,18) = true;//borre linea
    textcolor(11);
    write('Email: ');
    textcolor(white);
    readln(dato_prop.email);
    dato_prop.email:= LowerCase(dato_prop.email);
    dato_prop.estado:= false;
    //VALIDAR DATOS DEL USUARIO
    textcolor(14);
    write('HAZ INGRESADO TUS DATOS CORRECTAMENTE? (si/no): ');textcolor(white);
    readln(opcion);
    opcion:= LowerCase(opcion);
    pos:=filesize(arch_p);
    
    if opcion = 'si' then
		begin
		ESCRIBIR_DATO_ARCHIVO_P(arch_p,dato_prop,pos);
		end
    else if opcion = 'no' then
	    begin
	     textcolor(14);
	     write('Desea modificar los datos? (si/no): ');textcolor(white);
	     readln(opcion2);
	     opcion2:= LowerCase(opcion2);
	     if opcion2 = 'si'then
	     	begin
	     	ESCRIBIR_DATO_ARCHIVO_P(arch_p,dato_prop,pos);
	     	modificacion_c(pos,arch_p);
	     	end;
	    end;
	if (opcion = 'si') or (opcion2 = 'si') then
		begin
			dato_dni_arbol.dato:= dato_prop.dni;
		    dato_dni_arbol.posi:= pos;
		    agregar_nodo(raiz_dni,dato_dni_arbol);

		    dato_apinomb_arbol.dato:= dato_prop.apellido + dato_prop.nombres;
		    dato_apinomb_arbol.posi:= pos;
		    agregar_nodo(raiz_nomb,dato_apinomb_arbol);
		end;
	clrscr;
	end;
procedure baja_c(posi:byte;var arch_p:t_archivo_p);
var pos:byte;
	x:t_datoprop;
	resp:string;
	nro_contr:string;
	arch_t,arch_t2:t_archivo_t;
	begin
	pos:=posi;
	LEER_DATO_ARCHIVO_P(arch_p,x,pos);
	writeln('');
	textcolor(lightred);
	write('Seguro que quiere dar de BAJA a ');
	textcolor(white);
	write(x.nombres,' ',x.apellido);
	textcolor(lightred);
	write('? (si/no): ');
	textcolor(white);
	readln(resp);
	resp:= LowerCase(resp);
		    	if (x.estado = true) and (resp = 'si')then
		    	begin
		    		x.estado:= false;
		    		nro_contr:=x.nro_contr;
		    		textcolor(14);
		    		writeln('');
		    		writeln('----Baja EXITOSA----');
		    		//procedure que da de baja terrenos
		    		baja_terr(nro_contr,arch_t,arch_t2);
		    		ESCRIBIR_DATO_ARCHIVO_P(arch_p,x,pos);
		    	end;
		readkey;
		clrscr;
	end;
procedure modificacion_c(var pos:byte;var arch_p:t_archivo_p);
var dato,aux:t_datoprop;
	begin
		textcolor(lightred);
		writeln('ESTAS EN MODIFICACION DE PROPIETARIO');
		textcolor(11);
		writeln('PRESIONE ENTER EN LOS DATOS QUE NO DESEA MODIFICAR');
		LEER_DATO_ARCHIVO_P(arch_p,dato,pos);
		aux:= dato;
		textcolor(11);
	    write('Apellido: ');
		textcolor(white);
		readln(aux.apellido);
		aux.apellido:= LowerCase(aux.apellido);
		textcolor(11);
	    write('Nombre: ');
		textcolor(white);
		readln(aux.nombres);
		aux.nombres:= LowerCase(aux.nombres);
		textcolor(11);
	    write('Direccion: ');
		  textcolor(white);
		  readln(aux.direccion);
		  aux.direccion:= LowerCase(aux.direccion);
		  textcolor(11);
		  write('Ciudad: ');
		  textcolor(white);
		  readln(aux.ciudad);
		  aux.ciudad:= LowerCase(aux.ciudad);
		  repeat
		  textcolor(11);
		  write('Telefono: ');
		  textcolor(white);
		  readln(aux.tel);
		  until comprobar_num(aux.tel,5) = true;
		  textcolor(11);
		  write('Email: ');
		  textcolor(white);
		  readln(aux.email);
		  aux.email:= LowerCase(aux.email);
		  if aux.apellido<>''then
		  dato.apellido:= aux.apellido;
		  if aux.nombres<>''then
		  dato.nombres:= aux.nombres;
		  if aux.direccion<>''then
		  dato.direccion:= aux.direccion;
		  if aux.ciudad <> ''then
		  dato.ciudad:= aux.ciudad;
		  if aux.tel<>''then
		  dato.tel:= aux.tel;
		  if aux.email<>''then
		  dato.email:= aux.email;

		  ESCRIBIR_DATO_ARCHIVO_P(arch_p,dato,pos);
		readkey;
		clrscr;
	end;
procedure consulta_c(var state:boolean;var pos:byte;var arch_p:t_archivo_p);
var dato:t_datoprop;
	fecha_con_barras:string[10];
	begin
		
		LEER_DATO_ARCHIVO_P(arch_p,dato,pos);
		textcolor(14);
		writeln('----',dato.apellido,' ',dato.nombres,'----');
		writeln('');
		if dato.estado = true then
		begin
		textcolor(14);write('Nro contribuyente: ');textcolor(white);writeln(dato.nro_contr);
		textcolor(14);write('Apellido: ');textcolor(white);writeln(dato.apellido);
		textcolor(14);write('Nombre: ');textcolor(white);writeln(dato.nombres);
		textcolor(14);write('Direccion: ');textcolor(white);writeln(dato.direccion);
		textcolor(14);write('Ciudad: ');textcolor(white);writeln(dato.ciudad);
		textcolor(14);write('DNI: ');textcolor(white);writeln(dato.dni);
		fecha_con_barras:= mostrar_fecha(dato.fech_nac);
		textcolor(14);write('Fecha de Nacimiento: ');textcolor(white);writeln(fecha_con_barras);
		textcolor(14);write('Telefono: ');textcolor(white);writeln(dato.tel);
		textcolor(14);write('Email: ');textcolor(white);writeln(dato.email);
		textcolor(14);write('ESTADO: ');textcolor(lightgreen);writeln(dato.estado);
		end
		else begin 
		textcolor(14);write('ESTADO: ');textcolor(lightred);writeln(dato.estado);
		end;
		state:= dato.estado;
		textcolor(white);
	end;
procedure ABMC_c2(pos:byte;dni:string;var arch_p:t_archivo_p); //;var raiz_dni,raiz_nomb:t_puntero
var op:byte;
	state:boolean;
	begin
	repeat
	
	consulta_c(state,pos,arch_p);
	if state = true then
	begin
		writeln('--ELIGA OPCION--');
		writeln('');
		writeln('1. Baja');
		writeln('2. Modificacion');
		writeln('0. SALIR');
		writeln('');
		write('Opcion -> ');
		readln(op);
		clrscr;
		case op of
		1:baja_c(pos,arch_p);
		2:modificacion_c(pos,arch_p);
		end;
	end
	else begin
			op:= 0;
			readkey;
		end;
	until op=0;
	end;
procedure ABMC_c(var arch_p:t_archivo_p;var raiz_dni,raiz_nomb:t_puntero);
var op,op2,pos:byte;
var encontrado: t_puntero;
var dni:string;
	begin
	  	CREAR_ARCHIVO_P(arch_p,ruta_p);
	  	repeat
		encontrado:=nil;
		clrscr;
		textcolor(14);
		writeln('------ CONTRIBUYENTES -------');
		writeln(' ');
		writeln('----Para salir NO inegrese ningun dato----');
		textcolor(white);
		repeat
		write('Ingrese DNI: ');
		readln(dni);
		until comprobar_num(dni,4) = true;
		dni:=LowerCase(dni);
		if (dni<> '') then
		begin
			encontrado:= preorden(raiz_dni,dni);
			if encontrado=nil then
			begin
			textcolor(14);
			writeln('--NO EXISTE--');
				if (dni <> '')then
				begin
					writeln('Va a agregar?');
					writeln('1. SI');
					writeln('2. NO');
					write('Opcion -> ');
					readln(op2);
					if op2 = 1 then
					begin
					ABRIR_ARCHIVO_P(arch_p,ruta_p);
					alta_c(dni,arch_p,raiz_dni,raiz_nomb);
					CERRAR_ARCHIVO_P(arch_p);
					end;
				end;
			end
			else if (dni <> '') and (encontrado <>nil) then
			begin
				pos:=encontrado^.info.posi;
				ABRIR_ARCHIVO_P(arch_p,ruta_p);
				ABMC_c2(pos,dni,arch_p);
				CERRAR_ARCHIVO_P(arch_p);
			end;
		end;
			if (dni = '')then
				op:=0;
				clrscr;
		until op = 0;
	end;
end.