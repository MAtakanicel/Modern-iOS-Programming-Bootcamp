import SwiftUI

struct PersonalInfoCardView: View {
    let name: String
    let education: String
    let roles: String
    let projects: String
    let interests: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Üst kısım: İsim + monogram
            HStack(alignment: .center, spacing: 14) {
                MonogramView(text: name)
                    .frame(width: 64, height: 64)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.system(.title2, design: .rounded).weight(.semibold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Text("Kişisel Bilgi Kartı")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
            }

            Divider().opacity(0.6)

            // İçerik satırları
            InfoRow(icon: "graduationcap.fill", title: "Eğitim", text: education)
            InfoRow(icon: "iphone.gen3", title: "Rol", text: roles)
            InfoRow(icon: "hammer.fill", title: "Projeler", text: projects)
            InfoRow(icon: "sparkles", title: "İlgi Alanları", text: interests)
        }
        .padding(16)
        .background(
            CustomBackground()
        )
   
    }
}

// Alt Bileşenler

private struct InfoRow: View {
    let icon: String
    let title: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .imageScale(.medium)
                .font(.system(size: 18, weight: .semibold))
                .frame(width: 24, height: 24)
                .foregroundStyle(.blue)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(text)
                    .font(.system(.body, design: .rounded))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
    }
}

private struct MonogramView: View {
    let text: String
    var initials: String {
        let parts = text.split(separator: " ")
        let letters = parts.prefix(2).compactMap { $0.first }
        return String(letters).uppercased()
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(colors: [Color.indigo, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
            Text(initials)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
        }
    }
}



