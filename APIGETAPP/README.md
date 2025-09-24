# API GET APP

### Kullanılan API
- JSONPlaceholder (`https://jsonplaceholder.typicode.com/users`)
- Açıklama: Ücretsiz bir test API’si. `users` uç noktasından kullanıcı listesi, adres ve şirket bilgileri döner. Bu proje, bu verileri çekip SwiftUI arayüzünde liste ve detay ekranlarında gösterir.

### Kısa Açıklama
- Uygulama açıldığında kullanıcılar `URLSession` ve `async/await` ile çekilir.
- `Codable` modelleriyle decode edilir (`User`, `Address`, `Geo`, `Company`).
- `UsersListView` içinde listeleme ve arama yapılır (isim/kullanıcı adı/e‑posta).
- Bir kullanıcıya tıklanınca `UserDetailView` detaylarını (e‑posta, telefon, web sitesi, adres, şirket) gösterir.
- Hata durumunda kullanıcıya "Bir hata oluştu" mesajı ve "Tekrar Dene" butonu gösterilir.

### Çalıştırma
- Xcode ile projeyi açın ve çalıştırın. İnternet bağlantısı yoksa hata mesajı görünür.
