//
//  ServiceItem.swift
//  pockeApp
//
//  Created by cristian manuel ardila troches on 30/04/23.
//
import UIKit
import SwiftUI

/// A simple model to keep track of tasks
class ServiceItem: NSObject, ObservableObject, Identifiable {
    var serviceId: Int32
    var storeId: Int32
    var reference: String
    //@Published var isCompleted: Bool = false

    init(service: Int32, store: Int32, ref: String) {
        serviceId = service
        storeId   = store
        reference = ref
    }
}

