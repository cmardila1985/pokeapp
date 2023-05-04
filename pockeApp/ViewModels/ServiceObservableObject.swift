//
//  ServiceObservableObject.swift
//  pockeApp
//
//  Created by cristian manuel ardila troches on 30/04/23.
//


import Foundation
import Combine

class ServiceObservableObject: ObservableObject {
    @Published var members = [Forms]()
    @Published var listServicesCurrent = [Forms]()
    @Published var isGettingData : Bool = true //To show the loading screen while the request is working
    @Published var validatedSuccesfly : Bool? = false //To Know if the result of the request is OK
    @Published var errorMessage : String?
    @Published var status : Int?
    @Published var totalServices : Int?
    // Tells if all records have been loaded. (Used to hide/show activity spinner)
    var membersListFull = false
    // Tracks last page loaded. Used to load next page (current + 1)
    var currentPage = 0
    // Limit of records per page. (Only if backend supports, it usually does)
    let perPage = 8
    private var cancellable: AnyCancellable?
    private var token =  UserDefaults.standard.string(forKey: Constants.DefaultsKeys.userToken) ?? ""
    private var userId =  UserDefaults.standard.string(forKey: Constants.DefaultsKeys.userId) ?? ""
    
    func fetchMembers() {
        
        let currentPageAdd = currentPage+1
        let url = URL(string: Constants.API.URL_LIST_POKEMONS + "?limit=\(perPage)&offset=\((currentPageAdd - 1)*10)")!
        var request =  URLRequest(url:url)
        let session = URLSession.shared
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        self.isGettingData = true
        cancellable = session.dataTaskPublisher(for: request)
            .tryMap {
                $0.data
            }
            .decode(type: ResponsePokemonList.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { (error) in
                print("Service request failed: \(String(describing: error))")
            }, receiveValue: { (result) in
                
                DispatchQueue.main.async { [self] in
                    self.status = 200
                    self.listServicesCurrent = result.results
                    self.currentPage += 1
                    self.members.append(contentsOf: result.results)
                    // If count of data received is less than perPage value then it is last page.
                    //self.status = result.statusCode
                    if result.results.count < self.perPage {
                        self.totalServices = result.count
                        self.validatedSuccesfly = true
                        self.membersListFull = true
                       
                    }else{
                        self.totalServices =  result.count
                        self.validatedSuccesfly = false
                    }
                }
                
                DispatchQueue.main.async { [self] in
                    self.isGettingData = false
                }
                
            }
        )
    }
}

 
