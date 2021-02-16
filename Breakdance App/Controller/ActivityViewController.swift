import UIKit
import CoreData

//
// ActivityViewController provides the user some information about their overall workout data.
//
//
class ActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //
    // MARK: - Properties
    //
    
    @IBOutlet var tableView: UITableView!
    
    //
    // MARK: - ViewController LifeCycle States
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
//        self.save(value: "Test 1")
//        self.save(value: "Test 2")
//        self.save(value: "Test 3")
        
        retrieveValues()
    }
    
    //
    // MARK: - TableView Properties
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        cell.textLabel?.text = "Test"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//
// MARK: - Core Data
//

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


