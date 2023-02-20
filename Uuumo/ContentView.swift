//
//  ContentView.swift
//  Uuumo
//
//  Created by Adeel Baig on 2023/01/31.
//

import SwiftUI
import MapKit

class Rent: ObservableObject {
    var id: Int
    var title: String
    var address: String
    var rent: Int
    var layout: String
    var age: String
    var station: String
    var detail: URL?
    var coordinate: [Double]
    var region: MKCoordinateRegion
    var buildingImage: URL?
    var layoutImage: URL?
    
    init(id: Int, title: String, address: String, rent: Int, layout: String, age: String, station: String, detail: String, coordinate: [Double], buildingImage: String, layoutImage: String) {
        self.id = id
        self.title = title
        self.address = address
        self.rent = rent
        self.layout = layout
        self.age = age
        self.station = station
        self.detail = URL(string: detail)
        self.coordinate = coordinate
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: coordinate[1],
                                           longitude: coordinate[0]),
            latitudinalMeters: 300,
            longitudinalMeters: 300
        )
        self.buildingImage = URL(string: buildingImage)
        self.layoutImage = URL(string: layoutImage)
    }
    
}

struct Annotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    
    let screenHeight: Int = Int(UIScreen.main.bounds.height)
    let screenWidth: Int = Int(UIScreen.main.bounds.width)
    
    var annotations: [Annotation]{
        get{
            return [Annotation(coordinate: CLLocationCoordinate2D(latitude: rentInfo.coordinate[1],
                                                                  longitude: rentInfo.coordinate[0]))]
        }}
    
    @StateObject var rentInfo: Rent
    @GestureState var scaler = 1.0
    
    var scaleImage: some Gesture {
        MagnificationGesture()
            .updating($scaler) { currentState, gestureState, transaction in
                gestureState = currentState
            }
    }
    
    var body: some View {
        
        VStack{
            Text(rentInfo.title)
                .font(.title2)
                .bold()
            HStack(alignment: .top){
                Group{
                    AsyncImage(url: rentInfo.buildingImage) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .cornerRadius(12)
                    .scaleEffect(scaler)
                    .gesture(scaleImage)
                    
                    AsyncImage(url: rentInfo.layoutImage) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .cornerRadius(12)
                    .scaleEffect(scaler)
                    .gesture(scaleImage)
                }
                .frame(width: CGFloat(screenWidth-25)/2)
            }
            Spacer()
            VStack(alignment: .leading){
                HStack{
                    Text("\(rentInfo.layout)")
                    Text("\(String(format: "%.1f", Double(rentInfo.rent)*0.0001))万円")
                        .foregroundColor(.green)
                }
                .font(.title3)
                .bold()
                Text("住所: \(rentInfo.address)")
                Text("最寄駅: \(rentInfo.station)")
                Link("詳細", destination: rentInfo.detail!)
            }
            Map(coordinateRegion: $rentInfo.region,
                annotationItems: annotations,
                annotationContent: { (annotation) in
                MapAnnotation(coordinate: annotation.coordinate) {
                    VStack {
                        Image(systemName: "house.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.orange)
                    }
                }
            })
            .ignoresSafeArea()
            .frame(height: CGFloat(screenHeight * 2/5))
            .cornerRadius(12)
            .padding()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
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
        
        ContentView(rentInfo: rentExample)
    }
}
