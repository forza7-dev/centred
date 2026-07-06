export interface SavedEntry {
  id: string
  toolId: string
  label: string
  data: Record<string, string | string[]>
  createdAt: string
  updatedAt: string
}

let memoryStore: SavedEntry[] = []

function loadAll(): SavedEntry[] {
  if (import.meta.server) return []
  return [...memoryStore]
}

function saveAll(entries: SavedEntry[]) {
  if (import.meta.server) return
  memoryStore = [...entries]
}

function generateId(): string {
  return Date.now().toString(36) + Math.random().toString(36).slice(2, 7)
}

export function useToolData() {
  function getEntry(entryId: string): SavedEntry | null {
    return loadAll().find(e => e.id === entryId) ?? null
  }

  function createEntry(toolId: string): string {
    const entries = loadAll()
    const id = generateId()
    entries.push({
      id,
      toolId,
      label: '',
      data: {},
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    })
    saveAll(entries)
    return id
  }

  function saveField(entryId: string, fieldId: string, value: string | string[]) {
    const entries = loadAll()
    const entry = entries.find(e => e.id === entryId)
    if (!entry) return
    entry.data[fieldId] = value
    entry.updatedAt = new Date().toISOString()
    if (fieldId === 'name' && typeof value === 'string' && value.trim()) {
      entry.label = value.trim()
    }
    saveAll(entries)
  }

  function getFieldValue(entryId: string, fieldId: string): string | string[] {
    const entry = getEntry(entryId)
    if (!entry) return ''
    return entry.data[fieldId] ?? ''
  }

  function deleteEntry(entryId: string) {
    const entries = loadAll().filter(e => e.id !== entryId)
    saveAll(entries)
  }

  return {
    getEntry,
    createEntry,
    saveField,
    getFieldValue,
    deleteEntry,
  }
}
