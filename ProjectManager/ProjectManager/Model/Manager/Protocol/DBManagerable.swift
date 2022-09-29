//
//  DBManagerable.swift
//  ProjectManager
//
//  Created by Kiwi on 2022/09/11.
//

import Foundation

protocol DBManagerable {
    
    func fetch() -> [Todo]
    func fetch(by status: Status) -> [Todo]
    func add(model: Todo)
    func delete(id: UUID)
    func update(id: UUID, title: String, body: String, date: Date)
    func changeStatus(id: UUID, to status: Status)
}
