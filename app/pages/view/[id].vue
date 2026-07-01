<script setup lang="ts">
const route = useRoute()
const router = useRouter()
const entryId = route.params.id as string

const { getToolById } = useTools()
const { getEntry, deleteEntry } = useToolData()

const ready = ref(false)
const tool = ref<ReturnType<typeof getToolById>>(undefined)
const entryData = ref<Record<string, string | string[]>>({})
const entryLabel = ref('')
const showGdprNotice = ref(false)
const showPersonalise = ref(false)

const fontOptions = [
  { id: 'clean', label: 'Clean', family: "'DM Sans', system-ui, sans-serif" },
  { id: 'elegant', label: 'Elegant', family: "'Marcellus', Georgia, serif" },
  { id: 'handwritten', label: 'Handwritten', family: "'Caveat', cursive" },
]

const bgOptions = [
  { id: 'white', label: 'White', colour: '#FFFFFF' },
  { id: 'sand', label: 'Sand', colour: '#FAF6F0' },
  { id: 'sky', label: 'Sky', colour: '#EFF8FA' },
  { id: 'blush', label: 'Blush', colour: '#FAF3F0' },
  { id: 'lavender', label: 'Lavender', colour: '#F0EFF8' },
]

const accentOptions = [
  { id: 'teal', label: 'Teal', colour: '#72B9CF' },
  { id: 'coral', label: 'Coral', colour: '#CF8872' },
  { id: 'navy', label: 'Navy', colour: '#161F38' },
  { id: 'forest', label: 'Forest', colour: '#6B9E7D' },
  { id: 'purple', label: 'Purple', colour: '#8B7EC4' },
]

const selectedFont = ref('clean')
const selectedBg = ref('white')
const selectedAccent = ref('teal')

const currentFont = computed(() => fontOptions.find(f => f.id === selectedFont.value)?.family ?? fontOptions[0].family)
const currentBg = computed(() => bgOptions.find(b => b.id === selectedBg.value)?.colour ?? bgOptions[0].colour)
const currentAccent = computed(() => accentOptions.find(a => a.id === selectedAccent.value)?.colour ?? accentOptions[0].colour)

const isMyPeople = computed(() => tool.value?.id === 'my-people')
const isBestWorstDay = computed(() => tool.value?.id === 'best-worst-day')
const isAboutMe = computed(() => tool.value?.id === 'about-me')
const isWhatMatters = computed(() => tool.value?.id === 'what-matters')
const isWhatsWorking = computed(() => tool.value?.id === 'whats-working')
const isHowICommunicate = computed(() => tool.value?.id === 'how-i-communicate')
const isMyPerfectWeek = computed(() => tool.value?.id === 'my-perfect-week')
const isMyDirection = computed(() => tool.value?.id === 'my-direction')
const isMyStory = computed(() => tool.value?.id === 'my-story')

const myPeopleQuadrants = [
  { fieldId: 'closest', label: 'Closest to me', colour: '#CF8872' },
  { fieldId: 'important', label: 'Important to me', colour: '#D99A5B' },
  { fieldId: 'wider', label: 'Other people in my life', colour: '#6B9E7D' },
  { fieldId: 'paid', label: 'Paid support', colour: '#9B8AB8' },
]

const myDirectionColumns = [
  { fieldId: 'now', question: 'What are things like now?' },
  { fieldId: 'who', question: 'Who are the people and services in my life?' },
  { fieldId: 'working', question: 'What\'s working and not working?' },
  { fieldId: 'first-steps', question: 'What should we do first?' },
  { fieldId: 'next-month', question: 'What can we do in the next month?' },
]

const myStoryQuadrants = [
  { fieldId: 'dreams', label: 'My Dreams', colour: '#8B7EC4', type: 'text' },
  { fieldId: 'nightmares', label: 'My Nightmares', colour: '#6B9E7D', type: 'text' },
  { fieldId: 'about', label: 'About Me', colour: '#72B9CF', type: 'list' },
  { fieldId: 'gifts', label: 'My Gifts', colour: '#C1666B', type: 'list' },
  { fieldId: 'support', label: 'To Support Me', colour: '#C97B96', type: 'list' },
]

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
  entryData.value = entry.data
  entryLabel.value = entry.label
  ready.value = true
})

function getListData(fieldId: string): string[] {
  const val = entryData.value[fieldId]
  if (Array.isArray(val)) return val.filter(v => v.trim() !== '')
  if (typeof val === 'string' && val) return [val]
  return []
}

function getTextData(fieldId: string): string {
  const val = entryData.value[fieldId]
  if (typeof val === 'string') return val
  if (Array.isArray(val)) return val.join(', ')
  return ''
}

function getPhotoGallery(fieldId: string): string[] {
  const val = entryData.value[fieldId]
  if (Array.isArray(val)) return val.filter(v => v.startsWith('data:'))
  return []
}

function getListWithPhotoData(fieldId: string): Array<{ text: string; photo: string | null }> {
  const val = entryData.value[fieldId]
  if (!Array.isArray(val)) return []
  return val.map(item => {
    try {
      const parsed = JSON.parse(item)
      return { text: parsed.text || '', photo: parsed.photo || null }
    } catch {
      return { text: item, photo: null }
    }
  }).filter(item => item.text || item.photo)
}

function accentWithOpacity(opacity: number): string {
  const hex = currentAccent.value.replace('#', '')
  const r = parseInt(hex.substring(0, 2), 16)
  const g = parseInt(hex.substring(2, 4), 16)
  const b = parseInt(hex.substring(4, 6), 16)
  return `rgba(${r}, ${g}, ${b}, ${opacity})`
}

const exportEl = ref<HTMLElement>()
const exporting = ref(false)

async function exportPdf() {
  if (!exportEl.value || !tool.value) return
  exporting.value = true
  try {
    const html2pdf = (await import('html2pdf.js')).default
    const name = getTextData('name') || 'Unnamed'
    await html2pdf(exportEl.value, {
      margin: [10, 10, 10, 10],
      filename: `${tool.value.name} - ${name}.pdf`,
      image: { type: 'jpeg', quality: 0.98 },
      html2canvas: { scale: 2, useCORS: true },
      jsPDF: { unit: 'mm', format: 'a4', orientation: (isMyPeople.value || isHowICommunicate.value || isMyPerfectWeek.value || isMyDirection.value || isMyStory.value) ? 'landscape' : 'portrait' },
    })
    deleteEntry(entryId)
    showGdprNotice.value = true
  } finally {
    exporting.value = false
  }
}

function handleDelete() {
  if (confirm('Are you sure you want to delete this? This cannot be undone.')) {
    deleteEntry(entryId)
    router.push('/')
  }
}

function goBack() {
  router.push(`/fill/${entryId}?step=last`)
}
</script>

