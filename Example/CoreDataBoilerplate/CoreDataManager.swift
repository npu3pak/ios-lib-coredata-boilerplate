//
//  CoreDataManager.swift
//  CoreDataBoilerplate
//
//  Created by Евгений Сафронов on 31.01.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import CoreData
import CoreDataBoilerplate

class CoreDataManager {
    static let instance = CoreDataManager()
    
    var context: NSManagedObjectContext
    
    private init() {
        context = try! NSManagedObjectContext(modelName: "Model", dbStoreName: "Store", concurrencyType: .mainQueueConcurrencyType)
    }
}
