//
//  Task_ManagedObject+CoreDataProperties.swift
//  
//
//  Created by Marcelo Farjalla on 3/2/20.
//
//

import Foundation
import CoreData


extension Task_ManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task_ManagedObject> {
        return NSFetchRequest<Task_ManagedObject>(entityName: "Task")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var id: String?
    @NSManaged public var list_id: String?
    @NSManaged public var order: Int64
    @NSManaged public var posted: Date?
    @NSManaged public var task_description: String?
    @NSManaged public var deleted: Bool

}
