//
//  ResponseLogin.swift
//  pockeApp
//
//  Created by cristian manuel ardila troches on 2/05/23.
//


import Foundation

struct ResponseLogin: Codable {
    // MARK: - Properties
    let refreshToken:String?
    let accessToken:String?
    let message: String?
    let timestamp: String?
    let path: String?
    let statusCode: Int?
    let email: String?
    let name: String?
    let displayName: String?
    var userId: Int?
    var languageId:Int?
    var token:String?
    var tokenApp:String?
    var active:Bool?
    var accountId: Int?
    var employeeId: Int?
    var vehicleId: Int?
    /*var profileIds: [Int]?
    var permissionIds: [Int]?
    var officeIds: [Int]?
    var clientIds: [Int]?
    var storeIds: [Int]?
    var zoneIds: [Int]?*/
    
    
    
    // MARK: - Codable
    // Coding Keys
    enum CodingKeys: String, CodingKey {
        
        case refreshToken = "refreshToken"
        case accessToken = "accessToken"
        case message
        case timestamp
        case path
        case statusCode
        case user = "user"
         
    }
    
    enum UserCodingKeys: String, CodingKey{
        case email          = "email"
        case name           = "name"
        case displayName    = "displayName"
        case userId         = "userId"
        case languageId     = "languageId"
        case token          = "token"
        case tokenApp       = "tokenApp"
        case active         = "active"
        case accountId      = "accountId"
        case employeeId     = "employeeId"
        case vehicleId      = "vehicleId"
        /*case profileIds: [Int]?
        case permissionIds: [Int]?
        case officeIds: [Int]?
        case clientIds: [Int]?
        case storeIds: [Int]?
        case zoneIds: [Int]?*/
    }
    // Decoding
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
         
        if let refreshToken =  try container.decodeIfPresent(String.self, forKey: .refreshToken) {
            self.refreshToken = refreshToken
        }else {
            self.refreshToken = "N/A"
        }
        
        if let accessToken =  try container.decodeIfPresent(String.self, forKey: .accessToken) {
            self.accessToken = accessToken
        }else {
            self.accessToken = "N/A"
        }
        
        if let message =  try container.decodeIfPresent(String.self, forKey: .message) {
            self.message = message
        }else {
            self.message = "N/A"
        }
        
        if let timestamp =  try container.decodeIfPresent(String.self, forKey: .timestamp) {
            self.timestamp = timestamp
        }else {
            self.timestamp = "N/A"
        }
        
        if let path =  try container.decodeIfPresent(String.self, forKey: .path) {
            self.path = path
        }else {
            self.path = "N/A"
        }
        
        if let statusCode =  try container.decodeIfPresent(Int.self, forKey: .statusCode) {
            self.statusCode = statusCode
        }else {
            self.statusCode = 200
        }
        
        if container.allKeys.contains(.user) == true {
            let user    = try container.nestedContainer(keyedBy: UserCodingKeys.self, forKey: .user)
            email       = try user.decode(String.self, forKey: .email)
            name        = try user.decode(String.self, forKey: .name)
            displayName = try user.decode(String.self, forKey: .displayName)
            userId      = try user.decode(Int.self, forKey: .userId)
            languageId  = try user.decode(Int.self, forKey: .languageId)
            token       = try user.decode(String.self, forKey: .token)
            tokenApp    = try user.decode(String.self, forKey: .tokenApp)
            active      = try user.decode(Bool.self, forKey: .active)
            accountId   = try user.decode(Int.self, forKey: .accountId)
            employeeId  = try user.decode(Int.self, forKey: .employeeId)
            vehicleId   = try user.decode(Int.self, forKey: .vehicleId)
            
       
        }else{
            print(" Decodificando el detalle del usuario ")
            email = "N/A"
            name = "N/A"
            displayName = "N/A"
        }
         
    }
    // Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
        try container.encode(message, forKey: .timestamp)
        try container.encode(message, forKey: .path)
        
        
        var user = container.nestedContainer(keyedBy: UserCodingKeys.self, forKey: .user)
        try user.encode(email, forKey: .email)
        try user.encode(name, forKey: .name)
        try user.encode(displayName, forKey: .displayName)
       
    }
}

