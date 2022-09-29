//
//  DataManager.swift
//  ProjectManager
//
//  Created by Kiwi on 2022/09/11.
//

import Foundation
import Combine

final class DataManager: ObservableObject {
    
    @Published var dbManager = TodoCoreDataManager.shared
//    var cancellable: AnyCancellable?
//    
//    init() {
//        self.cancellable = self.dbManager.$todoData.sink(
//            receiveValue: { [weak self] _ in
//                self?.objectWillChange.send()
//            }
//        )
//    }
    
    func fetch() -> [Todo] {
        self.dbManager.fetch()
    }
    
    func fetch(by status: Status) -> [Todo] {
        self.dbManager.fetch(by: status)
    }
    
    func add(title: String, body: String, date: Date, status: Status) {
        self.dbManager.add(model: Todo(title: title, body: body, date: date, status: status))
    }
    
    func delete(index: Int) {
        self.dbManager.delete(index: index)
    }
    
    func update(title: String, body: String, date: Date, index: Int) {
        self.dbManager.update(title: title, body: body, date: date, index: index)
    }
    
    func changeStatus(to status: Status, index: Int) {
        self.dbManager.changeStatus(to: status, index: index)
    }
    
}
