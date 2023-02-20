//
//  FavoriteView.swift
//  Uuumo
//
//  Created by Adeel Baig on 2023/02/16.
//

import SwiftUI

struct FavoriteView: View {
    
    @State var favoriteRent: [RentData]
    
    var body: some View {
        if (favoriteRent.isEmpty){
            Text("お気に入り物件はありません。")
        }else{
            NavigationView{
                List{
                    ForEach(Array(favoriteRent.enumerated()), id: \.offset) { id, item in
                        
                        NavigationLink(destination: ContentView(rentInfo: Rent(id: id, title: item.title, address: item.address, rent: item.rent, layout: item.layout, age: item.age, station: item.station, detail: item.detail, coordinate: item.coordinate, buildingImage: item.buildingImage, layoutImage: item.layoutImage))){
                            
                            ListElementView(rentInfo: Rent(id: id, title: item.title, address: item.address, rent: item.rent, layout: item.layout, age: item.age, station: item.station, detail: item.detail, coordinate: item.coordinate, buildingImage: item.buildingImage, layoutImage: item.layoutImage))
                        }
                        .navigationTitle("お気に入り物件")
                        .listRowInsets(
                            EdgeInsets(top: 0,
                                       leading: 18,
                                       bottom: 25,
                                       trailing: 0
                                      )
                        )
                    }
                    .onDelete { (offsets) in
                        self.favoriteRent.remove(atOffsets: offsets)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}


struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView(favoriteRent: [RentData(id: 0,
                                             title: "ルフォンプログレ神田プレミア 305号室",
                                             address: "東京都千代田区神田須田町１",
                                             rent: 140000,
                                             layout: "ワンルーム",
                                             age: "新築",
                                             station: "ＪＲ山手線/神田駅 歩4分",
                                             detail: "https://suumo.jp/chintai/bc_100314250507/",
                                             coordinate: [139.769836, 35.696224],
                                             buildingImage: "https://img01.suumo.com/front/gazo/fr/bukken/530/100314249530/100314249530_8w.jpg",
                                             layoutImage: "https://img01.suumo.com/front/gazo/fr/bukken/507/100314250507/100314250507_cw.jpg")])
    }
}
