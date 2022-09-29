//
//  TodoCoreDataManager.swift
//  ProjectManager
//
//  Created by Kiwon Song on 2022/09/28.
//

import SwiftUI
import CoreData

final class TodoCoreDataManager: DBManagerable, ObservableObject {
    
    static let shared = TodoCoreDataManager()
    
    let container = NSPersistentContainer(name: "TodoCoreData")
    @Published var todoData: [Todo] = .init()
    private var todoCoreData: [TodoCoreData] = .init()
    
    private init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func fetch() -> [Todo] {
        let request: NSFetchRequest<TodoCoreData> = TodoCoreData.fetchRequest()
        
        do {
            todoCoreData = try container.viewContext.fetch(request)
            
            todoCoreData.forEach {
                guard let status = Status(rawValue: $0.status) else { return }
                todoData.append(Todo(title: $0.title, body: $0.body, date: $0.date, status: status))
            }
        } catch {
            print(error.localizedDescription)
        }
        return todoData
    }
    
    func fetch(by status: Status) -> [Todo] {
        let request: NSFetchRequest<TodoCoreData> = TodoCoreData.fetchRequest()
        
        do {
            todoCoreData = try container.viewContext.fetch(request)
            
            todoCoreData.forEach {
                guard let status = Status(rawValue: $0.status) else { return }
                todoData.append(Todo(title: $0.title, body: $0.body, date: $0.date, status: status))
            }
        } catch {
            print(error.localizedDescription)
        }
        return todoData.filter { $0.status == status }
    }
    
    func add(model: Todo) {
        let todoData = TodoCoreData(context: container.viewContext)
        todoData.id = model.id
        todoData.title = model.title
        todoData.body = model.body
        todoData.date = model.date
        todoData.status = model.status.rawValue
        
        do {
            try container.viewContext.save()
            self.todoData = fetch()
        } catch {
            print(error.localizedDescription)
        }
    }
 
        func delete(id: UUID) {
    
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TodoCoreData")
            request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
            
            do {
                guard let targetData = try container.viewContext.fetch(request).first as? NSManagedObject else { return }
                
                container.viewContext.delete(targetData)
                try container.viewContext.save()
                self.todoData = fetch()
            } catch {
                print(error.localizedDescription)
            }
    
        }
    
    func update(id: UUID, title: String, body: String, date: Date) {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TodoCoreData")
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            if let fetchedTodoData = try container.viewContext.fetch(request).first as? TodoCoreData {
                fetchedTodoData.setValue(id, forKey: "id")
                fetchedTodoData.setValue(title, forKey: "title")
                fetchedTodoData.setValue(body, forKey: "body")
                fetchedTodoData.setValue(date, forKey: "date")
                
                try container.viewContext.save()
                self.todoData = fetch()
            } else {
                add(model: Todo(title: title, body: body, date: date, status: .todo))
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func changeStatus(id: UUID, to status: Status) {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TodoCoreData")
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg )
        do {
            if let fetchedTodoData = try container.viewContext.fetch(request).first as? TodoCoreData {
                fetchedTodoData.setValue(status, forKey: "status")
                
                try container.viewContext.save()
                self.todoData = fetch()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
