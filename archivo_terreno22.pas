unit archivo_terreno22;
interface
{$codepage UTF8}
uses crt,ARCHIVO_PROP_MANEJO_SIMPLE,VALIDACION_DE_DATOS,ARCHIVO_TERREN_MANEJO_SIMPLE,arbol_pro22;
procedure comprobante(var arch_t:t_archivo_t; var arch_p:t_archivo_p);
function busqueda_nrocontr_dni(var raiz_dni:t_puntero; var x:string;var arch_p:t_archivo_p):string;
function avaluo(var tipo_edif,zona:byte;var super:integer;var valor_basico:real): real;
procedure alta_t(contri:string;var arch_t:t_archivo_t;var arch_p:t_archivo_p;var raiz_dni:t_puntero);
procedure contri_true(var arch_p:t_archivo_p;contri:string);//da de alta elcontribuyente al agregar un terreno
procedure baja_t(var arch_p:t_archivo_p;contri:string;var arch_t:t_archivo_t;var arch_t2:t_archivo_t;var buscado:boolean;var raiz_dni:t_puntero);
procedure contri_false(var arch_p:t_archivo_p;contri:string);
procedure modificacion_t(contri:string;var arch_t:t_archivo_t;var raiz_dni:t_puntero);
procedure consulta_t(contri:string;var arch_t:t_archivo_t;var raiz_dni:t_puntero);
procedure ABMC_t2(contri:string;var arch_p:t_archivo_p;var arch_t,arch_t2:t_archivo_t;var buscado:boolean;var raiz_dni:t_puntero);
procedure ABMC_t(var arch_p:t_archivo_p;var arch_t,arch_t2:t_archivo_t;var raiz_dni:t_puntero);
implementation
procedure comprobante(var arch_t:t_archivo_t; var arch_p:t_archivo_p);
var DNI:string[8];
var contri,fecha:string; //fecha
var pos,pos2:byte;
var dato_prop:t_datoprop;
var dato_ter:t_datoterr;
	estado,existe:boolean;
begin
	clrscr;
	pos:=0;
	existe:=false;
	pos2:=0;
	textcolor(14);
  	writeln('------ COMPROBANTE -------');
  	writeln(' ');
  	repeat
  	textcolor(white);
	write('Introduzca el DNI: ');
	readln(DNI);
	until comprobar_num(dni,3) = true;

	ABRIR_ARCHIVO_P(arch_p,ruta_p);
	while not(EOF(arch_p)) do
	begin
	LEER_DATO_ARCHIVO_P(arch_p,dato_prop,pos);
		if (DNI = dato_prop.dni) then
		begin
		// fecha:= mostrar_fecha(dato_prop.fech_nac);
		textcolor(lightgreen);
		writeln('-----|/////////////////////|-------');
		writeln('-----|DATOS DEL PROPIETARIO|-----');
		writeln('-----|/////////////////////|-------');
		textcolor(white);
		writeln('----',dato_prop.apellido,' ',dato_prop.nombres,'----');
		writeln('');
		textcolor(14);write('Nro contribuyente: ');textcolor(white);writeln(dato_prop.nro_contr);
		textcolor(14);write('Apellido: ');textcolor(white);writeln(dato_prop.apellido);
		textcolor(14);write('Nombre: ');textcolor(white);writeln(dato_prop.nombres);
		textcolor(14);write('Direccion: ');textcolor(white);writeln(dato_prop.direccion);
		textcolor(14);write('Ciudad: ');textcolor(white);writeln(dato_prop.ciudad);
		textcolor(14);write('DNI: ');textcolor(white);writeln(dato_prop.dni);
		fecha:= mostrar_fecha(dato_prop.fech_nac);
		textcolor(14);write('Fecha de Nacimiento: ');textcolor(white);writeln(fecha); //(fecha) o (dato_prop.fech_nac)
		textcolor(14);write('Telefono: ');textcolor(white);writeln(dato_prop.tel);
		textcolor(14);write('Email: ');textcolor(white);writeln(dato_prop.email);
		textcolor(14);write('ESTADO: ');textcolor(white);writeln(dato_prop.estado);
		estado:= dato_prop.estado;
		contri:= dato_prop.nro_contr;
		existe:=true;
		end;
	pos:=pos+1;
	end;
	CERRAR_ARCHIVO_P(arch_p);
	if existe = false then
	writeln('NO EXISTE')
	else if (estado = false) and (existe = true)then
	begin
	textcolor(lightred);
	writeln('-----|/////////////////|-----');
	writeln('-----|NO TIENE TERRENOS|-----');
	writeln('-----|/////////////////|-------');
	textcolor(white);
	end
	else	begin
			textcolor(lightgreen);
			writeln('-----|/////////////////|-------');
			writeln('-----|DATOS DE TERRENOS|-----');
			writeln('-----|/////////////////|-------');
			textcolor(white);
			writeln('----------------------------------------------------');
			textcolor(14);
			writeln('Nro plano     valor    super   zona   tipo_edif');
			textcolor(white);
			writeln('----------------------------------------------------');
			end;
	ABRIR_ARCHIVO_T(arch_t,ruta_t);
	while not(EOF(arch_t)) do
	begin
	LEER_DATO_ARCHIVO_T(arch_t,dato_ter,pos2);
		if contri = dato_ter.nro_contr then
		begin
		writeln(dato_ter.nro_plano,'     ',dato_ter.valor:0:2,'    ',dato_ter.super,'    ',dato_ter.zona,'    ',dato_ter.tipo_edif);
		end;
	pos2:=pos2+1;
	end;
	CERRAR_ARCHIVO_T(arch_t);
	readkey;
