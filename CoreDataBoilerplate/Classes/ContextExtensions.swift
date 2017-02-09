import Foundation
import CoreData

public extension NSManagedObjectContext {
    
    public func inserting<T: NSManagedObject>(entityName: String) -> T {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: self) as! T
    }
    
    public func entity(_ name: String) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: name, in: self)
    }
    
    public static func asyncInit(modelName: String, dbStoreName: String, concurrencyType: NSManagedObjectContextConcurrencyType, onError: @escaping (String) -> Void, onSuccess: @escaping (NSManagedObjectContext) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                let context = try NSManagedObjectContext(modelName: modelName, dbStoreName: dbStoreName, concurrencyType: concurrencyType)
                DispatchQueue.main.async {
                    onSuccess(context)
                }
            } catch InitError.modelNotFoundError{
                DispatchQueue.main.async {
                    onError("Could not find model \(modelName).momd in main bundle")
                }
            } catch {
                DispatchQueue.main.async {
                    onError("\(error)")
                }
            }
        }
    }
    
    public convenience init(modelName: String, dbStoreName: String, concurrencyType: NSManagedObjectContextConcurrencyType) throws {
        let modelUrl = Bundle.main.url(forResource: modelName, withExtension: "momd")!
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl) else {
            throw InitError.modelNotFoundError
        }
        
        let dir = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last!
        let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let url = dir.appendingPathComponent("\(dbStoreName).sqlite")
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            throw error
        }
        
        self.init(concurrencyType: concurrencyType)
        persistentStoreCoordinator = coordinator
        
    }
    
    public func saveIfNeeded() throws {
        if hasChanges {
            do {
                try save()
            } catch {
                throw error
            }
        }
    }
    
    public func fetchedController<T>(entityName: String, orderBy sortingKey: String, ascending: Bool = true, groupBy sectionNameKeyPath: String? = nil) -> NSFetchedResultsController<T> {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: sortingKey, ascending: ascending)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
    }
    
    
    public enum InitError: Error {
        case modelNotFoundError
    }
}
