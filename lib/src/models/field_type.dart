/// Ported from `design-reference/app/composables/useTools.ts`'s
/// `ToolField.type` union. `listWithPhoto` is included even though the
/// prototype's TypeScript union omits it — `my-people` actually uses it and
/// both the fill and view pages handle it, so the omission there is a bug
/// in the prototype's type, not something to replicate.
enum FieldType { text, textarea, list, photo, photoGallery, listWithPhoto }