end;
//BUSQUEDA DE Nro de contribuyente con el DNI
function busqueda_nrocontr_dni(var raiz_dni:t_puntero; var x:string;var arch_p:t_archivo_p):string;
var arbol_dni:t_puntero;
var vacio:string;
var dato_prop:t_datoprop;
begin
	vacio:='no';
	arbol_dni:=preorden(raiz_dni, x);

	if arbol_dni = nil then
		busqueda_nrocontr_dni:= vacio
	else
		begin
		ABRIR_ARCHIVO_p(arch_p,ruta_p);
		LEER_DATO_ARCHIVO_P(arch_p,dato_prop,arbol_dni^.info.posi);
		busqueda_nrocontr_dni:= dato_prop.nro_contr;
		CERRAR_ARCHIVO_P(arch_p);
		end;
end;
//Realiza el calculo del valor de la propiedad
function avaluo(var tipo_edif,zona:byte;var super:integer;var valor_basico:real): real;
var valor_zona,valor_edif:real;
begin
         case zona of 
         			//segun la zona 
                    1: valor_zona:=1.5;
                    2: valor_zona:=1.1;
                    3: valor_zona:=0.7;
                    4: valor_zona:=0.4;
                    5: valor_zona:=0.1;
                   end;
        case tipo_edif of
        			//segun el tipo de edificacion 
		          1: valor_edif:=1.7;
		          2: valor_edif:=1.3;
		          3: valor_edif:=1.1; 
		          4: valor_edif:=0.8;
		          5: valor_edif:=0.5;
		         end;
    avaluo:= (valor_basico*super*valor_edif*valor_zona); // calculo
