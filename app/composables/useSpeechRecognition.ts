export function useSpeechRecognition() {
  const isSupported = ref(false)
  const listeningId = ref<string | null>(null)

  let recognition: any = null

  onMounted(() => {
    const SR = (window as any).SpeechRecognition || (window as any).webkitSpeechRecognition
    isSupported.value = !!SR
    if (!SR) return
    recognition = new SR()
    recognition.continuous = false
    recognition.interimResults = false
    recognition.lang = 'en-GB'
  })

  function listen(id: string, onResult: (text: string) => void) {
    if (!recognition) return
    if (listeningId.value === id) {
      recognition.stop()
      listeningId.value = null
      return
    }
    if (listeningId.value) recognition.stop()
    listeningId.value = id
    recognition.onresult = (e: any) => {
      onResult(e.results[0][0].transcript.trim())
      listeningId.value = null
    }
    recognition.onerror = () => { listeningId.value = null }
    recognition.onend = () => { listeningId.value = null }
    recognition.start()
  }

  return { isSupported, listeningId, listen }
}
