  

# Documentación de ElBuscaMaquinas

![[A_professional_banner_for_'ElBuscaMaquinas'_with_a.png]] 

---

  

## ¿Qué es ElBuscaMaquinas?

  

**ElBuscaMaquinas** es una herramienta en Bash diseñada para interactuar con el archivo `bundle.js` disponible en `https://htbmachines.github.io/bundle.js`. Esta herramienta permite buscar información sobre máquinas de Hack The Box (HTB) por nombre, dirección IP, dificultad y sistema operativo, así como listar todas las máquinas disponibles.  



---

  

## ¿Cómo ejecutar la herramienta?

  

Para ejecutar **ElBuscaMaquinas**, sigue estos pasos:

  

1. **Asegúrate de tener las dependencias requeridas**:

   - Asegúrate de que `js-beautify` esté instalado. Si no, puedes instalarlo usando:

     ```bash

     npm install -g js-beautify

     ```

2. **Descarga o clona el script desde GitHub**:

   - Clona el repositorio:

     ```bash

     git clone https://github.com/RogelioGF/ElBuscaMaquinas.git

     ```

   - Navega al directorio:

     ```bash

     cd ElBuscaMaquinas

     ```

  

3. **Haz que el script sea ejecutable** (si no lo es ya):

   ```bash

   chmod +x htbmachines.sh

   ```

  

4. **Ejecuta el script**:

   ```bash

   ./htbmachines.sh

   ```

  

---

  

## Herramientas adicionales necesarias

  

La única herramienta adicional necesaria es `js-beautify` para formatear código JSON o JavaScript. Asegura que el código esté correctamente formateado y sea fácil de leer.

  

---



## Opciones Disponibles

El script **ElBuscaMaquinas** cuenta con varias opciones para diferentes funcionalidades. A continuación se enumeran y describen cada una de ellas:

- `-u`: **Descargar e instalar dependencias necesarias.**
    - Esta opción asegura que todas las dependencias necesarias estén instaladas en el sistema.
- `-m [nombre]`: **Buscar por nombre de máquina.**
    - Busca y muestra información de las máquinas cuyo nombre contiene el término proporcionado.
- `-i [IP]`: **Buscar por dirección IP de máquina.**
    - Busca y muestra información de las máquinas cuya dirección IP contiene el término proporcionado.
- `-d [dificultad]`: **Buscar por dificultad de máquina.**
    - Busca y muestra información de las máquinas cuya dificultad coincide con la proporcionada.
- `-o [sistema operativo]`: **Buscar por sistema operativo de máquina.**
    - Busca y muestra información de las máquinas cuyo sistema operativo contiene el término proporcionado.
- `-s [skill]`: **Buscar por skill**
    - Busca y muestra información de las máquinas que requieren ciertas habilidades.
- `-c [certificación]`: **Buscar por certificación.**
	- Busca y muestra información de las máquinas que están relacionadas con una certificación específica.
- `-y [enlace de YouTube]`: **Buscar por enlace de YouTube.**
	- Busca y muestra información de las máquinas que tienen un enlace de YouTube específico.
- `-h`: **Mostrar el panel de ayuda.**
    - Muestra un resumen de las opciones disponibles y su funcionalidad.  




--- 



## Funciones Disponibles

  

**ElBuscaMaquinas** cuenta con las siguientes funciones, cada una con un propósito específico para ayudar a gestionar y buscar máquinas:

  

1. **updateFiles()**:

   - **Descripción**: Actualiza la lista de archivos de máquinas desde el repositorio.

   - **Uso**: `updateFiles`

  

2. **searchMachine()**:

   - **Descripción**: Busca una máquina por su nombre.

   - **Uso**: `searchMachine <machine_name>`

  

3. **searchIP()**:

   - **Descripción**: Busca una máquina por su dirección IP.

   - **Uso**: `searchIP <machine_ip>`

  

4. **getYoutubeLink()**:

   - **Descripción**: Recupera un enlace de YouTube relacionado con una máquina específica.

   - **Uso**: `getYoutubeLink <machine_name>`

  

5. **getMachinesDifficulty()**:

   - **Descripción**: Lista máquinas según su nivel de dificultad.

   - **Uso**: `getMachinesDifficulty <difficulty_level>`

  

6. **getMachinesOperatingSystem()**:

   - **Descripción**: Lista máquinas según su sistema operativo.

   - **Uso**: `getMachinesOperatingSystem <os_name>`

  

7. **getMachinesOsDifficulty()**:

   - **Descripción**: Lista máquinas según su sistema operativo y nivel de dificultad.

   - **Uso**: `getMachinesOsDifficulty <os_name> <difficulty_level>`

  

8. **getSkills()**:

   - **Descripción**: Recupera las habilidades necesarias para abordar una máquina específica.

   - **Uso**: `getSkills <machine_name>`

  

9. **getMachineCertificate()**:

   - **Descripción**: Genera un certificado por completar una máquina específica.

   - **Uso**: `getMachineCertificate <machine_name>`

  

---

## Flujo General del Script

1. **Definición de Colores:** Se definen los colores para la salida en la terminal usando códigos de escape ANSI.
    
2. **Manejador de `Ctrl+C`:**
    
    - Se configura un manejador para la señal `Ctrl+C` que permite salir del script limpiamente, mostrando un mensaje de salida y restaurando la configuración de la terminal.
3. **Declaración de Variables Globales:**
    
    - `main_url`: Contiene la URL del archivo `bundle.js` que se encuentra en `https://htbmachines.github.io/bundle.js`.
4. **Función `helpPanel`:**
    
    - Muestra al usuario las opciones disponibles para interactuar con el script, incluyendo cómo buscar máquinas por nombre, IP, dificultad, sistema operativo, habilidades, certificaciones y enlaces de YouTube.

5. **Función `searchByName`:**
    
    - Busca máquinas por nombre. 
	
1. **Función `searchByIP`:**
    
    - Busca máquinas por dirección IP.
	
1. **Función `searchByDifficulty`:**
    
    - Busca máquinas por dificultad. 
	
1. **Función `searchByOS`:**
    
    - Busca máquinas por sistema operativo. 
	
1. **Función `searchBySkills`:**
    
    - Busca máquinas por habilidades. 
    
10. **Función `searchByCertification`:**
    
    - Busca máquinas por certificación. 
	
11. **Función `searchByYouTubeLink`:**
    
    - Busca máquinas por enlace de YouTube. 


Este flujo permite una interacción estructurada y ordenada con el archivo `bundle.js`, ofreciendo al usuario una herramienta versátil para obtener información de máquinas de HTB.
