//
//  TodoCoreData+CoreDataProperties.swift
//  
//
//  Created by Kiwi on 2022/09/28.
//
//

import Foundation
import CoreData


extension TodoCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoCoreData> {
        return NSFetchRequest<TodoCoreData>(entityName: "TodoCoreData")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var body: String
    @NSManaged public var date: Date
    @NSManaged public var status: String

}
