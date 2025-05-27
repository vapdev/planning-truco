// i18n.config.ts

import en from './locales/en'
import fr from './locales/fr'
import pt from './locales/pt'
import es from './locales/es'
import zh from './locales/zh'
import ar from './locales/ar'
import de from './locales/de'
import it from './locales/it'
import ja from './locales/ja'
import pl from './locales/pl'
import ru from './locales/ru'
import ko from './locales/ko'

export default defineI18nConfig(() => ({
  legacy: false,
  locale: 'en',
  messages: {
    en,
    fr,
    pt,
    es,
    zh,
    ar,
    de,
    it,
    ja,
    pl,
    ru,
    ko,
  }
}))