//
//  ViewController.swift
//  CoreDataBoilerplate
//
//  Created by npu3pak on 01/30/2017.
//  Copyright (c) 2017 npu3pak. All rights reserved.
//

import UIKit
import CoreDataBoilerplate
import CoreData

class ViewController: UIViewController {
    let fetchedController: NSFetchedResultsController<NSManagedObject> = {
        return CoreDataManager.instance.context.fetchedController(entityName: "Employee", orderBy: "name")
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

