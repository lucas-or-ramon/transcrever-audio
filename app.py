import streamlit as st
import os
import tempfile
import time
import ssl
import urllib3
from faster_whisper import WhisperModel

# Configuracao para ambientes corporativos com proxy SSL
# Defina TRANSCRICAO_SKIP_SSL=true para ignorar verificacao SSL
if os.environ.get('TRANSCRICAO_SKIP_SSL', '').lower() == 'true':
    ssl._create_default_https_context = ssl._create_unverified_context
    urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
    os.environ['HF_HUB_DISABLE_SSL_VERIFY'] = '1'
    os.environ['CURL_CA_BUNDLE'] = ''
    os.environ['REQUESTS_CA_BUNDLE'] = ''
    os.environ['HF_HUB_OFFLINE'] = '1'  # Forca modo offline se modelo ja existe local
    os.environ['TRANSFORMERS_OFFLINE'] = '1'  # Evita checks online
    
# Configuracoes gerais para evitar warnings e checks desnecessarios
os.environ['HF_HUB_DISABLE_TELEMETRY'] = '1'
os.environ['HF_HUB_DISABLE_IMPLICIT_TOKEN'] = '1'

st.set_page_config(
    page_title="Transcrição de Áudio",
    page_icon="🎙️",
    layout="centered"
)

MODEL_SIZES = ["tiny", "base", "small", "medium", "large-v1", "large-v2", "large-v3"]


def load_model(model_size):
    """Carrega o modelo Whisper com o tamanho especificado (CPU only)."""
    # Sempre usar CPU para maxima compatibilidade entre computadores
    device = "cpu"
    compute_type = "int8"
    
    # Se modo offline ativo, tentar usar cache local
    if os.environ.get('HF_HUB_OFFLINE') == '1':
        try:
            model = WhisperModel(
                model_size, 
                device=device, 
                compute_type=compute_type,
                local_files_only=True
            )
            return model, device
        except Exception:
            # Ignora erro e tenta modo normal
            pass
    
    # Carregar normalmente (tenta baixar se nao existir)
    model = WhisperModel(model_size, device=device, compute_type=compute_type)
    return model, device


def transcribe_audio(audio_path, model, progress_bar, status_text):
    """Transcreve o arquivo de áudio usando o modelo carregado."""
    segments, info = model.transcribe(audio_path, beam_size=5)
    
    status_text.text(f"Idioma detectado: {info.language} (confiança: {info.language_probability:.2f})")
    
    transcription = ""
    total_duration = info.duration if hasattr(info, 'duration') else 0
    
    for i, segment in enumerate(segments):
        transcription += segment.text + " "
        
        if total_duration > 0:
            progress = min((segment.end / total_duration), 1.0)
            progress_bar.progress(progress, text=f"Transcrevendo... {progress:.0%}")
        
        time.sleep(0.01)
    
    return transcription.strip()


def main():
    st.title("🎙️ Transcrição de Áudio para Texto")
    st.markdown("""
    **Converta seus arquivos de áudio em texto automaticamente.**
    
    Esta aplicação utiliza o modelo **Whisper** da OpenAI (otimizado via `faster-whisper`) 
    para transcrever áudios localmente no seu computador, sem necessidade de internet ou APIs pagas.
    """)
    
    st.divider()
    
    col1, col2 = st.columns([2, 1])
    
    with col1:
        uploaded_file = st.file_uploader(
            "📁 Arraste ou selecione um arquivo de áudio",
            type=["mp3", "wav", "m4a", "flac", "ogg", "wma"],
            help="Formatos suportados: MP3, WAV, M4A, FLAC, OGG, WMA"
        )
    
    with col2:
        model_size = st.selectbox(
            "🧠 Tamanho do Modelo",
            options=MODEL_SIZES,
            index=1,
            help="""
            - **tiny**: Muito rápido, precisão básica
            - **base**: Rápido, boa precisão (recomendado)
            - **small**: Equilíbrio entre velocidade e precisão
            - **medium/large**: Mais precisos, mais lentos
            """
        )
    
    st.divider()
    
    if uploaded_file is not None:
        st.info(f"📄 Arquivo selecionado: **{uploaded_file.name}** ({uploaded_file.size / 1024:.1f} KB)")
        
        if st.button("🚀 Iniciar Transcrição", type="primary", use_container_width=True):
            progress_bar = st.progress(0, text="Aguardando início...")
            status_text = st.empty()
            
            try:
                with tempfile.NamedTemporaryFile(delete=False, suffix=f".{uploaded_file.name.split('.')[-1]}") as tmp_file:
                    tmp_file.write(uploaded_file.getvalue())
                    tmp_path = tmp_file.name
                
                status_text.text("⏳ Carregando modelo... (pode levar alguns segundos na primeira vez)")
                progress_bar.progress(0.1, text="Carregando modelo...")
                
                model, device = load_model(model_size)
                
                status_text.text("✅ Modelo carregado em 🖥️ CPU! Iniciando transcrição...")
                progress_bar.progress(0.2, text="Processando áudio...")
                
                start_time = time.time()
                transcription = transcribe_audio(tmp_path, model, progress_bar, status_text)
                elapsed_time = time.time() - start_time
                
                progress_bar.progress(1.0, text="Transcrição concluída!")
                status_text.text(f"✅ Transcrição finalizada em {elapsed_time:.1f} segundos")
                
                st.divider()
                st.subheader("📝 Texto Transcrito:")
                
                st.text_area(
                    "Resultado da transcrição",
                    value=transcription,
                    height=300,
                    label_visibility="collapsed"
                )
                
                st.download_button(
                    label="📥 Baixar Transcrição (.txt)",
                    data=transcription,
                    file_name=f"{uploaded_file.name.rsplit('.', 1)[0]}_transcricao.txt",
                    mime="text/plain",
                    use_container_width=True
                )
                
            except Exception as e:
                error_msg = str(e)
                
                # Detectar erro SSL comum em redes corporativas
                if "CERTIFICATE_VERIFY_FAILED" in error_msg or "SSL" in error_msg:
                    st.error("❌ Erro de certificado SSL - Rede corporativa detectada")
                    st.markdown("""
                    **Possiveis solucoes:**
                    
                    **Opcao 1 - Modo Corporativo (Recomendado):**
                    1. Feche a aplicacao
                    2. Execute no terminal/cmd:
                       ```
                       set TRANSCRICAO_SKIP_SSL=true
                       ```
                    3. Rode novamente: `run.bat` (Windows) ou `./run.sh` (Linux)
                    
                    **Opcao 2 - Configurar certificado corporativo:**
                    Solicite ao departamento de TI o certificado raiz da empresa
                    e configure nas variaveis de ambiente.
                    
                    **Opcao 3 - Download manual do modelo:**
                    Se o erro persistir, baixe o modelo manualmente e coloque na pasta:
                    `~/.cache/huggingface/hub/` (Linux) ou `%USERPROFILE%.cache\huggingface\hub\` (Windows)
                    """
                )
                else:
                    st.error(f"❌ Erro durante a transcricao: {error_msg}")
                    st.info("💡 Dica: Verifique se o arquivo de audio nao esta corrompido e se ha memoria disponivel.")
            
            finally:
                if 'tmp_path' in locals() and os.path.exists(tmp_path):
                    os.unlink(tmp_path)
    
    else:
        st.info("👆 Faça upload de um arquivo de áudio para começar.")
    
    st.divider()
    st.caption("🔒 100% Local & Gratuito • Powered by Whisper & Streamlit")


if __name__ == "__main__":
    main()
