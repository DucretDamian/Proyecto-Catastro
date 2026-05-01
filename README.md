# Sistema de Gestión Catastro

Este proyecto es una aplicación de consola robusta desarrollada en **Pascal**, diseñada para la administración y control de contribuyentes y sus terrenos correspondientes. El sistema permite gestionar de manera eficiente el registro de propiedades, el cálculo automático de avalúos y la generación de estadísticas detalladas.

## 🚀 Funcionalidades Principales

* **Gestión de Contribuyentes (ABMC):** Administración completa de los datos de los propietarios, permitiendo búsquedas rápidas mediante el uso de estructuras de datos optimizadas.
* **Gestión de Terrenos (ABMC):** Registro de parcelas vinculadas a cada contribuyente, incluyendo número de plano, domicilio, superficie y zona.
* **Cálculo de Avalúo Automático:** Función inteligente que calcula el valor de la propiedad basándose en la superficie, el tipo de edificación (5 categorías) y la zona de ubicación (5 zonas).
* **Generación de Comprobantes:** Módulo para visualizar un resumen detallado de los datos del propietario y todos los terrenos asociados a su DNI.
* **Reportes y Listados:**
    * Listado ordenado por **Apellido y Nombre** (utilizando recorridos de árboles binarios).
    * Listado ordenado por **Fecha de Inscripción**.
    * Listado clasificado por **Zonas Geográficas**.

## ⚠️ Consideraciones y Advertencias

* **Persistencia de Datos:** Al ejecutar el programa, se crearán automáticamente archivos con extensión `.DAT` en el mismo directorio del ejecutable. Estos archivos son necesarios para almacenar la información de contribuyentes y terrenos de forma permanente.
* **Limitaciones de Validación:** Las rutinas de validación actuales pueden presentar comportamientos inesperados en casos muy específicos. Por ejemplo, si se deja un campo de DNI vacío, el sistema podría informar que "no se encontró el registro" en lugar de solicitar una entrada válida. Se recomienda ingresar los datos siguiendo el formato solicitado.

## 🛠️ Detalles Técnicos

El sistema destaca por una implementación organizada en unidades funcionales:

* **Estructuras de Datos:** Utiliza **Árboles Binarios de Búsqueda** para optimizar la localización de contribuyentes por DNI y Nombre.
* **Persistencia:** Manejo de **Archivos Binarios** para el almacenamiento permanente de la información.
* **Interfaz de Usuario (TUI):** Menú interactivo con navegación mediante flechas de teclado, colores y manejo de coordenadas en pantalla para una mejor experiencia de usuario.
* **Validación:** Módulo dedicado (`VALIDACION_DE_DATOS`) para asegurar la integridad de fechas y tipos de datos numéricos.

## 📁 Estructura del Proyecto

| Unidad | Descripción |
| :--- | :--- |
| `catastro22.pas` | Programa principal y punto de entrada. |
| `archivo_terreno22.pas` | Lógica de negocio para la gestión de terrenos y cálculos de avalúo. |
| `estadistica_catastro2.pas` | Procesamiento de datos y métricas del sistema. |
| `menu_catastro2.pas` | Implementación del menú principal y navegación. |
| `visual_op.pas` | Funciones estéticas y de control de movimiento en el menú. |
| `VALIDACION_DE_DATOS.pas` | Motor de validación de entradas de usuario. |

## ⚙️ Instalación y Ejecución

### 1. Requisitos Previos
Necesitarás tener instalado el compilador **Free Pascal (FPC)**. 
* **Linux:** `sudo pacman -S fpc` o `sudo apt install fpc`
* **Windows:** Descarga el instalador desde [freepascal.org](https://www.freepascal.org/download.html).

### 2. Compilación
Clona el repositorio y compila el programa principal desde la terminal:
```bash
fpc catastro22.pas
