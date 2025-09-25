## API Explorer (iOS) — Rick and Morty

SwiftUI + MVVM uygulaması. Rick and Morty API kullanılarak karakterleri listeleme, arama, sayfalama, detay ve favoriler özellikleri sunar.

### Özellikler
- Ana liste: isim, küçük görsel, kısa meta (tür • durum)
- Sunucu taraflı arama: `name` parametresi ile
- Sayfalama: sonsuz kaydırma (infinite scroll)
- Detay ekranı: büyük görsel ve ek bilgiler
- Pull-to-refresh
- Favorilere ekleme/çıkarma (UserDefaults) ve favoriler sekmesi
- Görsel önbellekleme: NSCache + URLCache ile basit cache
- Hata/boş durum ekranları
- Clean MVVM, Swift Concurrency (async/await)
- Unit test: JSON decode ve ViewModel durum testi (mock service)

### Gereksinimler
- Xcode 15+
- iOS 16+

### Kurulum
1. Projeyi Xcode ile açın: `API Explorer.xcodeproj`
2. Çalıştırın (⌘R). Ek bağımlılık yok.

### Mimari
- Models: `RMCharacter`, `RMCharacterPage`
- Network: `APIClient` (`CharactersServiceType`) — `URLSession` + `async/await`
- ViewModels: `CharactersListViewModel`, `CharacterDetailViewModel`
- Views: `CharactersListView`, `CharacterDetailView`, `FavoritesView`
- Persistence: `FavoritesStore` (UserDefaults)
- Images: `ImageLoader`, `CachedAsyncImage`

Akış:
1. `CharactersListViewModel` ilk sayfayı çeker, arama değişince 1. sayfaya döner.
2. Liste sonuna gelindiğinde `loadMoreIfNeeded` sonraki sayfayı ister.
3. Hatalarda durum `.error`, boş sonuçta `.empty` olarak güncellenir.
4. Favoriler `FavoritesStore` içinde `Set<Int>` olarak saklanır ve `environmentObject` ile paylaşılır.

### Testler
- `APITests` içinde:
  - `testDecodeCharacterPage`: JSON parse doğrulaması
  - `testListViewModelStates`: Mock service ile ViewModel state testi

### Notlar
- Görsel yükleme için `CachedAsyncImage` hem URLCache (request cache policy) hem de in-memory `NSCache` kullanır.
- Rick and Morty API kimlik doğrulama istemez: `https://rickandmortyapi.com/api/character`.

### Ekranlar
- Keşfet: liste, arama, sonsuz kaydırma, pull-to-refresh
- Detay: büyük görsel, tür/durum, cinsiyet, origin, konum, bölüm sayısı, favori butonu
- Favoriler: favori işareti verilen karakterler listesi

