import SwiftUI

struct NoteDetailBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(LinearGradient(
                colors: [
                    Color.orange.opacity(0.08),
                    Color.pink.opacity(0.08)
                ],
                startPoint: .topTrailing,
                endPoint: .bottomLeading)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.orange.opacity(0.3),
                                Color.pink.opacity(0.3)
                            ],
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .orange.opacity(0.1), radius: 8, x: 0, y: 4)
            .accessibilityElement(children: .contain)
    }
}

#Preview {
    NoteDetailBackground()
        .frame(width: 300, height: 150)
        .padding()
}
