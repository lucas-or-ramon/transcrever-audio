import streamlit as st
import os
import tempfile
import time
from faster_whisper import WhisperModel

st.set_page_config(
    page_title="Transcrição de Áudio",
    page_icon="🎙️",
    layout="centered"
)

MODEL_SIZES = ["tiny", "base", "small", "medium", "large-v1", "large-v2", "large-v3"]


def load_model(model_size):
    """Carrega o modelo Whisper com o tamanho especificado (CPU only)."""
    # Sempre usar CPU para máxima compatibilidade entre computadores
    device = "cpu"
    compute_type = "int8"
    
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
                st.error(f"❌ Erro durante a transcrição: {str(e)}")
                st.info("💡 Dica: Verifique se o arquivo de áudio não está corrompido e se há memória disponível.")
            
            finally:
                if 'tmp_path' in locals() and os.path.exists(tmp_path):
                    os.unlink(tmp_path)
    
    else:
        st.info("👆 Faça upload de um arquivo de áudio para começar.")
    
    st.divider()
    st.caption("🔒 100% Local & Gratuito • Powered by Whisper & Streamlit")


if __name__ == "__main__":
    main()
