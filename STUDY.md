# STUDY.md — Изучаем Flutter через этот проект

Этот файл — полный учебный разбор проекта. Прочитав его вместе с кодом, ты сможешь написать такое же приложение с нуля.

---

## 1. Что такое Flutter и как он работает

**Flutter** — UI-фреймворк от Google для создания нативных приложений из одного кода (Android, iOS, Web, Desktop).

**Dart** — язык программирования, на котором пишется Flutter. Строго типизированный, ООП, компилируется в нативный код.

### Как Flutter рисует экран

Flutter не использует нативные UI-компоненты Android (TextView, Button и т.д.). Вместо этого он сам рисует каждый пиксель через движок **Skia / Impeller**. Это даёт:
- 60/120 fps на любой платформе
- Полный контроль над внешним видом
- Одинаковый вид на Android и iOS

### Widget Tree

В Flutter **абсолютно всё — это виджет**: текст, кнопка, отступ, даже весь экран. Виджеты вкладываются друг в друга образуя дерево:

```
MaterialApp
 └─ Scaffold
     ├─ AppBar
     │   └─ Text("Профиль")
     └─ body: Column
         ├─ CircleAvatar
         ├─ Text("Артем")
         └─ ElevatedButton
```

Flutter перестраивает только изменившиеся части дерева — это называется **reconciliation** (как в React).

---

## 2. StatelessWidget vs StatefulWidget

### StatelessWidget

Виджет без внутреннего состояния. Перерисовывается только когда меняются входные параметры (props).

```dart
class MyLabel extends StatelessWidget {
  final String text;
  const MyLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}
```

### StatefulWidget

Виджет с внутренним состоянием. Вызов `setState(() { ... })` запускает перерисовку.

```dart
class LikeCounter extends StatefulWidget {
  const LikeCounter({super.key});
  @override
  State<LikeCounter> createState() => _LikeCounterState();
}

class _LikeCounterState extends State<LikeCounter> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => setState(() => _count++),  // перерисует виджет
      child: Text('Нравится: $_count'),
    );
  }
}
```

В этом проекте `ProfileScreen` — `StatefulWidget` (хранит `_likes`, `_liked`).  
`GalleryScreen`, `ContactsScreen`, `AboutScreen` — `StatelessWidget`.

---

## 3. Архитектура проекта

### Точка входа: `main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // обязательно перед async операциями
  final prefs = await SharedPreferences.getInstance();  // читаем настройки
  runApp(App(prefs: prefs));  // запускаем приложение
}
```

`WidgetsFlutterBinding.ensureInitialized()` нужен потому, что мы вызываем `await` ДО запуска Flutter engine. Без этого вызова — краш.

### Корневой виджет: `App` (`app.dart`)

```
App (StatefulWidget)
 ├─ initState: создаёт ThemeNotifier(prefs)
 ├─ dispose: уничтожает ThemeNotifier
 └─ build: ValueListenableBuilder<ThemeMode>
     └─ MaterialApp(theme: dark, darkTheme: light, themeMode: notifier.value)
         └─ _MainScaffold(themeNotifier)
```

`App` — `StatefulWidget` потому, что `ThemeNotifier` должен создаться ОДИН раз в `initState` и жить до уничтожения приложения. Если бы мы создавали его в `build()`, он пересоздавался бы при каждой перерисовке.

### Управление состоянием темы: `ValueNotifier<ThemeMode>`

Вместо сторонних библиотек (Riverpod, BLoC) используется встроенный Flutter паттерн:

```dart
class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier(SharedPreferences prefs) 
      : super(prefs.getString('themeMode') == 'light' ? ThemeMode.light : ThemeMode.dark);
  
  void toggle() {
    value = value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    // value = ... автоматически уведомляет слушателей!
  }
}
```

`ValueNotifier` — это `ChangeNotifier` + `value` поле. Когда присваиваешь `value`, все `ValueListenableBuilder` перестраиваются.

```dart
ValueListenableBuilder<ThemeMode>(
  valueListenable: _themeNotifier,
  builder: (context, mode, child) {
    return MaterialApp(themeMode: mode, ...);
  },
);
```

### Навигация между вкладками: `IndexedStack`

```dart
IndexedStack(
  index: _tab,  // активная вкладка
  children: [ProfileScreen(), GalleryScreen(), ContactsScreen()],
)
```

`IndexedStack` держит ВСЕ дочерние виджеты в памяти, но показывает только один. Преимущество: при переключении вкладок scroll position и состояние сохраняется. Это лучше чем просто показывать `children[_tab]` — там состояние теряется.

### Навигация на другой экран: `Navigator`

```dart
// Открыть About экран:
Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => const AboutScreen()),
);
// Закрыть (кнопка "Назад"):
Navigator.of(context).pop();
```

`MaterialPageRoute` добавляет анимацию перехода в стиле Material Design. `Navigator` — стек экранов: `push` добавляет экран, `pop` убирает.

---

## 4. Дизайн-система EAM в Flutter

EAM — это Vue.js проект с glassmorphism дизайном. В Flutter мы адаптировали его цвета и стиль.

### Цвета (`app_colors.dart`)

Все цвета — `static const Color`. Flutter использует `Color(0xAARRGGBB)`:
- `0xFF` в начале = полная непрозрачность (alpha = 255)
- `0x12` = ~7% непрозрачность
- `0x2E` = ~18% непрозрачность

```dart
// EAM: --app-bg: #080a11  →  Flutter:
static const Color darkBg = Color(0xFF080A11);

