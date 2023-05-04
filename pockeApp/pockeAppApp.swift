//
//  pockeAppApp.swift
//  pockeApp
//
//  Created by cristian manuel ardila troches on 30/04/23.
//

import SwiftUI

@main
struct pockeAppApp: App {
    @StateObject var manager: DataManager = DataManager()
    @State var log = UserDefaults.standard.bool(forKey: Constants.DefaultsKeys.logged)
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(named: "DownButtonBack")
        UINavigationBar.appearance().tintColor = .white
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().backgroundColor = UIColor(Color("BackGround"))
        UITableView.appearance().backgroundColor = UIColor(Color("BackGround"))
        UITableView.appearance().contentInset.top = -35
        UIScrollView.appearance().keyboardDismissMode = .onDrag
    }
    
    var body: some Scene {
        WindowGroup {
             
            Group{
                NavigationMenu(manager: manager)
            }.onOpenURL { url in
                
            }
        }
    }
}
