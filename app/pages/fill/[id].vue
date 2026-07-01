<script setup lang="ts">
const route = useRoute()
const router = useRouter()
const entryId = route.params.id as string

const { getToolById } = useTools()
const { getFieldValue, saveField, getEntry } = useToolData()
const { isSupported: speechSupported, listeningId, listen } = useSpeechRecognition()

const ready = ref(false)
const tool = ref<ReturnType<typeof getToolById>>(undefined)
const currentStep = ref(0)
const formData = reactive<Record<string, string | string[]>>({})

onMounted(() => {
  const entry = getEntry(entryId)
  if (!entry) {
    router.replace('/')
    return
  }
  tool.value = getToolById(entry.toolId)
  if (!tool.value) {
    router.replace('/')
    return
  }
  for (const s of tool.value.steps) {
    for (const f of s.fields) {
      const saved = getFieldValue(entryId, f.id)
      if (f.type === 'list' || f.type === 'photo-gallery' || f.type === 'list-with-photo') {
        formData[f.id] = Array.isArray(saved) ? [...saved] : saved ? [saved as string] : []
      } else {
        formData[f.id] = (saved as string) || ''
      }
    }
  }

  const stepParam = route.query.step
  if (stepParam === 'last' && tool.value) {
    currentStep.value = tool.value.steps.length - 1
  } else if (stepParam && !isNaN(Number(stepParam))) {
    currentStep.value = Math.min(Number(stepParam), tool.value.steps.length - 1)
  }

  ready.value = true
})

const totalSteps = computed(() => tool.value?.steps.length ?? 0)
const step = computed(() => tool.value?.steps[currentStep.value])
const progress = computed(() => totalSteps.value ? ((currentStep.value + 1) / totalSteps.value) * 100 : 0)

function saveCurrentStep() {
  if (!step.value) return
  for (const f of step.value.fields) {
    saveField(entryId, f.id, formData[f.id])
  }
}

function nextStep() {
  saveCurrentStep()
  if (currentStep.value < totalSteps.value - 1) {
    currentStep.value++
    window.scrollTo({ top: 0, behavior: 'smooth' })
  } else {
    router.push(`/view/${entryId}`)
  }
}

