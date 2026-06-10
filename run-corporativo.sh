#!/bin/bash

echo "=========================================="
echo " Transcricao de Audio - Modo Corporativo"
echo "=========================================="
echo ""
echo "AVISO: SSL verification sera desabilitado."
echo "Use apenas em redes corporativas confiaveis."
echo ""
read -p "Pressione ENTER para continuar..."

# Verificar se setup foi feito
if [ ! -f "venv/bin/python" ]; then
    echo "ERRO: Ambiente virtual nao encontrado!"
    echo ""
    echo "Por favor, execute primeiro:"
    echo "    ./setup.sh"
    echo ""
    exit 1
fi

if ! command -v ffmpeg &> /dev/null; then
    echo "ERRO: FFmpeg nao encontrado!"
    echo ""
    echo "Por favor, execute primeiro:"
    echo "    ./setup.sh"
    echo ""
    exit 1
fi

echo "Configurando ambiente..."

# Desabilitar verificacao SSL para redes corporativas
export TRANSCRICAO_SKIP_SSL=true
echo "OK: Modo corporativo ativado (SSL verification OFF)"
echo ""

echo "Iniciando aplicacao..."
echo "Acesse: http://localhost:8501"
echo "Pressione Ctrl+C para parar"
echo ""

venv/bin/streamlit run app.py

if [ $? -ne 0 ]; then
    echo ""
    echo "ERRO: A aplicacao foi encerrada com erro."
    echo ""
    exit 1
fi

echo ""
echo "Aplicacao encerrada."