end;
procedure alta_t(contri:string;var arch_t:t_archivo_t;var arch_p:t_archivo_p;var raiz_dni:t_puntero);
var pos:byte;
var op1:string[5];
var super_int:integer;
var buscado:boolean;
var x,dato:t_datoterr;
var valor_m2:real;
    begin
     	valor_m2:=12308.60;
    	textcolor(11);
    	writeln('Para dar de Alta:');
    	writeln('| Ingrese los datos a continuacion: |');
        dato.nro_contr:= contri;

        contri_true(arch_p,contri);

        textcolor(11);
        write('Numero de plano: ');
        textcolor(white);
        readln(dato.nro_plano);
    pos:=0;
    buscado:=false;
    if (NOT(EOF(arch_t))) then
	    begin
	     	while(NOT EOF(arch_t)) and (buscado = false) do
	     	begin
	     		LEER_DATO_ARCHIVO_T(arch_t,x,pos);
	     		if (x.nro_contr = dato.nro_contr) and (x.nro_plano = dato.nro_plano) then
	     			begin
	     			writeln('Ya EXISTE el numero de plano para este Contribuyente');
	     			buscado:=true;
	     			end
	     		else begin
	          		pos:=pos+1;
	          		end;
	     	end;
    	end;
    if buscado = false then
    begin
        repeat
        textcolor(11);
        write('Fecha de inscripcion (aaaa/mm/dd): ');
        textcolor(white);
        readln(dato.fecha_insc);
        textcolor(11);
        until comprobar_fecha(dato.fecha_insc,4) = true; //copy(dato.fecha_insc,1,4) <= '2023' and copy(dato.fecha_insc,5,6) <= 12;
        write('Domicilio: ');
        textcolor(white);
        readln(dato.domicilio);
        dato.domicilio:= LowerCase(dato.domicilio);
        textcolor(11);
        write('Super en m2: ');
        textcolor(white);
        readln(dato.super);
        repeat
        textcolor(11);
        write('Zona (1/2/3/4/5): ');
        textcolor(white);
        readln(dato.zona);
        textcolor(11);
        write('Tipo de Edificacion (1/2/3/4/5): ');
        textcolor(white);
        readln(dato.tipo_edif);
        until ((dato.zona<=5) and (dato.zona>=1)) and ((dato.tipo_edif>=1) and (dato.tipo_edif<=5));
    	Val(dato.super, super_int);
    	dato.valor:= avaluo(dato.tipo_edif,dato.zona,super_int,valor_m2);
    	write('Haz ingresado los datos correctamente?');
    	textcolor(lightred);write('(si/no): '); textcolor(white);
    	readln(op1);
    	op1:=lowercase(op1);
    	if op1='si' then
    	ESCRIBIR_DATO_ARCHIVO_T(arch_t,dato,pos)
    	else if op1 = 'no' then
    	writeln('Los datos no han sido guardados');
    	//ESCRIBIR_DATO_ARCHIVO_T(arch_t,dato,pos);
     end;
     readkey;
     clrscr;
     end;
procedure contri_true(var arch_p:t_archivo_p;contri:string);
var dato_p:t_datoprop;
var pos:byte;
	begin
	pos:=0;
	ABRIR_ARCHIVO_P(arch_p,ruta_p);
	while not(EOF(arch_p)) do
	begin
		LEER_DATO_ARCHIVO_P(arch_p,dato_p,pos);
		if (dato_p.nro_contr = contri) then
		begin
			dato_p.estado:= true;
			ESCRIBIR_DATO_ARCHIVO_P(arch_p,dato_p,pos);
		end;
		pos:= pos + 1;
	end;
	CERRAR_ARCHIVO_P(arch_p);
	end;
//Realiza baja sobre el archivo 
procedure baja_t(var arch_p:t_archivo_p;contri:string;var arch_t:t_archivo_t;var arch_t2:t_archivo_t;var buscado:boolean;var raiz_dni:t_puntero);
var plano:string[8];
var pos,pos_3,contador,pos2,op:byte;
var x,aux,dato:t_datoterr;
	begin
	pos:=0;
	pos2:=0;
	contador:=0;
	buscado:= false;
	textcolor(11);
	writeln('Para dar de Baja un terreno: ');
	textcolor(11);
	write('Introduzca Numero de plano: ');
	textcolor(white);
	readln(plano);

	CREAR_ARCHIVO_T(arch_t2,ruta_t2);
	ABRIR_ARCHIVO_T(arch_t2,ruta_t2);
	 while NOT(EOF(arch_t)) do
	    begin
	    	LEER_DATO_ARCHIVO_T(arch_t,x,pos);
	    	if (contri = x.nro_contr) and (plano = x.nro_plano) then
	    	begin
	    	buscado:=true;
	    	textcolor(14);
					writeln('');
					writeln('----Nro de Contribuyente: ',x.nro_contr,'----');
					writeln('');
					textcolor(14);write('Nro plano: ');textcolor(white);writeln(x.nro_plano);
					textcolor(14);write('Avaluo: ');textcolor(white);writeln(x.valor:0:2);
					textcolor(14);write('Fecha de inscripcion: ');textcolor(white);writeln(x.fecha_insc);
					textcolor(14);write('Domicilio: ');textcolor(white);writeln(x.domicilio);
					textcolor(14);write('Super: ');textcolor(white);writeln(x.super);
					textcolor(14);write('Zona: ');textcolor(white);writeln(x.zona);
					textcolor(14);write('Tipo de Edificacion: ');textcolor(white);writeln(x.tipo_edif);
					writeln('');
					textcolor(lightred);
					writeln('¿Dar de baja?');
					textcolor(white);
					writeln('1: Si');
					writeln('2: No');
					write('Opcion -> ');
					readln(op);
			end;
	    	if (contri <> x.nro_contr) OR (plano <> x.nro_plano)then
		    	begin
		    		ESCRIBIR_DATO_ARCHIVO_T(arch_t2,x,pos2);
		    		pos2:=pos2+1;
		    	end;
		    pos:=pos+1;
	    end;

	if (buscado = false)  then
		  begin
		  textcolor(14);
		  writeln('');
			writeln('----Este terreno NO existe----');
			textcolor(white);
			readkey;
			end;
	if (buscado = true) and (op = 1) then
		begin
			CERRAR_ARCHIVO_T(arch_t);
			BORRAR_ARCHIVO_T(arch_t);
			CERRAR_ARCHIVO_T(arch_t2);
	    		writeln('');
	    		writeln('----BAJA EXITOSA----');
	    		readkey;
    	
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
		CERRAR_ARCHIVO_T(arch_t);
		ABRIR_ARCHIVO_T(arch_t,ruta_t);
		pos_3:=0;
		while NOT(EOF(arch_t)) do 
			begin
			LEER_DATO_ARCHIVO_T(arch_t,dato,pos_3);
			if contri = dato.nro_contr then
				begin
				contador:= contador +1;
				end;
			pos_3:= pos_3+1;
			end;

		if (contador = 0)then
			begin
			contri_false(arch_p,contri);
			end;
		end;
		if op=2 then
		clrscr;
		CERRAR_ARCHIVO_T(arch_t2);
		BORRAR_ARCHIVO_T(arch_t2);
		CERRAR_ARCHIVO_T(arch_t);
		clrscr;
	end;
