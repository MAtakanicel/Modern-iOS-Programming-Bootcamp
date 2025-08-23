import SwiftUI


struct ProfileStats: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let systemIcon: String
}


struct Homework2: View {
    // Küçük kart verileri
    private let stats: [ProfileStats] = [
        .init(title: "Takipçi",     value: "1.2k", systemIcon: "person.2.fill"),
        .init(title: "Takip Edilen", value: "340", systemIcon: "person.crop.circle.badge.checkmark"),
        .init(title: "Beğeni",       value: "8.9K", systemIcon: "heart.fill")
    ]

    // Hakkımda metni
    private let about =
    """
    iOS geliştiricisi adayıyım. Swift ve React Native kullanarak \
    MVVM ve Viper mimarisi, Firebase entegrasyonu ile uygulamalar geliştiriyorum. 
    Performans, erişilebilirlik ve test odaklı \
    geliştirme prensiplerine önem veririm. Boş zamanlarımda tasarım sistemleri ve \
    animasyonlarla uğraşırım. Uzun vadede ileri seviye mobil mimariler ve ölçeklenebilir \
    uygulamalar üzerine derinleşmek istiyorum.
    """

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

                // ÜST BÖLÜM (HEADER)
                HeaderSection(
                    name: "Mehmet Atakan İçel",
                    subtitle: "iOS Developer • Swift | React Native",
                    imageName: "profile"
                )

                // BİLGİ KARTLARI (HStack)
                StatsSection(stats: stats)
                    .padding()

                // HAKKIMDA
                AboutSection(text: about)
                    .padding(.horizontal)
                    .padding(.bottom)
                
                // Buttonalr
                ButtonSection()
            }
        }
        .background(Color(.systemBackground))
  
    }
}

private struct HeaderSection: View {
    let name: String
    let subtitle: String
    let imageName: String

    var body: some View {
        ZStack {
            // Arkaplan (Gradient)
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.9),
                    Color.purple.opacity(0.9)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 225)
            .overlay(alignment: .bottom) {
                // açıklma
                VStack(spacing: 8) {
                    ProfileImage(imageName: imageName)
                        .accessibilityLabel("Profil resmi")
                        .padding(.bottom, 4)

                    Text(name)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                        .accessibilityAddTraits(.isHeader)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .accessibilityLabel("Kısa açıklama: \(subtitle)")
                }
                .padding(.bottom, 16)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal)
        .padding(.top, 8)
        .shadow(color: .black.opacity(0.12), radius: 10, y: 6)
        .navigationTitle("Ödev 2")
    }
}

private struct ProfileImage: View {
    let imageName: String
    var body: some View {
        ZStack {
            //Sembol
            if UIImage(named: imageName) != nil {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
            } else {
                //Yedek sembol
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .foregroundStyle(.white.opacity(0.95))
                    .background(.white.opacity(0.15))
                    .clipShape(Circle())
            }
        }
        .frame(width: 96, height: 96)
        .clipShape(Circle())
        .overlay(
            Circle()
                .strokeBorder(Color.white.opacity(0.85), lineWidth: 3)
        )
        .shadow(radius: 6, y: 4)
    }
}

private struct StatsSection: View {
    let stats: [ProfileStats]

    var body: some View {
        HStack(spacing: 12) {
            ForEach(stats) { stat in
                StatCard(stat: stat)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

private struct StatCard: View {
    let stat: ProfileStats

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: stat.systemIcon)
                .font(.title3)
                .imageScale(.medium)
                .accessibilityHidden(true)

            Text(stat.value)
                .font(.headline)
                .minimumScaleFactor(0.8)

            Text(stat.title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(.vertical, 14)
        .frame(height: 86)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.secondary.opacity(0.12))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(stat.title): \(stat.value)")
    }
}

private struct AboutSection: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Hakkımda")
                .font(.headline)
                .bold()
                .accessibilityAddTraits(.isHeader)

            Text(text)
                .font(.body)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
                .lineSpacing(3)
                .accessibilityLabel("Hakkımda metni")
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.secondary.opacity(0.12))
        )
    }
}

private struct ButtonSection: View {
    @State private var showAlert : Bool = false
    @State private var showMessageAlert : Bool = false
    var body: some View{
        HStack{
            Button(action: {
                showMessageAlert.toggle()
            }){
                Text("Mesaj Gönder")
                    .foregroundStyle(.white.opacity(0.9))
                    .bold()
            }
            .frame(width: 145, height: 75)
            .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing).opacity(0.75))
            .cornerRadius(20)
            .padding()
            
            Button(action: {
                showAlert.toggle()
            }){
                Text("Takip Et")
                    .foregroundStyle(.white.opacity(0.9))
                    .bold()
            }
            .frame(width: 145,height: 75)
            .buttonBorderShape(.roundedRectangle)
            .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing).opacity(0.75))
            .cornerRadius(20)
            .padding()
      
        }.background(CustomBackground())
       
        // Bu bölge fena kolpa 😂
            .alert("Takiptesin 🥳", isPresented: $showAlert) {
                Button("Harika 🤩", role: .cancel) { }
            } message: {
                Text("Takipçi sayısı 1256 oldu 🎉")
            }
            
            .alert("Hata! 🤦🏻‍♂️", isPresented: $showMessageAlert){
                Button("Üzgünüzz 😔",role: .cancel) { }
            } message: {
                Text("Şu an işlem yapamıyoruz 😭")
            }
    }
    
}

#Preview {
        Homework2()
            .preferredColorScheme(.light)

    
}
