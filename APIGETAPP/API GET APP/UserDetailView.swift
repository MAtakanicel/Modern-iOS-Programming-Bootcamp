import SwiftUI

struct UserDetailView: View {
    let user: User

    var body: some View {
        Form {
            Section(header: Text("Genel")) {
                LabeledContent("Ad", value: user.name)
                LabeledContent("Kullanıcı Adı", value: user.username)
                LabeledContent("E-posta", value: user.email)
                LabeledContent("Telefon", value: user.phone)
                LabeledContent("Web Sitesi", value: user.website)
            }
            Section(header: Text("Adres")) {
                LabeledContent("Adres", value: user.address.formatted)
                LabeledContent("Koordinatlar", value: "\(user.address.geo.lat), \(user.address.geo.lng)")
            }
            Section(header: Text("Şirket")) {
                LabeledContent("Ad", value: user.company.name)
                LabeledContent("Slogan", value: user.company.catchPhrase)
                LabeledContent("Alan", value: user.company.bs)
            }
        }
        .navigationTitle(user.username)
    }
}

#Preview {
    UserDetailView(user: User(
        id: 1,
        name: "Leanne Graham",
        username: "Bret",
        email: "Sincere@april.biz",
        address: Address(
            street: "Kulas Light",
            suite: "Apt. 556",
            city: "Gwenborough",
            zipcode: "92998-3874",
            geo: Geo(lat: "-37.3159", lng: "81.1496")
        ),
        phone: "1-770-736-8031 x56442",
        website: "hildegard.org",
        company: Company(name: "Romaguera-Crona", catchPhrase: "Multi-layered client-server neural-net", bs: "harness real-time e-markets")
    ))
}


