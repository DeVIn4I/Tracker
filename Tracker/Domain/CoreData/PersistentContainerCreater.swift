//
//  PersistentContainerCreater.swift
//  Tracker
//
//  Created by Pavel Razumov on 30.04.2023.
//

import Foundation
import CoreData

struct PersistentContainerCreater {    
    private let modelName = "Tracker"
    
    func persistentContainer() throws -> NSPersistentContainer {
        let container = NSPersistentContainer(name: modelName)
        
        var loadError: Error?
        container.loadPersistentStores { description, error in
            if error != nil {
                assertionFailure("Some persistent container error")
                loadError = error
            }
        }
        
        try loadError.map { throw $0 }
        
        return container
    }
}
