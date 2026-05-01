unit menu_catastro2;
interface
{$codepage UTF8}
uses
   crt,visual_op,ARCHIVO_PROP_MANEJO_SIMPLE,ARCHIVO_TERREN_MANEJO_SIMPLE,archivo_prop22,arbol_pro22,archivo_terreno22,listado_apinomb22,listado_fechaa22,listado_zonass22,estadistica_catastro2;
//Menu Principal
procedure menu();
implementation
procedure menu();
// var op:string[2];//opcion
var tecla:string;
var actual:byte;
var arch_p: t_archivo_p;
var arch_t,arch_t2: t_archivo_t;
var raiz_dni,raiz_nomb:t_puntero;
	begin
		actual:=1;
		crear_arbol(raiz_dni);
		crear_arbol(raiz_nomb);
		cargar_arbol_api(raiz_nomb,arch_p);
		writeln('');
		cargar_arbol_dni(raiz_dni,arch_p);
	repeat
		//crea y carga arboles
		clrscr;
		textcolor(white);

		gotoxy(2,1);
		writeln('| | Menu Principal Catastro | |');
		// gotoxy(2,2);
		pinta_linea(2,3,actual+2,0,15);
		writeln(' Contribuyentes ');
		// gotoxy(2,3);
		pinta_linea(2,4,actual+2,0,15);
		writeln(' Terrenos ');
		// gotoxy(2,4);
		pinta_linea(2,5,actual+2,0,15);
		writeln(' Listado ordenado por Apellido y Nombre ');
		// gotoxy(2,5);
		pinta_linea(2,6,actual+2,0,15);
		writeln(' Listado ordenado por fecha ');
		// gotoxy(2,6);
		pinta_linea(2,7,actual+2,0,15);
		writeln(' Listado ordenado por Zonas ');
		// gotoxy(2,7);
		pinta_linea(2,8,actual+2,0,15);
		writeln(' Estadisticas ');
		// gotoxy(2,8);
		pinta_linea(2,9,actual+2,0,15);
		writeln(' Comprobante de datos ');
		// gotoxy(2,9);
		pinta_linea(2,10,actual+2,15,4);
		writeln(' SALIR ');
		textcolor(white);textbackground(black);
		// gotoxy(2,10);
		// writeln('NOTA: Ingresar Opcion y Presionar "ENTER"');
		// gotoxy(2,11);
		//writeln('Ingresar Opcion:');readln(op);
		tecla:= readkey;
		mover_mouse(actual,8,1,tecla);
		if (actual <> 8)and (tecla = CHR(13)) then
		case actual of
		1:ABMC_c(arch_p,raiz_dni,raiz_nomb);//ABMC de contribuyentes (consulta por DNI)
		2:ABMC_t(arch_p,arch_t,arch_t2,raiz_dni);//ABMC de terrenos(consulta por DNI)
		3:listado_apynom(arch_t,arch_p,raiz_nomb);
		4:genera_listado_fecha(arch_t);
		5:listado_por_zona(arch_t);
		6:estadistica(arch_p,arch_t);
		7:comprobante(arch_t,arch_p);
		end;
		clrscr;
	until (actual = 8) and (tecla = CHR(13));
	end;
end.