<template>
  <div class="mx-auto px-4 sm:px-6 py-8 sm:py-12" :class="(isMyDirection || isMyStory) ? 'max-w-6xl' : 'max-w-3xl'">
    <!-- GDPR notice after PDF export -->
    <div v-if="showGdprNotice" class="text-center py-16">
      <div class="w-16 h-16 rounded-full bg-teal/10 flex items-center justify-center mx-auto mb-6">
        <svg class="w-8 h-8 text-teal" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
      </div>
      <h2 class="text-2xl font-heading text-navy mb-3">PDF downloaded</h2>
      <p class="text-navy/60 max-w-md mx-auto mb-8">
        For your privacy, all data has been deleted from Centred. Nothing is stored in the app.
      </p>
      <NuxtLink to="/" class="btn-primary">
        <svg class="w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
        </svg>
        Back to tools
      </NuxtLink>
    </div>

    <template v-else-if="ready && tool">
      <NuxtLink to="/" class="inline-flex items-center gap-2 text-sm text-navy/40 hover:text-teal transition-colors mb-6">
        <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
        </svg>
        Back to tools
      </NuxtLink>

      <div class="flex flex-wrap items-center gap-3 mb-6">
        <h1 class="text-2xl sm:text-3xl text-navy flex-1">{{ tool.name }}</h1>
        <button class="btn-secondary text-sm" @click="goBack">
          <svg class="w-4 h-4 mr-1.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
          </svg>
          Back to amend
        </button>
        <button class="btn-secondary text-sm" @click="showPersonalise = !showPersonalise">
          <svg class="w-4 h-4 mr-1.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M7 21a4 4 0 01-4-4V5a2 2 0 012-2h4a2 2 0 012 2v12a4 4 0 01-4 4zm0 0h12a2 2 0 002-2v-4a2 2 0 00-2-2h-2.343M11 7.343l1.657-1.657a2 2 0 012.828 0l2.829 2.829a2 2 0 010 2.828l-8.486 8.485M7 17h.01" />
          </svg>
          Personalise
        </button>
        <button class="btn-primary text-sm" :disabled="exporting" @click="exportPdf">
          <svg class="w-4 h-4 mr-1.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
          {{ exporting ? 'Exporting...' : 'Export PDF' }}
        </button>
        <button class="p-2 text-navy/20 hover:text-coral transition-colors" title="Delete" @click="handleDelete">
          <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
          </svg>
        </button>
      </div>

      <!-- GDPR notice -->
      <div class="flex items-start gap-3 px-4 py-3 rounded-xl bg-teal/5 border border-teal/10 mb-6">
        <svg class="w-5 h-5 text-teal shrink-0 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
        </svg>
        <p class="text-sm text-navy/60">Your data is only stored temporarily on this device. Once you export the PDF, everything is automatically deleted.</p>
      </div>

      <!-- Personalisation panel -->
      <div v-if="showPersonalise" class="card mb-6 space-y-5">
        <h3 class="font-heading text-navy text-lg">Personalise your document</h3>

        <div>
          <p class="text-sm font-medium text-navy mb-2">Font</p>
          <div class="flex flex-wrap gap-2">
            <button
              v-for="font in fontOptions" :key="font.id"
              class="px-4 py-2 rounded-xl text-sm font-medium border-2 transition-all duration-150"
              :class="selectedFont === font.id
                ? 'border-teal bg-teal/5 text-teal'
                : 'border-navy/10 text-navy/60 hover:border-navy/20'"
              :style="{ fontFamily: font.family }"
              @click="selectedFont = font.id"
            >
              {{ font.label }}
            </button>
          </div>
        </div>

        <div>
          <p class="text-sm font-medium text-navy mb-2">Background</p>
          <div class="flex flex-wrap gap-2">
            <button
              v-for="bg in bgOptions" :key="bg.id"
              class="w-10 h-10 rounded-xl border-2 transition-all duration-150 relative"
              :class="selectedBg === bg.id ? 'border-teal scale-110' : 'border-navy/10 hover:border-navy/20'"
              :style="{ backgroundColor: bg.colour }"
              :title="bg.label"
              @click="selectedBg = bg.id"
            >
              <svg v-if="selectedBg === bg.id" class="w-4 h-4 text-teal absolute inset-0 m-auto" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3">
                <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" />
              </svg>
            </button>
          </div>
        </div>

        <div>
          <p class="text-sm font-medium text-navy mb-2">Accent colour</p>
          <div class="flex flex-wrap gap-2">
            <button
              v-for="accent in accentOptions" :key="accent.id"
              class="w-10 h-10 rounded-xl border-2 transition-all duration-150 relative"
              :class="selectedAccent === accent.id ? 'border-navy scale-110' : 'border-transparent hover:border-navy/20'"
              :style="{ backgroundColor: accent.colour }"
              :title="accent.label"
              @click="selectedAccent = accent.id"
            >
              <svg v-if="selectedAccent === accent.id" class="w-4 h-4 text-white absolute inset-0 m-auto" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3">
                <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" />
              </svg>
            </button>
          </div>
        </div>
      </div>

      <!-- The document -->
      <div ref="exportEl" class="rounded-2xl shadow-sm border border-navy/5 overflow-hidden" :style="{ backgroundColor: currentBg, fontFamily: currentFont }">
        <!-- Header -->
        <div class="px-8 py-6" :style="{ backgroundColor: currentAccent }">
          <h2 class="text-2xl font-heading text-white">{{ tool.name }}</h2>
          <p v-if="getTextData('name')" class="text-white/80 mt-1 text-lg">{{ getTextData('name') }}</p>
        </div>

        <!-- ==================== ABOUT ME: Grid layout ==================== -->
        <div v-if="isAboutMe" class="p-5">
          <div class="grid grid-cols-2 gap-3">
            <!-- Top left: Photo -->
            <div class="p-4 rounded-xl" :style="{ border: '1px solid ' + accentWithOpacity(0.15) }">
              <img v-if="getTextData('photo')" :src="getTextData('photo')" alt=""
                   class="w-full aspect-square rounded-xl object-cover" />
              <div v-else class="w-full aspect-square rounded-xl flex items-center justify-center"
                   :style="{ backgroundColor: accentWithOpacity(0.05) }">
                <svg class="w-16 h-16" :style="{ color: accentWithOpacity(0.2) }" fill="currentColor" viewBox="0 0 24 24">
                  <circle cx="12" cy="8" r="4" />
                  <path d="M4 20c0-4.4 3.6-8 8-8s8 3.6 8 8" />
                </svg>
              </div>
            </div>

            <!-- Top right: What people like and admire -->
            <div class="p-4 rounded-xl" :style="{ border: '1px solid ' + accentWithOpacity(0.15) }">
              <h3 class="font-semibold text-xs uppercase tracking-wider mb-3" :style="{ color: currentAccent }">
                What people like and admire about me
              </h3>
              <ul v-if="getListData('admire').length > 0" class="space-y-1">
                <li v-for="(item, i) in getListData('admire')" :key="i" class="flex items-start gap-2 text-navy/80 text-sm">
                  <span class="w-1.5 h-1.5 rounded-full mt-1.5 shrink-0" :style="{ backgroundColor: currentAccent }" />
                  <span>{{ item }}</span>
                </li>
              </ul>
              <p v-else class="text-navy/20 italic text-sm">Not filled in</p>
            </div>

            <!-- Bottom left: What is important to me -->
            <div class="p-4 rounded-xl" :style="{ border: '1px solid ' + accentWithOpacity(0.15) }">
              <h3 class="font-semibold text-xs uppercase tracking-wider mb-3" :style="{ color: currentAccent }">
                What is important to me
              </h3>
              <ul v-if="getListData('important').length > 0" class="space-y-1">
                <li v-for="(item, i) in getListData('important')" :key="i" class="flex items-start gap-2 text-navy/80 text-sm">
                  <span class="w-1.5 h-1.5 rounded-full mt-1.5 shrink-0" :style="{ backgroundColor: currentAccent }" />
                  <span>{{ item }}</span>
                </li>
              </ul>
              <div v-if="getPhotoGallery('important-photos').length > 0" class="flex flex-wrap gap-2 mt-3">
                <div v-for="(photo, i) in getPhotoGallery('important-photos')" :key="i"
                     class="w-14 h-14 rounded-lg overflow-hidden">
                  <img :src="photo" class="w-full h-full object-cover" alt="" />
                </div>
              </div>
              <p v-if="getListData('important').length === 0 && getPhotoGallery('important-photos').length === 0" class="text-navy/20 italic text-sm">Not filled in</p>
            </div>

            <!-- Bottom right: How to support me well -->
            <div class="p-4 rounded-xl" :style="{ border: '1px solid ' + accentWithOpacity(0.15) }">
              <h3 class="font-semibold text-xs uppercase tracking-wider mb-3" :style="{ color: currentAccent }">
                How to support me well
              </h3>
              <ul v-if="getListData('support').length > 0" class="space-y-1">
                <li v-for="(item, i) in getListData('support')" :key="i" class="flex items-start gap-2 text-navy/80 text-sm">
                  <span class="w-1.5 h-1.5 rounded-full mt-1.5 shrink-0" :style="{ backgroundColor: currentAccent }" />
                  <span>{{ item }}</span>
                </li>
              </ul>
              <div v-if="getPhotoGallery('support-photos').length > 0" class="flex flex-wrap gap-2 mt-3">
                <div v-for="(photo, i) in getPhotoGallery('support-photos')" :key="i"
                     class="w-14 h-14 rounded-lg overflow-hidden">
                  <img :src="photo" class="w-full h-full object-cover" alt="" />
                </div>
              </div>
              <p v-if="getListData('support').length === 0 && getPhotoGallery('support-photos').length === 0" class="text-navy/20 italic text-sm">Not filled in</p>
            </div>
          </div>
        </div>

        <!-- ==================== MY PEOPLE: Quadrant grid ==================== -->
        <div v-else-if="isMyPeople" class="px-6 py-4">
          <div class="relative mx-auto grid grid-cols-2 grid-rows-2 gap-3" style="max-width: 640px;">
            <div v-for="quadrant in myPeopleQuadrants" :key="quadrant.fieldId"
                 class="rounded-xl p-4"
                 :style="{ border: '2px solid ' + quadrant.colour, backgroundColor: quadrant.colour + '0F', minHeight: '170px' }">
              <h3 class="font-semibold text-xs uppercase tracking-wider mb-3" :style="{ color: quadrant.colour }">
                {{ quadrant.label }}
              </h3>
              <ul v-if="getListWithPhotoData(quadrant.fieldId).length > 0" class="space-y-2">
                <li v-for="(person, i) in getListWithPhotoData(quadrant.fieldId)" :key="i" class="flex items-center gap-2">
                  <div v-if="person.photo" class="w-8 h-8 rounded-full overflow-hidden shrink-0 border" :style="{ borderColor: quadrant.colour }">
                    <img :src="person.photo" class="w-full h-full object-cover" alt="" />
                  </div>
                  <div v-else class="w-8 h-8 rounded-full shrink-0 flex items-center justify-center text-white text-xs font-semibold"
                       :style="{ backgroundColor: quadrant.colour }">
                    {{ (person.text.charAt(0) || '?').toUpperCase() }}
                  </div>
                  <span class="text-navy/80 text-sm">{{ person.text }}</span>
                </li>
              </ul>
              <p v-else class="text-navy/20 italic text-sm">Not filled in</p>
            </div>

            <!-- Centre: Me -->
            <div class="absolute flex items-center justify-center rounded-full bg-white font-bold overflow-hidden"
                 style="left: 50%; top: 50%; transform: translate(-50%, -50%); z-index: 10; width: 56px; height: 56px; border: 2.5px solid #72B9CF; color: #72B9CF; font-size: 13px;">
              <img v-if="getTextData('me-photo')" :src="getTextData('me-photo')" class="w-full h-full object-cover" alt="Me" />
              <span v-else>Me</span>
            </div>
          </div>
        </div>

        <!-- ==================== MY DIRECTION: PATH diagram ==================== -->
        <div v-else-if="isMyDirection" class="px-4 sm:px-6 py-6">
          <div class="grid items-stretch" style="min-height: 340px; grid-template-columns: repeat(6, minmax(0, 1fr)) 84px 84px; gap: 0;">

            <!-- 5-column table -->
            <div v-for="(col, i) in myDirectionColumns" :key="col.fieldId"
                 class="flex flex-col px-2 py-3 min-w-0"
                 :style="{
                   borderTop: '2px solid ' + currentAccent, borderBottom: '2px solid ' + currentAccent,
                   borderLeft: i === 0 ? '2px solid ' + currentAccent : '1.5px solid ' + accentWithOpacity(0.3),
                   borderRadius: i === 0 ? '12px 0 0 12px' : '0',
                 }">
              <p class="text-[11px] font-semibold text-navy text-center mb-2 leading-snug">{{ col.question }}</p>
              <ul v-if="getListData(col.fieldId).length > 0" class="space-y-1 flex-1">
                <li v-for="(item, idx) in getListData(col.fieldId)" :key="idx" class="text-[11px] text-navy/80 flex items-start gap-1">
                  <span class="w-1 h-1 rounded-full mt-1 shrink-0" :style="{ backgroundColor: currentAccent }" />
                  <span class="break-words">{{ item }}</span>
                </li>
              </ul>
              <p v-else class="text-navy/20 italic text-[11px] text-center">Not filled in</p>
            </div>

            <!-- Chevron: three months (plain box for now) -->
            <div class="flex flex-col px-2 py-3 min-w-0"
                 :style="{
                   borderTop: '2px solid ' + currentAccent, borderBottom: '2px solid ' + currentAccent,
                   borderLeft: '1.5px solid ' + accentWithOpacity(0.3),
                 }">
              <p class="text-[11px] font-semibold text-navy text-center mb-2 leading-snug">What can we do in the next three months?</p>
              <ul v-if="getListData('three-months').length > 0" class="space-y-1 flex-1">
                <li v-for="(item, idx) in getListData('three-months')" :key="idx" class="text-[11px] text-navy/80 flex items-start gap-1">
                  <span class="w-1 h-1 rounded-full mt-1 shrink-0" :style="{ backgroundColor: currentAccent }" />
                  <span class="break-words">{{ item }}</span>
                </li>
              </ul>
              <p v-else class="text-navy/20 italic text-[11px] text-center">Not filled in</p>
            </div>

            <!-- Goals pill -->
            <div class="flex flex-col items-center px-2 min-w-0">
              <div class="flex-1 w-full flex flex-col items-center px-2 py-4 min-w-0" style="border-radius: 9999px;"
                   :style="{ border: '2px solid ' + currentAccent }">
                <span class="font-semibold text-xs mb-1" :style="{ color: currentAccent }">Goals</span>
                <ul v-if="getListData('goals').length > 0" class="space-y-1">
                  <li v-for="(item, idx) in getListData('goals')" :key="idx" class="text-[11px] text-navy/80 text-center break-words">{{ item }}</li>
                </ul>
                <p v-else class="text-navy/20 italic text-[11px]">Not filled in</p>
              </div>
            </div>

            <!-- Dream pill -->
            <div class="flex flex-col items-center px-2 min-w-0">
              <div class="flex-1 w-full flex flex-col items-center justify-center px-2 py-4 min-w-0" style="border-radius: 9999px;"
                   :style="{ border: '2px solid ' + currentAccent }">
                <span class="font-semibold text-xs mb-1 flex items-center gap-1" :style="{ color: currentAccent }">
                  Dream
                  <span :style="{ color: currentAccent }">&#9733;</span>
                </span>
                <p class="text-[11px] text-navy/80 text-center whitespace-pre-line break-words">{{ getTextData('dream') || 'Not filled in' }}</p>
              </div>
            </div>

          </div>
        </div>

        <!-- ==================== MY STORY: Vertical story box + 3 columns of two ==================== -->
        <div v-else-if="isMyStory" class="px-4 sm:px-6 py-6">
          <div class="grid gap-3" style="grid-template-columns: 0.8fr repeat(3, minmax(0, 1fr)); grid-template-rows: 1fr 1fr; min-height: 460px;">

            <!-- My Story: vertical box spanning both rows -->
            <div class="rounded-xl p-4 min-w-0" style="grid-column: 1; grid-row: 1 / span 2; border: 2px solid #CF8872; background-color: rgba(207,136,114,0.06);">
              <h3 class="font-semibold text-xs uppercase tracking-wider mb-3" style="color: #CF8872;">My Story</h3>
              <ul v-if="getListData('story').length > 0" class="space-y-1.5">
                <li v-for="(item, i) in getListData('story')" :key="i" class="flex items-start gap-2 text-navy/80 text-sm">
                  <span class="w-1.5 h-1.5 rounded-full mt-1.5 shrink-0" style="background-color: #CF8872;" />
                  {{ item }}
                </li>
              </ul>
              <p v-else class="text-navy/20 italic text-sm">Not filled in</p>
            </div>

            <!-- My Dreams -->
            <div class="rounded-xl p-4 min-w-0" style="grid-column: 2; grid-row: 1;"
                 :style="{ border: '2px solid ' + myStoryQuadrants[0].colour, backgroundColor: myStoryQuadrants[0].colour + '0F' }">
              <h3 class="font-semibold text-xs uppercase tracking-wider mb-3" :style="{ color: myStoryQuadrants[0].colour }">{{ myStoryQuadrants[0].label }}</h3>
              <p v-if="getTextData('dreams')" class="text-sm text-navy/80 whitespace-pre-line">{{ getTextData('dreams') }}</p>
              <p v-else class="text-navy/20 italic text-sm">Not filled in</p>
            </div>

            <!-- My Nightmares -->
            <div class="rounded-xl p-4 min-w-0" style="grid-column: 2; grid-row: 2;"
                 :style="{ border: '2px solid ' + myStoryQuadrants[1].colour, backgroundColor: myStoryQuadrants[1].colour + '0F' }">
              <h3 class="font-semibold text-xs uppercase tracking-wider mb-3" :style="{ color: myStoryQuadrants[1].colour }">{{ myStoryQuadrants[1].label }}</h3>
              <p v-if="getTextData('nightmares')" class="text-sm text-navy/80 whitespace-pre-line">{{ getTextData('nightmares') }}</p>
              <p v-else class="text-navy/20 italic text-sm">Not filled in</p>
            </div>

            <!-- About Me -->
            <div class="rounded-xl p-4 min-w-0" style="grid-column: 3; grid-row: 1;"
                 :style="{ border: '2px solid ' + myStoryQuadrants[2].colour, backgroundColor: myStoryQuadrants[2].colour + '0F' }">
              <h3 class="font-semibold text-xs uppercase tracking-wider mb-3" :style="{ color: myStoryQuadrants[2].colour }">{{ myStoryQuadrants[2].label }}</h3>
              <ul v-if="getListData('about').length > 0" class="space-y-1.5">
                <li v-for="(item, i) in getListData('about')" :key="i" class="flex items-start gap-2 text-navy/80 text-sm">
                  <span class="w-1.5 h-1.5 rounded-full mt-1.5 shrink-0" :style="{ backgroundColor: myStoryQuadrants[2].colour }" />
                  {{ item }}
                </li>
              </ul>
              <p v-else class="text-navy/20 italic text-sm">Not filled in</p>
            </div>

            <!-- My Gifts -->
            <div class="rounded-xl p-4 min-w-0" style="grid-column: 3; grid-row: 2;"
                 :style="{ border: '2px solid ' + myStoryQuadrants[3].colour, backgroundColor: myStoryQuadrants[3].colour + '0F' }">
              <h3 class="font-semibold text-xs uppercase tracking-wider mb-3" :style="{ color: myStoryQuadrants[3].colour }">{{ myStoryQuadrants[3].label }}</h3>
              <ul v-if="getListData('gifts').length > 0" class="space-y-1.5">
                <li v-for="(item, i) in getListData('gifts')" :key="i" class="flex items-start gap-2 text-navy/80 text-sm">
                  <span class="w-1.5 h-1.5 rounded-full mt-1.5 shrink-0" :style="{ backgroundColor: myStoryQuadrants[3].colour }" />
                  {{ item }}
                </li>
              </ul>
              <p v-else class="text-navy/20 italic text-sm">Not filled in</p>
            </div>

            <!-- To Support Me -->
            <div class="rounded-xl p-4 min-w-0" style="grid-column: 4; grid-row: 1;"
                 :style="{ border: '2px solid ' + myStoryQuadrants[4].colour, backgroundColor: myStoryQuadrants[4].colour + '0F' }">
              <h3 class="font-semibold text-xs uppercase tracking-wider mb-3" :style="{ color: myStoryQuadrants[4].colour }">{{ myStoryQuadrants[4].label }}</h3>
              <ul v-if="getListData('support').length > 0" class="space-y-1.5">
                <li v-for="(item, i) in getListData('support')" :key="i" class="flex items-start gap-2 text-navy/80 text-sm">
                  <span class="w-1.5 h-1.5 rounded-full mt-1.5 shrink-0" :style="{ backgroundColor: myStoryQuadrants[4].colour }" />
                  {{ item }}
                </li>
              </ul>
              <p v-else class="text-navy/20 italic text-sm">Not filled in</p>
            </div>

            <!-- Action Plan -->
            <div class="rounded-xl p-4 min-w-0" style="grid-column: 4; grid-row: 2; border: 2px solid #161F38; background-color: rgba(22,31,56,0.04);">
              <h3 class="font-semibold text-xs uppercase tracking-wider mb-3" style="color: #161F38;">Action Plan</h3>
              <ul v-if="getListData('action-plan').length > 0" class="space-y-1.5">
                <li v-for="(item, i) in getListData('action-plan')" :key="i" class="flex items-start gap-2 text-navy/80 text-sm">
                  <span class="w-1.5 h-1.5 rounded-full mt-1.5 shrink-0" style="background-color: #161F38;" />
                  {{ item }}
                </li>
              </ul>
              <p v-else class="text-navy/20 italic text-sm">Not filled in</p>
            </div>

          </div>
        </div>

        <!-- ==================== BEST/WORST DAY: Two columns + action arrow ==================== -->
        <div v-else-if="isBestWorstDay" class="p-5">
          <!-- Person photo -->
          <div v-if="getPhotoGallery('person-photo').length > 0" class="flex flex-wrap gap-2 mb-4">
            <div v-for="(photo, i) in getPhotoGallery('person-photo')" :key="i"
                 class="w-16 h-16 rounded-full overflow-hidden border-2" :style="{ borderColor: accentWithOpacity(0.3) }">
              <img :src="photo" class="w-full h-full object-cover" alt="" />
            </div>
          </div>

          <!-- Two columns: Best day | Worst day -->
          <div class="grid grid-cols-2 gap-3 mb-3">
            <!-- Left: My Best Day -->
            <div class="p-4 rounded-xl" :style="{ border: '1px solid ' + accentWithOpacity(0.15) }">
              <div class="flex items-center gap-2 mb-3">
                <svg class="w-5 h-5 shrink-0" viewBox="0 0 28 28" fill="none">
                  <circle cx="14" cy="14" r="6" :fill="currentAccent" />
                  <g :stroke="currentAccent" stroke-width="2" stroke-linecap="round">
                    <line x1="14" y1="2" x2="14" y2="5" />
                    <line x1="14" y1="23" x2="14" y2="26" />
                    <line x1="2" y1="14" x2="5" y2="14" />
                    <line x1="23" y1="14" x2="26" y2="14" />
                    <line x1="5.5" y1="5.5" x2="7.6" y2="7.6" />
                    <line x1="20.4" y1="20.4" x2="22.5" y2="22.5" />
                    <line x1="5.5" y1="22.5" x2="7.6" y2="20.4" />
                    <line x1="20.4" y1="7.6" x2="22.5" y2="5.5" />
                  </g>
                </svg>
                <h3 class="font-semibold text-xs uppercase tracking-wider" :style="{ color: currentAccent }">My best day</h3>
              </div>
              <ul v-if="getListData('best').length > 0" class="space-y-1">
                <li v-for="(item, i) in getListData('best')" :key="i" class="flex items-start gap-2 text-navy/80 text-sm">
                  <span class="w-1.5 h-1.5 rounded-full mt-1.5 shrink-0" :style="{ backgroundColor: currentAccent }" />
                  <span>{{ item }}</span>
                </li>
              </ul>
              <div v-if="getPhotoGallery('best-photos').length > 0" class="flex flex-wrap gap-2 mt-3">
                <div v-for="(photo, i) in getPhotoGallery('best-photos')" :key="i"
                     class="w-16 h-16 rounded-lg overflow-hidden">
                  <img :src="photo" class="w-full h-full object-cover" alt="" />
                </div>
              </div>
              <p v-if="getListData('best').length === 0 && getPhotoGallery('best-photos').length === 0" class="text-navy/20 italic text-sm">Not filled in</p>
            </div>

            <!-- Right: My Worst Day -->
            <div class="p-4 rounded-xl" :style="{ border: '1px solid ' + accentWithOpacity(0.15) }">
              <div class="flex items-center gap-2 mb-3">
                <svg class="w-5 h-5 shrink-0" viewBox="0 0 28 28" fill="none">
                  <path d="M8 20h12a5 5 0 10-1.2-9.9A7 7 0 005.5 14.3 4 4 0 008 20z" :fill="accentWithOpacity(0.35)" :stroke="currentAccent" stroke-width="1.5" />
                </svg>
                <h3 class="font-semibold text-xs uppercase tracking-wider" :style="{ color: currentAccent }">My worst day</h3>
              </div>
              <ul v-if="getListData('worst').length > 0" class="space-y-1">
                <li v-for="(item, i) in getListData('worst')" :key="i" class="flex items-start gap-2 text-navy/80 text-sm">
                  <span class="w-1.5 h-1.5 rounded-full mt-1.5 shrink-0" :style="{ backgroundColor: currentAccent }" />
                  <span>{{ item }}</span>
                </li>
              </ul>
              <div v-if="getPhotoGallery('worst-photos').length > 0" class="flex flex-wrap gap-2 mt-3">
                <div v-for="(photo, i) in getPhotoGallery('worst-photos')" :key="i"
                     class="w-16 h-16 rounded-lg overflow-hidden">
                  <img :src="photo" class="w-full h-full object-cover" alt="" />
                </div>
              </div>
              <p v-if="getListData('worst').length === 0 && getPhotoGallery('worst-photos').length === 0" class="text-navy/20 italic text-sm">Not filled in</p>
            </div>
          </div>

          <!-- Action section with arrow -->
          <div class="flex items-stretch">
            <div class="flex-1 p-4" :style="{ border: '1px solid ' + accentWithOpacity(0.15), borderRight: 'none', borderRadius: '12px 0 0 12px' }">
              <h3 class="font-semibold text-xs uppercase tracking-wider mb-3" :style="{ color: currentAccent }">
                What will it take to have more good days and fewer bad days
              </h3>
              <ul v-if="getListData('action').length > 0" class="space-y-1">
                <li v-for="(item, i) in getListData('action')" :key="i" class="flex items-start gap-2 text-navy/80 text-sm">
                  <span class="w-1.5 h-1.5 rounded-full mt-1.5 shrink-0" :style="{ backgroundColor: currentAccent }" />
                  <span>{{ item }}</span>
                </li>
              </ul>
              <div v-if="getPhotoGallery('action-photos').length > 0" class="flex flex-wrap gap-2 mt-3">
                <div v-for="(photo, i) in getPhotoGallery('action-photos')" :key="i"
                     class="w-14 h-14 rounded-lg overflow-hidden">
                  <img :src="photo" class="w-full h-full object-cover" alt="" />
                </div>
              </div>
              <p v-if="getListData('action').length === 0 && getPhotoGallery('action-photos').length === 0" class="text-navy/20 italic text-sm">Not filled in</p>
            </div>
            <div class="shrink-0 self-stretch flex" style="width: 36px;">
              <svg class="w-full h-full" viewBox="0 0 36 100" preserveAspectRatio="none">
                <polygon points="0,0 36,50 0,100" :fill="accentWithOpacity(0.06)" />
                <line x1="0" y1="0" x2="36" y2="50" :stroke="accentWithOpacity(0.15)" stroke-width="1" />
                <line x1="36" y1="50" x2="0" y2="100" :stroke="accentWithOpacity(0.15)" stroke-width="1" />
              </svg>
            </div>
          </div>
        </div>

        <!-- ==================== WHAT MATTERS & WHAT HELPS: Two side-by-side columns ==================== -->
        <div v-else-if="isWhatMatters" class="p-5">
          <!-- Person photo -->
          <div v-if="getPhotoGallery('person-photo').length > 0" class="flex flex-wrap gap-2 mb-3">
            <div v-for="(photo, i) in getPhotoGallery('person-photo')" :key="i"
                 class="w-14 h-14 rounded-full overflow-hidden border-2" :style="{ borderColor: accentWithOpacity(0.3) }">
              <img :src="photo" class="w-full h-full object-cover" alt="" />
            </div>
          </div>

          <!-- Two columns -->
          <div class="grid grid-cols-2 gap-3" style="min-height: 420px;">
            <!-- Left: What matters -->
            <div class="p-5 rounded-xl flex flex-col" :style="{ border: '1.5px solid ' + accentWithOpacity(0.2) }">
              <h3 class="font-semibold text-xs uppercase tracking-wider mb-4" :style="{ color: currentAccent }">What matters to me</h3>
              <ul v-if="getListData('matters').length > 0" class="space-y-1.5">
                <li v-for="(item, i) in getListData('matters')" :key="i" class="flex items-start gap-2 text-navy/80 text-sm">
                  <span class="w-1.5 h-1.5 rounded-full mt-1.5 shrink-0" :style="{ backgroundColor: currentAccent }" />
                  <span>{{ item }}</span>
                </li>
              </ul>
              <div v-if="getPhotoGallery('matters-photos').length > 0" class="flex flex-wrap gap-2 mt-3">
                <div v-for="(photo, i) in getPhotoGallery('matters-photos')" :key="i" class="w-14 h-14 rounded-lg overflow-hidden">
                  <img :src="photo" class="w-full h-full object-cover" alt="" />
                </div>
              </div>
              <p v-if="getListData('matters').length === 0 && getPhotoGallery('matters-photos').length === 0" class="text-navy/20 italic text-sm">Not filled in</p>
            </div>

            <!-- Right: What helps -->
            <div class="p-5 rounded-xl flex flex-col" :style="{ border: '1.5px solid ' + accentWithOpacity(0.2) }">
              <h3 class="font-semibold text-xs uppercase tracking-wider mb-4" :style="{ color: currentAccent }">What helps me stay well</h3>
              <ul v-if="getListData('helps').length > 0" class="space-y-1.5">
                <li v-for="(item, i) in getListData('helps')" :key="i" class="flex items-start gap-2 text-navy/80 text-sm">
                  <span class="w-1.5 h-1.5 rounded-full mt-1.5 shrink-0" :style="{ backgroundColor: currentAccent }" />
                  <span>{{ item }}</span>
                </li>
              </ul>
              <div v-if="getPhotoGallery('helps-photos').length > 0" class="flex flex-wrap gap-2 mt-3">
                <div v-for="(photo, i) in getPhotoGallery('helps-photos')" :key="i" class="w-14 h-14 rounded-lg overflow-hidden">
                  <img :src="photo" class="w-full h-full object-cover" alt="" />
                </div>
              </div>
              <p v-if="getListData('helps').length === 0 && getPhotoGallery('helps-photos').length === 0" class="text-navy/20 italic text-sm">Not filled in</p>
            </div>
          </div>
        </div>

        <!-- ==================== WHAT'S WORKING: Table grid + arrow ==================== -->
        <div v-else-if="isWhatsWorking" class="p-5">
          <!-- Table -->
          <div class="rounded-xl overflow-hidden" :style="{ border: '1.5px solid ' + accentWithOpacity(0.2) }">
            <!-- Header row -->
            <div class="grid grid-cols-2">
              <div class="p-3 flex items-center gap-2" :style="{ backgroundColor: accentWithOpacity(0.1), borderRight: '1px solid ' + accentWithOpacity(0.2) }">
                <svg class="w-4 h-4 shrink-0" viewBox="0 0 24 24" fill="currentColor" :style="{ color: currentAccent }">
                  <path d="M7.493 18.75c-.425 0-.82-.236-.975-.632A7.48 7.48 0 016 15.375c0-1.75.599-3.358 1.602-4.634.151-.192.373-.309.6-.397.473-.183.89-.514 1.212-.924a9.042 9.042 0 012.861-2.4c.723-.384 1.35-.956 1.653-1.715a4.498 4.498 0 00.322-1.672V3a.75.75 0 01.75-.75 2.25 2.25 0 012.25 2.25c0 1.152-.26 2.243-.723 3.218-.266.558.107 1.282.725 1.282h3.126c1.026 0 1.945.694 2.054 1.715.045.422.068.85.068 1.285a11.952 11.952 0 01-2.649 7.521c-.388.482-.987.729-1.605.729H14.23c-.483 0-.964-.078-1.423-.23l-3.114-1.04a4.501 4.501 0 00-1.423-.23h-.777zM2.331 10.977a11.969 11.969 0 00-.831 4.398 12 12 0 00.52 3.507c.26.85 1.084 1.368 1.973 1.368H4.9c.445 0 .72-.498.523-.898a8.963 8.963 0 01-.924-3.977c0-1.708.476-3.305 1.302-4.666.245-.403-.028-.959-.5-.959H4.25c-.832 0-1.612.453-1.918 1.227z" />
                </svg>
                <span class="font-semibold text-xs uppercase tracking-wider" :style="{ color: currentAccent }">What's working</span>
              </div>
              <div class="p-3 flex items-center gap-2" :style="{ backgroundColor: accentWithOpacity(0.04) }">
                <svg class="w-4 h-4 shrink-0" viewBox="0 0 24 24" fill="currentColor" :style="{ color: currentAccent }">
                  <path d="M15.73 5.25h1.035A7.465 7.465 0 0118 9.375a7.465 7.465 0 01-1.235 4.125h-.148c-.806 0-1.534.446-2.031 1.08a9.04 9.04 0 01-2.861 2.4c-.723.384-1.35.956-1.653 1.715a4.498 4.498 0 00-.322 1.672V21a.75.75 0 01-.75.75 2.25 2.25 0 01-2.25-2.25c0-1.152.26-2.243.723-3.218C7.74 15.724 7.366 15 6.748 15H3.622c-1.026 0-1.945-.694-2.054-1.715A12.134 12.134 0 011.5 12c0-2.848.992-5.464 2.649-7.521.388-.482.987-.729 1.605-.729H9.77c.483 0 .964.078 1.423.23l3.114 1.04a4.501 4.501 0 001.423.23zM21.669 13.023c.536-1.362.831-2.845.831-4.398 0-1.22-.182-2.398-.52-3.507-.26-.85-1.084-1.368-1.973-1.368H19.1c-.445 0-.72.498-.523.898.591 1.2.923 2.55.923 3.977a8.959 8.959 0 01-1.302 4.666c-.245.403.028.959.5.959h1.053c.832 0 1.612-.453 1.918-1.227z" />
                </svg>
                <span class="font-semibold text-xs uppercase tracking-wider" :style="{ color: currentAccent }">What's not working</span>
              </div>
            </div>

            <!-- Me -->
            <div :style="{ borderTop: '1px solid ' + accentWithOpacity(0.15) }">
              <div class="px-3 py-2 text-center" :style="{ backgroundColor: accentWithOpacity(0.06), borderBottom: '1px solid ' + accentWithOpacity(0.12) }">
                <span class="text-xs font-semibold uppercase tracking-wider" :style="{ color: currentAccent }">Me</span>
              </div>
              <div class="grid grid-cols-2" style="min-height: 72px;">
                <div class="p-3" :style="{ borderRight: '1px solid ' + accentWithOpacity(0.15) }">
                  <ul v-if="getListData('person-working').length > 0" class="space-y-1">
                    <li v-for="(item, i) in getListData('person-working')" :key="i" class="flex items-start gap-2 text-navy/80 text-sm">
                      <span class="w-1.5 h-1.5 rounded-full mt-1.5 shrink-0" :style="{ backgroundColor: currentAccent }" />
                      <span>{{ item }}</span>
                    </li>
                  </ul>
                </div>
                <div class="p-3">
                  <ul v-if="getListData('person-not-working').length > 0" class="space-y-1">
                    <li v-for="(item, i) in getListData('person-not-working')" :key="i" class="flex items-start gap-2 text-navy/80 text-sm">
                      <span class="w-1.5 h-1.5 rounded-full mt-1.5 shrink-0" :style="{ backgroundColor: accentWithOpacity(0.4) }" />
                      <span>{{ item }}</span>
                    </li>
                  </ul>
                </div>
              </div>
            </div>

            <!-- Family & Friends -->
            <div :style="{ borderTop: '1px solid ' + accentWithOpacity(0.15) }">
              <div class="px-3 py-2 text-center" :style="{ backgroundColor: accentWithOpacity(0.06), borderBottom: '1px solid ' + accentWithOpacity(0.12) }">
                <span class="text-xs font-semibold uppercase tracking-wider" :style="{ color: currentAccent }">Family &amp; Friends</span>
              </div>
              <div class="grid grid-cols-2" style="min-height: 72px;">
                <div class="p-3" :style="{ borderRight: '1px solid ' + accentWithOpacity(0.15) }">
                  <ul v-if="getListData('family-working').length > 0" class="space-y-1">
                    <li v-for="(item, i) in getListData('family-working')" :key="i" class="flex items-start gap-2 text-navy/80 text-sm">
                      <span class="w-1.5 h-1.5 rounded-full mt-1.5 shrink-0" :style="{ backgroundColor: currentAccent }" />
                      <span>{{ item }}</span>
                    </li>
                  </ul>
                </div>
                <div class="p-3">
                  <ul v-if="getListData('family-not-working').length > 0" class="space-y-1">
                    <li v-for="(item, i) in getListData('family-not-working')" :key="i" class="flex items-start gap-2 text-navy/80 text-sm">
                      <span class="w-1.5 h-1.5 rounded-full mt-1.5 shrink-0" :style="{ backgroundColor: accentWithOpacity(0.4) }" />
                      <span>{{ item }}</span>
                    </li>
                  </ul>
                </div>
              </div>
            </div>

            <!-- Staff -->
            <div :style="{ borderTop: '1px solid ' + accentWithOpacity(0.15) }">
              <div class="px-3 py-2 text-center" :style="{ backgroundColor: accentWithOpacity(0.06), borderBottom: '1px solid ' + accentWithOpacity(0.12) }">
                <span class="text-xs font-semibold uppercase tracking-wider" :style="{ color: currentAccent }">Staff</span>
              </div>
              <div class="grid grid-cols-2" style="min-height: 72px;">
                <div class="p-3" :style="{ borderRight: '1px solid ' + accentWithOpacity(0.15) }">
                  <ul v-if="getListData('staff-working').length > 0" class="space-y-1">
                    <li v-for="(item, i) in getListData('staff-working')" :key="i" class="flex items-start gap-2 text-navy/80 text-sm">
                      <span class="w-1.5 h-1.5 rounded-full mt-1.5 shrink-0" :style="{ backgroundColor: currentAccent }" />
                      <span>{{ item }}</span>
                    </li>
                  </ul>
                </div>
                <div class="p-3">
                  <ul v-if="getListData('staff-not-working').length > 0" class="space-y-1">
                    <li v-for="(item, i) in getListData('staff-not-working')" :key="i" class="flex items-start gap-2 text-navy/80 text-sm">
                      <span class="w-1.5 h-1.5 rounded-full mt-1.5 shrink-0" :style="{ backgroundColor: accentWithOpacity(0.4) }" />
                      <span>{{ item }}</span>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>

          <!-- Arrow: What needs to happen next? -->
          <div class="flex items-stretch mt-3">
            <div class="flex-1 p-4" :style="{ border: '1.5px solid ' + accentWithOpacity(0.2), borderRight: 'none', borderRadius: '12px 0 0 12px' }">
              <h3 class="font-semibold text-xs uppercase tracking-wider mb-3" :style="{ color: currentAccent }">What needs to happen next?</h3>
              <ul v-if="getListData('next-steps').length > 0" class="space-y-1">
                <li v-for="(item, i) in getListData('next-steps')" :key="i" class="flex items-start gap-2 text-navy/80 text-sm">
                  <span class="w-1.5 h-1.5 rounded-full mt-1.5 shrink-0" :style="{ backgroundColor: currentAccent }" />
                  <span>{{ item }}</span>
                </li>
              </ul>
              <p v-else class="text-navy/20 italic text-sm">Not filled in</p>
            </div>
            <div class="shrink-0 self-stretch flex" style="width: 36px;">
              <svg class="w-full h-full" viewBox="0 0 36 100" preserveAspectRatio="none">
                <polygon points="0,0 36,50 0,100" :fill="accentWithOpacity(0.08)" />
                <line x1="0" y1="0" x2="36" y2="50" :stroke="accentWithOpacity(0.2)" stroke-width="1.5" />
                <line x1="36" y1="50" x2="0" y2="100" :stroke="accentWithOpacity(0.2)" stroke-width="1.5" />
              </svg>
            </div>
          </div>
        </div>

        <!-- ==================== HOW I COMMUNICATE: Three-column layout ==================== -->
        <div v-else-if="isHowICommunicate" class="p-5">
          <div class="grid grid-cols-3 gap-3" style="min-height: 380px;">

            <!-- Column 1: What is happening? (Coral) -->
            <div class="rounded-xl flex flex-col overflow-hidden" style="border: 2px solid #CF8872;">
              <div class="px-3 py-2" style="background-color: rgba(207,136,114,0.12); border-bottom: 1.5px solid #CF8872;">
                <h3 class="font-semibold text-sm" style="color: #CF8872;">What is happening?</h3>
              </div>
              <div class="p-3 flex-1 space-y-4 text-sm text-navy/80">
                <template v-for="scenario in [
                  { label: 'When comfortable', id: 'happy-signs' },
                  { label: 'When uncomfortable', id: 'unhappy-signs' },
                  { label: 'When needing something', id: 'needs-signs' },
                ]" :key="scenario.id">
                  <div v-if="getListData(scenario.id).length > 0">
                    <p class="text-xs font-medium mb-1" style="color: rgba(207,136,114,0.7);">{{ scenario.label }}</p>
                    <ul class="space-y-0.5">
                      <li v-for="(item, i) in getListData(scenario.id)" :key="i">{{ item }}</li>
                    </ul>
                  </div>
                </template>
              </div>
            </div>

            <!-- Column 2: What we think it means (Purple) -->
            <div class="rounded-xl flex flex-col overflow-hidden" style="border: 2px solid #9B8AB8;">
              <div class="px-3 py-2" style="background-color: rgba(155,138,184,0.12); border-bottom: 1.5px solid #9B8AB8;">
                <h3 class="font-semibold text-sm" style="color: #9B8AB8;">What we think it means</h3>
              </div>
              <div class="p-3 flex-1 space-y-4 text-sm text-navy/80">
                <template v-for="scenario in [
                  { label: 'When comfortable', id: 'happy-meaning' },
                  { label: 'When uncomfortable', id: 'unhappy-meaning' },
                  { label: 'When needing something', id: 'needs-meaning' },
                ]" :key="scenario.id">
                  <div v-if="getTextData(scenario.id)">
                    <p class="text-xs font-medium mb-1" style="color: rgba(155,138,184,0.7);">{{ scenario.label }}</p>
                    <p class="whitespace-pre-line">{{ getTextData(scenario.id) }}</p>
                  </div>
                </template>
              </div>
            </div>

            <!-- Column 3: How to respond (Teal) -->
            <div class="rounded-xl flex flex-col overflow-hidden" style="border: 2px solid #72B9CF;">
              <div class="px-3 py-2" style="background-color: rgba(114,185,207,0.12); border-bottom: 1.5px solid #72B9CF;">
                <h3 class="font-semibold text-sm" style="color: #72B9CF;">How to respond</h3>
              </div>
              <div class="p-3 flex-1 space-y-4 text-sm text-navy/80">
                <template v-for="scenario in [
                  { label: 'When comfortable', id: 'happy-response' },
                  { label: 'When uncomfortable', id: 'unhappy-response' },
                  { label: 'When needing something', id: 'needs-response' },
                ]" :key="scenario.id">
                  <div v-if="getTextData(scenario.id)">
                    <p class="text-xs font-medium mb-1" style="color: rgba(114,185,207,0.7);">{{ scenario.label }}</p>
                    <p class="whitespace-pre-line">{{ getTextData(scenario.id) }}</p>
                  </div>
                </template>
              </div>
            </div>

          </div>
        </div>

        <!-- ==================== MY PERFECT WEEK: 7-day grid ==================== -->
        <div v-else-if="isMyPerfectWeek" class="p-4">
          <div class="grid" style="grid-template-columns: 72px repeat(7, 1fr); gap: 3px;">

            <!-- Header row -->
            <div />
            <div v-for="day in ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']" :key="day"
                 class="text-center font-semibold py-1.5 rounded text-xs tracking-wide"
                 :style="{ color: currentAccent, backgroundColor: accentWithOpacity(0.1) }">
              {{ day }}
            </div>

            <!-- Mornings row -->
            <div class="flex flex-col items-center justify-center gap-1 py-2 rounded"
                 :style="{ backgroundColor: accentWithOpacity(0.06) }">
              <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" :stroke="currentAccent" stroke-width="1.5" stroke-linecap="round">
                <path d="M5 13 A7 7 0 0 1 19 13" />
                <line x1="3" y1="13" x2="21" y2="13" />
                <line x1="4" y1="16.5" x2="20" y2="16.5" />
                <line x1="6.5" y1="20" x2="17.5" y2="20" />
                <line x1="12" y1="2" x2="12" y2="5.5" />
                <line x1="5.5" y1="5.5" x2="7.5" y2="7.5" />
                <line x1="18.5" y1="5.5" x2="16.5" y2="7.5" />
                <line x1="2.5" y1="10" x2="5" y2="11" />
                <line x1="21.5" y1="10" x2="19" y2="11" />
              </svg>
              <span class="font-semibold text-center leading-tight" style="font-size: 8px; text-transform: uppercase; letter-spacing: 0.05em;" :style="{ color: currentAccent }">Mornings</span>
            </div>
            <div v-for="day in ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']" :key="'m-' + day"
                 class="p-2 rounded text-xs text-navy/80 whitespace-pre-line"
                 :style="{ border: '1px solid ' + accentWithOpacity(0.2), minHeight: '90px' }">
              {{ getTextData(day + '-morning') }}
            </div>

            <!-- Afternoons row -->
            <div class="flex flex-col items-center justify-center gap-1 py-2 rounded"
                 :style="{ backgroundColor: accentWithOpacity(0.06) }">
              <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" :stroke="currentAccent" stroke-width="1.5" stroke-linecap="round">
                <circle cx="12" cy="12" r="4" />
                <line x1="12" y1="2" x2="12" y2="5" /><line x1="12" y1="19" x2="12" y2="22" />
                <line x1="2" y1="12" x2="5" y2="12" /><line x1="19" y1="12" x2="22" y2="12" />
                <line x1="4.9" y1="4.9" x2="7" y2="7" /><line x1="17" y1="17" x2="19.1" y2="19.1" />
                <line x1="4.9" y1="19.1" x2="7" y2="17" /><line x1="17" y1="7" x2="19.1" y2="4.9" />
              </svg>
              <span class="font-semibold text-center leading-tight" style="font-size: 8px; text-transform: uppercase; letter-spacing: 0.05em;" :style="{ color: currentAccent }">Afternoons</span>
            </div>
            <div v-for="day in ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']" :key="'a-' + day"
                 class="p-2 rounded text-xs text-navy/80 whitespace-pre-line"
                 :style="{ border: '1px solid ' + accentWithOpacity(0.2), minHeight: '90px' }">
              {{ getTextData(day + '-afternoon') }}
            </div>

            <!-- Evenings row -->
            <div class="flex flex-col items-center justify-center gap-1 py-2 rounded"
                 :style="{ backgroundColor: accentWithOpacity(0.06) }">
              <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" :stroke="currentAccent" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                <polygon points="12,2 15,9 22,9 16.5,13.5 18.5,21 12,16.5 5.5,21 7.5,13.5 2,9 9,9" :fill="currentAccent" fill-opacity="0.2" />
              </svg>
              <span class="font-semibold text-center leading-tight" style="font-size: 8px; text-transform: uppercase; letter-spacing: 0.05em;" :style="{ color: currentAccent }">Evenings</span>
            </div>
            <div v-for="day in ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']" :key="'e-' + day"
                 class="p-2 rounded text-xs text-navy/80 whitespace-pre-line"
                 :style="{ border: '1px solid ' + accentWithOpacity(0.2), minHeight: '90px' }">
              {{ getTextData(day + '-evening') }}
            </div>

          </div>
        </div>

        <!-- ==================== DEFAULT: Generic sections ==================== -->
        <div v-else class="px-8 py-6 space-y-6">
          <template v-for="s in tool.steps" :key="s.id">
            <template v-for="field in s.fields" :key="field.id">
              <template v-if="field.id !== 'name' && field.id !== 'photo' && field.id !== 'role'">
                <div v-if="field.type === 'photo-gallery' && getPhotoGallery(field.id).length > 0" class="border-b border-navy/5 pb-5 last:border-0">
                  <div class="flex flex-wrap gap-3">
                    <div v-for="(photo, i) in getPhotoGallery(field.id)" :key="i" class="w-24 h-24 rounded-xl overflow-hidden border-2" :style="{ borderColor: currentAccent + '30' }">
                      <img :src="photo" class="w-full h-full object-cover" alt="Photo" />
                    </div>
                  </div>
                </div>

                <div v-else-if="field.type !== 'photo-gallery'" class="border-b border-navy/5 pb-5 last:border-0">
                  <h3 class="font-semibold text-sm uppercase tracking-wider mb-3" :style="{ color: currentAccent }">{{ field.label }}</h3>

                  <ul v-if="field.type === 'list' && getListData(field.id).length > 0" class="space-y-2">
                    <li v-for="(item, i) in getListData(field.id)" :key="i" class="flex items-start gap-3 text-navy/80">
                      <span class="w-2 h-2 rounded-full mt-2 shrink-0" :style="{ backgroundColor: currentAccent }" />
                      <span>{{ item }}</span>
                    </li>
                  </ul>

                  <p v-else-if="(field.type === 'text' || field.type === 'textarea') && getTextData(field.id)" class="text-navy/80 whitespace-pre-line">{{ getTextData(field.id) }}</p>

                  <p v-else class="text-navy/20 italic text-sm">Not filled in</p>
                </div>
              </template>
            </template>
          </template>

          <div v-if="getTextData('role')" class="border-b border-navy/5 pb-5">
            <h3 class="font-semibold text-sm uppercase tracking-wider mb-3" :style="{ color: currentAccent }">Role</h3>
            <p class="text-navy/80">{{ getTextData('role') }}</p>
          </div>
        </div>

        <div class="px-8 py-4 text-center text-xs" :style="{ color: currentAccent + '60' }">Created with Centred by Forza7</div>
      </div>
    </template>

    <div v-else class="text-center py-20 text-navy/30">Loading...</div>
  </div>
</template>
