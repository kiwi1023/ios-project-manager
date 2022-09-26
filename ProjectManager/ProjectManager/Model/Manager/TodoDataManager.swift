//
//  TodoDataManager.swift
//  ProjectManager
//
//  Created by Kiwi on 2022/09/11.
//

import Foundation

final class TodoDataManager: DBManagerable, ObservableObject {
 
    @Published var todoData: [Todo] = .init()
    
    func fetch() -> [Todo] {
        return todoData
    }
    
    func add(title: String, body: String, date: Date, status: Status) {
        self.todoData.append(Todo(title: title, body: body, date: date, status: .todo))
    }
    
    func delete(id: UUID) {
        self.todoData.removeAll(where: { $0.id == id })
    }
    
    func update(id: UUID, title: String, body: String, date: Date) {
        guard let index = todoData.firstIndex(where: { $0.id == id }) else { return }
        
        todoData[index].title = title
        todoData[index].body = body
        todoData[index].date = date
    }
    
    func changeStatus(id: UUID, to status: Status) {
        guard let index = todoData.firstIndex(where: { $0.id == id }) else { return }
        print(index)
        todoData[index].status = status
    }
    
}
