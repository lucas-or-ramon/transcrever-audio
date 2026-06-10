@echo off
chcp 65001 >nul
echo ==========================================
echo  🎙️  Transcrição de Áudio - Setup
echo ==========================================
echo.

REM Verificar se Python está instalado
echo [1/5] Verificando Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python não encontrado!
    echo.
    echo Por favor, instale o Python 3.8 ou superior:
    echo https://www.python.org/downloads/
    echo.
    echo ⚠️  IMPORTANTE: Durante a instalação, marque a opção:
    echo    "Add Python to PATH"
    echo.
    pause
    exit /b 1
)
for /f "tokens=2" %%a in ('python --version 2^>^&1') do echo ✅ Python encontrado: %%a
echo.

REM Verificar/instalar FFmpeg portable
echo [2/5] Verificando FFmpeg...
if exist "ffmpeg\bin\ffmpeg.exe" (
    echo ✅ FFmpeg já existe na pasta do projeto
) else (
    echo ⬇️  Baixando FFmpeg portable...
    echo    Isso pode levar alguns minutos...
    echo.
    
    REM Criar pasta temporária
    if not exist "temp" mkdir temp
    
    REM Baixar ffmpeg usando PowerShell
    powershell -Command "& {Invoke-WebRequest -Uri 'https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip' -OutFile 'temp\ffmpeg.zip'}" 2>nul
    
    if exist "temp\ffmpeg.zip" (
        echo    Extraindo FFmpeg...
        powershell -Command "& {Expand-Archive -Path 'temp\ffmpeg.zip' -DestinationPath 'temp' -Force}"
        
        REM Mover para pasta final
        for /d %%D in (temp\ffmpeg*) do (
            move "%%D" "ffmpeg" >nul 2>&1
        )
        
        REM Limpar temp
        rmdir /s /q temp 2>nul
        
        if exist "ffmpeg\bin\ffmpeg.exe" (
            echo ✅ FFmpeg instalado com sucesso!
        ) else (
            echo ❌ Falha ao instalar FFmpeg automaticamente
            echo.
            echo Por favor, baixe manualmente:
            echo 1. Acesse: https://github.com/BtbN/FFmpeg-Builds/releases
            echo 2. Baixe: ffmpeg-master-latest-win64-gpl.zip
            echo 3. Extraia para esta pasta e renomeie a pasta para "ffmpeg"
            echo.
            pause
            exit /b 1
        )
    ) else (
        echo ❌ Falha no download do FFmpeg
        echo Verifique sua conexão com a internet.
        pause
        exit /b 1
    )
)
echo.

REM Criar ambiente virtual
echo [3/5] Criando ambiente virtual...
if exist "venv" (
    echo ⚠️  Ambiente virtual já existe. Pulando...
) else (
    python -m venv venv
    if errorlevel 1 (
        echo ❌ Falha ao criar ambiente virtual
        pause
        exit /b 1
    )
    echo ✅ Ambiente virtual criado
)
echo.

REM Instalar dependências
echo [4/5] Instalando dependências Python...
echo    Isso pode levar alguns minutos na primeira vez...
echo.

venv\Scripts\pip install --upgrade pip -q
venv\Scripts\pip install -r requirements.txt

if errorlevel 1 (
    echo ❌ Falha ao instalar dependências
    pause
    exit /b 1
)

echo ✅ Dependências instaladas com sucesso!
echo.

REM Testar FFmpeg
echo [5/5] Testando FFmpeg...
set "PATH=%CD%\ffmpeg\bin;%PATH%"
ffmpeg -version >nul 2>&1
if errorlevel 1 (
    echo ❌ FFmpeg não está funcionando corretamente
    pause
    exit /b 1
)
echo ✅ FFmpeg configurado corretamente!
echo.

echo ==========================================
echo  ✅ Setup concluído com sucesso!
echo ==========================================
echo.
echo Agora você pode executar: run.bat
echo.
pause
