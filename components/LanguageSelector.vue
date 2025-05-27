<template>
  <div class="select-none relative z-50">
    <button
      @click="toggleLanguageDropdown"
      class="group p-2 rounded-lg backdrop-blur-sm bg-white/5 border border-white/20 hover:bg-white/10 transition-all duration-300 transform hover:scale-105"
    >
      <Icon
        size="24"
        class="text-white group-hover:text-purple-200 transition-colors duration-300"
        :name="flagIcons[currentLocale]"
      />
    </button>

    <Transition name="dropdown">
      <div 
        ref="modal" 
        v-if="showLanguageDropdown" 
        class="absolute top-14 right-0 backdrop-blur-sm bg-white/10 border border-white/20 shadow-2xl rounded-2xl p-3 min-w-[200px] z-[9999]"
        style="pointer-events: auto;"
      >
        <div 
          v-for="(label, lang) in languages" 
          :key="lang" 
          @click="handleSetLocale(lang)" 
          class="group flex items-center justify-between p-3 rounded-xl hover:bg-white/10 cursor-pointer transition-all duration-300 transform hover:scale-105"
          :class="{ 'bg-gradient-to-r from-purple-500/20 to-pink-500/20': currentLocale === lang }"
        >
          <Icon 
            size="20" 
            :name="flagIcons[lang]" 
            class="group-hover:scale-110 transition-transform duration-300" 
          />
          <span 
            class="text-white font-medium group-hover:text-purple-200 transition-colors duration-300"
            :class="{ 'text-purple-200': currentLocale === lang }"
          >
            {{ label }}
          </span>
        </div>
      </div>
    </Transition>
  </div>
</template>

<script setup>
import { computed, ref } from 'vue';
import { onClickOutside } from '@vueuse/core'
const { gtag } = useGtag();

const { setLocale, locale } = useI18n();

const handleSetLocale = (lang) => {
  gtag("event", "set_locale", { lang });
  setLocale(lang);
  showLanguageDropdown.value = false; // Fechar dropdown após seleção
};

const showLanguageDropdown = ref(false);
const currentLocale = computed(() => locale.value);

const modal = ref(null);

onClickOutside(modal, event => {
  if (showLanguageDropdown.value) {
    toggleLanguageDropdown();
  }
});

const toggleLanguageDropdown = () => {
  showLanguageDropdown.value = !showLanguageDropdown.value;
};

const languages = {
  en: 'English',
  pt: 'Português',
  fr: 'Français',
  es: 'Español',
  de: 'Deutsch',
  it: 'Italiano',
  pl: 'Polski',
  ru: 'Русский',
  ar: 'العربية',
  zh: '中文',
  ja: '日本語',
  ko: '한국어',
};

const flagIcons = {
  en: 'cif:us',
  pt: 'cif:br',
  fr: 'cif:fr',
  es: 'cif:es',
  zh: 'cif:cn',
  ar: 'cif:sa',
  de: 'cif:de',
  ja: 'cif:jp',
  it: 'cif:it',
  ru: 'cif:ru',
  pl: 'cif:pl',
  ko: 'cif:kr',
};
</script>

<style scoped>
.dropdown-enter-active,
.dropdown-leave-active {
  transition: all 0.3s ease;
}

.dropdown-enter-from,
.dropdown-leave-to {
  opacity: 0;
  transform: translateY(-10px) scale(0.95);
}

.dropdown-enter-to,
.dropdown-leave-from {
  opacity: 1;
  transform: translateY(0) scale(1);
}

.backdrop-blur-sm {
  backdrop-filter: blur(8px);
}

/* Garantir que o modal seja sempre clicável */
.select-none {
  position: relative;
  isolation: isolate;
}

.select-none > .absolute {
  position: absolute !important;
  z-index: 9999 !important;
  pointer-events: auto !important;
}
</style>
