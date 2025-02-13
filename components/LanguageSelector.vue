<template>
  <div class="select-none relative">
    <Icon
      @click="toggleLanguageDropdown"
      size="30"
      class="hover:cursor-pointer"
      :name="flagIcons[currentLocale]"
      :color="isDarkMode ? 'white' : '#3f4146'"
    />

    <div v-if="showLanguageDropdown" class="absolute top-12 right-0 bg-white shadow-lg rounded-lg p-2">
      <div 
        v-for="(label, lang) in languages" 
        :key="lang" 
        @click="setLocale(lang)" 
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
import { useI18n } from 'vue-i18n';

const { setLocale, locale } = useI18n();
const showLanguageDropdown = ref(false);
const currentLocale = computed(() => locale.value);

const toggleLanguageDropdown = () => {
  showLanguageDropdown.value = !showLanguageDropdown.value;
};

const languages = {
  en: 'English',
  pt: 'Português',
  fr: 'Français',
  es: 'Español',
};

const flagIcons = {
  en: 'cif:us',
  pt: 'cif:br',
  fr: 'cif:fr',
  es: 'cif:es',
};
</script>
