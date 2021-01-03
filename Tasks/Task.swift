//
//  Task.swift
//  Tasks
//
//  Created by aprirez on 1/3/21.
//

import Foundation

protocol Task {
    var name: String { get set }
    var description: String { get set }
    
    func subtasksCount() -> Int
}

class CompositeTask: Task {
    
    var name: String
    var description: String

    var tasks: [Task] = []
    
    static let debugDescription = "Description..."
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }

    func subtasksCount() -> Int {
        var count = 0
        for task in tasks {
            count += 1
            count += task.subtasksCount()
        }
        return count
    }
}

