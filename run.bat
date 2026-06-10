@echo off
chcp 65001 >nul
echo ==========================================
echo  🎙️  Transcrição de Áudio
echo ==========================================
echo.

REM Verificar se o setup foi feito
if not exist "venv\Scripts\python.exe" (
    echo ❌ Ambiente virtual não encontrado!
    echo.
    echo Por favor, execute primeiro:
    echo    setup.bat
    echo.
    pause
    exit /b 1
)

if not exist "ffmpeg\bin\ffmpeg.exe" (
    echo ❌ FFmpeg não encontrado!
    echo.
    echo Por favor, execute primeiro:
    echo    setup.bat
    echo.
    pause
    exit /b 1
)

REM Configurar PATH para FFmpeg local (apenas para esta sessão)
echo 🛠️  Configurando ambiente...
set "PATH=%CD%\ffmpeg\bin;%PATH%"
echo ✅ FFmpeg configurado
echo.

REM Ativar ambiente virtual e rodar
echo 🚀 Iniciando aplicação...
echo    Acesse: http://localhost:8501
echo    Pressione Ctrl+C para parar
echo.

venv\Scripts\streamlit run app.py

if errorlevel 1 (
    echo.
    echo ❌ A aplicação foi encerrada com erro.
    echo.
    pause
    exit /b 1
)

echo.
echo ✅ Aplicação encerrada.
pause
