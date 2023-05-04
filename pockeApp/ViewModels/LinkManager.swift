//
//  LinkManager.swift
//  pockeApp
//
//  Created by cristian manuel ardila troches on 1/05/23.
//
import Foundation

class LinkManager : ObservableObject{
    @Published var currentView: linkedView = .login
    @Published var ssid : String? = ""
    func checkLink(url : URL)->Bool {
        
        guard let host = URLComponents(url: url, resolvingAgainstBaseURL: true)?.path else{
            return false
        }
        print(host)
        if host == linkedView.login.rawValue{
            currentView = .login
        }
        else if host == linkedView.verifyEmail.rawValue{
            currentView = .verifyEmail
            let getSsid = getQueryStringParameter(url: url.absoluteString, param: "ssid")
            ssid = getSsid ?? nil
            
        }else if host == linkedView.restore.rawValue{
            currentView = .restore
        }else{
            return false
        }
        
        return true
    }
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}

enum linkedView: String{
    case login = "/login"
    case login2 = "/login2"
    case restore = "/restore"
    case verifyEmail = "/verified-email"
    case navigationMenu = "/navigation"
    case register = "/register"
    case sendRecoverPassword = "/send-recovery"
}


