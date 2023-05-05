//
//  NavigationMenu.swift
//  pockeApp
//
//  Created by cristian manuel ardila troches on 1/05/23.
//

import SwiftUI

struct NavigationMenu: View {
    
    @StateObject var manager: DataManager = DataManager()
    @State var show = false
    @State var currentView2 = "default"
    @State var statusServActive = "4"
    @State var showToolbar = true
    let defaults = UserDefaults.standard
    @State var isLogout = false
    @State var mail = UserDefaults.standard.string(forKey: Constants.DefaultsKeys.userMail) ?? ""
    @State var name = UserDefaults.standard.string(forKey: Constants.DefaultsKeys.userName) ?? ""
    @Environment(\.colorScheme) var colorScheme
    
    
    
    var body: some View {
        ZStack{
            TabPanelServicesView(showToolbar: $showToolbar, show: $show,currentView: $currentView2, manager: _manager )
        }
    }
}
