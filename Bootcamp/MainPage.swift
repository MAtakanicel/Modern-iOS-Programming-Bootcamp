
import Foundation
import SwiftUI

struct MainPage: View {
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .center, spacing: 20) {
                
                PersonalInfoCardView(
                    name: "Mehmet Atakan İÇEL",
                    education: "Bilgisayar Mühendisliği (Süleyman Demirel Üniversitesi, son sınıf)",
                    roles: "iOS Developer | Swift & SwiftUI | React Native",
                    projects: "FitLife AI , Kişisel Finans Uygulaması",
                    interests: "Mobil geliştirme & Web teknolojileri."
                )
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                .background(Color(.systemBackground))
                
                NavigationLink(destination: Homework1()){
                    Text("Ödev 1")
                        .font(.headline)
                        .frame(width: 200, height: 40)
                        .foregroundColor(.white.opacity(0.9))
                        .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(20)
                }
                
                NavigationLink(destination: Homework2()){
                    Text("Ödev 2")
                        .font(.headline)
                        .frame(width: 200, height: 40)
                        .foregroundColor(.white.opacity(0.9))
                        .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(20)
                }
                
                NavigationLink(destination: Homework3()){
                    Text("Ödev 3")
                        .font(.headline)
                        .frame(width: 200, height: 40)
                        .foregroundColor(.white.opacity(0.9))
                        .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(20)
                    
                    
                    Spacer()
                }
            }
        }
    }
}
    
    

#Preview {
    MainPage()
        .preferredColorScheme(.light)
    
}

