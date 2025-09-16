import SwiftUI

struct CustomBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(LinearGradient(
                colors: [
                    Color.blue.opacity(0.12),
                    Color.purple.opacity(0.12)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(.quaternary, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 6)
            .accessibilityElement(children: .contain)
        
    }
}

#Preview {
    CustomBackground()
        .frame(width: 300, height: 100)
        .padding()
}
