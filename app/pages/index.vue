<script setup lang="ts">
const { tools } = useTools()
const { createEntry } = useToolData()
const router = useRouter()

const toolIcons: Record<string, string> = {
  user: 'M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z',
  balance: 'M3 6l3 1m0 0l-3 9a5.002 5.002 0 006.001 0M6 7l3 9M6 7l6-2m6 2l3-1m-3 1l-3 9a5.002 5.002 0 006.001 0M18 7l3 9m-3-9l-6-2m0-2v2m0 16V5m0 16H9m3 0h3',
  people: 'M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z',
  'sun-cloud': 'M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z',
  'check-cross': 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z',
  target: 'M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z',
  chat: 'M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z',
  calendar: 'M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z',
}

const colourMap: Record<string, string> = {
  teal: 'bg-teal/10 text-teal border-teal/20',
  coral: 'bg-coral/10 text-coral border-coral/20',
  navy: 'bg-navy/10 text-navy border-navy/20',
}

function startNew(toolId: string) {
  const entryId = createEntry(toolId)
  router.push(`/fill/${entryId}`)
}
</script>

<template>
  <div class="max-w-5xl mx-auto px-4 sm:px-6 py-8 sm:py-12">
    <div class="mb-10">
      <h1 class="text-3xl sm:text-4xl text-navy mb-3">Your planning tools</h1>
      <p class="text-navy/60 text-lg max-w-2xl">
        Pick a tool, fill in each section, and export a completed PDF.
        For your privacy, nothing is stored in the app.
      </p>
    </div>

    <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
      <div
        v-for="tool in tools"
        :key="tool.id"
        class="card flex flex-col"
      >
        <div class="flex items-start gap-4 mb-3">
          <div
            class="w-12 h-12 rounded-xl flex items-center justify-center shrink-0 border"
            :class="colourMap[tool.colour]"
          >
            <svg class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
              <path stroke-linecap="round" stroke-linejoin="round" :d="toolIcons[tool.icon]" />
            </svg>
          </div>
          <div class="flex-1 min-w-0">
            <h2 class="font-semibold text-navy text-lg leading-tight">
              {{ tool.name }}
            </h2>
            <p class="text-sm text-navy/50 mt-0.5">{{ tool.tagline }}</p>
          </div>
        </div>

        <p class="text-sm text-navy/60 flex-1 mb-4">{{ tool.description }}</p>

        <button
          class="btn-primary text-sm w-full mt-auto"
          @click="startNew(tool.id)"
        >
          <svg class="w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
          </svg>
          Start new
        </button>
      </div>
    </div>
  </div>
</template>
