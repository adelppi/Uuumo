//
//  ListElementView.swift
//  Uuumo
//
//  Created by Adeel Baig on 2023/02/14.
//

import SwiftUI
import MapKit

struct ListElementView: View {
    
    let screenHeight: Int = Int(UIScreen.main.bounds.height)
    let screenWidth: Int = Int(UIScreen.main.bounds.width)
    
    @StateObject var rentInfo: Rent
    
    var annotations: [Annotation]{
        get{
            return [Annotation(coordinate: CLLocationCoordinate2D(latitude: rentInfo.coordinate[1],
                                                                  longitude: rentInfo.coordinate[0]))]
        }}
    
    
    var body: some View {
        VStack{
            HStack{
                AsyncImage(url: rentInfo.buildingImage) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .cornerRadius(12)
                .frame(width: CGFloat(screenWidth/3))
                
                VStack(alignment: .leading){
                    Text("\(rentInfo.title)\n")
                        .font(.title3)
                        .bold()
                    HStack{
                        Text("間取り:")
                        Text("\(rentInfo.layout)")
                            .bold()
                    }
                    HStack{
                        Text("家賃:")
                        Text("\(rentInfo.rent)円")
                            .foregroundColor(.green)
                            .bold()
                    }
                }
                .padding(.trailing, 10)
                .frame(width: CGFloat(screenWidth * 2/3))
            }
            Map(coordinateRegion: $rentInfo.region,
                annotationItems: annotations,
                annotationContent: { (annotation) in
                MapAnnotation(coordinate: annotation.coordinate) {
                    VStack {
                        Image(systemName: "house.circle.fill")
                            .font(.system(size: 25))
                            .foregroundColor(.orange)
                    }
                }
            })
            .cornerRadius(12)
            .padding(.horizontal, 10)
        }
        .frame(width: CGFloat(screenWidth), height: CGFloat(screenHeight/3))
    }
}

struct ListElementView_Previews: PreviewProvider {
    static var previews: some View {
        
        let rentExample = Rent(id: 0,
                               title: "ルフォンプログレ神田プレミア 305号室",
                               address: "東京都千代田区神田須田町１",
                               rent: 140000,
                               layout: "ワンルーム",
                               age: "新築",
                               station: "ＪＲ山手線/神田駅 歩4分",
                               detail: "https://suumo.jp/chintai/bc_100314250507/",
                               coordinate: [139.769836, 35.696224],
                               buildingImage: "https://img01.suumo.com/front/gazo/fr/bukken/530/100314249530/100314249530_8w.jpg",
                               layoutImage: "https://img01.suumo.com/front/gazo/fr/bukken/507/100314250507/100314250507_cw.jpg")
        
        ListElementView(rentInfo: rentExample)
    }
}
