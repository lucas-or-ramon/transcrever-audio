#!/bin/bash

echo "=========================================="
echo " 🎙️  Transcrição de Áudio (WSL)"
echo "=========================================="
echo ""

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verificar se setup foi feito
if [ ! -f "venv/bin/python" ]; then
    echo -e "${RED}❌ Ambiente virtual não encontrado!${NC}"
    echo ""
    echo "Por favor, execute primeiro:"
    echo "    ./setup.sh"
    echo ""
    exit 1
fi

if ! command -v ffmpeg &> /dev/null; then
    echo -e "${RED}❌ FFmpeg não encontrado!${NC}"
    echo ""
    echo "Por favor, execute primeiro:"
    echo "    ./setup.sh"
    echo ""
    exit 1
fi

echo -e "${GREEN}✅ Ambiente configurado${NC}"
echo ""

echo -e "${YELLOW}🚀 Iniciando aplicação...${NC}"
echo "    Acesse: http://localhost:8501"
echo "    Pressione Ctrl+C para parar"
echo ""

venv/bin/streamlit run app.py

if [ $? -ne 0 ]; then
    echo ""
    echo -e "${RED}❌ A aplicação foi encerrada com erro.${NC}"
    echo ""
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Aplicação encerrada.${NC}"
