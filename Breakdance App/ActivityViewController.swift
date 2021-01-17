//
//  ActivityViewController.swift
//  Breakdance App
//
//  Created by Lawrence Dizon on 1/17/21.
//  Copyright © 2021 Lawrence Dizon. All rights reserved.
//

import UIKit
import CoreData

class ActivityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.save(value: "Test 1")
//        self.save(value: "Test 2")
//        self.save(value: "Test 3")
        
        retrieveValues()
    }
    

}

extension ActivityViewController {
    func save(value: String){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "TestEntity", in: context) else { return }
            
            let newValue = NSManagedObject(entity: entityDescription, insertInto: context)
            
            newValue.setValue(value, forKey: "testValue")
            
            do {
                try context.save()
                print("Saved \(value)")
            }catch {
                print("Saving error")
            }
        }
    }
    
    func retrieveValues(){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<TestEntity>(entityName: "TestEntity")
            
            do {
                let results = try context.fetch(fetchRequest)
                
                for result in results {
                    if let testValue = result.testValue {
                        print(testValue)
                    }
                }
                
            } catch {
                print("Could not retrieve")
            }
        }
    }
}


