# VIM: Edición y compilación desde la terminal

## Introducción

Esta actividad presenta el ciclo básico de trabajo con programas en C desde la terminal: compilar, leer los warnings de `gcc`, editar el código con `vim`, volver a compilar y ejecutar el resultado.

La primera sección contiene un ejercicio breve y guiado de `vim`. Las secciones siguientes aplican inmediatamente esas operaciones sobre programas que producen advertencias diferentes al activar `-Wall`, `-Wextra` y `-Werror`.

En este laboratorio no se utilizarán tuberías, redirecciones ni códigos de salida. Esos mecanismos se introducirán en la actividad siguiente.

### Pre-requisitos

- Haber completado la actividad de uso básico de la terminal
- Saber compilar y ejecutar un programa sencillo con `gcc`
- Tener `vim` y `gcc` disponibles en la máquina virtual
- Haber revisado las presentaciones de compilación básica y edición con Vim

### Objetivo general

- Corregir warnings de compilación mediante un ciclo reproducible de compilación, edición y ejecución

### Objetivos específicos

- Abrir, modificar, guardar y cerrar archivos con `vim`
- Reconocer el archivo, la línea y el tipo de warning informado por `gcc`
- Observar la diferencia entre una compilación básica y la activación de `-Wall` y `-Wextra`
- Comprender el efecto de convertir warnings en errores mediante `-Werror`
- Corregir código desde la terminal y comprobar el resultado mediante una nueva compilación
- Ejecutar los binarios generados y revisar su salida

### Estructura inicial

```text
workspace/
├── programas/
│   ├── ajuste.c
│   ├── comparacion.c
│   └── registro.c
└── scripts/
    └── check.sh
```

Los programas se editarán y compilarán directamente dentro de `workspace/programas`. Cada caso está preparado para destacar el efecto de un flag diferente.

El script `check.sh` comprueba que los tres códigos puedan compilarse sin warnings con todos los flags solicitados, que los ejecutables existan y que produzcan los resultados esperados. Cada resultado señala la subsección que debe revisarse si queda alguna actividad pendiente.

## Actividad

### 1. Ejercicio guiado de Vim

Esta primera actividad será desarrollada colectivamente durante la clase. Su propósito es reconocer el flujo mínimo de edición antes de modificar código C.

#### 1.1. Preparar el directorio de trabajo

Desde la raíz del repositorio, entrar a `workspace` y crear el directorio `actividad`:

```bash
cd workspace
mkdir actividad
pwd
```

#### 1.2. Crear y guardar un archivo

Abrir un archivo nuevo:

```bash
vim actividad/notas.txt
```

Dentro de Vim:

1. Presionar `i` para entrar en modo inserción
2. Escribir exactamente las siguientes líneas:

```text
Flujo de compilación
Compilar y leer warnings
Editar el código con Vim
Volver a compilar y ejecutar
```

3. Presionar `Esc` para regresar al modo normal
4. Escribir `:set number` y presionar `Enter`
5. Usar las flechas para recorrer el archivo
6. Escribir `:w` y presionar `Enter` para guardar sin salir
7. Escribir `:q` y presionar `Enter` para cerrar Vim

Confirmar el contenido desde la terminal:

```bash
cat actividad/notas.txt
```

### 2. Compilar y corregir un warning

#### 2.1. Compilar

Usar los comandos aprendidos en el laboratorio anterior para entrar al directorio `programas` e inspeccionar el contenido de `registro.c`.

Compilar y ejecutar:

```bash
gcc -std=c11 registro.c -o registro
./registro
```

El programa debe mostrar:

```text
Muestras procesadas: 4
```

La ausencia de mensajes del compilador no garantiza que el código esté libre de situaciones sospechosas. Solo indica que `gcc` pudo generar el ejecutable con la configuración solicitada.

#### 2.2. Activar `-Wall`

Volver a compilar con el mismo comando anterior, pero agregando la flag `-Wall`.

El warning contiene cuatro datos importantes:

- El nombre del archivo
- La línea y columna relacionadas con el problema
- La palabra `warning`
- El identificador de la comprobación entre corchetes

En este caso, `-Wall` informa que una variable fue declarada, pero nunca se utiliza. Aunque se muestre un warning, `gcc` todavía puede producir el ejecutable.

#### 2.3. Corregir el código con Vim

