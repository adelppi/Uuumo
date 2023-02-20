//
//  ChatView.swift
//  Uuumo
//
//  Created by Adeel Baig on 2023/02/02.
//

import SwiftUI
import OpenAISwift

final class ViewModel: ObservableObject{
    init(){}
    
    private var client: OpenAISwift?
    
    func setup(){
        client = OpenAISwift(authToken: "~~~~~~~ APIキー ~~~~~~~")
    }
    
    func send(text: String,
              completion: @escaping (String) -> Void){
        client?.sendCompletion(with: text,
                               maxTokens: 250,
                               completionHandler: {result in
            switch result{
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                completion(output)
            case .failure:
                break
            }
        })
    }
    
}

struct ChatView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var models = [String]()
    
    var body: some View {
        VStack(){
            ForEach(models, id: \.self){ string in
                if string.contains("ChatGPT:"){
                    HStack{
                        Text(string.replacingOccurrences(of: "ChatGPT:", with: ""))
                            .foregroundColor(.black)
                            .padding()
                            .background(.gray.opacity(0.2))
                            .cornerRadius(10)
                        Spacer()
                    }
                }else{
                    HStack{
                        Spacer()
                        Text(string)
                            .foregroundColor(.white)
                            .padding()
                            .background(.orange)
                            .cornerRadius(10)
                    }
                }
            }
            
            Spacer()
            
            HStack{
                TextField("AIに聞いてみよう", text: $text)
                    .padding(7.5)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.gray).opacity(0.2)))
                Button("送信"){
                    send()
                    print(models)
                }
            }
        }
        .onAppear{
            viewModel.setup()
        }
        .padding()
    }
    
    func send(){
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        
        models.append("\(text)")
        viewModel.send(text: text){ response in
            DispatchQueue.main.async{
                self.models.append("ChatGPT:" + response.replacingOccurrences(of: "\n", with: ""))
                self.text = ""
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
