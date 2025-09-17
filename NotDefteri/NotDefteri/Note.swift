import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {}

extension Note {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var content: String
    @NSManaged public var date: Date
}

extension Note: Identifiable {}

extension Note {
    static func create(in context: NSManagedObjectContext, title: String, content: String) -> Note {
        let note = Note(context: context)
        note.id = UUID()
        note.title = title
        note.content = content
        note.date = Date()
        return note
    }
}


