//
//  CoreDataStack.swift
//  VkStyle
//
//  Created by aprirez on 10/4/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import CoreData

class CoreDataStack {
    
    let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores(
            completionHandler: {
                (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func clearAllData() {
        guard let storeUrl = persistentContainer.persistentStoreCoordinator.persistentStores.first?.url else { return }
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: storeUrl)
    }
}
