//
//  ListServicesView.swift
//
//  Created by cristian manuel ardila troches on 9/01/23.
//
//

import SwiftUI
import SVGView
import ListPagination
// import ImagePickerView
import Foundation
import Combine


struct ListServicesView: View {
    
    //Data Core Offline
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var todoItems: FetchedResults<Services>
    @ObservedObject var monitor = NetworkMonitor()
    @State private var showAlertSheet = false
    
    @ObservedObject var servicesModel = ServiceObservableObject()
    @ObservedObject var serviceObs = ServiceObservableObject()
    @Binding var showToolbar : Bool
   // @ObservedObject  var servicesModel =  ServiceViewModel()
  //  @ObservedObject var validateModel = ValidateModelViewModel()
    @State var search :String = ""
    @State var isReady : Bool = false
    @State var services : [Forms]?
    @State var contractCount : Int = 0
    @State var itemClicked: Bool = false
    @State var itemClicked2 : Bool = false
    @State var selectedPokemon : Forms?
    
   // @State var selectedContrac : ServiceModel?
    @Binding var show : Bool
   
    @State var dislog = false
  //  @Binding var link : linkedView
    @State var hasObjectType : Int = 0
    @Binding var currentView : String
  //
    @Environment(\.colorScheme) var colorScheme
    let defaults = UserDefaults.standard
    var tokenCurrent: String = ""
    
    init(showToolbar: Binding<Bool>, show: Binding<Bool>, currentView: Binding<String>) {
        
        self._showToolbar = showToolbar
        self._show = show
        self._currentView = currentView
        UITableView.appearance().separatorStyle = .none

        UITableViewCell.appearance().backgroundColor = UIColor(Color("BackGround"))
        UITableView.appearance().backgroundColor = UIColor(Color("BackGround"))
        UITableView.appearance().contentInset.top = -35
         
        tokenCurrent = ""//defaults.value(forKey: Constants.DefaultsKeys.userToken) as! String
        servicesModel.fetchMembers()
    }
    
 
    /// Add a new item
    private func addItem() {
        /*presentTextInputAlert(title: "Agrega un nuevo Pokémon", message: "Ingresa su nombre") { name in
            let newPokemon = Services(context: viewContext)
            newPokemon.name = name
            try? viewContext.save()
        }*/
        //let newPokemon = Services(context: viewContext)
        /*print("REMOVER LOS POKEMONES")
        print(todoItems.count)
        let newPokemon = Services(context: viewContext)
        newPokemon.name = "bulbasaur"
        newPokemon.url = "bulbasaur"
        print("VALIDANDO EL POKE ON OK")
        print(todoItems)*/
        //context.del(data)
       // print( todoItems.elementsEqual(Sequence))
       
       /* let fetchRequest = Services.fetchRequest()

            // Perform Fetch Request
           viewContext.perform {
                do {
                    // Execute Fetch Request
                    let result = try fetchRequest.execute()
                    
                    fetchRequest.predicate = NSPredicate(format: "name = %@", newPokemon)
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
                    // Update Books Label
                    print("\(result.count) Books")
                    print("\(fetchRequest) pokemon")
                    var fetchedSongs = try viewContext.fetch(fetchRequest)
                    print(fetchedSongs)

                } catch {
                    print("Unable to Execute Fetch Request, \(error)")
                }
            }*/
        
        if  servicesModel.listServicesCurrent.count > 0 {
            
            for pokemon in servicesModel.listServicesCurrent {
                
                 
                let newPokemon = Services(context: viewContext)
                newPokemon.name = pokemon.name
                newPokemon.url = pokemon.url
                try? viewContext.save()
            }
            
        }

    }
    
