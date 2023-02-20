//
//  QualifiedView.swift
//  Uuumo
//
//  Created by Adeel Baig on 2023/02/04.
//

import SwiftUI

struct RentData: Codable {
    let id: Int
    let title: String
    let address: String
    let rent: Int
    let layout: String
    let age: String
    let station: String
    let detail: String
    let coordinate: [Double]
    let buildingImage: String
    let layoutImage: String
}

struct QualifiedView: View {
    
    let screenHeight: Int = Int(UIScreen.main.bounds.height)
    let screenWidth: Int = Int(UIScreen.main.bounds.width)
    
    let conditionURL: String
    @State var favorites = [RentData]()
    @State var results = [RentData]()
    
    var body: some View {
        NavigationStack{
            VStack{
                NavigationLink{FavoriteView(favoriteRent: favorites)}label: {
                    Image(systemName: "heart")
                        .position(x: CGFloat(screenWidth - 50))
                        .font(.system(size: 25))
                        .foregroundColor(.blue)
                }
                .frame(height: 10)
                NavigationView{
                    List{
                        ForEach(Array(results.enumerated()), id: \.offset) { id, item in
                            
                            NavigationLink(destination: ContentView(rentInfo: Rent(id: id, title: item.title, address: item.address, rent: item.rent, layout: item.layout, age: item.age, station: item.station, detail: item.detail, coordinate: item.coordinate, buildingImage: item.buildingImage, layoutImage: item.layoutImage))){
                                
                                ListElementView(rentInfo: Rent(id: id, title: item.title, address: item.address, rent: item.rent, layout: item.layout, age: item.age, station: item.station, detail: item.detail, coordinate: item.coordinate, buildingImage: item.buildingImage, layoutImage: item.layoutImage))
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
                                Button(action: {favorites.append(item)}, label: { Image(systemName: "heart.fill")})
                            })
                            .tint(.orange)
                            .listRowInsets(
                                EdgeInsets(top: 0,
                                           leading: 18,
                                           bottom: 25,
                                           trailing: 0
                                          )
                            )
                        }
                    }
                    .listStyle(.plain)
                    .onAppear(perform: loadData)
                }
            }
        }
        .navigationTitle("検索結果")
    }
    
    
    func loadData() {
        guard let url = URL(string: self.conditionURL) else {
            print("invalid endpoint")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([RentData].self, from: data) {
                    DispatchQueue.main.async {
                        self.results = response
                    }
                    return
                }
            }
        }.resume()
    }
    
}

struct QualifiedView_Previews: PreviewProvider {
    static var previews: some View {
        QualifiedView(conditionURL: " https://18e5-2400-2410-a121-7300-887b-254a-c1a0-e5ec.jp.ngrok.io/rents/?city=%E5%8D%83%E4%BB%A3%E7%94%B0%E5%8C%BA&layout=3DK&rent=400000&walkDistance=10%E5%88%86%E4%BB%A5%E5%86%85")
        
    }
}
