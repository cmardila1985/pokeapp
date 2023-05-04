//
//  ServiceListRowView.swift
//  pockeApp
//
//  Created by cristian manuel ardila troches on 1/05/23.
//

import SwiftUI
import SVGView

struct ServiceListRowView: View {
    var service : Forms
    @State private var show: Bool = false
    @Binding var itemClicked : Bool
    @Binding var selectedPokemon : Forms?
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 7, style: .continuous)
                .fill(Color.white)
            HStack(spacing : 15){
                //Constants.IMAGE_URL
                if service.name != nil {
                    AsyncImage(url: URL(string: "\(Constants.IMAGE_URL)\(getIdPokemon(inputString: service.url)).png")).scaledToFill().frame(width: 100).clipped()
                }else{
                    Image("CSLogo01").resizable().frame(width: 60, alignment: .leading).padding(5)
                }
                VStack(spacing : 0){
                    HStack{
                        Text("\(service.name)")
                            .font(.custom("Poppins-Bold", size: 16.0))
                            .lineLimit(show ? 10:2)
                            .foregroundColor(Color("TextDarkest"))
                            .frame(maxWidth: .infinity,alignment : .bottomLeading)
                            .padding(.vertical, show ? 10: 20)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        
                        
                    }
                    
                    
                }.padding(.vertical, 5).zIndex(1)
                
                
            }.background(Color("ModelListColor")).zIndex(1).onTapGesture {
                selectedPokemon = service
                itemClicked = true
            }.onLongPressGesture{
                
            }
            
        }.frame(maxWidth: .infinity, minHeight: 70)// .listRowBackground(Color("BackGround"))
            .padding(.bottom, -8).cornerRadius(5)
    }
}


func getIdPokemon(inputString: String) -> Int{
    
    let target: String = "pokemon"
    let endingIndex = 0
    let startingIndex = 0
    if let range = inputString.range(of: target) {
        let startingIndex = inputString.distance(from: inputString.startIndex, to: range.lowerBound)
        let endingIndex = inputString.distance(from: inputString.startIndex, to: range.upperBound)
        let start = inputString.index(inputString.startIndex, offsetBy: endingIndex+1)
        let end = inputString.index(inputString.startIndex, offsetBy: inputString.count-2)
        let range2 = start...end
        let newString = String(inputString[range2])
        return Int(newString)!
    } else {
        return 0
    }
    
    return 1
}