Abrir `registro.c` con Vim.

Dentro de Vim:

1. Escribir `:set number` para mostrar los números de línea
2. Usar el número informado por `gcc` para moverse con `:N`, reemplazando `N` por la línea correspondiente
3. Confirmar que la variable señalada no participa en el resultado
4. Eliminar su línea con `dd`
5. Guardar y salir con `:wq`

#### 2.4. Volver a compilar y ejecutar

Repetir la compilación de 2.2 después de corregir el código. Si compila sin warnings, ejecutar el programa. Si todavía aparece un warning, leer atentamente el mensaje completo, revisar la línea señalada y corregir lo necesario antes de volver a compilar.

El programa debe compilar sin warnings y conservar su resultado original, ya que la variable eliminada no era necesaria.

### 3. Activar `-Wextra` y utilizar un parámetro

#### 3.1. Comparar `-Wall` con `-Wextra`

Adaptar el comando de 2.2 para compilar `ajuste.c` con `-Wall` y `-std=c11`, generar un ejecutable llamado `ajuste` y ponerlo en funcionamiento.

El resultado inicial es:

```text
Valor ajustado: 11
```

Repetir la compilación agregando `-Wextra` al comando anterior.

`-Wextra` activa comprobaciones adicionales. El nuevo warning señala que uno de los parámetros de la función no se utiliza.

#### 3.2. Corregir el cálculo con Vim

Abrir `ajuste.c` con Vim.

Usar el número de línea del warning para localizar el cálculo. Modificar la expresión para que el resultado sume `incremento` en lugar de sumar siempre el valor fijo `1`. Para editar una parte de la línea se puede entrar al modo inserción con `i` y utilizar las teclas `Backspace` o `Delete`.

Guardar y salir con `:wq`.

#### 3.3. Recompilar y mostrar el nuevo resultado

Repetir la compilación anterior después de corregir el código. Si compila sin warnings, ejecutar `ajuste`. Si todavía aparece un warning, leer atentamente el mensaje completo, revisar la línea señalada y corregir lo necesario antes de volver a compilar.

El programa debe compilar sin warnings y mostrar:

```text
Valor ajustado: 15
```

### 4. Convertir warnings en errores con `-Werror`

#### 4.1. Observar un warning que permite compilar

Adaptar el comando de 3.1 para compilar `comparacion.c` con `-Wall`, `-Wextra` y `-std=c11`, generar el ejecutable `comparacion` y ponerlo en funcionamiento.

`gcc` muestra un warning relacionado con la condición, pero genera el ejecutable. Al ejecutarlo, el programa informa incorrectamente que dos valores diferentes son iguales.

#### 4.2. Impedir la compilación mientras exista el warning

Eliminar el ejecutable anterior y repetir la compilación agregando `-Werror`. Luego utilizar un listado detallado del contenido de la carpeta (eg.: `ls -la`) para comprobar si `comparacion` volvió a generarse.

`-Werror` no incorpora una comprobación nueva. Convierte los warnings habilitados en errores y evita generar un nuevo ejecutable mientras el warning siga presente.

#### 4.3. Corregir la condición con Vim

Abrir `comparacion.c` con Vim y dirigirse a la línea indicada por el warning.

La condición está asignando un valor cuando debería comparar ambos valores. Corregir el operador, guardar y salir.

#### 4.4. Recompilar y ejecutar

Repetir la compilación de 4.2. Si compila sin warnings, ejecutar el programa generado. Si todavía aparece un warning, leer atentamente el mensaje completo, revisar la línea señalada y corregir lo necesario antes de volver a compilar.

El programa debe compilar sin warnings y mostrar la siguiente salida:

```text
Los valores son distintos
```

### 5. Verificación final

#### 5.1. Habilitar la ejecución del script

Usar los comandos practicados anteriormente para regresar a `workspace`, revisar los permisos de `scripts/check.sh`, agregar permiso de ejecución para el propietario y comprobar nuevamente sus permisos.

#### 5.2. Ejecutar el script

Ejecutar `scripts/check.sh` desde `workspace`.

El script vuelve a comprobar los fuentes con `-Wall`, `-Wextra`, `-Werror` y `-std=c11`. También revisa los ejecutables y sus resultados. El resumen final muestra cuántas comprobaciones son exitosas y cuántas permanecen pendientes.