    var body: some View {
        NavigationView{
            ZStack{
              
                ZStack{
                    VStack{
                       /*Button(action: addItem, label: {
                           Image(systemName: "plus")
                       })*/
                        /*HStack{
                            Spacer()
                            Text("list_services_text1").font(.custom("Poppins-Bold", size: 25.0)).foregroundColor(!servicesModel.isGettingData&&(servicesModel.status != 401)||isReady ? .white:Color("GaleryTitleColor")).frame(maxHeight: .infinity, alignment: .bottom).padding(.bottom,15)
                            Spacer()
                        }
                        .zIndex(2.0).frame(height: 115).background(!servicesModel.isGettingData&&(servicesModel.status != 401)||isReady  ? Color("BlueHeader"):Color("SkeletonHeader")).cornerRadius(10).offset(x: 0, y: -50).padding(.bottom,-70).redacted(reason: !servicesModel.isGettingData&&(servicesModel.status != 401)||isReady  ? []:.placeholder)*/
                        ZStack{
                            Rectangle().frame(maxWidth: .infinity, maxHeight: 55, alignment: .center).foregroundColor(Color("BackGroundSearch")).cornerRadius(10)
                            HStack{
                                Spacer()
                                Image(systemName: "magnifyingglass").font(.system(size: 15)).padding(.leading, 5).foregroundColor( search != "" ? Color("SearchGlassSelected"):Color("SearchGlass"))
                                TextField("list_services_text2", text: $search)
                                    .onChange(of: search) { location in
                                        
                                        if(location.isEmpty){
                                            servicesModel.fetchMembers()
                                        }
                                                   
                                    }
                                    .font(.custom("Poppins-Regular", size: 13.0))
                                    .foregroundColor(Color("TextDarkest"))
                                
                                if search != ""{
                                    Button(action: {
                                        search = ""
                                    }, label: {
                                        Image(systemName: "xmark").font(.system(size: 15)).padding(.leading, 5).foregroundColor( search != "" ? Color("ColorSearchFixed"):Color("ColorSearchNotFixed")).padding(.trailing, 5)
                                    })
                                    
                                }
                                
                                Spacer()
                            }.padding(.top,10)
                        }.zIndex(1.0).padding(.bottom,10).redacted(reason:  !servicesModel.isGettingData&&(servicesModel.status != 401)||isReady ? []:.placeholder)
                       
                        if !servicesModel.isGettingData  {
                            
                            if servicesModel.status == 200{
                                
                                if !monitor.isConnected {
                                    
                                    if(todoItems.count > 0){
                                        Text("Sin conexión a internet (Off line)")
                                        List {
                                            ForEach(todoItems) { item in
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 7, style: .continuous)
                                                        .fill(Color.white)
                                                    HStack(spacing : 15){
                                                        //Constants.IMAGE_URL
                                                        if item.name != nil {
                                                            AsyncImage(url: URL(string: "\(Constants.IMAGE_URL)\(getIdPokemon(inputString: item.url!)).png")).scaledToFill().frame(width: 100).clipped()
                                                        }else{
                                                            Image("CSLogo01").resizable().frame(width: 60, alignment: .leading).padding(5)
                                                        }
                                                        VStack(spacing : 0){
                                                            HStack{
                                                                Text("\(item.name ?? "No Name")")
                                                                    .font(.custom("Poppins-Bold", size: 16.0))
                                                                    .lineLimit(show ? 10:2)
                                                                    .foregroundColor(Color("TextDarkest"))
                                                                    .frame(maxWidth: .infinity,alignment : .bottomLeading)
                                                                    .padding(.vertical, show ? 10: 20)
                                                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                                                
                                                                
                                                                
                                                            }
                                                            
                                                            
                                                        }.padding(.vertical, 5).zIndex(1)
                                                        
                                                        
                                                    }.background(Color("ModelListColor")).zIndex(1).onTapGesture {
                                                       // selectedPokemon = service
                                                        itemClicked = true
                                                    }.onLongPressGesture{
                                                        
                                                    }
                                                    
                                                }.frame(maxWidth: .infinity, minHeight: 70)// .listRowBackground(Color("BackGround"))
                                                    .padding(.bottom, -8).cornerRadius(5)
                                                /*Label(item.name ?? "No Name", systemImage: "circle.fill")
                                                    .frame(maxWidth: .infinity, alignment: .leading).contentShape(Rectangle())
                                                    .onTapGesture {
                                                        
                                                    }*/
                                            }
                                        }
                                    }
                                }else{
                                    Text("Con conexión a internet (On line)")
                                    listOfServices(
                                                   search: $search,
                                                   itemClicked: $itemClicked2,
                                                   selectedPokemon: $selectedPokemon
                                                  ).onAppear(){
                                        // services = servicesModel.services!
                                         isReady = true
                                         
                                     }
                                    
                                }
                                
                                
                                
                             
                            }else{
                                Text("").onAppear(){
                                    let defaults = UserDefaults.standard
                                    defaults.set(false, forKey: Constants.DefaultsKeys.userToken)
                                    dislog = true
                                }.alert(isPresented: $dislog) {
                                    Alert(title: Text("list_text26"), message: Text("list_text27"), dismissButton: .default(Text("Ok")){
                                      //  link = .login2
                                    })
                                }
                            }
                        }else if servicesModel.isGettingData{
                          
                            if  servicesModel.listServicesCurrent.count > 0 {
                                
                                
                                listOfServices(
                                               search: $search,
                                               itemClicked: $itemClicked2,
                                               selectedPokemon: $selectedPokemon
                                               ).onAppear(){
                                     isReady = true
                                 }
                            }else{
                                ScrollView{
                                    HStack{
                                        Image("CSLogo01").resizable().frame(width: 60,height: 120).foregroundColor(Color("ColorSearchNotFixed")).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder)
                                        VStack{
                                            Image("CSLogo01").resizable().frame(maxWidth: .infinity, maxHeight: 25).foregroundColor(Color("ColorSearchNotFixed")).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder).padding(.horizontal,15)
                                            Text("Este es un servicio que tiene un").foregroundColor(Color("ColorSearchNotFixed")).frame(maxWidth: .infinity).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder)
                                            Text("Este es un servicio que tiene un").foregroundColor(Color("ColorSearchNotFixed")).frame(maxWidth: .infinity).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder)
                                        }.frame(maxWidth: .infinity,maxHeight: 120)
                                    }.cornerRadius(5).background(Color("ModelListColor")).frame(height: 120).padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                    HStack{
                                        Image("CSLogo01").resizable().frame(width: 60,height: 120).foregroundColor(Color("ColorSearchNotFixed")).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder)
                                        VStack{
                                            Image("CSLogo01").resizable().frame(maxWidth: .infinity, maxHeight: 25).foregroundColor(Color("ColorSearchNotFixed")).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder).padding(.horizontal,15)
                                            Text("Este es un servicio que tiene un").foregroundColor(Color("ColorSearchNotFixed")).frame(maxWidth: .infinity).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder)
                                            Text("Este es un servicio que tiene un").foregroundColor(Color("ColorSearchNotFixed")).frame(maxWidth: .infinity).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder)
                                        }.frame(maxWidth: .infinity,maxHeight: 120)
                                    }.cornerRadius(5).background(Color("ModelListColor")).frame(height: 120).padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                    HStack{
                                        Image("CSLogo01").resizable().frame(width: 60,height: 120).foregroundColor(Color("ColorSearchNotFixed")).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder)
                                        VStack{
                                            Image("CSLogo01").resizable().frame(maxWidth: .infinity, maxHeight: 25).foregroundColor(Color("ColorSearchNotFixed")).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder).padding(.horizontal,15)
                                            Text("Este es un servicio que tiene un").foregroundColor(Color("ColorSearchNotFixed")).frame(maxWidth: .infinity).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder)
                                            Text("Este es un servicio que tiene un").foregroundColor(Color("ColorSearchNotFixed")).frame(maxWidth: .infinity).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder)
                                        }.frame(maxWidth: .infinity,maxHeight: 120)
                                    }.cornerRadius(5).background(Color("ModelListColor")).frame(height: 120).padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                    HStack{
                                        Image("CSLogo01").resizable().frame(width: 60,height: 120).foregroundColor(Color("ColorSearchNotFixed")).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder)
                                        VStack{
                                            Image("CSLogo01").resizable().frame(maxWidth: .infinity, maxHeight: 25).foregroundColor(Color("ColorSearchNotFixed")).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder).padding(.horizontal,15)
                                            Text("Este es un servicio que tiene un").foregroundColor(Color("ColorSearchNotFixed")).frame(maxWidth: .infinity).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder)
                                            Text("Este es un servicio que tiene un").foregroundColor(Color("ColorSearchNotFixed")).frame(maxWidth: .infinity).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder)
                                        }.frame(maxWidth: .infinity,maxHeight: 120)
                                    }.cornerRadius(5).background(Color("ModelListColor")).frame(height: 120).padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                    HStack{
                                        Image("CSLogo01").resizable().frame(width: 60,height: 120).foregroundColor(Color("ColorSearchNotFixed")).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder)
                                        VStack{
                                            Image("CSLogo01").resizable().frame(maxWidth: .infinity, maxHeight: 25).foregroundColor(Color("ColorSearchNotFixed")).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder).padding(.horizontal,15)
                                            Text("Este es un servicio que tiene un").foregroundColor(Color("ColorSearchNotFixed")).frame(maxWidth: .infinity).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder)
                                            Text("Este es un servicio que tiene un").foregroundColor(Color("ColorSearchNotFixed")).frame(maxWidth: .infinity).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder)
                                        }.frame(maxWidth: .infinity,maxHeight: 120)
                                    }.cornerRadius(5).background(Color("ModelListColor")).frame(height: 120).padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                    HStack{
                                        Image("CSLogo01").resizable().frame(width: 60,height: 120).foregroundColor(Color("ColorSearchNotFixed")).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder)
                                        VStack{
                                            Image("CSLogo01").resizable().frame(maxWidth: .infinity, maxHeight: 25).foregroundColor(Color("ColorSearchNotFixed")).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder).padding(.horizontal,15)
                                            Text("Este es un servicio que tiene un").foregroundColor(Color("ColorSearchNotFixed")).frame(maxWidth: .infinity).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder)
                                            Text("Este es un servicio que tiene un").foregroundColor(Color("ColorSearchNotFixed")).frame(maxWidth: .infinity).redacted(reason:  !servicesModel.isGettingData&&servicesModel.status != 401 ? []:.placeholder)
                                        }.frame(maxWidth: .infinity,maxHeight: 120)
                                    }.cornerRadius(5).background(Color("ModelListColor")).frame(height: 120).padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                    
                                }
                            }
                        }
                        Spacer()
                    }.navigationBarHidden(true)
                    
                }.onAppear(){
                    showToolbar = true
                    servicesModel.fetchMembers()
                    addItem()
                }
                
               
            }.onAppear(){
               currentView = "default"
                showToolbar = true
               
            }
            .navigationBarHidden(true)
        }.navigationBarBackButtonHidden(true).navigationViewStyle(.stack)
    }
}

