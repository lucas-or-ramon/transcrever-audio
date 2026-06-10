# 🎙️ Transcrição de Áudio para Texto

Aplicação web local para transcrição de áudio em texto (Speech-to-Text) utilizando o modelo **Whisper** da OpenAI (versão otimizada `faster-whisper`).

**✅ 100% Gratuito • ✅ 100% Local • ✅ Sem APIs pagas**

---

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

1. **Python 3.8 ou superior**
2. **FFmpeg** (necessário para processar arquivos de áudio)

### Instalação do FFmpeg (Automática):

- **Windows**: O `setup.bat` baixa e configura automaticamente
- **WSL/Linux**: O `setup.sh` instala via `sudo apt install ffmpeg`
- **macOS**: O `setup.sh` instala via `brew install ffmpeg` (se brew estiver instalado)

**Instalação Manual (se preferir):**
- **Ubuntu/Debian**: `sudo apt update && sudo apt install ffmpeg`
- **macOS**: `brew install ffmpeg`
- **Windows**: Baixe em https://ffmpeg.org/download.html e extraia para pasta `ffmpeg\`

---

## 🚀 Instalação e Execução

### Windows (Rápido - Scripts Automáticos)

Se você está no Windows e não tem privilégios de administrador:

```batch
# 1. Apenas clique duas vezes em setup.bat (primeira vez)
setup.bat

# 2. Depois sempre execute run.bat
run.bat
```

O `setup.bat` faz tudo automaticamente:
- ✅ Verifica se Python está instalado
- ⬇️ Baixa FFmpeg portable (não precisa de admin)
- 🐍 Cria ambiente virtual
- 📦 Instala todas as dependências

O `run.bat` configura o PATH temporariamente e inicia o Streamlit.

---

### WSL / Linux / macOS (Scripts Automáticos)

No WSL, Linux ou macOS, use os scripts bash:

```bash
# 1. Primeira vez - configuração
./setup.sh

# 2. Sempre que quiser usar
./run.sh
```

O `setup.sh` faz automaticamente:
- ✅ Verifica/instala Python3
- ⬇️ Instala FFmpeg via apt (WSL/Linux) ou brew (macOS)
- 🐍 Cria ambiente virtual
- 📦 Instala dependências

---

### Linux/macOS (ou Windows manual)

Siga os passos abaixo na pasta do projeto:

### 1. Criar ambiente virtual (recomendado)

```bash
python -m venv venv
```

### 2. Ativar o ambiente virtual

**Linux/macOS:**
```bash
source venv/bin/activate
```

**Windows:**
```bash
venv\Scripts\activate
```

### 3. Instalar dependências

```bash
pip install -r requirements.txt
```

> **⚠️ Nota:** Na primeira execução, o modelo Whisper será baixado automaticamente (pode levar alguns minutos dependendo do tamanho escolhido).

### 4. Executar a aplicação

```bash
streamlit run app.py
```

O navegador abrirá automaticamente em `http://localhost:8501`

---

## � Estrutura do Projeto

```
transcrever-texto/
├── app.py                 # Aplicação principal (Streamlit)
├── requirements.txt       # Dependências Python
├── .gitignore            # Arquivos ignorados pelo Git
├── setup.bat             # Script de instalação (Windows CMD)
├── run.bat               # Script de execução (Windows CMD)
├── setup.sh              # Script de instalação (Linux/WSL)
├── run.sh                # Script de execução (Linux/WSL)
├── ffmpeg/               # FFmpeg portable (Windows - baixado automaticamente)
├── README.md             # Este arquivo
└── venv/                 # Ambiente virtual (criado na instalação)
```

---

## 🎯 Como Usar

1. **Abra** a aplicação no navegador (`http://localhost:8501`)
2. **Selecione** o tamanho do modelo (recomendado: `base`)
3. **Faça upload** do arquivo de áudio (MP3, WAV, M4A, etc.)
4. **Clique** em "Iniciar Transcrição"
5. **Aguarde** o processamento (barra de progresso mostra o status)
6. **Copie** o texto ou **baixe** como arquivo `.txt`

---

## 🧠 Tamanhos de Modelo

| Modelo | Tamanho | Velocidade (CPU) | Precisão | Uso Recomendado |
|--------|---------|-----------------|----------|-----------------|
| `tiny` | ~39 MB | ⚡ Muito rápido | ⭐ Básica | Testes rápidos |
| `base` | ~74 MB | ⚡ Rápido (~1x tempo de áudio) | ⭐⭐⭐ Boa | **Padrão - Equilíbrio ideal** |
| `small` | ~244 MB | 🔄 Moderado (~2x tempo de áudio) | ⭐⭐⭐⭐ Muito boa | Melhor qualidade aceitável |
| `medium` | ~769 MB | 🐌 Lento (~4x tempo de áudio) | ⭐⭐⭐⭐⭐ Excelente | Alta precisão, requer mais RAM |
| `large-v3` | ~1.5 GB | 🐌🐌 Muito lento (~8x tempo de áudio) | ⭐⭐⭐⭐⭐⭐ Máxima | Melhor qualidade, muito lento em CPU |

---

## ⚠️ Requisitos de Hardware (CPU Only)

> **Nota**: Esta versão roda exclusivamente em **CPU** para máxima compatibilidade entre computadores (Windows, Linux, WSL, macOS) sem necessidade de GPU.

- **CPU**: Qualquer CPU moderna (Intel/AMD/Apple Silicon)
- **RAM**: 
  - Mínimo: 4GB (para modelos tiny/base)
  - Recomendado: 8GB+ (para modelos small/medium)
  - Para large-v3: 16GB+ recomendado
- **Disco**: ~1-3GB para os modelos (baixados automaticamente na primeira vez)

---

## 🐛 Solução de Problemas

| Problema | Solução |
|----------|---------|
| `ffmpeg not found` | Instale o FFmpeg (veja seção de pré-requisitos) |
| `Out of memory` | Use um modelo menor (tiny/base) ou feche outros programas |
| Modelo não baixa | Verifique conexão com internet (apenas na 1ª vez) |
| Transcrição lenta | Use modelo menor (tiny/base) ou upgrade de RAM |

---

## 📄 Licença

Projeto open-source. Utiliza:
- [Whisper](https://github.com/openai/whisper) - OpenAI
- [faster-whisper](https://github.com/SYSTRAN/faster-whisper) - Otimização
- [Streamlit](https://streamlit.io/) - Interface web

---

## 💡 Dicas

- A primeira execução com um modelo novo será mais lenta (download do modelo)
- Arquivos de áudio longos demoram mais - seja paciente
- A qualidade do áudio afeta a precisão da transcrição
- Microfone próximo e ambiente silencioso = melhor resultado
