//
//  ResponseServiceList.swift
//  pockeApp
//
//  Created by cristian manuel ardila troches on 30/04/23.
//

import Foundation

struct ResponsePokemonList: Codable {

    let next: String?
    let previous: String?
    let count: Int
    let results: [Forms]
    
    enum CodingKeys: String, CodingKey {
        case next
        case previous
        case count
        case results = "results"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let next =  try container.decodeIfPresent(String.self, forKey: .next) {
            self.next = next
        }else {
            self.next = "N/A"
        }
        
        if let previous =  try container.decodeIfPresent(String.self, forKey: .previous) {
            self.previous = previous
        }else {
            self.previous = "N/A"
        }
        
        if let count =  try container.decodeIfPresent(Int.self, forKey: .count) {
            self.count = count
        }else {
            self.count = 0
        }
        
        if container.allKeys.contains(.results) == true {
            self.results = try container.decode(Array.self, forKey: .results)
       
        }else{
            self.results = []
        }
        
        
    }

  func encode(to encoder: Encoder) throws {
    /*var container = encoder.container(keyedBy: CodingKeys.self)
    var response = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
    try response.encode(self.bar, forKey: .bar)
    try response.encode(self.baz, forKey: .baz)
    try response.encode(self.friends, forKey: .friends)*/
   }
}

struct Forms: Codable{
    let name: String
    let url: String
    enum CodingKeys: String, CodingKey {
      case name = "name"
      case url = "url"
    }
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.name = try container.decode(String.self, forKey: .name)
      self.url = try container.decode(String.self, forKey: .url)
    }
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(self.name, forKey: .name)
      try container.encode(self.url, forKey: .url)
    }
}

struct FormsMap: Codable{
    var name : String
    var url  : String
}




 

