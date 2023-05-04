//
//  Constants.swift
//  pockeApp
//
//  Created by cristian manuel ardila troches on 30/04/23.
//

import Foundation

struct Constants{
    
    static let BASE_URL =  "https://pokeapi.co/api/v2"
    static let IMAGE_URL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
    static let URLROOTPHP = "https://url"
    static let API_URL =    Constants.BASE_URL + "/"
    
    struct API {
        static let URL_LIST_POKEMONS =  API_URL + "pokemon/"
    }
    
    struct DefaultsKeys {
        static let userMail     =  "userMailKey"
        static let userToken    =  "userToken"
        static let userId       =  "userId"
        static let userName     =  "userName"
        static let vehicleId    =  "vehicleId"
        static let logged       =  "logged"
      
    }
    
}
