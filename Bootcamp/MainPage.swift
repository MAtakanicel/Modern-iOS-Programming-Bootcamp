
import Foundation
import SwiftUI

struct MainPage: View {

    var body: some View {
        
        NavigationStack {
            VStack(alignment: .center) {
                
                PersonalInfoCardView(
                    name: "Mehmet Atakan İÇEL",
                    education: "Bilgisayar Mühendisliği (Süleyman Demirel Üniversitesi, son sınıf)",
                    roles: "iOS Developer | Swift & SwiftUI | React Native",
                    projects: "FitLife AI , Kişisel Finans Uygulaması",
                    interests: "Mobil geliştirme & Web teknolojileri."
                )
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
                
                .background(Color(.systemBackground))
                
                NavigationLink(destination: Homework1()){
                    Text("Ödev 1")
                        .font(.headline)
                        .frame(width: 200, height: 40)
                        .foregroundColor(.black)
                        .background(.blue.opacity(0.9))
                        .cornerRadius(20)
                }
                
                Spacer()
            }
            
        }
        
    }
}
    
    

#Preview {
    MainPage()
        .preferredColorScheme(.light)
    
}