procedure contri_false(var arch_p:t_archivo_p;contri:string);
var pos:byte;
var dato_prop:t_datoprop;
	begin
	pos:=0;
	ABRIR_ARCHIVO_P(arch_p,ruta_p);
	while NOT(EOF(arch_p)) do
		begin
		LEER_DATO_ARCHIVO_P(arch_p,dato_prop,pos);
		if (dato_prop.nro_contr = contri)then
		begin
			dato_prop.estado:= false;
			ESCRIBIR_DATO_ARCHIVO_P(arch_p,dato_prop,pos);
		end;
		pos:=pos+1;
		end;
	CERRAR_ARCHIVO_P(arch_p);
	end;
//modificacion de datos (superficie y tipo de edificacion) y recalculo del avaluo
procedure modificacion_t(contri:string;var arch_t:t_archivo_t;var raiz_dni:t_puntero);
var pos,op:byte;
var dato:t_datoterr;
var plano:string[8];
var encontrado:boolean;
var super_int:integer;
var valor_m2:real;
	begin
		valor_m2:=12308.60;
		pos:=0;
		encontrado:=false;
		textcolor(11);
		writeln('Para realizar una Modificacion: ');
		textcolor(11);
		write('Numero de plano: ');
		textcolor(white);
		readln(plano);
		while not (EOF(arch_t)) and (encontrado = false)  do
		begin
			LEER_DATO_ARCHIVO_T(arch_t,dato,pos);
			if (dato.nro_plano = plano) and (dato.nro_contr = contri) then
			begin
				encontrado:=true;
				repeat
					writeln('----Modificacion----');
					writeln('1: Superficie');
					writeln('2: Tipo de Edificacion');
					writeln('0: SALIR');
					readln(op);
					clrscr;
					case op of
					1:begin
							writeln('Superficie en m2: ');
							readln(dato.super);
							clrscr;
						end;
					2:begin
							repeat
							writeln('Tipo de Edificacion (1/2/3/4/5): ');
							readln(dato.tipo_edif);
							until (dato.tipo_edif>=1) and (dato.tipo_edif<=5);
							clrscr;
						end;
					end;

				until op=0;
				Val(dato.super, super_int);
   				dato.valor:= avaluo(dato.tipo_edif,dato.zona,super_int,valor_m2);
   				ESCRIBIR_DATO_ARCHIVO_T(arch_t,dato,pos);
		  	end;
		  	pos:=pos+1;
			end;
			if (encontrado= false) and (op<>0) then
			begin
			textcolor(14);
			writeln('----NO ENCONTRADO----');
			textcolor(white);
			readkey;
			end;
			clrscr;
			end;
