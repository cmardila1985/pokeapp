//
//  ResponsePokemonDetail.swift
//  pockeApp
//
//  Created by cristian manuel ardila troches on 4/05/23.
//

import Foundation

struct ResponsePokemonDetail: Codable {

    let types: [Types]
    let abilities: [Abilities]
    let moves : [Moves]
    
    enum CodingKeys: String, CodingKey {
        case types = "types"
        case abilities = "abilities"
        case moves = "moves"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if container.allKeys.contains(.types) == true {
            self.types = try container.decode(Array.self, forKey: .types)
       
        }else{
            self.types = []
        }
        
        if container.allKeys.contains(.abilities) == true {
            self.abilities = try container.decode(Array.self, forKey: .abilities)
       
        }else{
            self.abilities = []
        }
        
        
        if container.allKeys.contains(.moves) == true {
            self.moves = try container.decode(Array.self, forKey: .moves)
        }else{
            self.moves = []
        }
        
    }
     
  func encode(to encoder: Encoder) throws {
   }
}

struct Abilities: Codable{
    let slot: Int
    let type: TypeDetail
    
    enum CodingKeys: String, CodingKey {
      case slot = "slot"
      case type = "ability"
        
    }
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.slot = try container.decode(Int.self, forKey: .slot)
      self.type = try container.decode(TypeDetail.self, forKey: .type)
        
    }
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(self.slot, forKey: .slot)
      try container.encode(self.type, forKey: .type)
    }
}

struct Types: Codable{
    let slot: Int
    let type: TypeDetail
    
    enum CodingKeys: String, CodingKey {
      case slot = "slot"
      case type = "type"
    }
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.slot = try container.decode(Int.self, forKey: .slot)
      self.type = try container.decode(TypeDetail.self, forKey: .type)
        
    }
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(self.slot, forKey: .slot)
      try container.encode(self.type, forKey: .type)
    }
}

struct Moves: Codable{
   // let slot: Int
    let move: TypeDetail
    let id = UUID()
    
    enum CodingKeys: String, CodingKey {
    //  case slot = "slot"
      case move = "move"
    }
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      //self.slot = try container.decode(Int.self, forKey: .slot)
      self.move = try container.decode(TypeDetail.self, forKey: .move)
        
    }
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
     //   try container.encode(self.slot, forKey: .slot)
      try container.encode(self.move, forKey: .move)
    }
}



struct TypeDetail: Codable{
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
 




 

