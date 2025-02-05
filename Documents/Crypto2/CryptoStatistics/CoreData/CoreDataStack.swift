//
//  CoreDataStack.swift
//  CryptoStatistics
//
// 
//

import CoreData

class CoreDataStack: ObservableObject {

    static let shared = CoreDataStack()
    private init() { }

    lazy var managedContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Coin")

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
}

extension CoreDataStack {

    func save() {
        guard persistentContainer.viewContext.hasChanges else { return }
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save the context:", error.localizedDescription)
        }
    }
}
