//
//  TodoListRowViewModel.swift
//  ProjectManager
//
//  Created by Kiwi on 2022/09/26.
//

import SwiftUI

final class TodoListRowViewModel: ObservableObject {
    @Published var todo: Todo
    @Published var statusChanging: Bool = false
    @Published var showingSheet: Bool = false
    @Published var index: Int
    
    init(todo: Todo, index: Int) {
        self.todo = todo
        self.index = index
    }
    
    func changeStatus(status: Status, dataManager: DataManager, index: Int) {
        dataManager.changeStatus(to: status, index: index)
        statusChanging.toggle()
    }
}