// EAM: rgba(14, 18, 31, 0.07)  →  Flutter:
// 0.07 * 255 ≈ 18 = 0x12
static const Color darkGlass = Color(0x120E121F);
```

### Темы (`app_theme.dart`)

`ThemeData` — глобальные стили приложения. Создаём два объекта: для тёмной и светлой темы. `MaterialApp` выбирает нужный через `themeMode`.

Ключевые части `ThemeData`:
- `colorScheme` — палитра цветов (primary, surface, error, etc.)
- `textTheme` — стили текста (headlineMedium, bodyLarge, etc.)
- `appBarTheme` — стиль AppBar
- `cardTheme` — стиль Card
- `elevatedButtonTheme` — стиль кнопок

Получить цвет из темы в виджете:
```dart
final accent = Theme.of(context).colorScheme.primary;
final isDark = Theme.of(context).brightness == Brightness.dark;
```

### GlassCard (`glass_card.dart`)

Glassmorphism = blur + translucent color + border.

```dart
// Blur через BackdropFilter:
BackdropFilter(
  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),  // dart:ui
  child: Container(
    color: Color(0x120E121F),  // полупрозрачный тёмный
    child: yourContent,
  ),
)
```

**Важно**: `BackdropFilter` размывает ВСЁ что находится ПОЗАДИ контейнера. Поэтому он завёрнут в `ClipRRect` чтобы blur не выходил за границы карточки.

В светлой теме glassmorphism не нужен — рисуем обычный белый контейнер с тенью.

---

## 5. Основные виджеты и паттерны

### Компоновка

```dart
Column(children: [...])         // вертикально
Row(children: [...])            // горизонтально
Wrap(spacing: 8, children: [...]) // с переносом (как flexbox)
Stack(children: [...])          // слои (один поверх другого)
Padding(padding: EdgeInsets.all(16), child: ...)
SizedBox(height: 20)            // пустое пространство
Expanded(child: ...)            // занять всё доступное место
Spacer()                        // гибкий разделитель
```

### CustomScrollView и Slivers

В `ProfileScreen` используется `CustomScrollView` + `SliverToBoxAdapter`. Это мощнее обычного `SingleChildScrollView`:

```dart
CustomScrollView(
  slivers: [
    SliverToBoxAdapter(child: profileContent),
    SliverList(delegate: ...),     // для списков
    SliverGrid(delegate: ...),     // для сеток
  ],
)
```

Преимущество: можно легко добавить `SliverAppBar` (схлопывающийся AppBar) без рефакторинга.

### Изображения

```dart
// Из assets:
Image.asset('user-files/avatar.jpg', fit: BoxFit.cover)

// Из сети (с кэшем):
CachedNetworkImage(
  imageUrl: 'https://picsum.photos/seed/1/400/400',
  placeholder: (_, __) => CircularProgressIndicator(),
  errorWidget: (_, __, ___) => Icon(Icons.error),
)
```

`CachedNetworkImage` скачивает и кэширует изображение на диск. При повторном открытии показывает из кэша.

### GridView

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,    // 3 колонки
    crossAxisSpacing: 3,  // горизонтальный отступ между ячейками
    mainAxisSpacing: 3,   // вертикальный отступ
    childAspectRatio: 1,  // квадратные ячейки
  ),
  itemCount: 30,
  itemBuilder: (context, index) => YourCell(index),
)
```

