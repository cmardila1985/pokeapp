//
//  PokemonDetailView.swift
//  pockeApp
//
//  Created by cristian manuel ardila troches on 3/05/23.
//
import SwiftUI

struct PokemonDetailView: View {
    @ObservedObject  var servicesModel =  ServiceViewModel()
    @Binding var selectedPokemon : Forms?
    @State var pokemonUrl = ""
    @State var isUpdate : Bool?
   // @ObservedObject  var modelView =  ModelViewModel()
    @State var isReady : Bool = false
    @State var isAnyError = false
    @State var titleAlert = ""
    @State var loginText1 = ""
    @Binding var showToolbar : Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    
    init(showToolbar: Binding<Bool>, selectedPokemon: Binding<Forms?>, pokemonUrl: String) {
        
        self._showToolbar = showToolbar
        self._selectedPokemon = selectedPokemon
        UITableView.appearance().separatorStyle = .none

        UITableViewCell.appearance().backgroundColor = UIColor(Color("BackGround"))
        UITableView.appearance().backgroundColor = UIColor(Color("BackGround"))
        UITableView.appearance().contentInset.top = -35

        servicesModel.getServices(idPokemon: getIdPokemon(inputString: pokemonUrl), page: 1)
    }
    
    var body: some View {
        ZStack{
            Color("BackGround")
            VStack{
                HStack{
                    Button(action: {
                        showToolbar = true

                        UIView.setAnimationsEnabled(true)
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        if colorScheme != .light{
                            Image("backButtonIconWhite").resizable().frame(width: 30, height: 30, alignment: .top)
                        }else{
                            Image("backButtonIcon").resizable().frame(width: 30, height: 30, alignment: .top)
                        }
                    }).padding(.horizontal,15)
                    Spacer()
                  
                }.frame(height: 50).background(Color("ModelListColor"))
                
                 
                    ZStack{
                         
                        VStack{
                            containerImgPokemon(servicesModel: servicesModel, selectedPokemon: selectedPokemon)
                           
                            .padding(EdgeInsets(top: 20, leading: 27, bottom: 0, trailing: 27))
                        }.alert(isPresented: $isAnyError) {
                            Alert(title: Text(titleAlert), message: Text(loginText1), dismissButton: .default(Text("Ok")))
                        }
                    }.padding(EdgeInsets(top: -20, leading: 0, bottom: 0, trailing: 0))
             
                
                
                if !servicesModel.isGettingData  {
                    
                    if servicesModel.status == 200{
                        
                        if(servicesModel.listTypes.count > 0){
                            Text("Tipo")
                            List(servicesModel.listTypes ,id : \.slot){  type in
                                Text("\(type.type.name)")
                            }
                        }
                        
                        if(servicesModel.listAbilities.count > 0){
                            Text("Habilidades")
                            List(servicesModel.listAbilities ,id : \.slot){  type in
                                Text("\(type.type.name)")
                            }
                        }
                        
                        
                        if(servicesModel.listMoves.count > 0){
                            Text("Movimientos")
                            List(servicesModel.listMoves ,id:  \.id){  type in
                                Text("\(type.move.name)")
                            }
                        }
                        
                    }
                    
                }
                
                Spacer()
            }
        } .navigationBarHidden(true)
            .navigationBarBackButtonHidden(false)
    }
}

struct containerImgPokemon : View {
    @ObservedObject  var servicesModel =  ServiceViewModel()
    @State var selectedPokemon : Forms?
    let text1:LocalizedStringKey = "text1"
    let text2ModelDetail:LocalizedStringKey = "text2_model_detail"
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 7, style: .continuous)
                .fill(Color("ModelListColor"))
            VStack{
                
                Text("Quien es ese Pokémon?")
                    .fontWeight(.heavy)
                    .font(.custom("Poppins-Bold", size: 17.0))
                    .foregroundColor(Color("TextDarkest"))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding(EdgeInsets(top: -100, leading: 23, bottom: 0, trailing: 23))
                
                
                AsyncImage(url: URL(string: "\(Constants.IMAGE_URL)\(getIdPokemon(inputString: selectedPokemon!.url)).png"))
                   // .scaledToFill().frame(width: 300).clipped()
               // Image("iconFolder")
                    .scaledToFill().frame(width: 150, height: 150, alignment: .center).padding(.top,-50)
                VStack(alignment: .center){
                    
                    Text("Es \(selectedPokemon!.name)")
                        .fontWeight(.light)
                        .lineSpacing(4)
                        .font(.body)
                        .font(.custom("Poppins-Bold", size: 17.0))
                        .foregroundColor(Color("TextDarkest"))
                        .padding(EdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 30))
                        .fixedSize(horizontal: false, vertical: true)
                    
                }
                 
            }.padding(.top,148)
            
        }
        
    }
    
}
 
