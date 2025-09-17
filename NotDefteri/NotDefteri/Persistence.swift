import Foundation
import CoreData

final class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        if let bundledModel = NSManagedObjectModel.mergedModel(from: [Bundle.main]) {
            container = NSPersistentContainer(name: "NotesModel", managedObjectModel: bundledModel)
        } else {
            let model = PersistenceController.managedObjectModel
            container = NSPersistentContainer(name: "NotesModel", managedObjectModel: model)
        }

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Hata: \(error), \(error.userInfo)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    static var managedObjectModel: NSManagedObjectModel = {
        let model = NSManagedObjectModel()

        // Note entity
        let noteEntity = NSEntityDescription()
        noteEntity.name = "Note"
        noteEntity.managedObjectClassName = String(describing: Note.self)

        // id: UUID
        let idAttr = NSAttributeDescription()
        idAttr.name = "id"
        idAttr.attributeType = .UUIDAttributeType
        idAttr.isOptional = false

        // title: String
        let titleAttr = NSAttributeDescription()
        titleAttr.name = "title"
        titleAttr.attributeType = .stringAttributeType
        titleAttr.isOptional = false

        // content: String
        let contentAttr = NSAttributeDescription()
        contentAttr.name = "content"
        contentAttr.attributeType = .stringAttributeType
        contentAttr.isOptional = false

        // date: Date
        let dateAttr = NSAttributeDescription()
        dateAttr.name = "date"
        dateAttr.attributeType = .dateAttributeType
        dateAttr.isOptional = false

        noteEntity.properties = [idAttr, titleAttr, contentAttr, dateAttr]

        model.entities = [noteEntity]
        return model
    }()

    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext
        for index in 1...5 {
            let note = Note(context: context)
            note.id = UUID()
            note.title = "Örnek Not \(index)"
            note.content = "Bu bir örnek içeriktir. Satır: \(index)"
            note.date = Date().addingTimeInterval(Double(-index) * 86400)
        }
        do {
            try context.save()
        } catch {
            fatalError("Önizleme hatası: \(error)")
        }
        return controller
    }()
}