### photo_view (fullscreen галерея)

```dart
PhotoViewGallery.builder(
  pageController: PageController(initialPage: index),
  itemCount: 30,
  builder: (context, index) => PhotoViewGalleryPageOptions(
    imageProvider: CachedNetworkImageProvider(url),
    minScale: PhotoViewComputedScale.contained,  // вписать в экран
    maxScale: PhotoViewComputedScale.covered * 2.5,  // до 2.5x zoom
  ),
)
```

---

## 6. Assets и pubspec.yaml

Flutter не включает в APK все файлы из проекта. Нужно явно объявить что включить:

```yaml
flutter:
  assets:
    - user-files/   # включить всю папку user-files/
    # Или отдельные файлы:
    # - user-files/avatar.jpg
    # - user-files/resume.pdf
```

Загрузка asset в коде:
```dart
// Как изображение:
Image.asset('user-files/avatar.jpg')

// Как бинарные данные:
final data = await rootBundle.load('user-files/resume.pdf');
final bytes = data.buffer.asUint8List();
```

---

## 7. SharedPreferences — постоянное хранилище

`SharedPreferences` — key-value хранилище на устройстве (аналог localStorage в браузере). Данные сохраняются между запусками приложения.

```dart
// Чтение:
final prefs = await SharedPreferences.getInstance();
final likes = prefs.getInt('profile_likes') ?? 0;
final isDark = prefs.getString('themeMode') == 'dark';

// Запись:
await prefs.setInt('profile_likes', 42);
await prefs.setString('themeMode', 'dark');
```

В `main.dart` мы получаем `prefs` один раз и передаём в `App`. Потом `ProfileScreen` получает свой экземпляр через `SharedPreferences.getInstance()` (возвращает тот же синглтон).

---

## 8. url_launcher — открыть ссылки

```dart
import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

// Примеры:
openUrl('https://vk.com/xx_arteem_xx');       // браузер
openUrl('https://t.me/xx_arteeem_xx');        // Telegram
openUrl('tel:+79991234567');                  // звонок
```

`LaunchMode.externalApplication` — открыть во внешнем приложении (браузер, мессенджер). Без этого может открыться в WebView внутри приложения.

**AndroidManifest.xml**: нужно добавить `<queries>` блок для Android 11+:
```xml
<queries>
  <intent>
    <action android:name="android.intent.action.VIEW"/>
    <data android:scheme="https"/>
  </intent>
</queries>
```

---

## 9. open_filex — открыть PDF

```dart
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

Future<void> openPdf() async {
  // 1. Загрузить PDF из assets как байты
  final data = await rootBundle.load('user-files/resume.pdf');
  
  // 2. Записать во временную папку приложения
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/resume.pdf');
  await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
  
  // 3. Открыть системным PDF-просмотром
  await OpenFilex.open(file.path);
}
```

Почему нельзя открыть напрямую из assets? Flutter assets — не файлы на диске, а данные в APK. Нужно сначала скопировать во временный файл.

Почему `getTemporaryDirectory()` а не `getDownloadsDirectory()`? Временная папка не требует разрешений на запись и очищается системой автоматически.

---

## 10. GitHub Actions CI/CD

GitHub Actions — бесплатный сервис автоматизации. Для публичных репозиториев — неограниченные минуты.

### Структура workflow файла

```yaml
name: Build & Release Signed APK

on:
  push:
    branches: [ main ]  # запускать при пуше в main

jobs:
  build:
    runs-on: ubuntu-latest  # виртуальная машина Ubuntu
    steps:
      - uses: actions/checkout@v4      # скачать код
      - uses: actions/setup-java@v4    # установить Java
        with:
          java-version: '17'
      - uses: subosito/flutter-action@v2  # установить Flutter
        with:
          flutter-version: '3.24.5'
      - run: flutter pub get            # shell команда
      - run: flutter build apk --release
```

`uses:` — использовать готовый action из GitHub Marketplace.  
`run:` — выполнить shell команду.

### Secrets

Секреты (пароли, ключи) хранятся в **Settings → Secrets → Actions**, не в коде. В workflow обращаемся через `${{ secrets.MY_SECRET }}`.

