import CoreData

struct PersistentController {
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "History")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error)")
            }
        })
    }
}
