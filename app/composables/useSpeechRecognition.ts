export function useSpeechRecognition() {
  const isSupported = ref(false)
  const listeningId = ref<string | null>(null)

  let SR: any = null
  let active: any = null

  onMounted(() => {
    SR = (window as any).SpeechRecognition || (window as any).webkitSpeechRecognition
    isSupported.value = !!SR
  })

  function listen(id: string, onResult: (text: string) => void) {
    if (!SR) return

    if (listeningId.value === id) {
      active?.stop()
      active = null
      listeningId.value = null
      return
    }

    active?.stop()
    active = null

    const recognition = new SR()
    recognition.continuous = false
    recognition.interimResults = false
    recognition.lang = 'en-GB'

    listeningId.value = id
    active = recognition

    recognition.onresult = (e: any) => {
      onResult(e.results[0][0].transcript.trim())
      listeningId.value = null
      active = null
    }
    recognition.onerror = () => {
      listeningId.value = null
      active = null
    }
    recognition.onend = () => {
      listeningId.value = null
      active = null
    }

    recognition.start()
  }

  return { isSupported, listeningId, listen }
}