function prevStep() {
  saveCurrentStep()
  if (currentStep.value > 0) {
    currentStep.value--
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

function addListItem(fieldId: string) {
  (formData[fieldId] as string[]).push('')
}

function removeListItem(fieldId: string, index: number) {
  (formData[fieldId] as string[]).splice(index, 1)
}

function updateListItem(fieldId: string, index: number, value: string) {
  (formData[fieldId] as string[])[index] = value
}

function addSuggestion(fieldId: string, suggestion: string) {
  const list = formData[fieldId] as string[]
  if (!list.includes(suggestion)) {
    list.push(suggestion)
  }
}

function isSuggestionSelected(fieldId: string, suggestion: string): boolean {
  return (formData[fieldId] as string[]).includes(suggestion)
}

function handlePhotoUpload(fieldId: string, event: Event) {
  const input = event.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return
  const reader = new FileReader()
  reader.onload = () => { formData[fieldId] = reader.result as string }
  reader.readAsDataURL(file)
  input.value = ''
}

function addGalleryPhoto(fieldId: string, event: Event) {
  const input = event.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return
  const reader = new FileReader()
  reader.onload = () => {
    (formData[fieldId] as string[]).push(reader.result as string)
  }
  reader.readAsDataURL(file)
  input.value = ''
}

function removeGalleryPhoto(fieldId: string, index: number) {
  (formData[fieldId] as string[]).splice(index, 1)
}

function parseListWithPhotoItem(item: string): { text: string; photo: string | null } {
  try {
    return JSON.parse(item)
  } catch {
    return { text: item, photo: null }
  }
}

function addListWithPhotoItem(fieldId: string) {
  (formData[fieldId] as string[]).push(JSON.stringify({ text: '', photo: null }))
}

function removeListWithPhotoItem(fieldId: string, index: number) {
  (formData[fieldId] as string[]).splice(index, 1)
}

function updateListWithPhotoText(fieldId: string, index: number, text: string) {
  const item = parseListWithPhotoItem((formData[fieldId] as string[])[index])
  item.text = text
  ;(formData[fieldId] as string[])[index] = JSON.stringify(item)
}

function updateListWithPhotoPhoto(fieldId: string, index: number, photo: string | null) {
  const item = parseListWithPhotoItem((formData[fieldId] as string[])[index])
  item.photo = photo
  ;(formData[fieldId] as string[])[index] = JSON.stringify(item)
}

function handleListPhotoUpload(fieldId: string, index: number, event: Event) {
  const input = event.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return
  const reader = new FileReader()
  reader.onload = () => {
    updateListWithPhotoPhoto(fieldId, index, reader.result as string)
  }
  reader.readAsDataURL(file)
  input.value = ''
}

function listenToText(fieldId: string) {
  listen(fieldId, (text) => { formData[fieldId] = text })
}

function listenAndAddToList(fieldId: string) {
  const listenKey = `voice-list-${fieldId}`
  listen(listenKey, (text) => {
    (formData[fieldId] as string[]).push(text)
  })
}
</script>

<template>
  <div class="max-w-3xl mx-auto px-4 sm:px-6 py-8 sm:py-12">
    <template v-if="ready && tool && step">
      <NuxtLink to="/" class="inline-flex items-center gap-2 text-sm text-navy/40 hover:text-teal transition-colors mb-6">
        <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
        </svg>
        Back to tools
      </NuxtLink>

      <div class="mb-8">
        <h1 class="text-2xl sm:text-3xl text-navy mb-1">{{ tool.name }}</h1>
        <p class="text-navy/50">{{ tool.tagline }}</p>
      </div>

      <div class="mb-8">
        <div class="flex items-center justify-between text-sm text-navy/40 mb-2">
          <span>Step {{ currentStep + 1 }} of {{ totalSteps }}</span>
          <span>{{ Math.round(progress) }}%</span>
        </div>
        <div class="h-2 bg-navy/5 rounded-full overflow-hidden">
          <div class="h-full bg-teal rounded-full transition-all duration-500 ease-out" :style="{ width: `${progress}%` }" />
        </div>
      </div>

      <div class="card mb-6">
        <h2 class="text-xl font-heading text-navy mb-1">{{ step.title }}</h2>
        <p v-if="step.description" class="text-navy/50 text-sm mb-6">{{ step.description }}</p>

        <div class="space-y-6">
          <div v-for="field in step.fields" :key="field.id">
            <label class="block text-sm font-medium text-navy mb-2">{{ field.label }}</label>

            <div v-if="field.type === 'text'" class="relative">
              <input v-model="formData[field.id] as string" type="text" class="input-field" :class="speechSupported ? 'pr-11' : ''" :placeholder="field.placeholder" />
              <button
                v-if="speechSupported"
                type="button"
                class="absolute right-3 top-1/2 -translate-y-1/2 p-1 rounded-full transition-colors"
                :class="listeningId === field.id ? 'text-teal' : 'text-navy/30 hover:text-teal'"
                :title="listeningId === field.id ? 'Listening — tap to stop' : 'Tap to speak'"
                @click="listenToText(field.id)"
              >
                <svg v-if="listeningId !== field.id" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 1a3 3 0 0 0-3 3v8a3 3 0 0 0 6 0V4a3 3 0 0 0-3-3z" />
                  <path stroke-linecap="round" stroke-linejoin="round" d="M19 10v2a7 7 0 0 1-14 0v-2" />
                  <line x1="12" y1="19" x2="12" y2="23" stroke-linecap="round" />
                  <line x1="8" y1="23" x2="16" y2="23" stroke-linecap="round" />
                </svg>
                <svg v-else class="w-5 h-5 animate-pulse" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M12 1a3 3 0 0 0-3 3v8a3 3 0 0 0 6 0V4a3 3 0 0 0-3-3z" />
                  <path d="M19 10v2a7 7 0 0 1-14 0v-2h2v2a5 5 0 0 0 10 0v-2h2z" />
                </svg>
              </button>
            </div>

            <textarea v-else-if="field.type === 'textarea'" v-model="formData[field.id] as string" class="textarea-field" rows="4" :placeholder="field.placeholder" />

            <!-- Photo with optional camera capture -->
            <div v-else-if="field.type === 'photo'" class="space-y-3">
              <p v-if="field.hint" class="text-xs text-navy/40">{{ field.hint }}</p>
              <div v-if="formData[field.id]" class="w-32 h-32 rounded-2xl overflow-hidden border-2 border-navy/10">
                <img :src="formData[field.id] as string" class="w-full h-full object-cover" alt="Photo" />
              </div>
              <div class="flex flex-wrap gap-2">
                <label class="btn-secondary cursor-pointer text-sm">
                  <svg class="w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                  </svg>
                  Browse
                  <input type="file" accept="image/*" class="hidden" @change="handlePhotoUpload(field.id, $event)" />
                </label>
                <label v-if="field.allowCamera" class="btn-secondary cursor-pointer text-sm">
                  <svg class="w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                  </svg>
                  Take photo
                  <input type="file" accept="image/*" capture="user" class="hidden" @change="handlePhotoUpload(field.id, $event)" />
                </label>
              </div>
            </div>

            <!-- List with optional suggestion chips -->
            <div v-else-if="field.type === 'list'" class="space-y-3">
              <!-- Suggestion chips -->
              <div v-if="field.suggestions?.length" class="flex flex-wrap gap-2 pb-2">
                <button
                  v-for="s in field.suggestions" :key="s"
                  class="px-3 py-1.5 rounded-full text-sm font-medium transition-all duration-150"
                  :class="isSuggestionSelected(field.id, s)
                    ? 'bg-teal text-white'
                    : 'bg-navy/5 text-navy/60 hover:bg-teal/10 hover:text-teal'"
                  @click="addSuggestion(field.id, s)"
                >
                  {{ s }}
                </button>
              </div>

              <!-- List items -->
              <div class="space-y-2">
                <div v-for="(item, index) in (formData[field.id] as string[])" :key="index" class="flex items-center gap-2">
                  <span class="text-teal font-bold text-sm w-6 text-center shrink-0">{{ index + 1 }}</span>
                  <input :value="item" type="text" class="input-field flex-1" :placeholder="field.placeholder" @input="updateListItem(field.id, index, ($event.target as HTMLInputElement).value)" />
                  <button class="p-2 text-navy/20 hover:text-coral transition-colors shrink-0" @click="removeListItem(field.id, index)">
                    <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                </div>
              </div>

              <div class="flex items-center gap-4 flex-wrap">
                <button class="inline-flex items-center gap-2 text-sm text-teal hover:text-teal-600 font-medium transition-colors" @click="addListItem(field.id)">
                  <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                  </svg>
                  Add item
                </button>
                <button
                  v-if="speechSupported"
                  type="button"
                  class="inline-flex items-center gap-2 text-sm font-medium transition-colors"
                  :class="listeningId === `voice-list-${field.id}` ? 'text-teal animate-pulse' : 'text-navy/40 hover:text-teal'"
                  @click="listenAndAddToList(field.id)"
                >
                  <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.8">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 1a3 3 0 0 0-3 3v8a3 3 0 0 0 6 0V4a3 3 0 0 0-3-3z" />
                    <path stroke-linecap="round" stroke-linejoin="round" d="M19 10v2a7 7 0 0 1-14 0v-2" />
                    <line x1="12" y1="19" x2="12" y2="23" stroke-linecap="round" />
                    <line x1="8" y1="23" x2="16" y2="23" stroke-linecap="round" />
                  </svg>
                  {{ listeningId === `voice-list-${field.id}` ? 'Listening...' : 'Speak to add' }}
                </button>
              </div>
            </div>

            <!-- Photo gallery -->
            <div v-else-if="field.type === 'photo-gallery'" class="space-y-3">
              <p v-if="field.hint" class="text-xs text-navy/40">{{ field.hint }}</p>
              <div v-if="(formData[field.id] as string[]).length > 0" class="flex flex-wrap gap-3">
                <div v-for="(photo, index) in (formData[field.id] as string[])" :key="index" class="relative group">
                  <div class="w-24 h-24 rounded-xl overflow-hidden border-2 border-navy/10">
                    <img :src="photo" class="w-full h-full object-cover" alt="Photo" />
                  </div>
                  <button
                    class="absolute -top-2 -right-2 w-6 h-6 rounded-full bg-coral text-white flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity"
                    @click="removeGalleryPhoto(field.id, index)"
                  >
                    <svg class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                </div>
              </div>
              <div class="flex flex-wrap gap-2">
                <label class="btn-secondary cursor-pointer text-sm">
                  <svg class="w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                  </svg>
                  Browse
                  <input type="file" accept="image/*" class="hidden" @change="addGalleryPhoto(field.id, $event)" />
                </label>
                <label class="btn-secondary cursor-pointer text-sm">
                  <svg class="w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                  </svg>
                  Take photo
                  <input type="file" accept="image/*" capture="environment" class="hidden" @change="addGalleryPhoto(field.id, $event)" />
                </label>
              </div>
            </div>

            <!-- List with photo per item -->
            <div v-else-if="field.type === 'list-with-photo'" class="space-y-3">
              <div class="space-y-3">
                <div v-for="(item, index) in (formData[field.id] as string[])" :key="index" class="flex items-center gap-3">
                  <div class="relative shrink-0">
                    <label class="cursor-pointer block">
                      <div v-if="parseListWithPhotoItem(item).photo"
                           class="w-12 h-12 rounded-full overflow-hidden border-2 border-navy/10">
                        <img :src="parseListWithPhotoItem(item).photo!" class="w-full h-full object-cover" alt="" />
                      </div>
                      <div v-else
                           class="w-12 h-12 rounded-full border-2 border-dashed border-navy/20 flex items-center justify-center text-navy/30 hover:border-teal hover:text-teal transition-colors">
                        <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                          <path stroke-linecap="round" stroke-linejoin="round" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                          <path stroke-linecap="round" stroke-linejoin="round" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                        </svg>
                      </div>
                      <input type="file" accept="image/*" class="hidden" @change="handleListPhotoUpload(field.id, index, $event)" />
                    </label>
                    <label class="absolute -bottom-1 -right-1 w-5 h-5 rounded-full bg-teal text-white flex items-center justify-center cursor-pointer"
                           title="Take photo">
                      <svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                        <path stroke-linecap="round" stroke-linejoin="round" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                      </svg>
                      <input type="file" accept="image/*" capture="user" class="hidden" @change="handleListPhotoUpload(field.id, index, $event)" />
                    </label>
                    <button v-if="parseListWithPhotoItem(item).photo"
                            class="absolute -top-1 -right-1 w-5 h-5 rounded-full bg-coral text-white flex items-center justify-center"
                            @click.prevent="updateListWithPhotoPhoto(field.id, index, null)">
                      <svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                      </svg>
                    </button>
                  </div>
                  <input :value="parseListWithPhotoItem(item).text" type="text" class="input-field flex-1"
                         :placeholder="field.placeholder"
                         @input="updateListWithPhotoText(field.id, index, ($event.target as HTMLInputElement).value)" />
                  <button class="p-2 text-navy/20 hover:text-coral transition-colors shrink-0"
                          @click="removeListWithPhotoItem(field.id, index)">
                    <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                </div>
              </div>
              <button class="inline-flex items-center gap-2 text-sm text-teal hover:text-teal-600 font-medium transition-colors"
                      @click="addListWithPhotoItem(field.id)">
                <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                </svg>
                Add person
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="flex items-center justify-between">
        <button v-if="currentStep > 0" class="btn-secondary" @click="prevStep">
          <svg class="w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
          </svg>
          Back
        </button>
        <div v-else />
        <button class="btn-primary" @click="nextStep">
          {{ currentStep === totalSteps - 1 ? 'Generate' : 'Next' }}
          <svg v-if="currentStep < totalSteps - 1" class="w-4 h-4 ml-2" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" />
          </svg>
          <svg v-else class="w-4 h-4 ml-2" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </button>
      </div>
    </template>

    <div v-else class="text-center py-20 text-navy/30">Loading...</div>
  </div>
</template>
