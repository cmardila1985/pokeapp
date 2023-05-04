//
//  ListContentView.swift
//  TodoList
//
//  Created by Apps4World on 12/18/21.
//

import SwiftUI

/// Main list view for the app
struct ListContentView: View {
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var todoItems: FetchedResults<Services>
    
    // MARK: - Main rendering function
    var body: some View {
        NavigationView {
            VStack{
            List {
                ForEach(todoItems) { item in
                    Label(item.reference ?? "No Name", systemImage: "circle.fill")
                        .frame(maxWidth: .infinity, alignment: .leading).contentShape(Rectangle())
                        .onTapGesture {
                           // item.isCompleted = !item.isCompleted
                            try? viewContext.save()
                        }
                }
            }
            .navigationTitle("TODO")
            .navigationBarItems(trailing: Button(action: addItem, label: {
                Image(systemName: "plus")
            }))
                Button(action: addItem, label: {
                   Image(systemName: "plus")
               })
            }
        }
    }
    
    /// Add a new item
    private func addItem() {
        presentTextInputAlert(title: "Add Task", message: "Enter your task name") { name in
            let newTask = Services(context: viewContext)
            newTask.reference = name
            try? viewContext.save()
        }
    }
}

// MARK: - Preview UI
struct ListContentView_Previews: PreviewProvider {
    static var previews: some View {
        ListContentView().environmentObject(DataManager())
    }
}

// MARK: - Present UIAlertController with a text field
func presentTextInputAlert(title: String, message: String, completion: @escaping (_ text: String) -> Void) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addTextField()
    let submitAction = UIAlertAction(title: "Save", style: .default) { _ in
        if let text = alert.textFields?.first?.text, !text.isEmpty {
            completion(text)
        }
    }
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alert.addAction(submitAction)
    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
}
