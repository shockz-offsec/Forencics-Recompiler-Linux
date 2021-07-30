# Forencics-Recompiler-Linux
Este script recompilará la mayoría de la información que se suele obtener de un sistema Linux ante un peritaje o análisis forense. Además toda la información será firmada con SHA256.

Preview de la ejecución del script:

![2021-07-14 00_56_50-Kali - VMware Workstation](https://user-images.githubusercontent.com/67438760/125535646-f30bb694-a43b-4bc6-8de6-58c8def24c09.png)

Preview del árbol de directorios de la salida del script:

![2021-07-14 00_57_01-Kali - VMware Workstation](https://user-images.githubusercontent.com/67438760/125535652-0af64b5a-282e-4b73-8616-a28178339432.png)


## Recolección

Se realizan las siguientes acciónes sobre el sistema Linux:

- Volcado de los siguientes elementos:
  - Archivo sudoers, passwd y shadow
  - Los ficheros del sistema con permisos de lectura
  - Los directorios del sistema
  - Historial de las shells del sistema
  - Procesos actuales del sistema
  - Configuraciones de red y conexiones
  - Logs del sistema (Incluido lastlog)
  - Listado de ficheros superiores a 1GB del sistema
