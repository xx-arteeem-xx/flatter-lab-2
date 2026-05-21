# Changelog

Все значимые изменения в проекте фиксируются в этом файле.  
Формат основан на [Keep a Changelog](https://keepachangelog.com/ru/1.0.0/).

---

## [Unreleased]

---

## [1.0.0] — 2026-05-22

### Добавлено

**Приложение**
- Инициализирован Flutter-проект `flatter_lab_2` с поддержкой Android
- Реализованы три вкладки через `BottomNavigationBar` + `IndexedStack`:
  - **Профиль** — аватар, автовычисляемый возраст (дата рождения 06.10.2004), карточки ВКонтакте / Telegram / GitHub / учёба / работа, теги интересов, кнопка скачивания резюме PDF, кнопка «Нравится» с персистентным счётчиком
  - **Галерея** — `GridView.builder` (3 столбца, 30 фото picsum.photos), полноэкранный просмотр с зумом (`photo_view`)
  - **Контакты** — `ListView.builder` из 5 контактов, кнопка звонка через `tel:` URI

**Дизайн-система (EAM → Flutter)**
- `AppColors` — все цвета из EAM: тёмный фон `#080A11`, акцент `#50C8FF`, светлый фон `#F4F7FF`, акцент light `#173EAC`, семантические цвета
- `AppTheme` — `ThemeData.dark()` и `ThemeData.light()` с `ColorScheme`, стилями AppBar, BottomNavigationBar, Chip, Card, кнопок
- `GlassCard` — glassmorphism-виджет: `BackdropFilter` + blur в тёмной теме, plain card с тенью в светлой
- Шрифт **Nunito** через `google_fonts` (аналог Trebuchet MS из EAM)

**Переключатель темы**
- `ThemeNotifier extends ValueNotifier<ThemeMode>` — переключение + сохранение в `SharedPreferences`
- `ThemeToggleButton` в AppBar (иконка меняется вместе с темой)

**CI/CD**
- `.github/workflows/release.yml` — автосборка подписанного release APK при пуше в `main`
- APK подписывается keystore из GitHub Secret `KEYSTORE_BASE64`
- Каждая сборка создаёт GitHub Release с тегом `v1.0.{run_number}`
- Стабильный URL для скачивания: `.../releases/latest/download/app-release.apk`
- `flutter create . --platforms android` в CI генерирует бинарные файлы (gradle-wrapper.jar, mipmap иконки)

**Android**
- `android/app/build.gradle` с signing config через `key.properties`
- `android/settings.gradle` с новым Flutter 3.22+ pluginManagement подходом
- `AndroidManifest.xml` с `INTERNET` и `queries` для `url_launcher`, `open_filex`
- Gradle 8.6, AGP 8.3.1, Kotlin 1.9.22, JDK 17, minSdk 21, targetSdk 35
- Тёмный splash экран `#080A11` (EAM тема)

**Документация**
- `README.md` — описание проекта, APK badge, инструкции по установке и настройке CI
- `CHANGELOG.md` — этот файл
- `STUDY.md` — подробный учебный материал по Flutter, архитектуре, CI/CD
- `SKILL.md` — контекст для AI в будущих итерациях

### Зависимости

```yaml
google_fonts: ^6.2.1
cached_network_image: ^3.3.1
url_launcher: ^6.3.0
open_filex: ^4.4.1
path_provider: ^2.1.3
shared_preferences: ^2.2.3
photo_view: ^0.14.0
flutter_launcher_icons: ^0.13.1 (dev)
flutter_lints: ^4.0.0 (dev)
```

---

[Unreleased]: https://github.com/xx-arteeem-xx/flatter-lab-2/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/xx-arteeem-xx/flatter-lab-2/releases/tag/v1.0.0
