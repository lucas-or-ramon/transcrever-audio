#!/bin/bash

set -e

echo "=========================================="
echo " 🎙️  Transcrição de Áudio - Setup (WSL)"
echo "=========================================="
echo ""

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# [1/5] Verificar Python
echo -e "${YELLOW}[1/5]${NC} Verificando Python..."
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python3 não encontrado!${NC}"
    echo ""
    echo "Instalando Python3..."
    sudo apt update
    sudo apt install -y python3 python3-pip python3-venv
fi
PYTHON_VERSION=$(python3 --version 2>&1)
echo -e "${GREEN}✅ Python encontrado: $PYTHON_VERSION${NC}"
echo ""

# [2/5] Verificar/instalar FFmpeg
echo -e "${YELLOW}[2/5]${NC} Verificando FFmpeg..."
if ! command -v ffmpeg &> /dev/null; then
    echo -e "${YELLOW}⬇️  FFmpeg não encontrado. Instalando...${NC}"
    
    # Detectar sistema operacional
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install ffmpeg
        else
            echo -e "${RED}❌ Homebrew não encontrado. Instale o FFmpeg manualmente:${NC}"
            echo "   https://ffmpeg.org/download.html"
            exit 1
        fi
    else
        # Linux/WSL
        sudo apt update
        sudo apt install -y ffmpeg
    fi
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Falha ao instalar FFmpeg${NC}"
        exit 1
    fi
fi
FFMPEG_VERSION=$(ffmpeg -version 2>&1 | head -n1)
echo -e "${GREEN}✅ FFmpeg instalado: $FFMPEG_VERSION${NC}"
echo ""

# [3/5] Criar ambiente virtual
echo -e "${YELLOW}[3/5]${NC} Criando ambiente virtual..."
if [ -d "venv" ]; then
    echo -e "${YELLOW}⚠️  Ambiente virtual já existe. Pulando...${NC}"
else
    python3 -m venv venv
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Falha ao criar ambiente virtual${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Ambiente virtual criado${NC}"
fi
echo ""

# [4/5] Instalar dependências
echo -e "${YELLOW}[4/5]${NC} Instalando dependências Python..."
echo "    Isso pode levar alguns minutos na primeira vez..."
echo ""

venv/bin/pip install --upgrade pip -q
venv/bin/pip install -r requirements.txt

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Falha ao instalar dependências${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Dependências instaladas com sucesso!${NC}"
echo ""

# [5/5] Testar instalação
echo -e "${YELLOW}[5/5]${NC} Testando instalação..."
venv/bin/python -c "import streamlit; import faster_whisper" 2>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Todas as bibliotecas estão funcionando!${NC}"
else
    echo -e "${RED}❌ Problema na instalação das bibliotecas${NC}"
    exit 1
fi
echo ""

echo "=========================================="
echo -e "${GREEN} ✅ Setup concluído com sucesso!${NC}"
echo "=========================================="
echo ""
echo "Agora você pode executar: ./run.sh"
echo ""
echo "IMPORTANTE: O modelo será baixado automaticamente na 1ª transcrição."
echo "Se tiver problemas com SSL/proxy em rede corporativa:"
echo "    1. Tente: ./run-corporativo.sh"
echo "    2. Ou baixe manualmente (veja README.md)"
echo ""
