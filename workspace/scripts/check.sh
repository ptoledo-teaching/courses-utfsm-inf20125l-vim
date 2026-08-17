#!/usr/bin/env bash

set -u

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
PROGRAMS="${WORKSPACE}/programas"
PASSES=0
FAILURES=0

pass() {
    printf 'PASS: %s\n' "$1"
    PASSES=$((PASSES + 1))
}

fail() {
    printf 'FAIL: %s\n' "$1"
    FAILURES=$((FAILURES + 1))
}

check() {
    local description="$1"
    shift

    if "$@"; then
        pass "${description}"
    else
        fail "${description}"
    fi
}

content_equals() {
    local path="$1"
    local expected="$2"

    [[ -f "${path}" ]] || return 1
    [[ "$(cat -- "${path}")" == "${expected}" ]]
}

compiles_without_warnings() {
    local source="$1"

    gcc -Wall -Wextra -Werror -std=c11 -fsyntax-only "${source}" >/dev/null 2>&1
}

is_binary_executable() {
    local path="$1"
    local description=""

    [[ -f "${path}" && -x "${path}" ]] || return 1
    description="$(file -b -- "${path}")"
    [[ "${description}" == ELF*executable* ]]
}

printf '%s\n' '========================================='
printf '%s\n' '==   Verificación de laboratorio VIM   =='
printf '%s\n' '========================================='
printf '\n== Actividades ==========================\n\n'

check "[1.2] Existe el directorio actividad" test -d "${WORKSPACE}/actividad"
check "[1.2] notas.txt existe en actividad" test -f "${WORKSPACE}/actividad/notas.txt"
check \
    "[1.2] notas.txt conserva el contenido esperado" \
    content_equals \
    "${WORKSPACE}/actividad/notas.txt" \
    $'Flujo de compilación\nCompilar y leer warnings\nEditar el código con Vim\nVolver a compilar y ejecutar'

check "[2.4] registro.c compila sin warnings" compiles_without_warnings "${PROGRAMS}/registro.c"
check "[2.4] registro existe como binario ejecutable" is_binary_executable "${PROGRAMS}/registro"

if [[ -x "${PROGRAMS}/registro" ]] &&
   [[ "$("${PROGRAMS}/registro")" == 'Muestras procesadas: 4' ]]; then
    pass "[2.4] registro produce la salida esperada"
else
    fail "[2.4] registro produce la salida esperada"
fi

check "[3.3] ajuste.c compila sin warnings" compiles_without_warnings "${PROGRAMS}/ajuste.c"
check "[3.3] ajuste existe como binario ejecutable" is_binary_executable "${PROGRAMS}/ajuste"

if [[ -x "${PROGRAMS}/ajuste" ]] &&
   [[ "$("${PROGRAMS}/ajuste")" == 'Valor ajustado: 15' ]]; then
    pass "[3.3] ajuste produce la salida esperada"
else
    fail "[3.3] ajuste produce la salida esperada"
fi

check "[4.4] comparacion.c compila sin warnings" compiles_without_warnings "${PROGRAMS}/comparacion.c"
check "[4.4] comparacion existe como binario ejecutable" is_binary_executable "${PROGRAMS}/comparacion"

if [[ -x "${PROGRAMS}/comparacion" ]] &&
   [[ "$("${PROGRAMS}/comparacion")" == 'Los valores son distintos' ]]; then
    pass "[4.4] comparacion produce la salida esperada"
else
    fail "[4.4] comparacion produce la salida esperada"
fi

check "[5.1] check.sh tiene permiso de ejecución" test -x "${SCRIPT_DIR}/check.sh"

printf '\n== Resumen ===============================\n\n'
TOTAL=$((PASSES + FAILURES))
COUNT_WIDTH=${#TOTAL}
printf '%-26s %*d\n' 'Comprobaciones exitosas:' "${COUNT_WIDTH}" "${PASSES}"
printf '%-26s %*d\n\n' 'Comprobaciones pendientes:' "${COUNT_WIDTH}" "${FAILURES}"

if (( FAILURES == 0 )); then
    exit 0
fi

exit 1
