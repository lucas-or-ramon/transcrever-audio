@echo off
chcp 1252 >nul
echo ==========================================
echo  Transcricao de Audio - Modo Corporativo
echo ==========================================
echo.
echo AVISO: SSL verification sera desabilitado.
echo Use apenas em redes corporativas confiaveis.
echo.
pause

if not exist "venv\Scripts\python.exe" (
    echo ERRO: Ambiente virtual nao encontrado!
    echo.
    echo Por favor, execute primeiro:
    echo    setup.bat
    echo.
    pause
    exit /b 1
)

if not exist "ffmpeg\bin\ffmpeg.exe" (
    echo ERRO: FFmpeg nao encontrado!
    echo.
    echo Por favor, execute primeiro:
    echo    setup.bat
    echo.
    pause
    exit /b 1
)

echo Configurando ambiente...
set "PATH=%CD%\ffmpeg\bin;%PATH%"

REM Desabilitar verificacao SSL para redes corporativas
set TRANSCRICAO_SKIP_SSL=true
echo OK: Modo corporativo ativado (SSL verification OFF)
echo.

echo Iniciando aplicacao...
echo Acesse: http://localhost:8501
echo Pressione Ctrl+C para parar
echo.

venv\Scripts\streamlit run app.py

if errorlevel 1 (
    echo.
    echo ERRO: A aplicacao foi encerrada com erro.
    echo.
    pause
    exit /b 1
)

echo.
echo Aplicacao encerrada.
pause
