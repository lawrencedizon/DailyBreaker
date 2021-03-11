import UIKit
import CoreData
import Charts

//
// ActivityViewController provides the user some information about their overall workout data.
//
//

class ActivityViewController: UIViewController {
    //
    // MARK: - Properties
    //
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    //
    // MARK: - ViewController LifeCycle States
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChartView.noDataText = "We will add data shortly"
        
        //CoreData stuff
        //retrieveValues()
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


