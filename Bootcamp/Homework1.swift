import SwiftUI

struct Homework1: View {
    // Temel veri tipleri
    @State private var age: Int = 25
    @State private var name: String = "Atakan İÇEL"
    @State private var isStudent: Bool = true
    @State private var height: Double = 1.75
    
    // Optional değişkenler
    @State private var nickname: String? = nil
    @State private var githubURL: String? = nil

    //Hesap Makinesi
    @State private var number1: String = ""
    @State private var number2: String = ""
    @State private var result: String = "Sonuç: —"
    
    //Closure filtreleme
    let sayilar = [1, 5, 12, 18, 7, 20, 3]
    @State private var sonuc: [Int] = []
    
    var body: some View {
        ScrollView {
            Text("Ödev 1.1 – Değişkenler & Optional")
                .font(.title2).bold().padding(.top)
            VStack(alignment: .leading, spacing: 20,) {
            
                
                // Temel Tipler
                Group {
                    Text("İsim: \(name)").padding(.top)
                    Text("Yaş: \(age)")
                    Text("Öğrenci mi? \(isStudent ? "Evet" : "Hayır")")
                    Text("Boy: \(height, specifier: "%.2f") m")
                }.padding(.horizontal)
                
                Divider()
                
                // Optional Kullanımı
                // if let ile güvenli açma
                if let url = githubURL {
                    Text("GitHub: \(url)")
                        .padding(.horizontal)
                        .padding(.bottom)
                } else {
                    Text("GitHub adresi yok")
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                
            }
            .background(CustomBackground())
            .padding(.bottom)
            .padding(.horizontal)
            Text("Ödev 1.2 - Fonksiyonlar ve Closure'lar")
                .font(.title2).bold()
            
            VStack {
                VStack(spacing: 10) {
                    Text("Basit Hesap Makinesi")
                        .font(.title2)
                        .bold()
                        .padding(.vertical,15)
                    
                    // Sayı girişleri
                    TextField("1. Sayı", text: $number1)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    TextField("2. Sayı", text: $number2)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    // İşlem butonları
                    HStack {
                        Button("➕") { calculate("+") }
                        Button("➖") { calculate("-") }
                        Button("✖️") { calculate("*") }
                        Button("➗") { calculate("/") }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    // Sonuç gösterimi
                    Text(result)
                        .font(.title3)
                        .padding(.vertical, 25)
                    
                }
                .background(CustomBackground())
                .padding(.horizontal,25)
                
            }
            VStack(spacing: 20) {
                        Text("Orijinal Dizi: \(sayilar.map { String($0) }.joined(separator: ", "))")
                            .font(.callout)
                            .padding(.top)
                            
                        
                        Button("10’dan Büyükleri Filtrele") {
                            sonuc = sayilar.filter { $0 > 10 }
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal,75)
                        
                        Button("Sayıları sırala") {
                            sonuc = sayilar.sorted { $0 < $1 }
                        }
                        .buttonStyle(.borderedProminent)
                       
                        
                        Text("Sonuç: \(sonuc.map { String($0) }.joined(separator: ", "))")
                            .font(.headline)
                            .padding(.bottom, 25)
                    }
            .background(CustomBackground())
            .padding()
            .navigationTitle("Ödev 1")
        }
}
    // Hesaplama fonksiyonu
      private func calculate(_ operation: String) {
          guard let a = Double(number1),
                let b = Double(number2) else {
              result = "Hata: Geçersiz sayı!"
              return
          }
          
          var value: Double = 0
          
          switch operation {
          case "+": value = a + b
          case "-": value = a - b
          case "*": value = a * b
          case "/":
              if b == 0 {
                  result = "Hata: Sıfıra bölünemez!"
                  return
              }
              value = a / b
          default: break
          }
          
          result = "Sonuç: \(value)"
      }
  }

#Preview {
    Homework1()
}
