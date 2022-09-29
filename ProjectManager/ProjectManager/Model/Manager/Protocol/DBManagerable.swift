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
    func fetchTodoCoreData() 
    func add(model: Todo)
    func delete(index: Int)
    func update(title: String, body: String, date: Date, index: Int)
    func changeStatus(to status: Status, index: Int)
}