struct listOfServices: View {
    @Binding var search : String
    @Binding var itemClicked : Bool
    @Binding var selectedPokemon: Forms?
   // @Binding var show: Bool
    @State var collapse = false
    @State var show2 = false
    @ObservedObject var serviceObs = ServiceObservableObject()
    @Environment(\.managedObjectContext) private var viewContext
  //  @ObservedObject  var servicesModel =  ServiceViewModel()
    var body: some View {
        
        if(itemClicked){
               Text("").fullScreenCover(isPresented: $itemClicked, content: {
                   PokemonDetailView(showToolbar: $show2, selectedPokemon: $selectedPokemon, pokemonUrl: selectedPokemon!.url)
               }
            )
        }
        

        //NavigationView {
            List {
                
                ForEach(serviceObs.members) { item in
                    
                    if search != "" {
                        
                        if item.name.lowercased().description.contains(search.lowercased()) {
                            
                            ServiceListRowView(
                                service: item,
                                //show: $collapse,
                                itemClicked: $itemClicked,
                                selectedPokemon: $selectedPokemon
                            )
                        }
                        
                    }else{
                        
                       // ProgressView()
                        ServiceListRowView(
                            service: item,
                            //show: $collapse,
                            itemClicked: $itemClicked,
                            selectedPokemon: $selectedPokemon
                        )
                    }
                }
                
                if serviceObs.membersListFull == false || serviceObs.listServicesCurrent.count > 0 {
                    ProgressView()
                    .onAppear {
                        serviceObs.fetchMembers()
                    }
                }
            }.simultaneousGesture(DragGesture().onChanged({ _ in
                if serviceObs.membersListFull == true {
                    serviceObs.fetchMembers()
                }
            }))
    }
}

