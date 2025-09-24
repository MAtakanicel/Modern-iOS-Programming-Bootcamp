import Foundation

@MainActor
final class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""

    private let client: APIClientProtocol

    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }

    var filteredUsers: [User] {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return users
        }
        let query = searchText.lowercased()
        return users.filter { user in
            user.name.lowercased().contains(query) ||
            user.username.lowercased().contains(query) ||
            user.email.lowercased().contains(query)
        }
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            let fetched = try await client.fetchUsers()
            self.users = fetched
        } catch {
            if let apiError = error as? APIError, let description = apiError.errorDescription {
                self.errorMessage = description
            } else {
                self.errorMessage = error.localizedDescription
            }
        }
        isLoading = false
    }
}


