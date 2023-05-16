import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.databaseName)
        container.loadPersistentStores(completionHandler: { _, error in
            let errorText = NSLocalizedString("unresolved_error", comment: "")
            _ = error.map { fatalError(errorText + " \($0)") }
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func backgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
}
