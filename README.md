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

> **Rede corporativa/proxy?** Se receber erro de SSL, use `run-corporativo.bat` em vez de `run.bat`

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

> **Rede corporativa/proxy?** Se receber erro de SSL, use `./run-corporativo.sh` em vez de `./run.sh`

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
├── app.py                    # Aplicacao principal (Streamlit)
├── requirements.txt          # Dependencias Python
├── .gitignore               # Arquivos ignorados pelo Git
├── setup.bat                # Instalacao Windows
├── run.bat                  # Execucao Windows
├── run-corporativo.bat      # Execucao Windows (rede corporativa/proxy SSL)
├── setup.sh                 # Instalacao Linux/WSL
├── run.sh                   # Execucao Linux/WSL
├── run-corporativo.sh       # Execucao Linux/WSL (rede corporativa/proxy SSL)
├── ffmpeg/                  # FFmpeg portable (Windows)
├── README.md                # Este arquivo
└── venv/                    # Ambiente virtual (criado na instalacao)
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
| `ffmpeg not found` | Instale o FFmpeg (veja secao de pre-requisitos) |
| `Out of memory` | Use um modelo menor (tiny/base) ou feche outros programas |
| Modelo nao baixa | Verifique conexao com internet (apenas na 1a vez) |
| Transcricao lenta | Use modelo menor (tiny/base) ou upgrade de RAM |
| `SSL: CERTIFICATE_VERIFY_FAILED` | **Rede corporativa/proxy** - Tente `run-corporativo.bat` ou baixe manualmente (veja secao "Download Manual do Modelo" abaixo) |

### Erro SSL em Redes Corporativas

Se voce receber erro de certificado SSL (`CERTIFICATE_VERIFY_FAILED`), provavelmente esta em uma rede corporativa com proxy/firewall que intercepta conexoes.

**Solucao rapida:**
- **Windows**: Execute `run-corporativo.bat` em vez de `run.bat`
- **Linux/WSL**: Execute `./run-corporativo.sh` em vez de `./run.sh`

Estes scripts desabilitam a verificacao SSL apenas para download dos modelos da Hugging Face. **Use apenas em redes corporativas confiaveis.**

---

## � Download Manual do Modelo (Redes Corporativas)

Se os scripts automaticos nao conseguirem baixar o modelo devido a restricoes de proxy/firewall corporativo, siga estes passos:

### Windows

1. **Baixe o modelo manualmente pelo navegador:**
   - Acesse: https://huggingface.co/Systran/faster-whisper-base/tree/main
   - Clique em cada arquivo abaixo e baixe:
     - `model.bin` (~74 MB)
     - `config.json` (~2 KB)
     - `tokenizer.json` (~1 MB)
     - `vocabulary.txt` (~400 KB)

2. **Crie a pasta de destino:**
   ```
   %USERPROFILE%\.cache\huggingface\hub\models--Systran--faster-whisper-base\snapshots\main\
   ```

3. **Copie os 4 arquivos baixados** para essa pasta

4. **Execute a aplicacao:** `run.bat`

### Linux/WSL

1. **Baixe o modelo manualmente pelo navegador:**
   - Acesse: https://huggingface.co/Systran/faster-whisper-base/tree/main
   - Baixe: `model.bin`, `config.json`, `tokenizer.json`, `vocabulary.txt`

2. **Crie a pasta de destino:**
   ```bash
   mkdir -p ~/.cache/huggingface/hub/models--Systran--faster-whisper-base/snapshots/main/
   ```

3. **Copie os arquivos** (ajuste o caminho de origem):
   ```bash
   cp ~/Downloads/model.bin ~/Downloads/config.json ~/Downloads/tokenizer.json ~/Downloads/vocabulary.txt ~/.cache/huggingface/hub/models--Systran--faster-whisper-base/snapshots/main/
   ```

4. **Execute a aplicacao:** `./run.sh`

> **Nota:** Uma vez copiado, o modelo fica salvo e nao precisa ser baixado novamente.

---

## �� Licença

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
