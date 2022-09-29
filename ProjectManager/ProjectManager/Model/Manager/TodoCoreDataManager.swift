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
    @Published var todoData: [TodoCoreData] = .init()
    private let name = "TodoCoreData"
    var context: NSManagedObjectContext {
        return container.viewContext
    }
        
    private init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func fetch() -> [Todo] {
        let request: NSFetchRequest<TodoCoreData> = TodoCoreData.fetchRequest()
        var todo: [Todo] = []
        
        do {
            todoData = try container.viewContext.fetch(request)
            
            todoData.forEach {
                guard let status = Status(rawValue: $0.status) else { return }
                todo.append(Todo(title: $0.title, body: $0.body, date: $0.date, status: status))
            }
        } catch {
            print(error.localizedDescription)
        }
        return todo
    }
    
    func fetch(by status: Status) -> [Todo] {
        let request: NSFetchRequest<TodoCoreData> = TodoCoreData.fetchRequest()
        var todo: [Todo] = []
        do {
            todoData = try context.fetch(request)
            
            todoData.forEach {
                guard let status = Status(rawValue: $0.status) else { return }
                todo.append(Todo(title: $0.title, body: $0.body, date: $0.date, status: status))
            }
        } catch {
            print(error.localizedDescription)
        }
        return todo.filter { $0.status == status }
    }
        
    func fetchTodoCoreData() {
        let request: NSFetchRequest<TodoCoreData> = TodoCoreData.fetchRequest()
        do {
           todoData = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
    }
        
    func add(model: Todo) {
        let todoData = TodoCoreData(context: context)
        todoData.id = model.id
        todoData.title = model.title
        todoData.body = model.body
        todoData.date = model.date
        todoData.status = model.status.rawValue
        
        do {
            try context.save()
            fetchTodoCoreData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(index: Int) {
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: self.name)
        let id = todoData[index].id
        
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            guard let targetData = try context.fetch(request).first as? NSManagedObject else { return }
            
            context.delete(targetData)
            try context.save()
            fetchTodoCoreData()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func update(title: String, body: String, date: Date, index: Int) {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: self.name)
        let id = todoData[index].id
        
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            if let fetchedTodoData = try context.fetch(request).first as? TodoCoreData {
                fetchedTodoData.setValue(id, forKey: "id")
                fetchedTodoData.setValue(title, forKey: "title")
                fetchedTodoData.setValue(body, forKey: "body")
                fetchedTodoData.setValue(date, forKey: "date")
                
                try context.save()
                fetchTodoCoreData()
            } else {
                add(model: Todo(title: title, body: body, date: date, status: .todo))
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func changeStatus(to status: Status, index: Int) {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: self.name)
        let id = todoData[index].id
        
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg )
        do {
            if let fetchedTodoData = try context.fetch(request).first as? TodoCoreData {
                fetchedTodoData.setValue(status.rawValue, forKey: "status")
                
                try context.save()
                fetchTodoCoreData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
