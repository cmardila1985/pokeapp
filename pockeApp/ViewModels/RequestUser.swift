//
//  RequestUser.swift
//  pockeApp
//
//  Created by cristian manuel ardila troches on 2/05/23.
//


import Foundation
import Alamofire
import AlamofireObjectMapper

class RequestUser: ObservableObject {
    
    @Published var isLogin : Bool = false //To show the loading screen while the request is working
    @Published var registedSuccesfly : Bool? // To Know if the result of the request is OK
    
    func login (email:String, password: String, remember: Bool, callback: @escaping (_ response: DataResponse<Any>) -> ()){
        
        let url = URL(string: Constants.API.URL_LOGIN)
        guard let requestUrl = url else { fatalError() }
        let parameters = ["email" : email,"password" : password, "remember": "true"]

        self.isLogin = true
        self.registedSuccesfly = false
        Alamofire.request(requestUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                callback(response)
        }
    }
    
    func infouser (_ ssid : String, callback: @escaping (_ response: DataResponse<Any>) -> ()){
        
        let url = URL(string: Constants.API.URL_INFOUSER)
        guard let requestUrl = url else { fatalError() }
        let headers = ["Authorization" : "Bearer "+ssid]
        self.isLogin = true
        Alamofire.request(requestUrl, method: .post, encoding: JSONEncoding.default, headers : headers)
            .responseJSON { response in
                callback(response)
        }
    }
    
    func update (_ ssid : String, mail: String, name:String, phone: String, city: String,callback: @escaping (_ response: DataResponse<Any>) -> ()){
        
        let url = URL(string: Constants.API.URL_UPDATE)
        let headers = ["Authorization" : "Bearer "+ssid]
        guard let requestUrl = url else { fatalError() }
        let parameters = ["name" : name,"phone" : phone, "city" : city]
        self.isLogin = true
        Alamofire.request(requestUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers : headers)
            .responseJSON { response in
                callback(response)
        }
    }
    
    func uploadImage(_ ssid : String,mail: String, name:String, phone: String, city: String, imageData: Data,callback: @escaping (_ response: DataResponse<Any>) -> ()){
        
        let headers : Alamofire.HTTPHeaders = [
            "cache-control" : "no-cache",
            "Accept-Language" : "en",
            "Connection" : "close",
            "Authorization" : "Bearer "+ssid
        ]
    
        let parameters = ["name" : name,"phone" : phone, "city" : city]
                  
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "photo", fileName: "image.jpg", mimeType: "image/jpeg");
                
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                  }
            },
            usingThreshold: .max,
            to: URL(string: Constants.API.URL_UPDATE)!,
                method: .post,
                headers: headers,
            encodingCompletion: { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                           callback(response)
                    }
                    upload.uploadProgress(closure: {
                            progress in
                                print(progress.fractionCompleted)
                        })
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
    
    
}

