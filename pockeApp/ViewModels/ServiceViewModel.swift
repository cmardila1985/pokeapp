//
//  ServiceViewModel.swift
//  pockeApp
//
//  Created by cristian manuel ardila troches on 30/04/23.
//


import Foundation
import Alamofire
import AlamofireObjectMapper

class ServiceViewModel : ObservableObject {
   // @Published var resultGalery = ResponseServiceList() //To use any change in the variable in another class or file
    @Published var isGettingData : Bool = true //To show the loading screen while the request is working
    @Published var validatedSuccesfly : Bool? = false //To Know if the result of the request is OK
    @Published var errorMessage : String?
    @Published var status : Int?
    @Published var listTypes : [Types] = []
    @Published var listAbilities : [Abilities] = []
    @Published var listMoves : [Moves] = []
    
    @Published var servicesCount : Int?
    var token =  UserDefaults.standard.string(forKey: Constants.DefaultsKeys.userToken) ?? ""
    func getServices (idPokemon : Int, page: Int){
        let url = URL(string: Constants.API.URL_LIST_POKEMONS + "\(idPokemon)")
        guard let requestUrl = url else { fatalError() }
       // let headers = ["Authorization" : "Bearer \(token)"]
        self.isGettingData = true
        Alamofire.request(requestUrl, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in

                if response.error != nil {
                    print("Error took place \(String(describing: response.error))")
                    return
                }
                
                guard let dataFromService = response.data,
                    let model : ResponsePokemonDetail = try? JSONDecoder().decode(ResponsePokemonDetail.self, from: dataFromService) else {
                    return
                }
                
                DispatchQueue.main.async { [self] in
                    
                    self.status = response.response?.statusCode
                    print(model)
                    if(response.response?.statusCode == 200){

                        self.listTypes  = []
                        self.listMoves = []
                        self.listAbilities = []
                        if(model.types.count > 0){

                            self.listTypes = model.types
                            self.listAbilities = model.abilities
                            self.listMoves = model.moves
                
                            self.validatedSuccesfly = true

                        }else{
                            self.listTypes = []
                            self.listAbilities = []
                            self.listMoves = []
                            self.servicesCount = 0
                        }
                        
                    }else{
                        self.validatedSuccesfly = false
                        self.listTypes = []
                        self.listAbilities = []
                        self.listMoves = []
                        self.servicesCount = 0
                    }
                     
                    self.isGettingData = false
                }
                
            }
        
    }

}


