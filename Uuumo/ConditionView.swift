//
//  ConditionView.swift
//  Uuumo
//
//  Created by Adeel Baig on 2023/01/31.
//

import SwiftUI


struct ConditionView: View {
    
    let walkDistanceList: [String] = ["1分以内", "5分以内", "7分以内", "10分以内", "15分以内", "20分以内", "指定しない"]
    let layoutList: [String] = ["ワンルーム", "1K", "1DK", "1LDK", "2K", "2DK", "2LDK", "3K", "3DK", "3LDK", "4K", "4DK", "4LDK", "5K以上"]
    
    @State var city: String = ""
    @State var walkDistanceSelection: String = "指定しない"
    @State var rentUpperSelection: Int = 200000
    @State private var layoutSelection: Set<String> = []
    
    
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
    
    
    var conditionURL: String{
        get{
            return "https://18e5-2400-2410-a121-7300-887b-254a-c1a0-e5ec.jp.ngrok.io/rents/?city=\(city)&layout=\(layoutSelection.description)&rent=\(String(rentUpperSelection))&walkDistance=\(walkDistanceSelection)"
                .addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!
        }
    }
    var body: some View {
        NavigationStack{
            ZStack{
                Color.white
                    .ignoresSafeArea()
                Group{
                    VStack{
                        VStack(alignment: .leading){
                            Text("条件を絞る")
                                .padding(.bottom, 10)
                                .font(.title)
                                .bold()
                            Text("市区町村")
                                .font(.caption)
                                .foregroundColor(.gray)
                            TextField("例: 新宿区", text: $city)
                                .frame(width: 250, height: 50)
                                .padding(.leading, 10)
                                .textFieldStyle(PlainTextFieldStyle())
                                .keyboardType(.default)
                                .background(Color.white)
                                .cornerRadius(2.5)
                                .overlay(RoundedRectangle(cornerRadius: 2.5).stroke(Color(.orange)))
                        }
                        VStack(alignment: .leading){
                            Text("家賃上限")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Picker("rentUpper", selection: $rentUpperSelection){
                                ForEach(3..<50){ i in
                                    Text("\(i)万円").tag(i * 10000)
                                }
                            }
                            .frame(width: 250, height: 50)
                            .padding(.leading, 10)
                            .cornerRadius(2.5)
                            .overlay(RoundedRectangle(cornerRadius: 2.5).stroke(Color(.orange)))
                        }
                        VStack(alignment: .leading){
                            Text("駅徒歩")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Picker("walkDictance", selection: $walkDistanceSelection){
                                ForEach(0 ..< walkDistanceList.count, id: \.self){ i in
                                    Text(walkDistanceList[i]).tag(walkDistanceList[i])
                                }
                            }
                            //                            .pickerStyle(.inline)
                            .frame(width: 250, height: 50)
                            .padding(.leading, 10)
                            .cornerRadius(2.5)
                            .overlay(RoundedRectangle(cornerRadius: 2.5).stroke(Color(.orange)))
                        }
                        VStack(alignment: .leading){
                            Text("間取り")
                                .font(.caption)
                                .foregroundColor(.gray)
                            List(selection: $layoutSelection){
                                ForEach(0 ..< layoutList.count, id: \.self){ i in
                                    Text(layoutList[i]).tag(layoutList[i])
                                }
                            }
                            .listStyle(.plain)
                            .frame(width: 250, height: 175)
                            .padding(.leading, 10)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                            .cornerRadius(2.5)
                            .overlay(RoundedRectangle(cornerRadius: 2.5).stroke(Color(.orange)))
                            .environment(\.editMode, .constant(.active))
                            
                        }
                        .padding(.bottom, 14)
                        
                        HStack{
                            NavigationLink{
                                ChatView()
                            }label:{
                                Image("robot")
                                    .resizable()
                                    .frame(width: 62.5, height: 62.5)
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(.orange)
                                    .cornerRadius(10)
                            }
                            NavigationLink{
                                QualifiedView(conditionURL: conditionURL)
                            }label:{
                                Text("検索")
                                    .font(.title)
                                    .bold()
                                    .frame(width: 140, height: 62.5)
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(.orange)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ConditionView_Previews: PreviewProvider {
    static var previews: some View {
        ConditionView()
    }
}
