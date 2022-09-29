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
    
    func fetch(by status: Status) -> [Todo] {
        let data = self.fetch()
        let filteredData = data.filter { $0.status == status }
        
        return filteredData
    }
    
    func add(model: Todo) {
        self.todoData.append(model)
    }
    
    func delete(index: Int) {
        let id = todoData[index].id
        self.todoData.removeAll(where: { $0.id == id })
    }
    
    func update(title: String, body: String, date: Date, index: Int) {
        
        todoData[index].title = title
        todoData[index].body = body
        todoData[index].date = date
    }
    
    func changeStatus(to status: Status, index: Int) {
        todoData[index].status = status
    }
    
    func fetchTodoCoreData() { }
}
