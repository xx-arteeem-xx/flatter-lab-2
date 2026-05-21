# Flutter Lab 2 — User Profile App

Лабораторная работа №2 по предмету «Разработка мобильных приложений».  
**Студент:** Фирсов Артем Алексеевич, НГУЭУ, ИСиТ, группа ИС302.

[![Build Status](https://github.com/xx-arteeem-xx/flatter-lab-2/actions/workflows/release.yml/badge.svg)](https://github.com/xx-arteeem-xx/flatter-lab-2/actions/workflows/release.yml)
[![Latest Release](https://img.shields.io/github/v/release/xx-arteeem-xx/flatter-lab-2)](https://github.com/xx-arteeem-xx/flatter-lab-2/releases/latest)

## Скачать APK

**[⬇️ Скачать последнюю версию APK](https://github.com/xx-arteeem-xx/flatter-lab-2/releases/latest/download/app-release.apk)**

> APK собирается автоматически через GitHub Actions при каждом пуше в `main` и публикуется в [Releases](https://github.com/xx-arteeem-xx/flatter-lab-2/releases).

---

## О приложении

Flutter-приложение с профилем пользователя. Реализован **3-й (продвинутый) уровень** задания:

- **Вкладка «Профиль»** — аватар, возраст (авто-вычисляется), информационные карточки (ВК, TG, GitHub, учёба, работа), теги интересов, кнопка скачивания резюме (PDF), кнопка «Нравится» с персистентным счётчиком
- **Вкладка «Галерея»** — сетка из 30 фотографий с полноэкранным просмотром и зумом
- **Вкладка «Контакты»** — список контактов с возможностью звонка

Дополнительно реализовано из **2-го уровня**: переключатель тёмной/светлой темы (сохраняется между запусками).

## Дизайн-система

Адаптирована из **EAM Design System** (glassmorphism, тёмный фон `#080A11`, акцент `#50C8FF`). Шрифт: **Nunito** (Google Fonts).

## Стек технологий

| | |
|---|---|
| Язык | Dart 3.3+ |
| Фреймворк | Flutter 3.24.5 |
| State management | `ValueNotifier<ThemeMode>` + `setState` |
| Кэш изображений | `cached_network_image` |
| Галерея | `photo_view` |
| Хранение | `shared_preferences` |
| CI/CD | GitHub Actions |
| Подпись APK | Keystore + GitHub Secrets |

## Сборка и запуск

### Требования

- Flutter SDK 3.24+
- Android SDK
- Java 17

### Первоначальная настройка (один раз)

```bash
git clone https://github.com/xx-arteeem-xx/flatter-lab-2.git
cd flatter-lab-2

# Сгенерировать бинарные файлы Android (gradle-wrapper.jar, mipmap icons)
flutter create . --platforms android

# Установить зависимости
flutter pub get
```

### Запуск

```bash
flutter run
```

### Настройка CI/CD подписи APK (один раз)

1. Сгенерировать keystore:
   ```bash
   keytool -genkey -v -keystore keystore.jks -alias upload -keyalg RSA -keysize 2048 -validity 10000
   ```

2. Закодировать в base64:
   ```powershell
   # Windows PowerShell:
   [Convert]::ToBase64String([IO.File]::ReadAllBytes('keystore.jks'))
   ```

3. Добавить в **Settings → Secrets and variables → Actions**:

   | Secret | Значение |
   |---|---|
   | `KEYSTORE_BASE64` | base64-строка keystore |
   | `KEY_STORE_PASSWORD` | пароль keystore |
   | `KEY_PASSWORD` | пароль ключа |
   | `KEY_ALIAS` | `upload` |

4. Пуш в `main` → APK появится в [Releases](https://github.com/xx-arteeem-xx/flatter-lab-2/releases)

### Свои файлы

| Файл | Назначение |
|---|---|
| `user-files/avatar.jpg` | Фото профиля |
| `user-files/resume.pdf` | Резюме (открывается PDF-приложением) |

---

## Структура проекта

```
lib/
├── main.dart                     # Точка входа
├── app.dart                      # MaterialApp + ThemeNotifier + MainScaffold
├── core/
│   ├── constants/                # Цвета, строки
│   └── theme/                    # AppTheme (dark/light), ThemeNotifier
├── models/                       # Contact, InfoItem
├── widgets/                      # GlassCard, ThemeToggleButton
└── features/
    ├── profile/                  # Экран профиля + виджеты
    ├── gallery/                  # Сетка + fullscreen viewer
    ├── contacts/                 # Список контактов
    └── about/                    # Экран "О приложении"
```

## Лицензия

[Unlicense](LICENSE) — свободное использование без ограничений.
