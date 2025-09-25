import Foundation
import SwiftUI

final class ImageLoader: ObservableObject {
    @Published private(set) var image: UIImage?

    private static let inMemoryCache = NSCache<NSURL, UIImage>()
    private let url: URL
    private var task: Task<Void, Never>?

    init(url: URL) {
        self.url = url
    }

    deinit {
        task?.cancel()
    }

    func load() {
        if let cached = Self.inMemoryCache.object(forKey: url as NSURL) {
            self.image = cached
            return
        }
        task = Task { [weak self] in
            guard let self else { return }
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                if let image = UIImage(data: data) {
                    Self.inMemoryCache.setObject(image, forKey: self.url as NSURL)
                    if Task.isCancelled { return }
                    await MainActor.run {
                        self.image = image
                    }
                }
            } catch {
            }
        }
    }
}

struct CachedAsyncImage: View {
    let url: URL?
    let placeholder: () -> AnyView

    init(url: URL?, @ViewBuilder placeholder: @escaping () -> some View) {
        self.url = url
        self.placeholder = { AnyView(placeholder()) }
    }

    var body: some View {
        Group {
            if let url {
                CachedImageView(url: url, placeholder: placeholder)
            } else {
                placeholder()
            }
        }
    }
}

private struct CachedImageView: View {
    @StateObject private var loader: ImageLoader
    let placeholder: () -> AnyView

    init(url: URL, placeholder: @escaping () -> AnyView) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.placeholder = placeholder
    }

    var body: some View {
        ZStack {
            if let uiImage = loader.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder()
            }
        }
        .onAppear { loader.load() }
    }
}