//muestra de datos de los terrenos de un contribuyente
procedure consulta_t(contri:string;var arch_t:t_archivo_t;var raiz_dni:t_puntero);
var dato:t_datoterr;
	pos:byte;
	encontrado:boolean;
	fecha_con_barras:string[10];
	begin
		pos:=0;
		encontrado:=false;
		textcolor(11);
		writeln('Para realizar una Consulta: ');
		if (pos=0)and (NOT(EOF(arch_t))) and (encontrado = false)then
		begin
			while (NOT(EOF(arch_t))) do
			begin
				LEER_DATO_ARCHIVO_T(arch_t,dato,pos);
				if (contri=dato.nro_contr) then
				begin
				textcolor(14);
					writeln('');
					writeln('----Nro de Contribuyente: ',dato.nro_contr,'----');
					writeln('');
					textcolor(14);write('Nro contribuyente: ');textcolor(white);writeln(dato.nro_contr);
					textcolor(14);write('Nro plano: ');textcolor(white);writeln(dato.nro_plano);
					textcolor(14);write('Avaluo: ');textcolor(white);writeln(dato.valor:0:2);
					fecha_con_barras:=mostrar_fecha(dato.fecha_insc);
					textcolor(14);write('Fecha de inscripcion: ');textcolor(white);writeln(fecha_con_barras);
					textcolor(14);write('Domicilio: ');textcolor(white);writeln(dato.domicilio);
					textcolor(14);write('Super: ');textcolor(white);writeln(dato.super);
					textcolor(14);write('Zona: ');textcolor(white);writeln(dato.zona);
					textcolor(14);write('Tipo de Edificacion: ');textcolor(white);writeln(dato.tipo_edif);
					encontrado:=true;
					readkey;
				end;
				pos:=pos+1;
			end;
		end;
	if encontrado = false then
	begin
	textcolor(14);
	writeln('----NO TIENE TERRENOS----');
	readkey;
	end;

	writeln(contri);
	textcolor(white);
	clrscr;
	end;
procedure ABMC_t2(contri:string;var arch_p:t_archivo_p;var arch_t,arch_t2:t_archivo_t;var buscado:boolean;var raiz_dni:t_puntero);
var op:byte;
	begin
		ABRIR_ARCHIVO_T(arch_t,ruta_t);
		repeat

			writeln(' ');
			writeln('1. Alta');
			writeln('2. Baja');
			writeln('3. Modificacion');
			writeln('4. Consulta');
			writeln('0. SALIR');
			writeln('');
			write('Opcion -> ');
			readln(op);
			clrscr;
			{-----------------------}
			Reset(arch_t);
			{-----------------------}
			case op of
			1:alta_t(contri,arch_t,arch_p,raiz_dni);
			2:baja_t(arch_p,contri,arch_t,arch_t2,buscado,raiz_dni);
			3:modificacion_t(contri,arch_t,raiz_dni);
			4:consulta_t(contri,arch_t,raiz_dni);
			end;
		until op=0;
		CERRAR_ARCHIVO_T(arch_t);
	end;

//MENU ABMC de Terrenos
procedure ABMC_t(var arch_p:t_archivo_p;var arch_t,arch_t2:t_archivo_t;var raiz_dni:t_puntero);
var op:byte;
var dni,contri:string;
var buscado:boolean;
	begin
	CREAR_ARCHIVO_T(arch_t,ruta_t);
	repeat
		clrscr;
		textcolor(14);
		writeln('------ TERRENOS -------');
		writeln('');
		repeat
		textcolor(white);
		write('Ingrese DNI: ');
		readln(dni);
		until comprobar_num(dni,3) = true;
		contri:='';
		if (dni <> '') then
		begin
		ABRIR_ARCHIVO_T(arch_t,ruta_t);
		contri:= busqueda_nrocontr_dni(raiz_dni,dni,arch_p);
		CERRAR_ARCHIVO_T(arch_t);
			if contri <> 'no' then
				ABMC_t2(contri,arch_p,arch_t,arch_t2,buscado,raiz_dni)
			else begin
				writeln('NO SE ENCUENTRA');
			readkey;
			end;
		end
		else op:=0;
	until op = 0;
	end;
end.
