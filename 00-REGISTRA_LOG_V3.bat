@echo off
setlocal enabledelayedexpansion

:: Define variáveis iniciais
set "filepath=%~1"
set "filename=%~n1"
set "filename=!filename:_= !"
set "filename=!filename:-= !"
set "log=Andamento.txt"

:: Conta o total de arquivos no diretório
set "total_arquivos=-2"
for %%A in (*) do set /a total_arquivos+=1

:: Cria arquivo de log, se não existir
if not exist "%log%" (
    echo Criando arquivo de log...
    > "%log%" echo(__________ LOG DE PROGRESSO: 0/%total_arquivos% 
)

:: Recupera o progresso atual do log
set "progresso=0"
for /f "delims=" %%A in ('findstr /b /c:"__________ LOG DE PROGRESSO" "%log%"') do set "linha_atual=%%A"
for /f "tokens=2 delims=:/" %%A in ("%linha_atual%") do set /a progresso=%%A

:: Verifica se o arquivo atual já foi registrado no log
set "contar_arquivo=0"
findstr /c:"%timestamp% %filename%" "%log%" >nul || set "contar_arquivo=1"

:: Incrementa o progresso, se necessário
if %contar_arquivo% equ 1 (
    set /a progresso+=1
)

:: Atualiza o log com o novo progresso
(
    echo(__________ LOG DE PROGRESSO:%progresso%/%total_arquivos%
    findstr /v "__________ LOG DE PROGRESSO" "%log%"
) > temp.txt
move /y temp.txt "%log%" >nul

:: Obtém data e hora atuais
for /f "tokens=1-3 delims=/ " %%a in ('date /t') do set "date=%%a/%%b/%%c"
for /f "tokens=1-3 delims=: " %%a in ('time /t') do set "time=%%a:%%b"

:: Define o timestamp
set "timestamp=%date% %time% -"

:: Registra o arquivo atual no log
chcp 65001 >nul
echo %timestamp% %filename% >> "%log%"

:: Corrige acentuação padrão ABNT2 (ç,ã,etc)
chcp 850 >nul

:: Abre o arquivo especificado
start "" "%filepath%"

exit