```yaml
- run: echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 --decode > android/keystore.jks
```

Это декодирует base64-строку обратно в бинарный `.jks` файл.

### Подпись APK

Android требует подписи APK для установки. Подпись создаётся через **keystore** — хранилище ключей.

1. Создать keystore (один раз):
   ```bash
   keytool -genkey -v -keystore keystore.jks -alias upload -keyalg RSA -keysize 2048 -validity 10000
   ```

2. Закодировать в base64 для хранения в GitHub Secrets:
   ```powershell
   [Convert]::ToBase64String([IO.File]::ReadAllBytes('keystore.jks'))
   ```

3. В CI декодировать и создать `key.properties`:
   ```yaml
   - run: echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 --decode > android/keystore.jks
   - run: |
       printf 'storePassword=%s\nkeyPassword=%s\nkeyAlias=%s\nstoreFile=../keystore.jks\n' \
         "${{ secrets.KEY_STORE_PASSWORD }}" \
         "${{ secrets.KEY_PASSWORD }}" \
         "${{ secrets.KEY_ALIAS }}" \
         > android/key.properties
   ```

4. В `android/app/build.gradle` читать `key.properties`:
   ```groovy
   def keystoreProps = new Properties()
   def propsFile = rootProject.file('key.properties')
   if (propsFile.exists()) keystoreProps.load(new FileInputStream(propsFile))
   
   android {
     signingConfigs {
       release {
         keyAlias keystoreProps['keyAlias']
         ...
       }
     }
   }
   ```

### GitHub Releases — стабильная ссылка на APK

```yaml
- name: Create GitHub Release
  env:
    GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}  # автоматически выдаётся GitHub
  run: |
    gh release create "v1.0.${{ github.run_number }}" \
      app-release.apk \
      --title "Release v1.0.${{ github.run_number }}"
```

`github.run_number` — монотонно возрастающий номер (1, 2, 3...), никогда не сбрасывается.

Стабильная ссылка всегда указывает на последний релиз:
```
https://github.com/xx-arteeem-xx/flatter-lab-2/releases/latest/download/app-release.apk
```

---

## 11. Android проект — минимальный набор файлов

При разработке Flutter создаёт Android проект автоматически. Вот что нужно знать о ключевых файлах:

### `android/settings.gradle`
Настройка сборочного окружения Gradle. Использует Flutter Plugin Loader — он подключает все Flutter-пакеты к Android сборке.

### `android/app/build.gradle`
Конфигурация Android приложения:
- `applicationId` — уникальный ID приложения в Google Play
- `minSdk` — минимальная версия Android (21 = Android 5.0)
- `targetSdk` — целевая версия (35 = Android 15)
- `signingConfigs` — настройки подписи
- `flutter.compileSdkVersion` — версия SDK из Flutter SDK (не хардкодим)

### `android/app/src/main/AndroidManifest.xml`
Декларация приложения: разрешения, активности, интент-фильтры.

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

Без этого не будет работать загрузка изображений из интернета.

### `android/gradle/wrapper/gradle-wrapper.jar`
Бинарный файл — загрузчик нужной версии Gradle. Не редактируется вручную. Генерируется `flutter create` или скачивается Gradle wrapper.

---

## 12. Как расширять приложение

### Добавить новую вкладку

1. Создать `lib/features/new_tab/new_tab_screen.dart`
2. Добавить в `_MainScaffold._screens` в `app.dart`
3. Добавить `BottomNavigationBarItem` в `bottomNavigationBar`
4. Добавить строку в `AppStrings` и `_titles` в `_MainScaffoldState`

### Добавить новый экран (не вкладку)

```dart
// Открыть:
Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => const NewScreen()),
);

// Или с передачей данных:
Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => ItemDetailScreen(item: selectedItem)),
);
```

### Добавить новый пакет

1. `flutter pub add package_name` (или вручную в `pubspec.yaml`)
2. `flutter pub get`
3. Для Android — проверить не нужны ли разрешения в `AndroidManifest.xml`

### Изменить данные профиля

Все строки в одном месте: [`lib/core/constants/app_strings.dart`](lib/core/constants/app_strings.dart).

### Изменить цвета

Все цвета: [`lib/core/constants/app_colors.dart`](lib/core/constants/app_colors.dart).  
Применяются в темах: [`lib/core/theme/app_theme.dart`](lib/core/theme/app_theme.dart).
