@echo off
echo ============================================
echo INICIANDO RESPALDO DE BASE DE DATOS PATITAS
echo ============================================

set FECHA=%date:~-4,4%%date:~-7,2%%date:~-10,2%
set HORA=%time:~0,2%%time:~3,2%
set ARCHIVO=C:\Backups\Patitas_Full_%FECHA%_%HORA%.sql

:: ---------------------------------------------------------
:: PASO 1: ELIGE TU RUTA (Borra los :: de la opción correcta)
:: ---------------------------------------------------------

:: OPCIÓN A: Si usas XAMPP (Lo más común)
set RUTA_MYSQL="C:\xampp\mysql\bin\mysqldump.exe"

:: OPCIÓN B: Si usas MySQL Workbench / Server instalado normal
:: set RUTA_MYSQL="C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqldump.exe"

:: ---------------------------------------------------------

echo Usando: %RUTA_MYSQL%

:: Comando de volcado usando la ruta completa
%RUTA_MYSQL% -u root -p --databases PATITAS --routines --triggers > "%ARCHIVO%"

echo.
if %ERRORLEVEL% equ 0 (
    echo EXITO: Respaldo guardado en %ARCHIVO%
) else (
    echo ERROR: No se pudo generar el backup. Verifica la ruta en el script.
)

pause