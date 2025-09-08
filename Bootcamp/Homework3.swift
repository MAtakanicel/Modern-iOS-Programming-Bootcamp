//Sayaç Uygulaması

import SwiftUI

struct Homework3: View {
    @State var sayac : Int = 0
    var body: some View {
        ZStack{
            
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
                
                
            
            VStack{
                Text("\(sayac)")
                    .font(.system(size: 100, weight: .bold, design: .default))
                    .foregroundColor(.purple)
                    .padding(.top, 100)
                    .accessibility(label: Text("Sayac"))
                    
                Spacer()
                
                HStack{
                    Button(action: {
                        sayac += 1
                    }){
                        Text("Artır")
                            .foregroundStyle(.white.opacity(0.9))
                            .bold()
                            .font(.system(size: 25))
                    }
                    .frame(width: 145,height: 75)
                    .buttonBorderShape(.roundedRectangle)
                    .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing).opacity(0.75))
                    .cornerRadius(20)
                    .padding()
                    
                    Button(action: {
                        if sayac > 0 {
                            sayac -= 1
                        }else{  }
                    }){
                        Text("Azalt")
                            .foregroundStyle(.white.opacity(0.9))
                            .bold()
                            .font(.system(size: 25))
                    }
                    .frame(width: 145,height: 75)
                    .buttonBorderShape(.roundedRectangle)
                    .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing).opacity(0.75))
                    .cornerRadius(20)
                    .padding()
                    
                }
                    Button(action: {
                        sayac = 0
                    }){
                        Text("Sıfırla")
                            .foregroundStyle(.white.opacity(0.9))
                            .bold()
                            .font(.system(size: 25))
                    }
                    .frame(width: 145,height: 75)
                    .buttonBorderShape(.roundedRectangle)
                    .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing).opacity(0.75))
                    .cornerRadius(20)
                    .padding()
                    
                
                
                Spacer()
            }
            
          
            
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 50)
        
        .navigationTitle("Sayaç Uygulaması")
    }
        
}

#Preview {
    Homework3()
}
