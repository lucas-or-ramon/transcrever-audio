@echo off
chcp 1252 >nul
echo ==========================================
echo  Transcricao de Audio - Setup
echo ==========================================
echo.

echo [1/5] Verificando Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo ERRO: Python nao encontrado!
    echo.
    echo Por favor, instale o Python 3.8 ou superior:
    echo https://www.python.org/downloads/
    echo.
    echo IMPORTANTE: Durante a instalacao, marque a opcao:
    echo    "Add Python to PATH"
    echo.
    pause
    exit /b 1
)
for /f "tokens=2" %%a in ('python --version 2^>^&1') do echo OK: Python encontrado: %%a
echo.

echo [2/5] Verificando FFmpeg...
if exist "ffmpeg\bin\ffmpeg.exe" (
    echo OK: FFmpeg ja existe na pasta do projeto
) else (
    echo Baixando FFmpeg portable...
    echo Isso pode levar alguns minutos...
    echo.
    
    if not exist "temp" mkdir temp
    
    powershell -Command "& {Invoke-WebRequest -Uri 'https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip' -OutFile 'temp\ffmpeg.zip'}" 2>nul
    
    if exist "temp\ffmpeg.zip" (
        echo Extraindo FFmpeg...
        powershell -Command "& {Expand-Archive -Path 'temp\ffmpeg.zip' -DestinationPath 'temp' -Force}"
        
        for /d %%D in (temp\ffmpeg*) do (
            move "%%D" "ffmpeg" >nul 2>&1
        )
        
        rmdir /s /q temp 2>nul
        
        if exist "ffmpeg\bin\ffmpeg.exe" (
            echo OK: FFmpeg instalado com sucesso!
        ) else (
            echo ERRO: Falha ao instalar FFmpeg automaticamente
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
        echo ERRO: Falha no download do FFmpeg
        echo Verifique sua conexao com a internet.
        pause
        exit /b 1
    )
)
echo.

echo [3/5] Criando ambiente virtual...
if exist "venv" (
    echo AVISO: Ambiente virtual ja existe. Pulando...
) else (
    python -m venv venv
    if errorlevel 1 (
        echo ERRO: Falha ao criar ambiente virtual
        pause
        exit /b 1
    )
    echo OK: Ambiente virtual criado
)
echo.

echo [4/5] Instalando dependencias Python...
echo Isso pode levar alguns minutos na primeira vez...
echo.

venv\Scripts\pip install --upgrade pip -q
venv\Scripts\pip install -r requirements.txt

if errorlevel 1 (
    echo ERRO: Falha ao instalar dependencias
    pause
    exit /b 1
)

echo OK: Dependencias instaladas com sucesso!
echo.

echo [5/5] Testando FFmpeg...
set "PATH=%CD%\ffmpeg\bin;%PATH%"
ffmpeg -version >nul 2>&1
if errorlevel 1 (
    echo ERRO: FFmpeg nao esta funcionando corretamente
    pause
    exit /b 1
)
echo OK: FFmpeg configurado corretamente!
echo.

echo ==========================================
echo  Setup concluido com sucesso!
echo ==========================================
echo.
echo Agora voce pode executar: run.bat
echo.
echo IMPORTANTE: O modelo sera baixado automaticamente na 1a transcricao.
echo Se tiver problemas com SSL/proxy em rede corporativa:
echo    1. Tente: run-corporativo.bat
echo    2. Ou baixe manualmente (veja README.md)
echo.
pause
