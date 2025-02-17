<template>
  <div class="select-none relative">
    <Icon
      @click="toggleLanguageDropdown"
      size="30"
      class="hover:cursor-pointer"
      :name="flagIcons[currentLocale]"
    />

    <div ref="modal" v-if="showLanguageDropdown" class="absolute top-12 right-0 bg-white shadow-lg rounded-lg p-2">
      <div 
        v-for="(label, lang) in languages" 
        :key="lang" 
        @click="handleSetLocale(lang)" 
        class="flex items-center justify-between p-2 hover:bg-gray-100 cursor-pointer"
      >
        <Icon size="20" :name="flagIcons[lang]" />
        <span class="text-gray-900">{{ label }}</span>
      </div>
    </div>
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
